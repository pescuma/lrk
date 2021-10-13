import 'package:dart_date/dart_date.dart';

class DayTotal {
  final DateTime day;
  final int total;

  DayTotal(this.day, this.total);

  /// start: inclusive
  /// end: exclusive
  static List<DayTotal> createRange(DateTime start, DateTime end, Map<DateTime, int> totals) {
    var result = <DayTotal>[];

    for (var d = start; d < end; d = d.addDays(1, true)) {
      result.add(DayTotal(d, totals[d] ?? 0));
    }

    return result;
  }
}
