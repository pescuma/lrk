import 'package:lrk_common/common.dart';

import 'users_db.dart';
import 'users_model.dart';

class UsersApp extends BaseApp {
  final UsersDB _db;
  User? _currentUser;
  UserConfig? _currentUserConfig;

  UsersApp(this._db);

  Future<List<User>> listUsers() async {
    return await _db.listUsers();
  }

  Future<User> addUser(User user) async {
    var result = await _db.addUser(user);

    await events.emit('add', 'user', result);

    return result;
  }

  Future<User> getCurrentUser() async {
    if (_currentUser == null) {
      var config = await _db.getConfig();
      config ??= await _db.saveConfig(UsersConfig());

      _currentUser = await _db.getUser(config.currentUser);

      if (_currentUser == null) {
        assert(config.currentUser == 0);
        _currentUser = await addUser(User());
        assert(_currentUser!.id == 0);
      }
    }

    return _currentUser!;
  }

  Future<User> changeCurrentUser(int userId) async {
    if (_currentUser?.id == userId) {
      return _currentUser!;
    }

    var user = await _db.getUser(userId);
    if (user == null) {
      throw Exception('Unknown user $userId');
    }

    await _db.saveConfig(UsersConfig(user.id));

    _currentUser = user;

    await events.emit('change', 'currentUser', _currentUser!);

    return _currentUser!;
  }

  Future<UserConfig> getCurrentUserConfig() async {
    if (_currentUserConfig == null) {
      var user = await getCurrentUser();

      _currentUserConfig = await _db.getUserConfig(user.id);
      _currentUserConfig ??= await _db.saveUserConfig(UserConfig(userId: user.id));
    }
    return _currentUserConfig!;
  }

  Future<UserConfig> setCurrentUserConfig(UserConfig config) async {
    var user = await getCurrentUser();

    if (config.userId != user.id) {
      config = config.withUserId(user.id);
    }

    _currentUserConfig = await _db.saveUserConfig(config);

    await events.emit('change', 'currentUserConfig', _currentUserConfig!);

    return _currentUserConfig!;
  }
}
