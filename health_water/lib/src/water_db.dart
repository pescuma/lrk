import 'package:lrk_common/common.dart';

import 'water_model.dart';

/// All quantities in ml
abstract class WaterDB {
  Future<WaterConfig?> getConfig(int userId);
  Future<WaterConfig> saveConfig(WaterConfig config);

  Future<WaterDayTotal> getTotal(int userId, Day day);

  /// start: inclusive
  /// end: inclusive
  Future<List<WaterDayTotal>> listTotals(int userId, Day start, Day end);

  /// start: inclusive
  /// end: inclusive
  Future<List<WaterConsumption>> listDetails(
      int userId, DateTime start, DateTime end);

  Future<WaterConsumption> add(
      WaterConsumption consumption, WaterDayTotal total);

  Future<void> dispose();
}

class MemoryWaterDB implements WaterDB {
  final _configs = <int, WaterConfig>{};
  final _consumptions = <WaterConsumption>[];
  final _totals = <Day, WaterDayTotal>{};

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
  Future<WaterConsumption> add(
      WaterConsumption consumption, WaterDayTotal total) async {
    _consumptions.add(consumption);
    _totals[total.day] = total;
    return consumption;
  }

  @override
  Future<WaterDayTotal> getTotal(int userId, Day day) async {
    return _totals[day] ?? WaterDayTotal(userId: userId, day: day, total: 0);
  }

  @override
  Future<List<WaterConsumption>> listDetails(
      int userId, DateTime start, DateTime end) async {
    return _consumptions
        .where((e) =>
            e.userId == userId &&
            e.date.isSameOrAfter(start) &&
            e.date.isSameOrBefore(end))
        .toList();
  }

  @override
  Future<List<WaterDayTotal>> listTotals(int userId, Day start, Day end) async {
    return _totals.values
        .where((e) => e.userId == userId && e.day >= start && e.day <= end)
        .toList();
  }

  @override
  Future<void> dispose() async {}
}
