import 'package:lrk_common/common.dart';
import 'package:lrk_health_water/src/water_db.dart';
import 'package:lrk_health_water/src/water_model.dart';

class WaterApp {
  final WaterDB _db;
  final Clock _clock;
  WaterConfig? _config;
  DateTime? _day;
  int? _total;
  ScheduledTask? _dayChangeTask;
  List<WaterConsumption>? _glasses;

  EventEmitter events = EventEmitter();

  WaterApp(this._db, this._clock);

  Future<void> dispose() async {
    _dayChangeTask?.cancel();

    events.emit('dispose');
  }

  Future<WaterConfig> getConfig() async {
    _config ??= await _db.getConfig();
    return _config!;
  }

  Future<void> setConfig(WaterConfig config) async {
    if (await getConfig() == config) {
      return;
    }

    _stopDayChangeTask();

    await _db.updateConfig(config);

    _config = config;

    if (_day != null && _day == _getCurrentDay(config)) {
      _startDayChangeTask(_config!);
    }

    events.emit('change', 'config');
  }

  void _stopDayChangeTask() {
    _dayChangeTask?.cancel();
    _dayChangeTask = null;
  }

  void _startDayChangeTask(WaterConfig config) {
    if (_dayChangeTask != null) return;

    _dayChangeTask = _clock.scheduleCron(
        "0 ${config.startingHourOfTheDay} * * *", //
        () => setDay(_clock.now()));
  }

  DateTime _getCurrentDay(WaterConfig config) {
    var now = _clock.now();

    if (now.hour < config.startingHourOfTheDay) {
      now = now.addDays(-1, true);
    }

    return now.startOfDay;
  }

  Future<DateTime> getDay() async {
    if (_day == null) {
      var config = await getConfig();

      _day = _getCurrentDay(config);

      _startDayChangeTask(config);
    }

    return _day!;
  }

  Future<void> setDay(DateTime date) async {
    date = date.startOfDay;

    if (_day == date) return;

    _day = date;
    _total = null;
    _glasses = null;

    if (_config != null) {
      var config = _config!;

      var now = _getCurrentDay(config);

      if (now == _day) {
        _startDayChangeTask(config);
      } else {
        _stopDayChangeTask();
      }
    }

    events.emit('change', 'day');
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
    assert(quantity > 0);

    var consumption = WaterConsumption(_clock.now(), quantity, glass);

    assert(consumption.date.startOfDay == await getDay());

    consumption = await _db.add(consumption);

    _glasses?.add(consumption);
    if (_total != null) _total = _total! + consumption.quantity;

    events.emit('change', 'glasses');
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
