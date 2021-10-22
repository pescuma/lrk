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
  Future<int> getTotal(int userId, DateTime day) {
    return _getDB(userId).getTotal(day);
  }

  /// start: inclusive
  /// end: inclusive
  @override
  Future<Map<DateTime, int>> listTotals(int userId, DateTime start, DateTime end) {
    return _getDB(userId).listTotals(start, end);
  }

  @override
  Future<List<model.WaterConsumption>> listDetails(int userId, DateTime day) {
    return _getDB(userId).listDetails(day);
  }

  @override
  Future<model.WaterConsumption> add(model.WaterConsumption consumption) {
    return _getDB(consumption.userId).add(consumption);
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

  model.WaterConfig toModelConfig(WaterConfig cfg) =>
      model.WaterConfig(userId: _userId, targetConsumption: cfg.targetConsumption);

  WaterConfig fromModelConfig(model.WaterConfig config) =>
      WaterConfig(id: _userId, targetConsumption: config.targetConsumption);

  Future<int> getTotal(DateTime day) async {
    int di = toDay(day);

    var total = await (select(watersPerDay)..where((t) => t.date.equals(di))) //
        .getSingleOrNull();

    return total?.quantity ?? 0;
  }

  /// start: inclusive
  /// end: inclusive
  Future<Map<DateTime, int>> listTotals(DateTime start, DateTime end) async {
    int si = toDay(start);
    int ei = toDay(end);

    var totals = await (select(watersPerDay)..where((t) => t.date.isBetweenValues(si, ei))).get();

    var result = <DateTime, int>{};

    for (var t in totals) {
      result[fromDay(t.date)] = t.quantity;
    }

    return result;
  }

  Future<List<model.WaterConsumption>> listDetails(DateTime day) async {
    var result = await (select(waterDetails)..where((c) => c.date.equals(day))).get();

    return result.map(toModelConsumption).toList();
  }

  Future<model.WaterConsumption> add(model.WaterConsumption consumption) async {
    var day = consumption.date.startOfDay;

    var total = await getTotal(day);

    var wc = fromModelConsumption(consumption);
    var wt = WaterPerDay(date: toDay(day), quantity: total + consumption.quantity);

    await transaction(() async {
      await into(waterDetails).insert(wc);
      await into(watersPerDay).insertOnConflictUpdate(wt);
    });

    return consumption;
  }

  int toDay(DateTime dt) => dt.year * 10000 + dt.month * 100 + dt.day;
  DateTime fromDay(int day) => DateTime(day ~/ 10000, day ~/ 100 % 100, day % 100);

  WaterDetail fromModelConsumption(model.WaterConsumption consumption) => WaterDetail(
      date: consumption.date, quantity: consumption.quantity, glass: consumption.glass.index);

  model.WaterConsumption toModelConsumption(WaterDetail c) =>
      model.WaterConsumption(_userId, c.date, c.quantity, model.Glass.values[c.glass]);
}

class WaterConfigs extends Table {
  IntColumn get id => integer()();
  IntColumn get targetConsumption => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class WaterDetails extends Table {
  DateTimeColumn get date => dateTime()();
  IntColumn get quantity => integer()();
  IntColumn get glass => integer()();

  @override
  Set<Column> get primaryKey => {date};
}

@DataClassName("WaterPerDay")
class WatersPerDay extends Table {
  @override
  String? get tableName => "water_per_day";

  IntColumn get date => integer()();
  IntColumn get quantity => integer()();

  @override
  Set<Column> get primaryKey => {date};
}
