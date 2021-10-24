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
        children: const <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: Text('Health'),
          ),
          HealthWaterRow(),
        ],
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
  late WaterApp app;

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
    return Card(
      child: Row(
        children: <Widget>[
          const IconButton(
            icon: Icon(
              MdiIcons.cup,
              color: Colors.blueAccent,
            ),
            iconSize: 20,
            padding: EdgeInsets.only(top: 8, bottom: 8, left: 0, right: 0),
            onPressed: null,
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8, left: 0, right: 4),
              child: Text(
                'Water consumption',
                style: TextStyle(color: Colors.blueAccent),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          FutureBuilder<int>(
            future: _getTotal(),
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if (snapshot.hasData) {
                final ifmt = NumberFormat("#,###");
                return Text(
                  '${ifmt.format(snapshot.data)} ml',
                  style: const TextStyle(color: Colors.blueAccent),
                  overflow: TextOverflow.ellipsis,
                );
              } else if (snapshot.hasError) {
                return const Text(
                  '---',
                  style: TextStyle(color: Colors.red),
                  overflow: TextOverflow.ellipsis,
                );
              } else {
                return const Text(
                  '---',
                  style: TextStyle(color: Colors.black26),
                  overflow: TextOverflow.ellipsis,
                );
              }
            },
          ),
          const IconButton(
            icon: Icon(Icons.chevron_right),
            padding: EdgeInsets.only(top: 8, bottom: 8, left: 0, right: 0),
            tooltip: 'Open water consumption app',
            onPressed: null,
          )
        ],
      ),
    );
  }
}
