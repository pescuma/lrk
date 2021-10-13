import 'package:lrk_health_water/water.dart';
import 'package:test/test.dart';

void main() {
  final date = DateTime(2000, 1, 2);
  final datetime = DateTime(2000, 1, 2, 3, 4, 5);

  test('Empty', () {
    final db = MemoryWaterDb();

    expect(db.getTotal(date), equals(0));
    expect(db.listDetails(date), isEmpty);
  });

  test('Add one', () {
    final db = MemoryWaterDb();

    db.add(WaterConsumption(datetime, 250, Glass.glass));

    expect(db.getTotal(date), equals(250));
  });

  test('Add two', () {
    final db = MemoryWaterDb();

    db.add(WaterConsumption(datetime, 250, Glass.glass));
    db.add(WaterConsumption(datetime, 350, Glass.glass));

    expect(db.getTotal(date), equals(600));
  });

  test('List totals', () {
    final db = MemoryWaterDb();
    var year = 2000;
    var month = 1;

    for (int i = 1; i <= 4; i++) {
      db.add(WaterConsumption(DateTime(year, month, i, 1, 1), 250, Glass.glass));
      db.add(WaterConsumption(DateTime(year, month, i, 2, 1), 350, Glass.glass));
    }

    expect(
        db.listTotals(DateTime(year, month, 2), DateTime(year, month, 4)),
        equals({
          DateTime(year, month, 2): 600, //
          DateTime(year, month, 3): 600
        }));
  });
}
