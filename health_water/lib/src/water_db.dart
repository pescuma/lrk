import 'package:darq/darq.dart';
import 'package:dart_date/dart_date.dart';
import 'package:lrk_health_water/src/water_model.dart';

/// All quantities in ml
abstract class WaterDB {
  int getTotal(DateTime day);

  /// start: inclusive
  /// end: exclusive
  Map<DateTime, int> listTotals(DateTime start, DateTime end);

  List<WaterConsumption> listDetails(DateTime day);

  void add(WaterConsumption consumption);
}

class MemoryWaterDb implements WaterDB {
  var entries = <WaterConsumption>[];

  @override
  void add(WaterConsumption consumption) {
    entries.add(consumption);
  }

  @override
  int getTotal(DateTime day) => entries
      .where((e) => e.date.isSameDay(day))
      .fold(0, (v, e) => v + e.quantity);

  @override
  List<WaterConsumption> listDetails(DateTime day) =>
      entries.where((e) => e.date.isSameDay(day)).toList();

  @override
  Map<DateTime, int> listTotals(DateTime start, DateTime end) {
    return entries
        .where((e) => e.date >= start && e.date < end)
        .groupBy((e) => e.date.startOfDay)
        .toHashMap((e) => MapEntry(e.key, e.elements.sum((i) => i.quantity)));
  }
}
