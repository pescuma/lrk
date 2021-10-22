import 'dart:async';

import 'package:clock/clock.dart' as pkg_clock;
import 'package:cron/cron.dart' as pkg_cron;
import 'package:dart_date/dart_date.dart';

class Clock {
  final pkg_clock.Clock _clock = pkg_clock.clock;

  DateTime now() => _clock.now();

  Stopwatch stopwatch() => _clock.stopwatch();

  ScheduledTask scheduleCron(String cron, void Function() callback) {
    return _CronScheduledTask(_clock, cron, callback);
  }

  ScheduledTask scheduleIn(Duration duration, void Function() callback) {
    var timer = Timer(duration, callback);
    return _TimerScheduledTask(timer);
  }

  ScheduledTask scheduleEach(Duration duration, void Function() callback) {
    var timer = Timer.periodic(duration, (timer) => callback());
    return _TimerScheduledTask(timer);
  }
}

abstract class ScheduledTask {
  void cancel();
}

class _CronScheduledTask implements ScheduledTask {
  final pkg_clock.Clock _clock;
  final pkg_cron.Schedule _schedule;
  final void Function() _callback;
  Timer? _nextTimer;

  _CronScheduledTask(this._clock, String cron, this._callback)
      : _schedule = pkg_cron.Schedule.parse(cron) {
    _scheduleNext();
  }

  void _scheduleNext() {
    assert(_nextTimer == null);

    var nextTime = _findNextTime(_clock.now());

    _nextTimer = Timer(nextTime.difference(_clock.now()), _execute);
  }

  DateTime _findNextTime(DateTime time) {
    time = time.startOfMinute.addMinutes(1);

    while (!_schedule.shouldRunAt(time)) {
      time = time.addMinutes(1);
    }

    return time;
  }

  void _execute() {
    _nextTimer = null;

    try {
      _callback();
    } finally {
      _scheduleNext();
    }
  }

  @override
  void cancel() async {
    _nextTimer?.cancel();
    _nextTimer = null;
  }
}

class _TimerScheduledTask implements ScheduledTask {
  final Timer _timer;

  _TimerScheduledTask(this._timer);

  @override
  void cancel() async {
    _timer.cancel();
  }
}
