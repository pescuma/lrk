import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:args/src/arg_results.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_standalone.dart';
import 'package:lrk_common/common.dart';
import 'package:lrk_db_sqlite/db_sqlite.dart';
import 'package:lrk_gui_cli/globals.dart';
import 'package:lrk_gui_cli/health_water_cmds.dart';
import 'package:lrk_health_water/water.dart';

Future<void> main(List<String> args) async {
  Intl.defaultLocale = await findSystemLocale();
  await initializeDateFormatting(Intl.defaultLocale);

  var runner = CommandRunner("lrk", "Life records keeper") //
    ..addCommand(HealthCommand());
  runner.argParser.addOption('db', help: 'databases path (defaults to current directory)');

  var parsedArgs = runner.parse(args);

  Directory dbDirectory = await _getDBsDirectory(parsedArgs);

  final db = DB(dbDirectory);

  di.provide<WaterDB>((_) => db.Water);
  di.provide((_) => Clock());
  di.provide((_) => WaterApp(_<WaterDB>(), _<Clock>()));

  await runner.runCommand(parsedArgs).catchError((error) {
    if (error is! UsageException) throw error;
    print(error);
    exit(64);
  });

  await di.getCached<WaterApp>()?.dispose();
}

Future<Directory> _getDBsDirectory(ArgResults parsedArgs) async {
  String? db = parsedArgs['db'];

  if (db == null) {
    return Directory.current;
  }

  var result = Directory(db);

  if (!await result.exists()) {
    await result.create(recursive: true);
  }
  return result;
}
