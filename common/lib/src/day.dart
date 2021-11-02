import 'package:dart_date/dart_date.dart';

class Day {
  final int year;
  final int month;
  final int day;

  Day(this.year, this.month, this.day);

  DateTime get start => toDateTime();
  DateTime get end => toDateTime().endOfDay;
  int get timestamp => start.timestamp;

  Day addDays(int days) {
    var d = toDateTime().addDays(days, true);
    return Day.fromDateTime(d);
  }

  Day addMonths(int months) {
    var d = toDateTime().addMonths(months);
    return Day.fromDateTime(d);
  }

  Day addYears(int years) {
    var d = toDateTime().addYears(years);
    return Day.fromDateTime(d);
  }

  DateTime toDateTime() => DateTime(year, month, day);

  int toInt() => year * 10000 + month * 100 + day;

  Day.fromDateTime(DateTime dt)
      : year = dt.year,
        month = dt.month,
        day = dt.day;

  Day.fromInt(int day)
      : year = day ~/ 10000,
        month = day ~/ 100 % 100,
        day = day % 100;

  @override
  String toString() {
    return '$year-$month-$day';
  }

  bool operator <=(Day other) => toDateTime() <= other.toDateTime();
  bool operator <(Day other) => toDateTime() < other.toDateTime();
  bool operator >=(Day other) => toDateTime() >= other.toDateTime();
  bool operator >(Day other) => toDateTime() > other.toDateTime();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Day &&
          runtimeType == other.runtimeType &&
          year == other.year &&
          month == other.month &&
          day == other.day;

  @override
  int get hashCode => year.hashCode ^ month.hashCode ^ day.hashCode;
}
