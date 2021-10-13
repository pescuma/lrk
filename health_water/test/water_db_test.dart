import 'package:lrk_common_testing/common_testing.dart';
import 'package:lrk_health_water/water.dart';
import 'package:test/test.dart';

void main() {
  final date = DateTime(2000, 1, 2);
  final datetime = DateTime(2000, 1, 2, 3, 4, 5);

  test_db('Empty', (db, time) async {
    expect(await db.getTotal(date), equals(0));
    expect(await db.listDetails(date), isEmpty);
  });

  test_db('Add one', (db, time) async {
    db.add(WaterConsumption(datetime, 250, Glass.glass));

    expect(await db.getTotal(date), equals(250));
  });

  test_db('Add two', (db, time) async {
    await db.add(WaterConsumption(datetime, 250, Glass.glass));
    await db.add(WaterConsumption(datetime, 350, Glass.glass));

    expect(await db.getTotal(date), equals(600));
  });

  test_db('List totals', (db, time) async {
    var year = 2000;
    var month = 1;

    for (int i = 1; i <= 4; i++) {
      await db.add(WaterConsumption(DateTime(year, month, i, 1, 1), 250, Glass.glass));
      await db.add(WaterConsumption(DateTime(year, month, i, 2, 1), 350, Glass.glass));
    }

    expect(
        await db.listTotals(DateTime(year, month, 2), DateTime(year, month, 4)),
        equals({
          DateTime(year, month, 2): 600, //
          DateTime(year, month, 3): 600
        }));
  });
}

void test_db(description, dynamic Function(WaterDB, FakeTime) body) {
  test_c(description, (time) {
    final db = MemoryWaterDB();

    body(db, time);
  });
}
