import 'package:lrk_health_water/water.dart';

class WaterSqliteDB implements WaterDB {
  @override
  Future<void> add(WaterConsumption consumption) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<WaterConfig> getConfig() {
    // TODO: implement getConfig
    throw UnimplementedError();
  }

  @override
  Future<int> getTotal(DateTime day) {
    // TODO: implement getTotal
    throw UnimplementedError();
  }

  @override
  Future<List<WaterConsumption>> listDetails(DateTime day) {
    // TODO: implement listDetails
    throw UnimplementedError();
  }

  @override
  Future<Map<DateTime, int>> listTotals(DateTime start, DateTime end) {
    // TODO: implement listTotals
    throw UnimplementedError();
  }

  @override
  Future<void> updateConfig(WaterConfig config) {
    // TODO: implement updateConfig
    throw UnimplementedError();
  }
}
