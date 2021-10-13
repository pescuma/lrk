import 'package:darq/darq.dart';
import 'package:dart_date/dart_date.dart';
import 'package:lrk_health_water/src/water_app.dart';
import 'package:lrk_health_water/src/water_model.dart';

/// All quantities in ml
abstract class WaterDB {
  WaterConfig getConfig();
  void updateConfig(WaterConfig config);

  int getTotal(DateTime day);

  /// start: inclusive
  /// end: exclusive
  Map<DateTime, int> listTotals(DateTime start, DateTime end);

  List<WaterConsumption> listDetails(DateTime day);

  void add(WaterConsumption consumption);
}

class MemoryWaterDb implements WaterDB {
  final _entries = <WaterConsumption>[];
  WaterConfig? _config;

  @override
  WaterConfig getConfig() {
    _config ??= WaterConfig();
    return _config!;
  }

  @override
  void updateConfig(WaterConfig config) {
    _config = config;
  }

  @override
  void add(WaterConsumption consumption) {
    _entries.add(consumption);
  }

  @override
  int getTotal(DateTime day) =>
      _entries.where((e) => e.date.isSameDay(day)).fold(0, (v, e) => v + e.quantity);

  @override
  List<WaterConsumption> listDetails(DateTime day) =>
      _entries.where((e) => e.date.isSameDay(day)).toList();

  @override
  Map<DateTime, int> listTotals(DateTime start, DateTime end) {
    return _entries
        .where((e) => e.date >= start && e.date < end)
        .groupBy((e) => e.date.startOfDay)
        .toHashMap((e) => MapEntry(e.key, e.elements.sum((i) => i.quantity)));
  }
}
