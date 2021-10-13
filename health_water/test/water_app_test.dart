import 'package:dart_date/dart_date.dart';
import 'package:lrk_common_testing/common_testing.dart';
import 'package:lrk_health_water/water.dart';
import 'package:test/test.dart';

void main() {
  void Function() prepare(void Function(WaterApp, FakeTime) body) {
    return fake((time) {
      var app = WaterApp(MemoryWaterDB(), time.clock);
      body(app, time);
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

  // cron does not allow faking time
  // test('Update current day', app((app, time) {
  //   time.now = DateTime(2000, 1, 1);
  //
  //   var day1 = time.await(app.getDay());
  //
  //   time.elapse(Duration(days: 10, minutes: 1));
  //
  //   var day2 = time.await(app.getDay());
  //
  //   expect(day1, equals(DateTime(2000, 1, 1)));
  //   expect(day2, equals(DateTime(2000, 1, 2)));
  // }));
}
