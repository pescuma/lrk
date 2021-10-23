import 'dart:io';

import 'package:lrk_common/common.dart';
import 'package:lrk_db_sqlite/db_sqlite.dart';
import 'package:lrk_health_water/water.dart';
import 'package:lrk_users/users.dart';

import 'container.dart';

Container setupDI(Directory dbDirectory) {
  var di = Container();

  final db = DB(dbDirectory);

  di.provide((_) => Clock());
  di.provide<UsersDB>((_) => db.createUsersDB());
  di.provide((_) => UsersApp(_<UsersDB>()));
  di.provide<WaterDB>((_) => db.createWaterDB());
  di.provide((_) => WaterApp(_<WaterDB>(), _<UsersApp>(), _<Clock>()));

  return di;
}
