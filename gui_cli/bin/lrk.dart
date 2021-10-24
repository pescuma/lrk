import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:args/src/arg_results.dart';
import 'package:dart_app_data/dart_app_data.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_standalone.dart';
import 'package:lrk_gui_cli/globals.dart';
import 'package:lrk_gui_cli/health_water_cmds.dart';
import 'package:lrk_gui_common/gui_common.dart';
import 'package:platform/platform.dart';

Future<void> main(List<String> args) async {
  Intl.defaultLocale = await findSystemLocale();
  await initializeDateFormatting(Intl.defaultLocale);

  var defaultDbDir = await _getDefaultDBsDir();

  var runner = CommandRunner("lrk", "Life records keeper") //
    ..addCommand(HealthCommand());
  runner.argParser.addOption('db', help: 'databases path (defaults to ${defaultDbDir.path})');

  var parsedArgs = runner.parse(args);

  Directory dbDir = await _getDBsDir(parsedArgs, defaultDbDir);

  try {
    di = setupDI(dbDir);

    await runner.runCommand(parsedArgs).catchError((error) {
      if (error is! UsageException) throw error;
      print(error);
      exit(64);
    });
  } finally {
    await di.disposeCreated();
  }
}

Future<Directory> _getDefaultDBsDir() async {
  const platform = LocalPlatform();

  final Directory result;
  if (platform.isWindows) {
    result = AppData.findOrCreate('LRK').directory;
  } else if (platform.isLinux || platform.isMacOS) {
    result = AppData.findOrCreate('.lrk').directory;
  } else {
    throw Exception("Unknown OS: ${platform.operatingSystem}");
  }

  return result;
}

Future<Directory> _getDBsDir(ArgResults parsedArgs, Directory defaultDbDir) async {
  String? db = parsedArgs['db'];

  Directory result;
  if (db != null) {
    result = Directory(db);
  } else {
    result = defaultDbDir;
  }

  if (!await result.exists()) {
    await result.create(recursive: true);
  }
  return result;
}
