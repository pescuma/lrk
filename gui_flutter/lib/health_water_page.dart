import 'package:flutter/material.dart';
import 'package:lrk_gui_common/gui_common.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'globals.dart';

class HealthWaterPage extends StatefulWidget {
  const HealthWaterPage({Key? key}) : super(key: key);

  @override
  _HealthWaterPageState createState() => _HealthWaterPageState();
}

class _HealthWaterPageState extends State<HealthWaterPage>
    with SingleTickerProviderStateMixin {
  late final WaterApp app;
  late final AnimatedSyncController sync;
  final glassIcons = BiMap<Glass, IconData>();
  int? total;
  int? expected;
  int? target;
  var glasses = <WaterConsumption>[];

  @override
  void initState() {
    super.initState();

    glassIcons[Glass.coffeeCup] = Icons.local_cafe_outlined;
    glassIcons[Glass.glass] = MdiIcons.cup;
    glassIcons[Glass.mug] = MdiIcons.glassMug;
    glassIcons[Glass.wineBottle] = MdiIcons.bottleWineOutline;

    sync = AnimatedSyncController(this);
    app = di.get<WaterApp>();

    sync.events.on('executing', _rebuild);
    app.events.on('change', _fetchData);

    _fetchData();
  }

  void _fetchData() {
    sync.execute(() async {
      total = await app.getTotal();
      expected = await app.getExpected();
      target = await app.getTarget();
      glasses = await app.getGlasses();
    });
  }

  void _rebuild() {
    print('rebuild');
    setState(() {});
  }

  Future<void> _add(int quantity, Glass glass) async {
    await app.add(quantity, glass);
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat ifmt = NumberFormat("#,###");
    final DateFormat dfmt = DateFormat.Hm();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const IconButton(
          icon: Icon(Icons.menu),
          tooltip: 'Navigation menu',
          onPressed: null,
        ),
        title: const Text('Water consumption'),
        actions: <Widget>[
          if (sync.executing || sync.hasError) sync.syncButton(onPressed: null),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          WaterProgressBar(
            total: total,
            expected: expected,
            target: target,
            padding:
                const EdgeInsets.only(top: 10, bottom: 6, left: 20, right: 20),
          ),
          Expanded(
            child: Card(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    spacing: 20,
                    runSpacing: 8,
                    clipBehavior: Clip.hardEdge,
                    children: glasses
                        .map((w) => _createGlassItem(
                              context,
                              ifmt: ifmt,
                              dfmt: dfmt,
                              water: w,
                              onPressed: null,
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 4,
              runSpacing: 4,
              children: [
                _createGlassButton(125, Glass.coffeeCup, ifmt),
                _createGlassButton(250, Glass.glass, ifmt),
                _createGlassButton(400, Glass.mug, ifmt),
                _createGlassButton(600, Glass.wineBottle, ifmt),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createGlassButton(int quantity, Glass glass, NumberFormat ifmt) {
    return ElevatedButton(
      onPressed: sync.wrapOnPressed(() => _add(quantity, glass)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        child: Column(
          children: [
            Icon(glassIcons[glass]!),
            Text(ifmt.format(quantity) + ' ml'),
          ],
        ),
      ),
    );
  }

  Widget _createGlassItem(
    BuildContext context, {
    required WaterConsumption water,
    required NumberFormat ifmt,
    required DateFormat dfmt,
    FutureFunc<void>? onPressed,
  }) {
    return GestureDetector(
      onTap: sync.wrapOnPressed(onPressed),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          children: [
            Icon(glassIcons[water.glass]!),
            const SizedBox(height: 1),
            Text(ifmt.format(water.quantity) + ' ml'),
            const SizedBox(height: 1),
            Text(
              dfmt.format(water.date),
              style: TextStyle(
                color: Theme.of(context).disabledColor,
                fontSize: 10,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class WaterProgressBar extends StatelessWidget {
  final int? total;
  final int? expected;
  final int? target;
  final EdgeInsetsGeometry padding;

  const WaterProgressBar(
      {required this.total,
      this.expected,
      required this.target,
      this.padding = const EdgeInsets.all(0),
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ifmt = NumberFormat("#,###");

    return Padding(
      padding: padding,
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            child: LinearProgressIndicator(
              value: (expected ?? 0) / (target ?? 1),
              color: const Color(0xff826a51),
              minHeight: 30,
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            child: LinearProgressIndicator(
              value: (total ?? 0) / (target ?? 1),
              color: Colors.blueAccent,
              backgroundColor: const Color.fromARGB(0, 0, 0, 0),
              minHeight: 30,
            ),
          ),
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(children: [
              if (total != null)
                Text(
                  ifmt.format(total) + ' ml',
                  style: const TextStyle(color: Colors.white70),
                ),
              Expanded(
                child: Container(),
              ),
              if (target != null)
                Text(
                  ifmt.format(target) + ' ml',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
            ]),
          ),
        ],
      ),
    );
  }
}

typedef FutureFunc<T> = Future<T> Function();
typedef VoidFutureFunc = Future<void> Function();

class AnimatedSyncController {
  late final AnimationController _controller;
  late final Animation<double> _rotateAnimation;

  final events = EventEmitter();

  bool get executing => _executing > 0;
  bool get hasError => error != null;
  String? error;
  int _executing = 0;

  AnimatedSyncController(TickerProvider vsync) {
    _controller = AnimationController(
        vsync: vsync, duration: const Duration(seconds: 200));
    _rotateAnimation = Tween<double>(begin: 360, end: 0).animate(_controller);
  }

  Widget syncButton({VoidCallback? onPressed, Key? key}) {
    return _AnimatedSync(
      animation: _rotateAnimation,
      onPressed: onPressed,
      error: error,
      key: key,
    );
  }

  Future<T> execute<T>(FutureFunc<T> func) async {
    return await wrapFunc(func)();
  }

  FutureFunc<T> wrapFunc<T>(FutureFunc<T> func) {
    return () async {
      _executing++;
      error = null;
      print('wrapFunc start executing = $_executing');
      if (_executing == 1) {
        _controller.forward();
        events.emit('executing', true);
        // Give time for screen update
        await Future.delayed(const Duration(seconds: 0));
      }
      try {
        return await func();
      } catch (e) {
        error = e.toString();
        rethrow;
      } finally {
        _executing--;
        print('wrapFunc end executing = $_executing');
        if (_executing == 0) {
          _controller.reset();
          _controller.stop();
          events.emit('executing', false);
        }
      }
    };
  }

  FutureFunc<T>? wrapOnPressed<T>(FutureFunc<T>? func) {
    if (func == null) {
      return null;
    } else {
      if (executing) {
        return null;
      } else {
        return wrapFunc(func);
      }
    }
  }
}

class _AnimatedSync extends AnimatedWidget {
  final VoidCallback? onPressed;
  final String? error;

  const _AnimatedSync(
      {required Animation<double> animation,
      this.onPressed,
      this.error,
      Key? key})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;

    return Transform.rotate(
      angle: animation.value,
      child: IconButton(
        icon: Icon(error != null ? Icons.error_outline : Icons.sync),
        color: error != null ? Colors.red : null,
        tooltip: error,
        onPressed: onPressed,
      ),
    );
  }
}
