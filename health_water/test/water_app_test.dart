import 'package:lrk_common/common.dart';
import 'package:lrk_common_testing/common_testing.dart';
import 'package:lrk_health_water/water.dart';
import 'package:lrk_users/users.dart';
import 'package:test/test.dart';

void main() {
  void Function() prepare(void Function(WaterApp, UsersApp, FakeTime) body) {
    return fake((time) {
      var users = UsersApp(MemoryUsersDB());
      var app = WaterApp(MemoryWaterDB(), users, time.clock);

      body(app, users, time);

      time.await(app.dispose());
    });
  }

  test('Empty', prepare((app, users, time) {
    expect(time.await(app.getTotal()), equals(0));
    expect(time.await(app.getGlasses()), isEmpty);
  }));

  test('Today', prepare((app, users, time) {
    time.now = DateTime(2000, 1, 2, 3, 4, 5);

    expect(time.await(app.getDay()), equals(Day.fromDateTime(time.now)));
  }));

  test('Respect start of day - before', prepare((app, users, time) {
    time.now = DateTime(2000, 1, 2, 2);

    time.await(users.setCurrentUserConfig(UserConfig(dayChangeHour: 3)));

    expect(time.await(app.getDay()), equals(Day(2000, 1, 1)));
  }));

  test('Respect start of day - same', prepare((app, users, time) {
    time.now = DateTime(2000, 1, 2, 3);

    time.await(users.setCurrentUserConfig(UserConfig(dayChangeHour: 3)));

    expect(time.await(app.getDay()), equals(Day(2000, 1, 2)));
  }));

  test('Respect start of day - after', prepare((app, users, time) {
    time.now = DateTime(2000, 1, 2, 4);

    time.await(users.setCurrentUserConfig(UserConfig(dayChangeHour: 3)));

    expect(time.await(app.getDay()), equals(Day(2000, 1, 2)));
  }));

  test('Not reached', prepare((app, users, time) {
    time.await(app.setConfig(WaterConfig(targetConsumption: 2000)));

    time.await(app.add(100));
    time.await(app.add(200));

    expect(time.await(app.getTotal()), equals(300));
    expect(time.await(app.getTarget()), equals(2000));
    expect(time.await(app.reachedTarget()), equals(false));
  }));

  test('Reached', prepare((app, users, time) {
    time.await(app.setConfig(WaterConfig(targetConsumption: 2000)));

    time.await(app.add(100));
    time.await(app.add(1900));

    expect(time.await(app.getTotal()), equals(2000));
    expect(time.await(app.getTarget()), equals(2000));
    expect(time.await(app.reachedTarget()), equals(true));
  }));

  test('Glasses', prepare((app, users, time) {
    time.await(app.add(100));
    time.await(app.add(200, Glass.coffeeCup));
    time.await(app.add(300, Glass.mug));

    expect(
        time.await(app.getGlasses()),
        equals([
          WaterConsumption(
              userId: 1, date: time.now, quantity: 100, glass: Glass.glass),
          WaterConsumption(
              userId: 1, date: time.now, quantity: 200, glass: Glass.coffeeCup),
          WaterConsumption(
              userId: 1, date: time.now, quantity: 300, glass: Glass.mug)
        ]));
  }));

  test('Update current day', prepare((app, users, time) {
    time.now = DateTime(2000, 1, 1);

    var day1 = time.await(app.getDay());

    time.elapse(Duration(days: 1));

    var day2 = time.await(app.getDay());

    expect(day1, equals(Day(2000, 1, 1)));
    expect(day2, equals(Day(2000, 1, 2)));
  }));

  test('Update day only if current', prepare((app, users, time) {
    time.now = DateTime(2001, 1, 1);
    var past = Day(2000, 1, 1);

    // Init timers for today
    time.await(app.getDay());

    time.await(app.setDay(past));

    time.elapse(Duration(days: 10));

    var day2 = time.await(app.getDay());

    expect(day2, equals(past));
  }));

  test('Change on setDate', prepare((app, users, time) {
    var changes = 0;
    app.events.on('change', () => changes++);

    time.await(app.setDay(Day(2000, 1, 2)));

    expect(changes, equals(1));
  }));

  test('No change on lazy init', prepare((app, users, time) {
    var changes = 0;
    app.events.on('change', () => changes++);

    time.await(app.getDay());

    expect(changes, equals(0));
  }));

  test('Change on new day', prepare((app, users, time) {
    var changes = 0;
    app.events.on('change', () => changes++);

    time.await(app.getDay());

    time.elapse(Duration(days: 1));

    expect(changes, equals(1));
  }));

  test('Change on add', prepare((app, users, time) {
    var changes = 0;
    app.events.on('change', (what) {
      if (what == 'glasses') {
        changes++;
      }
    });

    time.await(app.add(200));

    expect(changes, equals(1));
  }));

  test('Change on config', prepare((app, users, time) {
    var changes = 0;
    app.events.on('change', (what) {
      if (what == 'config') {
        changes++;
      }
    });

    time.await(app.setConfig(WaterConfig(targetConsumption: 12)));

    expect(changes, equals(1));
  }));

  test('No change on same config', prepare((app, users, time) {
    var changes = 0;
    app.events.on('change', () => changes++);

    var config = time.await(app.getConfig());

    time.await(app
        .setConfig(WaterConfig(targetConsumption: config.targetConsumption)));

    expect(changes, equals(0));
  }));

  test('Expected during day', prepare((app, users, time) {
    time.await(
        users.setCurrentUserConfig(UserConfig(wakeUpHour: 10, sleepHour: 15)));

    expect(time.await(app.getExpected()), equals(0));

    time.elapse(Duration(hours: 10));
    expect(time.await(app.getExpected()), equals(0));

    time.elapse(Duration(hours: 1));
    expect(time.await(app.getExpected()), equals(500));

    time.elapse(Duration(hours: 1));
    expect(time.await(app.getExpected()), equals(1000));

    time.elapse(Duration(hours: 1));
    expect(time.await(app.getExpected()), equals(1500));

    time.elapse(Duration(hours: 1));
    expect(time.await(app.getExpected()), equals(2000));

    time.elapse(Duration(hours: 1));
    expect(time.await(app.getExpected()), equals(2000));
  }));
}
