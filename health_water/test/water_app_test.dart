import 'package:dart_date/dart_date.dart';
import 'package:lrk_common_testing/common_testing.dart';
import 'package:lrk_health_water/water.dart';
import 'package:test/test.dart';

void main() {
  test_app('Empty', (app, time) async {
    expect(await app.getTotal(), equals(0));
    expect(await app.getGlasses(), isEmpty);
  });

  test_app('Today', (app, time) async {
    expect(await app.getDay(), equals(time.clock.now().startOfDay));
  });

  test_app('Respect start of day - before', (app, time) async {
    time.now = DateTime(2000, 1, 2, 2);

    await app.setConfig(WaterConfig(startingHourOfTheDay: 3));

    expect(await app.getDay(), equals(DateTime(2000, 1, 1)));
  });

  test_app('Respect start of day - same', (app, time) async {
    time.now = DateTime(2000, 1, 2, 3);

    await app.setConfig(WaterConfig(startingHourOfTheDay: 3));

    expect(await app.getDay(), equals(DateTime(2000, 1, 2)));
  });

  test_app('Respect start of day - after', (app, time) async {
    time.now = DateTime(2000, 1, 2, 4);

    await app.setConfig(WaterConfig(startingHourOfTheDay: 3));

    expect(await app.getDay(), equals(DateTime(2000, 1, 2)));
  });

  test_app('Not reached', (app, time) async {
    await app.setConfig(WaterConfig(targetConsumption: 2000));

    app.add(100);
    app.add(200);

    expect(await app.getTotal(), equals(300));
    expect(await app.getTarget(), equals(2000));
    expect(await app.reachedTarget(), equals(false));
  });

  test_app('Reached', (app, time) async {
    await app.setConfig(WaterConfig(targetConsumption: 2000));

    app.add(100);
    app.add(1900);

    expect(await app.getTotal(), equals(2000));
    expect(await app.getTarget(), equals(2000));
    expect(await app.reachedTarget(), equals(true));
  });

  test_app('Glasses', (app, time) async {
    await app.add(100);
    await app.add(200, Glass.coffeeCup);
    await app.add(300, Glass.mug);

    expect(
        await app.getGlasses(),
        equals([
          WaterConsumption(time.now, 100, Glass.glass),
          WaterConsumption(time.now, 200, Glass.coffeeCup),
          WaterConsumption(time.now, 300, Glass.mug)
        ]));
  });
}

void test_app(description, dynamic Function(WaterApp, FakeTime) body) {
  test_c(description, (time) {
    var app = WaterApp(MemoryWaterDB(), time.clock);

    body(app, time);
  });
}
