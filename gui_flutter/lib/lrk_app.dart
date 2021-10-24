import 'package:flutter/material.dart';

import 'applications_page.dart';
import 'globals.dart';

class LRKApp extends StatefulWidget {
  const LRKApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LRKAppState();
}

class _LRKAppState extends State<LRKApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LRK',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const ApplicationsPage(),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');

    if (state == AppLifecycleState.detached) {
      di.disposeCreated();
    }
  }
}
