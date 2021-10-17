import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:lrk_health_water/water.dart';
import 'package:path/path.dart' as p;

import 'water_db_sqlite.dart';

class DB {
  final Directory _folder;

  late WaterDB Water = WaterSqliteDB(_openConnection);

  DB(this._folder);

  LazyDatabase _openConnection(String name) {
    return LazyDatabase(() async {
      final file = File(p.join(_folder.path, name));
      return NativeDatabase(file);
    });
  }
}
