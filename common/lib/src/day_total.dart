import 'day.dart';

class DayTotal {
  final Day day;
  final int total;

  DayTotal(this.day, this.total);

  /// start: inclusive
  /// end: inclusive
  static List<DayTotal> createRange<T>(Day start, Day end, List<T> totals,
      Day Function(T) getDay, int Function(T) getTotal) {
    var days = <Day, int>{};
    for (var t in totals) {
      days[getDay(t)] = getTotal(t);
    }

    var result = <DayTotal>[];
    for (var d = start; d <= end; d = d.addDays(1)) {
      result.add(DayTotal(d, days[d] ?? 0));
    }
    return result;
  }
}
