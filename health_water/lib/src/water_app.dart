import 'package:lrk_common/common.dart';
import 'package:lrk_users/users.dart';

import 'water_db.dart';
import 'water_model.dart';

class WaterApp extends BaseApp {
  final WaterDB _db;
  final UsersApp _users;
  final Clock _clock;
  UserConfig? _userConfig;
  WaterConfig? _config;
  DateTime? _day;
  DateTime? _dayStart;
  DateTime? _dayEnd;
  int? _total;
  ScheduledTask? _dayChangeTask;
  List<WaterConsumption>? _glasses;

  WaterApp(this._db, this._users, this._clock) {
    _users.events.on('change', (what, obj) {
      if (what == 'currentUser') _onCurrentUserChange();
      if (what == 'currentUserConfig') _onCurrentUserConfigChange(obj);
    });
  }

  Future<UserConfig> _getUserConfig() async {
    _userConfig ??= await _users.getCurrentUserConfig();
    return _userConfig!;
  }

  Future<WaterConfig> getConfig() async {
    var user = await _getUserConfig();
    _config ??= await _db.getConfig(user.userId);
    _config ??= await _db.saveConfig(WaterConfig(userId: user.userId));
    return _config!;
  }

  Future<void> setConfig(WaterConfig config) async {
    var user = await _getUserConfig();

    if (config.userId != user.userId) {
      config = config.withUserId(user.userId);
    }

    if (await getConfig() == config) {
      return;
    }

    _config = await _db.saveConfig(config);

    await events.emit('change', 'config', _config!);
  }

  Future<DateTime> getDay() async {
    if (_day == null) {
      var user = await _getUserConfig();

      _day = _getCurrentDay(user);

      _startDayChangeTask(user);
    }
    return _day!;
  }

  Future<void> setDay(DateTime date) async {
    date = date.startOfDay;

    if (_day == date) return;

    var user = await _getUserConfig();

    _day = date;
    _total = null;
    _glasses = null;

    var today = _getCurrentDay(user);
    if (_day == today) {
      _startDayChangeTask(user);
    } else {
      _stopDayChangeTask();
    }

    await events.emit('change', 'day', _day!);
  }

  Future<int> getTotal() async {
    if (_total == null) {
      var user = await _getUserConfig();
      _total = await _db.getTotal(user.userId, await getDay());
    }
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
    if (_glasses == null) {
      var user = await _getUserConfig();
      _glasses = await _db.listDetails(user.userId, await getDay());
    }
    return _glasses!;
  }

  Future<void> add(int quantity, [Glass glass = Glass.glass]) async {
    assert(quantity > 0);

    var user = await _getUserConfig();
    var day = await getDay();

    var time = _clock.now();
    if (time.startOfDay != day) {
      time = DateTime(day.year, day.month, day.day, time.hour, time.minute,
          time.second, time.millisecond, time.microsecond);
    }

    var consumption = WaterConsumption(
        userId: user.userId, date: time, quantity: quantity, glass: glass);

    consumption = await _db.add(consumption);

    _glasses?.add(consumption);

    if (_total != null) {
      _total = _total! + consumption.quantity;
    }

    await events.emit('change', 'glasses');
  }

  /// start: inclusive
  /// end: inclusive
  Future<List<DayTotal>> listTotals(DateTime start, DateTime end) async {
    start = start.startOfDay;
    end = end.startOfDay.addDays(1, true);

    var user = await _getUserConfig();

    var totals = await _db.listTotals(user.userId, start, end);

    return DayTotal.createRange(start, end, totals);
  }

  void _onCurrentUserChange() {
    _stopDayChangeTask();
    _userConfig = null;
    _config = null;
    _total = null;
    _glasses = null;
  }

  void _onCurrentUserConfigChange(UserConfig userConfig) {
    var restartTask = _day != null &&
        _userConfig != null &&
        _userConfig!.dayChangeHour != userConfig.dayChangeHour &&
        _day != _getCurrentDay(userConfig);

    if (restartTask) {
      _stopDayChangeTask();
    }

    _userConfig = userConfig;

    if (restartTask) {
      _startDayChangeTask(userConfig);
    }
  }

  DateTime _getCurrentDay(UserConfig config) {
    var now = _clock.now();

    if (now.hour < config.dayChangeHour) {
      now = now.addDays(-1, true);
    }

    return now.startOfDay;
  }

  void _startDayChangeTask(UserConfig config) {
    if (_dayChangeTask != null) return;

    _dayChangeTask = _clock.scheduleCron(
        "0 ${config.dayChangeHour} * * *", //
        () => setDay(_clock.now()));
  }

  void _stopDayChangeTask() {
    _dayChangeTask?.cancel();
    _dayChangeTask = null;
  }

  @override
  Future<void> dispose() async {
    _dayChangeTask?.cancel();

    super.dispose();
  }
}

class DayConfig {}
