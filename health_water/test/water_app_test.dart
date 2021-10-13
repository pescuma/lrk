import 'package:lrk_health_water/water.dart';
import 'package:test/test.dart';
import 'package:dart_date/dart_date.dart';
import 'package:lrk_common_testing/common_testing.dart';

void main() {
  test_app('Empty', (app, time) {
    expect(app.total, equals(0));
    expect(app.glasses, isEmpty);
  });

  test_app('Today', (app, time) {
    expect(app.day, equals(time.clock.now().startOfDay));
  });

  test_app('Respect start of day - before', (app, time) {
    time.now = DateTime(2000, 1, 2, 2);

    app.config = WaterConfig(startingHourOfTheDay: 3);

    expect(app.day, equals(DateTime(2000, 1, 1)));
  });

  test_app('Respect start of day - same', (app, time) {
    time.now = DateTime(2000, 1, 2, 3);

    app.config = WaterConfig(startingHourOfTheDay: 3);

    expect(app.day, equals(DateTime(2000, 1, 2)));
  });

  test_app('Respect start of day - after', (app, time) {
    time.now = DateTime(2000, 1, 2, 4);

    app.config = WaterConfig(startingHourOfTheDay: 3);

    expect(app.day, equals(DateTime(2000, 1, 2)));
  });

  test_app('Not reached', (app, time) {
    app.config = WaterConfig(targetConsumption: 2000);

    app.add(100);
    app.add(200);

    expect(app.total, equals(300));
    expect(app.target, equals(2000));
    expect(app.reachedTarget, equals(false));
  });

  test_app('Reached', (app, time) {
    app.config = WaterConfig(targetConsumption: 2000);

    app.add(100);
    app.add(1900);

    expect(app.total, equals(2000));
    expect(app.target, equals(2000));
    expect(app.reachedTarget, equals(true));
  });

  test_app('Glasses', (app, time) {
    app.config = WaterConfig(targetConsumption: 2000);

    app.add(100);
    app.add(200, Glass.coffeeCup);
    app.add(300, Glass.mug);

    expect(
        app.glasses,
        equals([
          WaterConsumption(time.now, 100, Glass.glass),
          WaterConsumption(time.now, 200, Glass.coffeeCup),
          WaterConsumption(time.now, 300, Glass.mug)
        ]));
  });
}

void test_app(description, dynamic Function(WaterApp, FakeTime) body, {DateTime? time}) {
  test_c(description, (time) {
    var app = WaterApp(MemoryWaterDb(), time.clock);

    body(app, time);
  }, time: time);
}
