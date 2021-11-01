import 'package:lrk_common_testing/common_testing.dart';
import 'package:lrk_health_water/water.dart';
import 'package:test/test.dart';

void main() {
  final date = DateTime(2000, 1, 2);
  final datetime = DateTime(2000, 1, 2, 3, 4, 5);

  void Function() prepare(void Function(WaterDB, FakeTime) body) {
    return fake((time) {
      final db = MemoryWaterDB();
      body(db, time);
    });
  }

  test('Empty', prepare((db, time) {
    expect(time.await(db.getTotal(0, date)), equals(0));
    expect(time.await(db.listDetails(0, date)), isEmpty);
  }));

  test('Add one', prepare((db, time) {
    db.add(WaterConsumption(
        userId: 0, date: datetime, quantity: 250, glass: Glass.glass));

    expect(time.await(db.getTotal(0, date)), equals(250));
  }));

  test('Add two', prepare((db, time) {
    time.await(db.add(WaterConsumption(
        userId: 0, date: datetime, quantity: 250, glass: Glass.glass)));
    time.await(db.add(WaterConsumption(
        userId: 0, date: datetime, quantity: 350, glass: Glass.glass)));

    expect(time.await(db.getTotal(0, date)), equals(600));
  }));

  test('List totals', prepare((db, time) {
    var year = 2000;
    var month = 1;

    for (int i = 1; i <= 4; i++) {
      time.await(db.add(WaterConsumption(
          userId: 0,
          date: DateTime(year, month, i, 1, 1),
          quantity: 250,
          glass: Glass.glass)));
      time.await(db.add(WaterConsumption(
          userId: 0,
          date: DateTime(year, month, i, 2, 1),
          quantity: 350,
          glass: Glass.glass)));
    }

    expect(
        time.await(db.listTotals(
            0, DateTime(year, month, 2), DateTime(year, month, 4))),
        equals({
          DateTime(year, month, 2): 600, //
          DateTime(year, month, 3): 600
        }));
  }));
}
