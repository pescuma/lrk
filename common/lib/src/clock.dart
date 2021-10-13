import 'package:clock/clock.dart' as pkg_clock;
import 'package:cron/cron.dart' as pkg_cron;
import 'dart:async';

class Clock {
  final pkg_clock.Clock _clock = pkg_clock.clock;
  final pkg_cron.Cron _cron = pkg_cron.Cron();

  DateTime now() => _clock.now();

  Stopwatch stopwatch() => _clock.stopwatch();

  ScheduledTask scheduleCron(String cron, void Function() callback) {
    var task = _cron.schedule(pkg_cron.Schedule.parse(cron), callback);
    return _CronScheduledTask(task);
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
  Future<void> cancel();
}

class _CronScheduledTask implements ScheduledTask {
  final pkg_cron.ScheduledTask _task;

  _CronScheduledTask(this._task);

  @override
  Future<void> cancel() async {
    await _task.cancel();
  }
}

class _TimerScheduledTask implements ScheduledTask {
  final Timer _timer;

  _TimerScheduledTask(this._timer);

  @override
  Future<void> cancel() async {
    _timer.cancel();
  }
}
