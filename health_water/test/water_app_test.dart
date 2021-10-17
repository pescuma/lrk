import 'package:dart_date/dart_date.dart';
import 'package:lrk_common_testing/common_testing.dart';
import 'package:lrk_health_water/water.dart';
import 'package:test/test.dart';

void main() {
  void Function() prepare(void Function(WaterApp, FakeTime) body) {
    return fake((time) {
      var app = WaterApp(MemoryWaterDB(), time.clock);

      body(app, time);

      time.await(app.dispose());
    });
  }

  test('Empty', prepare((app, time) {
    expect(time.await(app.getTotal()), equals(0));
    expect(time.await(app.getGlasses()), isEmpty);
  }));

  test('Today', prepare((app, time) {
    time.now = DateTime(2000, 1, 2, 3, 4, 5);

    expect(time.await(app.getDay()), equals(time.now.startOfDay));
  }));

  test('Respect start of day - before', prepare((app, time) {
    time.now = DateTime(2000, 1, 2, 2);

    time.await(app.setConfig(WaterConfig(startingHourOfTheDay: 3)));

    expect(time.await(app.getDay()), equals(DateTime(2000, 1, 1)));
  }));

  test('Respect start of day - same', prepare((app, time) {
    time.now = DateTime(2000, 1, 2, 3);

    time.await(app.setConfig(WaterConfig(startingHourOfTheDay: 3)));

    expect(time.await(app.getDay()), equals(DateTime(2000, 1, 2)));
  }));

  test('Respect start of day - after', prepare((app, time) {
    time.now = DateTime(2000, 1, 2, 4);

    time.await(app.setConfig(WaterConfig(startingHourOfTheDay: 3)));

    expect(time.await(app.getDay()), equals(DateTime(2000, 1, 2)));
  }));

  test('Not reached', prepare((app, time) {
    time.await(app.setConfig(WaterConfig(targetConsumption: 2000)));

    time.await(app.add(100));
    time.await(app.add(200));

    expect(time.await(app.getTotal()), equals(300));
    expect(time.await(app.getTarget()), equals(2000));
    expect(time.await(app.reachedTarget()), equals(false));
  }));

  test('Reached', prepare((app, time) {
    time.await(app.setConfig(WaterConfig(targetConsumption: 2000)));

    time.await(app.add(100));
    time.await(app.add(1900));

    expect(time.await(app.getTotal()), equals(2000));
    expect(time.await(app.getTarget()), equals(2000));
    expect(time.await(app.reachedTarget()), equals(true));
  }));

  test('Glasses', prepare((app, time) {
    time.await(app.add(100));
    time.await(app.add(200, Glass.coffeeCup));
    time.await(app.add(300, Glass.mug));

    expect(
        time.await(app.getGlasses()),
        equals([
          WaterConsumption(time.now, 100, Glass.glass),
          WaterConsumption(time.now, 200, Glass.coffeeCup),
          WaterConsumption(time.now, 300, Glass.mug)
        ]));
  }));

  test('Update current day', prepare((app, time) {
    time.now = DateTime(2000, 1, 1);

    var day1 = time.await(app.getDay());

    time.elapse(Duration(days: 1));

    var day2 = time.await(app.getDay());

    expect(day1, equals(DateTime(2000, 1, 1)));
    expect(day2, equals(DateTime(2000, 1, 2)));
  }));

  test('Update day only if current', prepare((app, time) {
    time.now = DateTime(2001, 1, 1);
    var past = DateTime(2000, 1, 1);

    // Init timers for today
    time.await(app.getDay());

    time.await(app.setDay(past));

    time.elapse(Duration(days: 10));

    var day2 = time.await(app.getDay());

    expect(day2, equals(past));
  }));

  test('Change on setDate', prepare((app, time) {
    var changes = 0;
    app.events.on('change', () => changes++);

    time.await(app.setDay(DateTime(2000, 1, 2)));

    expect(changes, equals(1));
  }));

  test('No change on lazy init', prepare((app, time) {
    var changes = 0;
    app.events.on('change', () => changes++);

    time.await(app.getDay());

    expect(changes, equals(0));
  }));

  test('Change on new day', prepare((app, time) {
    var changes = 0;
    app.events.on('change', () => changes++);

    time.await(app.getDay());

    time.elapse(Duration(days: 1));

    expect(changes, equals(1));
  }));

  test('Change on add', prepare((app, time) {
    var changes = 0;
    app.events.on('change', () => changes++);

    time.await(app.add(200));

    expect(changes, equals(1));
  }));

  test('Change on config', prepare((app, time) {
    var changes = 0;
    app.events.on('change', () => changes++);

    time.await(app.setConfig(WaterConfig(startingHourOfTheDay: 12)));

    expect(changes, equals(1));
  }));

  test('No change on same config', prepare((app, time) {
    var changes = 0;
    app.events.on('change', () => changes++);

    var config = time.await(app.getConfig());

    time.await(app.setConfig(WaterConfig(
        startingHourOfTheDay: config.startingHourOfTheDay,
        targetConsumption: config.targetConsumption)));

    expect(changes, equals(0));
  }));
}
