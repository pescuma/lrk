import 'package:flutter/material.dart';
import 'package:lrk_gui_common/gui_common.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'globals.dart';

class ApplicationsPage extends StatelessWidget {
  const ApplicationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const IconButton(
          icon: Icon(Icons.menu),
          tooltip: 'Navigation menu',
          onPressed: null,
        ),
        title: const Text("LRK"),
        actions: const [
          IconButton(
            icon: Icon(Icons.grid_view),
            tooltip: 'View as Grid',
            onPressed: null,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          HeaderRow('Health'),
          const HealthWaterRow(),
        ],
      ),
    );
  }
}

class HeaderRow extends StatelessWidget {
  final String name;

  HeaderRow(this.name, {Key? key}) : super(key: key ?? Key(name));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(name),
    );
  }
}

class ApplicationRow extends StatelessWidget {
  final IconData? icon;
  final String name;
  final Color? color;

  final String? value;
  final Color? valueColor;

  final String routeName;

  ApplicationRow(
      {this.icon,
      required this.name,
      this.color,
      this.value,
      this.valueColor,
      required this.routeName,
      Key? key})
      : super(key: key ?? Key(name));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(routeName);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              if (icon != null) Icon(icon, color: color, size: 20),
              if (icon != null) const SizedBox(width: 4),
              Expanded(
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: color),
                ),
              ),
              if (value != null) const SizedBox(width: 4),
              if (value != null)
                Text(
                  value!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: valueColor ?? color),
                ),
              Icon(Icons.chevron_right, color: color, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class HealthWaterRow extends StatefulWidget {
  const HealthWaterRow() : super(key: const Key("health_water"));

  @override
  State<HealthWaterRow> createState() => _HealthWaterRowState();
}

class _HealthWaterRowState extends State<HealthWaterRow> {
  late final WaterApp app;

  _HealthWaterRowState() {
    app = di.get<WaterApp>();
  }

  Future<int> _getTotal() async {
    try {
      return await app.getTotal();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _getTotal(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        String value;
        Color? valueColor;
        if (snapshot.hasData) {
          final ifmt = NumberFormat("#,###");
          value = '${ifmt.format(snapshot.data)} ml';
        } else if (snapshot.hasError) {
          value = '---';
          valueColor = Colors.red;
        } else {
          value = '---';
          valueColor = Colors.black26;
        }

        return ApplicationRow(
          color: Colors.blueAccent,
          icon: MdiIcons.cup,
          name: 'Water consumption',
          value: value,
          valueColor: valueColor,
          routeName: '/health/water',
        );
      },
    );
  }
}
