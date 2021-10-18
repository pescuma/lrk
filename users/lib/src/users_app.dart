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

  Future<User> getCurrentUser() async {
    if (_currentUser == null) {
      var config = await _db.getConfig();
      if (config == null) {
        config = UsersConfig();
        config = await _db.saveConfig(config);
      }

      _currentUser = await _db.getUser(config.currentUser);
      if (_currentUser == null) {
        assert(config.currentUser == 0);
        _currentUser = User(0);
        await _db.addUser(_currentUser!);
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

    await _db.saveUserConfig(UserConfig(user.id));

    _currentUser = user;

    events.emit('change', 'currentUser');

    return _currentUser!;
  }

  Future<UserConfig> getCurrentUserConfig() async {
    if (_currentUserConfig == null) {
      var user = await getCurrentUser();

      _currentUserConfig = await _db.getUserConfig(user.id);
      if (_currentUserConfig == null) {
        _currentUserConfig = UserConfig(user.id);
        _currentUserConfig = await _db.saveUserConfig(_currentUserConfig!);
      }
    }

    return _currentUserConfig!;
  }
}
