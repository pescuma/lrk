import 'dart:io';

import 'package:dart_app_data/dart_app_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:lrk_gui_common/gui_common.dart';
import 'package:path_provider/path_provider.dart';
import 'package:platform/platform.dart';

import 'globals.dart';
import 'lrk_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Intl.defaultLocale = await findSystemLocale();
  await initializeDateFormatting(Intl.defaultLocale);

  Directory dbDir = await _getDBsDir();

  di = setupDI(dbDir);

  runApp(const LRKApp());
}

Future<Directory> _getDBsDir() async {
  const platform = LocalPlatform();

  final Directory result;
  if (platform.isAndroid) {
    var docsDir = await getExternalStorageDirectory();
    result = docsDir!;
  } else if (platform.isIOS || platform.isFuchsia) {
    result = await getApplicationDocumentsDirectory();
  } else if (platform.isWindows) {
    result = AppData.findOrCreate('LRK').directory;
  } else if (platform.isLinux || platform.isMacOS) {
    result = AppData.findOrCreate('.lrk').directory;
  } else {
    throw Exception("Unknown OS: ${platform.operatingSystem}");
  }

  print('DBs dir: $result');

  if (!await result.exists()) {
    await result.create(recursive: true);
  }

  return result;
}
