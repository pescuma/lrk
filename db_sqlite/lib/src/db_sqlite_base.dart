import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:lrk_health_water/water.dart';
import 'package:lrk_users/users.dart';
import 'package:path/path.dart' as p;

import 'health_water_db_sqlite.dart';
import 'users_db_sqlite.dart';

class DB {
  final Directory _folder;

  DB(this._folder);

  WaterDB createWaterDB() => WaterSqliteDB(_openConnection);
  UsersDB createUsersDB() => UsersSqliteDB(_openConnection);

  LazyDatabase _openConnection(String name) {
    return LazyDatabase(() async {
      final file = File(p.join(_folder.path, name));
      return NativeDatabase(file);
    });
  }
}
