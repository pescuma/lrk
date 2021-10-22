class UsersConfig {
  final int currentUser;

  UsersConfig({this.currentUser = 1});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsersConfig && runtimeType == other.runtimeType && currentUser == other.currentUser;

  @override
  int get hashCode => currentUser.hashCode;
}

class UserConfig {
  final int userId;
  final int dayChangeHour;
  final int sleepHour;
  final int wakeUpHour;

  UserConfig({this.userId = -1, this.dayChangeHour = 0, this.sleepHour = 11, this.wakeUpHour = 7});

  UserConfig withUserId(int userId) {
    return UserConfig(
        userId: userId, dayChangeHour: dayChangeHour, sleepHour: sleepHour, wakeUpHour: wakeUpHour);
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
      userId.hashCode ^ dayChangeHour.hashCode ^ wakeUpHour.hashCode ^ sleepHour.hashCode;
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
