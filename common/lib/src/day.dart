import 'package:dart_date/dart_date.dart';

class Day {
  final int day;
  final int month;
  final int year;

  Day({required this.day, required this.month, required this.year});

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

  Day.fromDateTime(DateTime dt)
      : day = dt.day,
        month = dt.month,
        year = dt.year;
}
