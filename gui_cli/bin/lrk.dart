import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:args/src/arg_results.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_standalone.dart';
import 'package:lrk_gui_cli/globals.dart';
import 'package:lrk_gui_cli/health_water_cmds.dart';
import 'package:lrk_gui_common/gui_common.dart';

Future<void> main(List<String> args) async {
  Intl.defaultLocale = await findSystemLocale();
  await initializeDateFormatting(Intl.defaultLocale);

  var runner = CommandRunner("lrk", "Life records keeper") //
    ..addCommand(HealthCommand());
  runner.argParser.addOption('db', help: 'databases path (defaults to current directory)');

  var parsedArgs = runner.parse(args);

  Directory dbDirectory = await _getDBsDirectory(parsedArgs);

  try {
    di = setupDI(dbDirectory);

    await runner.runCommand(parsedArgs).catchError((error) {
      if (error is! UsageException) throw error;
      print(error);
      exit(64);
    });
  } finally {
    await di.disposeCreated();
  }
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
