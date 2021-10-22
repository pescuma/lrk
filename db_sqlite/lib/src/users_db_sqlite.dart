import 'package:drift/drift.dart';
import 'package:lrk_users/users.dart' as model;

part 'users_db_sqlite.g.dart';

@DriftDatabase(tables: [Users, UsersConfigs])
class UsersSqliteDB extends _$UsersSqliteDB implements model.UsersDB {
  final LazyDatabase Function(String) _open;
  final _users = <int, _UserSqliteDB>{};

  @override
  int get schemaVersion => 1;

  UsersSqliteDB(this._open) : super(_open('users.db'));

  _UserSqliteDB _getUserDB(int userId) {
    return _users.putIfAbsent(userId, () => _UserSqliteDB(userId, _open));
  }

  @override
  Future<model.UsersConfig?> getConfig() async {
    var cfg = await select(usersConfigs).getSingleOrNull();

    if (cfg == null) {
      return null;
    }

    return toModelUsersConfig(cfg);
  }

  @override
  Future<model.UsersConfig> saveConfig(model.UsersConfig config) async {
    var cfg = fromModelUsersConfig(config);

    await into(usersConfigs).insertOnConflictUpdate(cfg);

    return config;
  }

  UsersConfig fromModelUsersConfig(model.UsersConfig config) =>
      UsersConfig(id: 0, currentUser: config.currentUser);

  model.UsersConfig toModelUsersConfig(UsersConfig cfg) =>
      model.UsersConfig(currentUser: cfg.currentUser);

  @override
  Future<model.User?> getUser(int id) async {
    var user = await (select(users)..where((t) => t.id.equals(id))) //
        .getSingleOrNull();

    if (user == null) {
      return null;
    }

    return toModelUser(user);
  }

  @override
  Future<model.User> addUser(model.User user) async {
    var uc = UsersCompanion(nickname: Value(user.nickname), name: Value(user.name));

    var id = await into(users).insert(uc);

    return user.withId(id);
  }

  @override
  Future<model.User> updateUser(model.User user) async {
    var uc = fromModelUser(user);

    await update(users).replace(uc);

    return user;
  }

  @override
  Future<List<model.User>> listUsers() async {
    var result = await (select(users)).get();

    return result.map(toModelUser).toList();
  }

  model.User toModelUser(User user) =>
      model.User(id: user.id, nickname: user.nickname, name: user.name);

  User fromModelUser(model.User user) =>
      User(id: user.id, nickname: user.nickname, name: user.name);

  @override
  Future<model.UserConfig?> getUserConfig(int userId) {
    return _getUserDB(userId).getUserConfig();
  }

  @override
  Future<model.UserConfig> saveUserConfig(model.UserConfig config) {
    return _getUserDB(config.userId).saveUserConfig(config);
  }

  @override
  Future<void> dispose() async {
    await close();
    await Future.wait(_users.values.map((e) => e.close()));
    _users.clear();
  }
}

@DriftDatabase(tables: [UserConfigs])
class _UserSqliteDB extends _$_UserSqliteDB {
  final int _userId;

  _UserSqliteDB(this._userId, LazyDatabase Function(String) open) : super(open('$_userId-user.db'));

  @override
  int get schemaVersion => 1;

  Future<model.UserConfig?> getUserConfig() async {
    var cfg = await select(userConfigs).getSingleOrNull();

    if (cfg == null) {
      return null;
    }

    return toModelConfig(cfg);
  }

  Future<model.UserConfig> saveUserConfig(model.UserConfig config) async {
    var cfg = fromModelConfig(config);

    await into(userConfigs).insertOnConflictUpdate(cfg);

    return config;
  }

  model.UserConfig toModelConfig(UserConfig cfg) => model.UserConfig(
      userId: _userId,
      dayChangeHour: cfg.dayChangeHour,
      sleepHour: cfg.sleepHour,
      wakeUpHour: cfg.wakeUpHour);

  UserConfig fromModelConfig(model.UserConfig cfg) => UserConfig(
      id: _userId,
      dayChangeHour: cfg.dayChangeHour,
      sleepHour: cfg.sleepHour,
      wakeUpHour: cfg.wakeUpHour);
}

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nickname => text().withLength(max: 1000)();
  TextColumn get name => text().withLength(max: 1000)();
}

class UsersConfigs extends Table {
  IntColumn get id => integer()();
  IntColumn get currentUser => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class UserConfigs extends Table {
  IntColumn get id => integer()();
  IntColumn get dayChangeHour => integer()();
  IntColumn get sleepHour => integer()();
  IntColumn get wakeUpHour => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
