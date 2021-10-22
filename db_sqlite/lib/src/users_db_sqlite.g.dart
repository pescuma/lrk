// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_db_sqlite.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class User extends DataClass implements Insertable<User> {
  final int id;
  final String nickname;
  final String name;
  User({required this.id, required this.nickname, required this.name});
  factory User.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return User(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      nickname: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}nickname'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nickname'] = Variable<String>(nickname);
    map['name'] = Variable<String>(name);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      nickname: Value(nickname),
      name: Value(name),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      nickname: serializer.fromJson<String>(json['nickname']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nickname': serializer.toJson<String>(nickname),
      'name': serializer.toJson<String>(name),
    };
  }

  User copyWith({int? id, String? nickname, String? name}) => User(
        id: id ?? this.id,
        nickname: nickname ?? this.nickname,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('nickname: $nickname, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nickname, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.nickname == this.nickname &&
          other.name == this.name);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> nickname;
  final Value<String> name;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.nickname = const Value.absent(),
    this.name = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String nickname,
    required String name,
  })  : nickname = Value(nickname),
        name = Value(name);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? nickname,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nickname != null) 'nickname': nickname,
      if (name != null) 'name': name,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id, Value<String>? nickname, Value<String>? name}) {
    return UsersCompanion(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('nickname: $nickname, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  final GeneratedDatabase _db;
  final String? _alias;
  $UsersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nicknameMeta = const VerificationMeta('nickname');
  late final GeneratedColumn<String?> nickname = GeneratedColumn<String?>(
      'nickname', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 1000),
      typeName: 'TEXT',
      requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 1000),
      typeName: 'TEXT',
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, nickname, name];
  @override
  String get aliasedName => _alias ?? 'users';
  @override
  String get actualTableName => 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nickname')) {
      context.handle(_nicknameMeta,
          nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta));
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    return User.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(_db, alias);
  }
}

class UsersConfig extends DataClass implements Insertable<UsersConfig> {
  final int id;
  final int currentUser;
  UsersConfig({required this.id, required this.currentUser});
  factory UsersConfig.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return UsersConfig(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      currentUser: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}current_user'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['current_user'] = Variable<int>(currentUser);
    return map;
  }

  UsersConfigsCompanion toCompanion(bool nullToAbsent) {
    return UsersConfigsCompanion(
      id: Value(id),
      currentUser: Value(currentUser),
    );
  }

  factory UsersConfig.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsersConfig(
      id: serializer.fromJson<int>(json['id']),
      currentUser: serializer.fromJson<int>(json['currentUser']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currentUser': serializer.toJson<int>(currentUser),
    };
  }

  UsersConfig copyWith({int? id, int? currentUser}) => UsersConfig(
        id: id ?? this.id,
        currentUser: currentUser ?? this.currentUser,
      );
  @override
  String toString() {
    return (StringBuffer('UsersConfig(')
          ..write('id: $id, ')
          ..write('currentUser: $currentUser')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, currentUser);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsersConfig &&
          other.id == this.id &&
          other.currentUser == this.currentUser);
}

class UsersConfigsCompanion extends UpdateCompanion<UsersConfig> {
  final Value<int> id;
  final Value<int> currentUser;
  const UsersConfigsCompanion({
    this.id = const Value.absent(),
    this.currentUser = const Value.absent(),
  });
  UsersConfigsCompanion.insert({
    this.id = const Value.absent(),
    required int currentUser,
  }) : currentUser = Value(currentUser);
  static Insertable<UsersConfig> custom({
    Expression<int>? id,
    Expression<int>? currentUser,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currentUser != null) 'current_user': currentUser,
    });
  }

  UsersConfigsCompanion copyWith({Value<int>? id, Value<int>? currentUser}) {
    return UsersConfigsCompanion(
      id: id ?? this.id,
      currentUser: currentUser ?? this.currentUser,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currentUser.present) {
      map['current_user'] = Variable<int>(currentUser.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersConfigsCompanion(')
          ..write('id: $id, ')
          ..write('currentUser: $currentUser')
          ..write(')'))
        .toString();
  }
}

class $UsersConfigsTable extends UsersConfigs
    with TableInfo<$UsersConfigsTable, UsersConfig> {
  final GeneratedDatabase _db;
  final String? _alias;
  $UsersConfigsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _currentUserMeta =
      const VerificationMeta('currentUser');
  late final GeneratedColumn<int?> currentUser = GeneratedColumn<int?>(
      'current_user', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, currentUser];
  @override
  String get aliasedName => _alias ?? 'users_configs';
  @override
  String get actualTableName => 'users_configs';
  @override
  VerificationContext validateIntegrity(Insertable<UsersConfig> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('current_user')) {
      context.handle(
          _currentUserMeta,
          currentUser.isAcceptableOrUnknown(
              data['current_user']!, _currentUserMeta));
    } else if (isInserting) {
      context.missing(_currentUserMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsersConfig map(Map<String, dynamic> data, {String? tablePrefix}) {
    return UsersConfig.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $UsersConfigsTable createAlias(String alias) {
    return $UsersConfigsTable(_db, alias);
  }
}

abstract class _$UsersSqliteDB extends GeneratedDatabase {
  _$UsersSqliteDB(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $UsersTable users = $UsersTable(this);
  late final $UsersConfigsTable usersConfigs = $UsersConfigsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [users, usersConfigs];
}

class UserConfig extends DataClass implements Insertable<UserConfig> {
  final int id;
  final int dayChangeHour;
  final int sleepHour;
  final int wakeUpHour;
  UserConfig(
      {required this.id,
      required this.dayChangeHour,
      required this.sleepHour,
      required this.wakeUpHour});
  factory UserConfig.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return UserConfig(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      dayChangeHour: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}day_change_hour'])!,
      sleepHour: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sleep_hour'])!,
      wakeUpHour: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}wake_up_hour'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day_change_hour'] = Variable<int>(dayChangeHour);
    map['sleep_hour'] = Variable<int>(sleepHour);
    map['wake_up_hour'] = Variable<int>(wakeUpHour);
    return map;
  }

  UserConfigsCompanion toCompanion(bool nullToAbsent) {
    return UserConfigsCompanion(
      id: Value(id),
      dayChangeHour: Value(dayChangeHour),
      sleepHour: Value(sleepHour),
      wakeUpHour: Value(wakeUpHour),
    );
  }

  factory UserConfig.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserConfig(
      id: serializer.fromJson<int>(json['id']),
      dayChangeHour: serializer.fromJson<int>(json['dayChangeHour']),
      sleepHour: serializer.fromJson<int>(json['sleepHour']),
      wakeUpHour: serializer.fromJson<int>(json['wakeUpHour']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dayChangeHour': serializer.toJson<int>(dayChangeHour),
      'sleepHour': serializer.toJson<int>(sleepHour),
      'wakeUpHour': serializer.toJson<int>(wakeUpHour),
    };
  }

  UserConfig copyWith(
          {int? id, int? dayChangeHour, int? sleepHour, int? wakeUpHour}) =>
      UserConfig(
        id: id ?? this.id,
        dayChangeHour: dayChangeHour ?? this.dayChangeHour,
        sleepHour: sleepHour ?? this.sleepHour,
        wakeUpHour: wakeUpHour ?? this.wakeUpHour,
      );
  @override
  String toString() {
    return (StringBuffer('UserConfig(')
          ..write('id: $id, ')
          ..write('dayChangeHour: $dayChangeHour, ')
          ..write('sleepHour: $sleepHour, ')
          ..write('wakeUpHour: $wakeUpHour')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dayChangeHour, sleepHour, wakeUpHour);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserConfig &&
          other.id == this.id &&
          other.dayChangeHour == this.dayChangeHour &&
          other.sleepHour == this.sleepHour &&
          other.wakeUpHour == this.wakeUpHour);
}

class UserConfigsCompanion extends UpdateCompanion<UserConfig> {
  final Value<int> id;
  final Value<int> dayChangeHour;
  final Value<int> sleepHour;
  final Value<int> wakeUpHour;
  const UserConfigsCompanion({
    this.id = const Value.absent(),
    this.dayChangeHour = const Value.absent(),
    this.sleepHour = const Value.absent(),
    this.wakeUpHour = const Value.absent(),
  });
  UserConfigsCompanion.insert({
    this.id = const Value.absent(),
    required int dayChangeHour,
    required int sleepHour,
    required int wakeUpHour,
  })  : dayChangeHour = Value(dayChangeHour),
        sleepHour = Value(sleepHour),
        wakeUpHour = Value(wakeUpHour);
  static Insertable<UserConfig> custom({
    Expression<int>? id,
    Expression<int>? dayChangeHour,
    Expression<int>? sleepHour,
    Expression<int>? wakeUpHour,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayChangeHour != null) 'day_change_hour': dayChangeHour,
      if (sleepHour != null) 'sleep_hour': sleepHour,
      if (wakeUpHour != null) 'wake_up_hour': wakeUpHour,
    });
  }

  UserConfigsCompanion copyWith(
      {Value<int>? id,
      Value<int>? dayChangeHour,
      Value<int>? sleepHour,
      Value<int>? wakeUpHour}) {
    return UserConfigsCompanion(
      id: id ?? this.id,
      dayChangeHour: dayChangeHour ?? this.dayChangeHour,
      sleepHour: sleepHour ?? this.sleepHour,
      wakeUpHour: wakeUpHour ?? this.wakeUpHour,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dayChangeHour.present) {
      map['day_change_hour'] = Variable<int>(dayChangeHour.value);
    }
    if (sleepHour.present) {
      map['sleep_hour'] = Variable<int>(sleepHour.value);
    }
    if (wakeUpHour.present) {
      map['wake_up_hour'] = Variable<int>(wakeUpHour.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserConfigsCompanion(')
          ..write('id: $id, ')
          ..write('dayChangeHour: $dayChangeHour, ')
          ..write('sleepHour: $sleepHour, ')
          ..write('wakeUpHour: $wakeUpHour')
          ..write(')'))
        .toString();
  }
}

class $UserConfigsTable extends UserConfigs
    with TableInfo<$UserConfigsTable, UserConfig> {
  final GeneratedDatabase _db;
  final String? _alias;
  $UserConfigsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _dayChangeHourMeta =
      const VerificationMeta('dayChangeHour');
  late final GeneratedColumn<int?> dayChangeHour = GeneratedColumn<int?>(
      'day_change_hour', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _sleepHourMeta = const VerificationMeta('sleepHour');
  late final GeneratedColumn<int?> sleepHour = GeneratedColumn<int?>(
      'sleep_hour', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _wakeUpHourMeta = const VerificationMeta('wakeUpHour');
  late final GeneratedColumn<int?> wakeUpHour = GeneratedColumn<int?>(
      'wake_up_hour', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, dayChangeHour, sleepHour, wakeUpHour];
  @override
  String get aliasedName => _alias ?? 'user_configs';
  @override
  String get actualTableName => 'user_configs';
  @override
  VerificationContext validateIntegrity(Insertable<UserConfig> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day_change_hour')) {
      context.handle(
          _dayChangeHourMeta,
          dayChangeHour.isAcceptableOrUnknown(
              data['day_change_hour']!, _dayChangeHourMeta));
    } else if (isInserting) {
      context.missing(_dayChangeHourMeta);
    }
    if (data.containsKey('sleep_hour')) {
      context.handle(_sleepHourMeta,
          sleepHour.isAcceptableOrUnknown(data['sleep_hour']!, _sleepHourMeta));
    } else if (isInserting) {
      context.missing(_sleepHourMeta);
    }
    if (data.containsKey('wake_up_hour')) {
      context.handle(
          _wakeUpHourMeta,
          wakeUpHour.isAcceptableOrUnknown(
              data['wake_up_hour']!, _wakeUpHourMeta));
    } else if (isInserting) {
      context.missing(_wakeUpHourMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserConfig map(Map<String, dynamic> data, {String? tablePrefix}) {
    return UserConfig.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $UserConfigsTable createAlias(String alias) {
    return $UserConfigsTable(_db, alias);
  }
}

abstract class _$_UserSqliteDB extends GeneratedDatabase {
  _$_UserSqliteDB(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $UserConfigsTable userConfigs = $UserConfigsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [userConfigs];
}
