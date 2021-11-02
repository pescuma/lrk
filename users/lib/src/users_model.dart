import 'package:lrk_common/common.dart';

class UsersConfig {
  final int currentUser;

  UsersConfig({this.currentUser = 1});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsersConfig &&
          runtimeType == other.runtimeType &&
          currentUser == other.currentUser;

  @override
  int get hashCode => currentUser.hashCode;
}

class UserConfig {
  final int userId;
  final int dayChangeHour;
  final int sleepHour;
  final int wakeUpHour;

  UserConfig(
      {this.userId = -1,
      this.dayChangeHour = 0,
      this.sleepHour = 23,
      this.wakeUpHour = 7});

  UserConfig withUserId(int userId) {
    return UserConfig(
        userId: userId,
        dayChangeHour: dayChangeHour,
        sleepHour: sleepHour,
        wakeUpHour: wakeUpHour);
  }

  DayConfig getDayConfig(Day day) {
    var start = day.toDateTime().addHours(dayChangeHour, true);
    var end = start.addDays(1, true).addMicroseconds(-1);

    var wakeUp = day.toDateTime().addHours(wakeUpHour, true);
    var sleep = day.toDateTime().addHours(sleepHour, true);
    if (sleepHour <= wakeUpHour) {
      sleep = sleep.addDays(1, true);
    }

    return DayConfig(
        day: day, start: start, wakeUp: wakeUp, sleep: sleep, end: end);
  }

  Day getToday(Clock clock) {
    var now = clock.now();

    if (now.hour < dayChangeHour) {
      now = now.addDays(-1, true);
    }

    return Day.fromDateTime(now);
  }

  DayConfig getTodayConfig(Clock clock) {
    return getDayConfig(getToday(clock));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserConfig &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          dayChangeHour == other.dayChangeHour &&
          wakeUpHour == other.wakeUpHour &&
          sleepHour == other.sleepHour;

  @override
  int get hashCode =>
      userId.hashCode ^
      dayChangeHour.hashCode ^
      wakeUpHour.hashCode ^
      sleepHour.hashCode;
}

class DayConfig {
  final Day day;
  final DateTime start;
  final DateTime wakeUp;
  final DateTime sleep;
  final DateTime end;

  DayConfig(
      {required this.day,
      required this.start,
      required this.wakeUp,
      required this.sleep,
      required this.end});
}

class User {
  final int id;
  final String nickname;
  final String name;

  User({this.id = -1, this.nickname = '', this.name = ''});

  User withId(int id) {
    return User(id: id, nickname: nickname, name: name);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          nickname == other.nickname;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ nickname.hashCode;
}
