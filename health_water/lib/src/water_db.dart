import 'package:lrk_common/common.dart';
import 'package:lrk_health_water/src/water_model.dart';

/// All quantities in ml
abstract class WaterDB {
  Future<WaterConfig> getConfig();
  Future<void> updateConfig(WaterConfig config);

  Future<int> getTotal(DateTime day);

  /// start: inclusive
  /// end: inclusive
  Future<Map<DateTime, int>> listTotals(DateTime start, DateTime end);

  Future<List<WaterConsumption>> listDetails(DateTime day);

  Future<WaterConsumption> add(WaterConsumption consumption);
}

class MemoryWaterDB implements WaterDB {
  final _entries = <WaterConsumption>[];
  WaterConfig? _config;

  @override
  Future<WaterConfig> getConfig() async {
    _config ??= WaterConfig();
    return _config!;
  }

  @override
  Future<void> updateConfig(WaterConfig config) async {
    _config = config;
  }

  @override
  Future<WaterConsumption> add(WaterConsumption consumption) async {
    _entries.add(consumption);

    return consumption;
  }

  @override
  Future<int> getTotal(DateTime day) async {
    int result = _entries
        .where((e) => e.date.isSameDay(day)) //
        .fold(0, (v, e) => v + e.quantity);
    return result;
  }

  @override
  Future<List<WaterConsumption>> listDetails(DateTime day) async =>
      _entries.where((e) => e.date.isSameDay(day)).toList();

  @override
  Future<Map<DateTime, int>> listTotals(DateTime start, DateTime end) async {
    return _entries
        .where((e) => e.date >= start && e.date <= end)
        .groupBy((e) => e.date.startOfDay)
        .toHashMap((e) => MapEntry(e.key, e.elements.sum((i) => i.quantity)));
  }
}
