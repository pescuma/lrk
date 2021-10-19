import 'package:lrk_common/common.dart';

import 'water_model.dart';

/// All quantities in ml
abstract class WaterDB {
  Future<WaterConfig?> getConfig(int userId);
  Future<WaterConfig> saveConfig(WaterConfig config);

  Future<int> getTotal(int userId, DateTime day);

  /// start: inclusive
  /// end: inclusive
  Future<Map<DateTime, int>> listTotals(int userId, DateTime start, DateTime end);

  Future<List<WaterConsumption>> listDetails(int userId, DateTime day);

  Future<WaterConsumption> add(WaterConsumption consumption);

  Future<void> dispose();
}

class MemoryWaterDB implements WaterDB {
  final _configs = <int, WaterConfig>{};
  final _entries = <WaterConsumption>[];

  @override
  Future<WaterConfig?> getConfig(int userId) async {
    return _configs[userId];
  }

  @override
  Future<WaterConfig> saveConfig(WaterConfig config) async {
    _configs[config.userId] = config;
    return config;
  }

  @override
  Future<WaterConsumption> add(WaterConsumption consumption) async {
    _entries.add(consumption);
    return consumption;
  }

  @override
  Future<int> getTotal(int userId, DateTime day) async {
    return _entries
        .where((e) => e.userId == userId && e.date.isSameDay(day))
        .fold<int>(0, (v, e) => v + e.quantity);
  }

  @override
  Future<List<WaterConsumption>> listDetails(int userId, DateTime day) async {
    return _entries.where((e) => e.userId == userId && e.date.isSameDay(day)).toList();
  }

  @override
  Future<Map<DateTime, int>> listTotals(int userId, DateTime start, DateTime end) async {
    return _entries
        .where((e) => e.userId == userId && e.date >= start && e.date <= end)
        .groupBy((e) => e.date.startOfDay)
        .toHashMap((e) => MapEntry(e.key, e.elements.sum((i) => i.quantity)));
  }

  @override
  Future<void> dispose() async {}
}
