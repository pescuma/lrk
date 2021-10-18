class UsersConfig {
  final int currentUser;

  UsersConfig([this.currentUser = 0]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsersConfig && runtimeType == other.runtimeType && currentUser == other.currentUser;

  @override
  int get hashCode => currentUser.hashCode;
}

class UserConfig {
  final int userId;
  final int startingHourOfTheDay;

  UserConfig(this.userId, {this.startingHourOfTheDay = 0});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserConfig &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          startingHourOfTheDay == other.startingHourOfTheDay;

  @override
  int get hashCode => userId.hashCode ^ startingHourOfTheDay.hashCode;
}

class User {
  final int id;
  final String name;
  final String nickname;

  User(this.id, {this.name = '', this.nickname = ''});

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
