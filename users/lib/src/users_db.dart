import 'package:lrk_common/common.dart';

import 'users_model.dart';

abstract class UsersDB implements Disposable {
  Future<UsersConfig?> getConfig();
  Future<UsersConfig> saveConfig(UsersConfig config);

  Future<User?> getUser(int userId);
  Future<User> addUser(User user);
  Future<User> updateUser(User user);
  Future<List<User>> listUsers();

  Future<UserConfig?> getUserConfig(int id);
  Future<UserConfig> saveUserConfig(UserConfig config);
}

class MemoryUsersDB implements UsersDB {
  UsersConfig? _config;
  final _userConfigs = <int, UserConfig>{};
  final _users = <int, User>{};
  var _nextUserId = 1;

  @override
  Future<UsersConfig?> getConfig() async {
    return _config;
  }

  @override
  Future<UsersConfig> saveConfig(UsersConfig config) async {
    _config = config;
    return config;
  }

  @override
  Future<User?> getUser(int userId) async {
    return _users[userId];
  }

  @override
  Future<User> addUser(User user) async {
    user = User(id: _nextUserId++, nickname: user.nickname, name: user.name);
    _users[user.id] = user;
    return user;
  }

  @override
  Future<User> updateUser(User user) async {
    _users[user.id] = user;
    return user;
  }

  @override
  Future<List<User>> listUsers() async {
    return _users.values.toList();
  }

  @override
  Future<UserConfig?> getUserConfig(int id) async {
    return _userConfigs[id];
  }

  @override
  Future<UserConfig> saveUserConfig(UserConfig config) async {
    _userConfigs[config.userId] = config;
    return config;
  }

  @override
  Future<void> dispose() async {}
}
