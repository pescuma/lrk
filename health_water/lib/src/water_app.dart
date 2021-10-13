import 'package:dart_date/dart_date.dart';
import 'package:lrk_health_water/src/water_db.dart';
import 'package:lrk_health_water/src/water_model.dart';
import 'package:lrk_common/common.dart';

class WaterApp {
  final WaterDB _db;
  final Clock _clock;
  WaterConfig? _config;
  DateTime? _day;
  int? _total;
  List<WaterConsumption>? _glasses;

  WaterApp(this._db, this._clock);

  Future<WaterConfig> getConfig() async {
    _config ??= await _db.getConfig();
    return _config!;
  }

  Future<void> setConfig(WaterConfig config) async {
    await _db.updateConfig(config);
    _config = config;
  }

  Future<DateTime> getDay() async {
    if (_day == null) {
      var now = _clock.now();

      var config = await getConfig();
      if (now.hour < config.startingHourOfTheDay) {
        now = now.addDays(-1, true);
      }

      _day = now.startOfDay;
    }

    return _day!;
  }

  Future<void> setDay(DateTime date) async {
    date = date.startOfDay;

    if (_day == date) return;

    _day = date;
    _total = null;
    _glasses = null;
  }

  Future<int> getTotal() async {
    _total ??= await _db.getTotal(await getDay());
    return _total!;
  }

  Future<int> getTarget() async {
    var config = await getConfig();
    return config.targetConsumption;
  }

  Future<bool> reachedTarget() async {
    return await getTotal() >= await getTarget();
  }

  Future<List<WaterConsumption>> getGlasses() async {
    _glasses ??= await _db.listDetails(await getDay());
    return _glasses!;
  }

  Future<void> add(int quantity, [Glass glass = Glass.glass]) async {
    var consumption = WaterConsumption(_clock.now(), quantity, glass);

    assert(consumption.date.startOfDay == await getDay());

    await _db.add(consumption);

    _glasses?.add(consumption);
    if (_total != null) _total = _total! + consumption.quantity;
  }

  /// start: inclusive
  /// end: inclusive
  Future<List<DayTotal>> listTotals(DateTime start, DateTime end) async {
    start = start.startOfDay;
    end = end.startOfDay.addDays(1, true);

    var totals = await _db.listTotals(start, end);

    return DayTotal.createRange(start, end, totals);
  }
}
