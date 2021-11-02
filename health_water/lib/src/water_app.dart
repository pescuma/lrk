import 'package:lrk_common/common.dart';
import 'package:lrk_users/users.dart';

import 'water_db.dart';
import 'water_model.dart';

class WaterApp extends BaseApp {
  final WaterDB _db;
  final UsersApp _users;
  final Clock _clock;
  UserConfig? _cacheUserConfig;
  WaterConfig? _cacheConfig;
  DayConfig? _cacheDayConfig;
  int? _cacheTotal;
  List<WaterConsumption>? _cacheGlasses;
  ScheduledTask? _dayChangeTask;

  WaterApp(this._db, this._users, this._clock) {
    _users.events.on('change', (what, obj) async {
      if (what == 'currentUser') _onCurrentUserChange();
      if (what == 'currentUserConfig') _onCurrentUserConfigChange(obj);
    });
  }

  Future<UserConfig> _getUserConfig() async {
    _cacheUserConfig ??= await _users.getCurrentUserConfig();
    return _cacheUserConfig!;
  }

  Future<WaterConfig> getConfig() async {
    var user = await _getUserConfig();
    _cacheConfig ??= await _db.getConfig(user.userId);
    _cacheConfig ??= await _db.saveConfig(WaterConfig(userId: user.userId));
    return _cacheConfig!;
  }

  Future<void> setConfig(WaterConfig config) async {
    var user = await _getUserConfig();

    if (config.userId != user.userId) {
      assert(config.userId == -1);
      config = config.withUserId(user.userId);
    }

    if (await getConfig() == config) {
      return;
    }

    _cacheConfig = await _db.saveConfig(config);

    await events.emit('change', 'config', _cacheConfig!);
  }

  Future<Day> getDay() async {
    var day = await _getDayConfig();
    return day.day;
  }

  Future<void> setDay(Day day) async {
    if (_cacheDayConfig?.day == day) {
      return;
    }

    var user = await _getUserConfig();
    _cacheDayConfig = user.getDayConfig(day);
    _cacheTotal = null;
    _cacheGlasses = null;

    var today = user.getToday(_clock);
    if (day == today) {
      _startDayChangeTask(user);
    } else {
      _stopDayChangeTask();
    }

    await events.emit('change', 'day', _cacheDayConfig!.day);
  }

  Future<int> getTotal() async {
    if (_cacheTotal == null) {
      var user = await _getUserConfig();
      var day = await _getDayConfig();
      var total = await _db.getTotal(user.userId, day.day);
      _cacheTotal = total.total;
    }
    return _cacheTotal!;
  }

  Future<int> getTarget() async {
    var config = await getConfig();
    return config.targetConsumption;
  }

  Future<bool> reachedTarget() async {
    return await getTotal() >= await getTarget();
  }

  Future<List<WaterConsumption>> getGlasses() async {
    if (_cacheGlasses == null) {
      var user = await _getUserConfig();
      var day = await _getDayConfig();
      _cacheGlasses = await _db.listDetails(user.userId, day.start, day.end);
    }
    return _cacheGlasses!;
  }

  Future<void> add(int quantity, [Glass glass = Glass.glass]) async {
    assert(quantity > 0);

    var user = await _getUserConfig();
    var day = await _getDayConfig();
    var soFar = await getTotal();

    var now = _clock.now();

    var date = DateTime(day.day.year, day.day.month, day.day.day, now.hour,
        now.minute, now.second, now.millisecond, now.microsecond);
    if (date.hour < user.dayChangeHour) {
      date = date.addDays(1, true);
    }
    assert(day.start <= date && date <= day.end);

    var consumption = WaterConsumption(
        userId: user.userId, date: date, quantity: quantity, glass: glass);
    var total = WaterDayTotal(
        userId: user.userId, day: day.day, total: soFar + quantity);

    consumption = await _db.add(consumption, total);

    _cacheGlasses?.add(consumption);
    _cacheTotal = total.total;

    await events.emit('change', 'glasses');
  }

  /// start: inclusive
  /// end: inclusive
  Future<List<DayTotal>> listTotals(Day start, Day end) async {
    var user = await _getUserConfig();

    List<WaterDayTotal> totals = await _db.listTotals(user.userId, start, end);

    return DayTotal.createRange<WaterDayTotal>(
        start, end, totals, (t) => t.day, (t) => t.total);
  }

  Future<void> _onCurrentUserChange() async {
    _stopDayChangeTask();

    _cacheUserConfig = null;
    _cacheConfig = null;
    _cacheTotal = null;
    _cacheGlasses = null;

    if (_cacheDayConfig == null) {
      return;
    }

    var user = await _getUserConfig();
    _cacheDayConfig = user.getDayConfig(_cacheDayConfig!.day);
    _restartDayChangeTask(user);

    await events.emit('change');
  }

  Future<void> _onCurrentUserConfigChange(UserConfig userConfig) async {
    _cacheUserConfig = userConfig;

    if (_cacheDayConfig == null) {
      return;
    }

    var newDayConfig = userConfig.getDayConfig(_cacheDayConfig!.day);
    if (_cacheDayConfig == newDayConfig) {
      return;
    }

    _cacheDayConfig = newDayConfig;
    _cacheTotal = null;
    _cacheGlasses = null;
    _restartDayChangeTask(userConfig);

    await events.emit('change');
  }

  Future<DayConfig> _getDayConfig() async {
    if (_cacheDayConfig == null) {
      var user = await _getUserConfig();
      _cacheDayConfig = user.getTodayConfig(_clock);
      _startDayChangeTask(user);
    }
    return _cacheDayConfig!;
  }

  void _startDayChangeTask(UserConfig config) {
    if (_dayChangeTask != null) {
      return;
    }

    _dayChangeTask = _clock.scheduleCron(
        "0 ${config.dayChangeHour} * * *", //
        () => setDay(Day.fromDateTime(_clock.now())));
  }

  void _stopDayChangeTask() {
    _dayChangeTask?.cancel();
    _dayChangeTask = null;
  }

  void _restartDayChangeTask(UserConfig config) {
    if (_dayChangeTask == null) {
      return;
    }

    _stopDayChangeTask();
    _startDayChangeTask(config);
  }

  @override
  Future<void> dispose() async {
    _dayChangeTask?.cancel();

    super.dispose();
  }
}
