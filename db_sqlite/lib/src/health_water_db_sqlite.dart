import 'package:drift/drift.dart';
import 'package:lrk_common/common.dart';
import 'package:lrk_health_water/water.dart' as model;

part 'health_water_db_sqlite.g.dart';

class WaterSqliteDB implements model.WaterDB {
  final LazyDatabase Function(String) _open;
  final _dbs = <int, _WaterUserSqliteDB>{};

  WaterSqliteDB(this._open);

  _WaterUserSqliteDB _getDB(int userId) {
    return _dbs.putIfAbsent(userId, () => _WaterUserSqliteDB(userId, _open));
  }

  @override
  Future<model.WaterConfig?> getConfig(int userId) {
    return _getDB(userId).getConfig();
  }

  @override
  Future<model.WaterConfig> saveConfig(model.WaterConfig config) {
    return _getDB(config.userId).saveConfig(config);
  }

  @override
  Future<model.WaterDayTotal> getTotal(int userId, Day day) {
    return _getDB(userId).getTotal(day);
  }

  /// start: inclusive
  /// end: inclusive
  @override
  Future<List<model.WaterDayTotal>> listTotals(int userId, Day start, Day end) {
    return _getDB(userId).listTotals(start, end);
  }

  @override
  Future<List<model.WaterConsumption>> listDetails(
      int userId, DateTime start, DateTime end) {
    return _getDB(userId).listDetails(start, end);
  }

  @override
  Future<model.WaterConsumption> add(
      model.WaterConsumption consumption, model.WaterDayTotal total) {
    return _getDB(consumption.userId).add(consumption, total);
  }

  @override
  Future<void> dispose() async {
    await Future.wait(_dbs.values.map((e) => e.close()));
    _dbs.clear();
  }
}

@DriftDatabase(tables: [WaterConfigs, WaterDetails, WatersPerDay])
class _WaterUserSqliteDB extends _$_WaterUserSqliteDB {
  final int _userId;

  _WaterUserSqliteDB(this._userId, LazyDatabase Function(String) open)
      : super(open('$_userId-health-water.db'));

  @override
  int get schemaVersion => 1;

  Future<model.WaterConfig?> getConfig() async {
    var cfg = await select(waterConfigs).getSingleOrNull();

    if (cfg == null) {
      return null;
    }

    return toModelConfig(cfg);
  }

  Future<model.WaterConfig> saveConfig(model.WaterConfig config) async {
    var cfg = fromModelConfig(config);

    await into(waterConfigs).insertOnConflictUpdate(cfg);

    return config;
  }

  model.WaterConfig toModelConfig(WaterConfig cfg) => model.WaterConfig(
      userId: _userId, targetConsumption: cfg.targetConsumption);

  WaterConfig fromModelConfig(model.WaterConfig config) =>
      WaterConfig(id: _userId, targetConsumption: config.targetConsumption);

  Future<model.WaterDayTotal> getTotal(Day day) async {
    int di = day.toInt();

    var total = await (select(watersPerDay)..where((t) => t.day.equals(di))) //
        .getSingleOrNull();

    return toModelTotal(total ?? WaterPerDay(day: day.toInt(), total: 0));
  }

  /// start: inclusive
  /// end: inclusive
  Future<List<model.WaterDayTotal>> listTotals(Day start, Day end) async {
    int si = start.toInt();
    int ei = end.toInt();

    var totals = await (select(watersPerDay)
          ..where((t) => t.day.isBetweenValues(si, ei)))
        .get();

    return totals.map(toModelTotal).toList();
  }

  /// start: inclusive
  /// end: inclusive
  Future<List<model.WaterConsumption>> listDetails(
      DateTime start, DateTime end) async {
    var result = await (select(waterDetails)
          ..where((c) => c.date.isBetweenValues(start, end)))
        .get();

    return result.map(toModelConsumption).toList();
  }

  Future<model.WaterConsumption> add(
      model.WaterConsumption consumption, model.WaterDayTotal total) async {
    var wc = WaterDetailsCompanion(
        date: Value(consumption.date),
        quantity: Value(consumption.quantity),
        glass: Value(consumption.glass.index));
    var wt = fromModelTotal(total);

    int? id;

    await transaction(() async {
      id = await into(waterDetails).insert(wc);
      await into(watersPerDay).insertOnConflictUpdate(wt);
    });

    return consumption.withId(id!);
  }

  WaterDetail fromModelConsumption(model.WaterConsumption consumption) =>
      WaterDetail(
          id: consumption.id,
          date: consumption.date,
          quantity: consumption.quantity,
          glass: consumption.glass.index);

  model.WaterConsumption toModelConsumption(WaterDetail c) =>
      model.WaterConsumption(
          userId: _userId,
          id: c.id,
          date: c.date,
          quantity: c.quantity,
          glass: model.Glass.values[c.glass]);

  WaterPerDay fromModelTotal(model.WaterDayTotal total) =>
      WaterPerDay(day: total.day.toInt(), total: total.total);

  model.WaterDayTotal toModelTotal(WaterPerDay c) => model.WaterDayTotal(
      userId: _userId, day: Day.fromInt(c.day), total: c.total);
}

class WaterConfigs extends Table {
  IntColumn get id => integer()();

  IntColumn get targetConsumption => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class WaterDetails extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get date => dateTime()();

  IntColumn get quantity => integer()();

  IntColumn get glass => integer()();
}

@DataClassName("WaterPerDay")
class WatersPerDay extends Table {
  @override
  String? get tableName => "water_per_day";

  IntColumn get day => integer()();

  IntColumn get total => integer()();

  @override
  Set<Column> get primaryKey => {day};
}
