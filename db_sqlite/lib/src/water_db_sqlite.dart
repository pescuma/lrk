import 'package:drift/drift.dart';
import 'package:lrk_common/common.dart';
import 'package:lrk_health_water/water.dart' as model;

part 'water_db_sqlite.g.dart';

@DriftDatabase(tables: [WaterConfigs, WaterConsumptions, WaterTotals])
class WaterSqliteDB extends _$WaterSqliteDB implements model.WaterDB {
  WaterSqliteDB(LazyDatabase Function(String) open) : super(open('water.db'));

  @override
  int get schemaVersion => 1;

  model.WaterConfig? _config;

  @override
  Future<model.WaterConfig> getConfig() async {
    if (_config != null) {
      return _config!;
    }

    var cfg = await select(waterConfigs).getSingleOrNull();

    if (cfg != null) {
      _config = model.WaterConfig(
          startingHourOfTheDay: cfg.startingHourOfTheDay, //
          targetConsumption: cfg.targetConsumption);
    } else {
      _config = model.WaterConfig();
    }

    return _config!;
  }

  @override
  Future<void> updateConfig(model.WaterConfig config) async {
    var cfg = WaterConfig(
        id: 0,
        startingHourOfTheDay: config.startingHourOfTheDay,
        targetConsumption: config.targetConsumption);

    await into(waterConfigs).insertOnConflictUpdate(cfg);

    _config = config;
  }

  @override
  Future<int> getTotal(DateTime day) async {
    var total = await (select(waterTotals)..where((t) => t.date.equals(day))) //
        .getSingleOrNull();

    return total?.quantity ?? 0;
  }

  /// start: inclusive
  /// end: exclusive
  @override
  Future<Map<DateTime, int>> listTotals(DateTime start, DateTime end) async {
    end = end.addDays(-1, true);

    var totals =
        await (select(waterTotals)..where((t) => t.date.isBetweenValues(start, end))).get();

    var result = <DateTime, int>{};

    for (var t in totals) {
      result[t.date] = t.quantity;
    }

    return result;
  }

  @override
  Future<List<model.WaterConsumption>> listDetails(DateTime day) async {
    var result = await (select(waterConsumptions)..where((c) => c.date.equals(day))).get();

    return result.map((c) => WaterConsumptionRow.fromDB(c)).toList();
  }

  @override
  Future<model.WaterConsumption> add(model.WaterConsumption consumption) async {
    var day = consumption.date.startOfDay;

    var total = await getTotal(day);

    var wc = WaterConsumptionsCompanion(
        date: Value(consumption.date),
        quantity: Value(consumption.quantity),
        glass: Value(consumption.glass.index));

    var wt = WaterTotal(date: day, quantity: total + consumption.quantity);
    int id = -1;

    await transaction(() async {
      id = await into(waterConsumptions).insert(wc);
      await into(waterTotals).insertOnConflictUpdate(wt);
    });

    return WaterConsumptionRow.fromModel(id, consumption);
  }
}

class WaterConfigs extends Table {
  IntColumn get id => integer()();
  IntColumn get startingHourOfTheDay => integer()();
  IntColumn get targetConsumption => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class WaterConsumptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get quantity => integer()();
  IntColumn get glass => integer()();
}

class WaterTotals extends Table {
  DateTimeColumn get date => dateTime()();
  IntColumn get quantity => integer()();

  @override
  Set<Column> get primaryKey => {date};
}

class WaterConsumptionRow extends model.WaterConsumption {
  final int id;

  WaterConsumptionRow.fromModel(this.id, model.WaterConsumption c)
      : super(c.date, c.quantity, c.glass);

  WaterConsumptionRow.fromDB(WaterConsumption c)
      : id = c.id,
        super(c.date, c.quantity, model.Glass.values[c.glass]);
}
