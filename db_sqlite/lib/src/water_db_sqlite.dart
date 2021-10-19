import 'package:drift/drift.dart';
import 'package:lrk_common/common.dart';
import 'package:lrk_health_water/water.dart' as model;

part 'water_db_sqlite.g.dart';

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
  /// end: exclusive
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

@DriftDatabase(tables: [WaterConfigs, WaterConsumptions, WaterTotals])
class _WaterUserSqliteDB extends _$_WaterUserSqliteDB {
  final int _userId;
  model.WaterConfig? _config;

  _WaterUserSqliteDB(this._userId, LazyDatabase Function(String) open)
      : super(open('$_userId-health-water.db'));

  @override
  int get schemaVersion => 1;

  Future<model.WaterConfig?> getConfig() async {
    if (_config != null) {
      return _config!;
    }

    var cfg = await select(waterConfigs).getSingleOrNull();

    if (cfg != null) {
      _config = model.WaterConfig(userId: _userId, targetConsumption: cfg.targetConsumption);
    }

    return _config;
  }

  Future<model.WaterConfig> saveConfig(model.WaterConfig config) async {
    var cfg = WaterConfig(id: 0, targetConsumption: config.targetConsumption);

    await into(waterConfigs).insertOnConflictUpdate(cfg);

    _config = config;

    return config;
  }

  Future<int> getTotal(DateTime day) async {
    var total = await (select(waterTotals)..where((t) => t.date.equals(day))) //
        .getSingleOrNull();

    return total?.quantity ?? 0;
  }

  /// start: inclusive
  /// end: exclusive
  Future<Map<DateTime, int>> listTotals(DateTime start, DateTime end) async {
    var totals =
        await (select(waterTotals)..where((t) => t.date.isBetweenValues(start, end))).get();

    var result = <DateTime, int>{};

    for (var t in totals) {
      result[t.date] = t.quantity;
    }

    return result;
  }

  Future<List<model.WaterConsumption>> listDetails(DateTime day) async {
    var result = await (select(waterConsumptions)..where((c) => c.date.equals(day))).get();

    return result
        .map(
            (c) => model.WaterConsumption(_userId, c.date, c.quantity, model.Glass.values[c.glass]))
        .toList();
  }

  Future<model.WaterConsumption> add(model.WaterConsumption consumption) async {
    var day = consumption.date.startOfDay;

    var total = await getTotal(day);

    var wc = WaterConsumption(
        date: consumption.date, quantity: consumption.quantity, glass: consumption.glass.index);

    var wt = WaterTotal(date: day, quantity: total + consumption.quantity);

    await transaction(() async {
      await into(waterConsumptions).insert(wc);
      await into(waterTotals).insertOnConflictUpdate(wt);
    });

    return consumption;
  }
}

class WaterConfigs extends Table {
  IntColumn get id => integer()();
  IntColumn get targetConsumption => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class WaterConsumptions extends Table {
  DateTimeColumn get date => dateTime()();
  IntColumn get quantity => integer()();
  IntColumn get glass => integer()();

  @override
  Set<Column> get primaryKey => {date};
}

class WaterTotals extends Table {
  DateTimeColumn get date => dateTime()();
  IntColumn get quantity => integer()();

  @override
  Set<Column> get primaryKey => {date};
}
