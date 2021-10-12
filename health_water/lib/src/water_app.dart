import 'package:clock/clock.dart';
import 'package:dart_date/dart_date.dart';
import 'package:lrk_health_water/src/water_db.dart';
import 'package:lrk_health_water/src/water_model.dart';

class WaterApp {
  final WaterConfig _config;
  final WaterDB _db;
  final Clock _clock;
  DateTime? _day;
  int? _total;
  List<WaterConsumption>? _glasses;

  WaterApp(this._config, this._db, this._clock);

  DateTime get day {
    if (_day == null) {
      var d = _clock.now();

      if (d.hour < _config.startingHourOfTheDay) {
        d = d.addDays(-1, true);
      }

      _day = d.startOfDay;
    }

    return _day!;
  }

  set day(DateTime date) {
    date = date.startOfDay;

    if (_day == date) return;

    _day = date;
    _total = null;
    _glasses = null;
  }

  int get total {
    _total ??= _db.getTotal(day);

    return _total!;
  }

  int get target {
    return _config.targetConsumption;
  }

  bool get reachedTarget {
    return total >= target;
  }

  List<WaterConsumption> get glasses {
    _glasses ??= _db.listDetails(day);

    return _glasses!;
  }

  void add(int quantity, [Glass glass = Glass.glass]) {
    var consumption = WaterConsumption(_clock.now(), quantity, glass);

    assert(consumption.date.startOfDay == day);

    _db.add(consumption);

    _glasses?.add(consumption);
    if (_total != null) _total = _total! + consumption.quantity;
  }

  /// start: inclusive
  /// end: inclusive
  List<DayTotal> listTotals(DateTime start, DateTime end) {
    start = start.startOfDay;
    end = end.startOfDay.addDays(1, true);

    var totals = _db.listTotals(start, end);

    return DayTotal.newRange(start, end, totals);
  }
}

class WaterConfig {
  int startingHourOfTheDay = 0;

  /// ml
  int targetConsumption = 2000;
}
