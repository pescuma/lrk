import 'package:args/command_runner.dart';
import 'package:interact/interact.dart';
import 'package:intl/intl.dart';
import 'package:lrk_common/common.dart';
import 'package:lrk_gui_cli/globals.dart';
import 'package:lrk_health_water/water.dart';
import 'package:tabular/tabular.dart';

import 'globals.dart';

class HealthCommand extends Command {
  @override
  final String name = "health";

  @override
  final String description = "Health related apps";

  HealthCommand() {
    addSubcommand(HealthWaterCommand());
  }
}

Future<void> _printTotal(WaterApp app) async {
  var total = await app.getTotal();
  var target = await app.getTarget();

  final ifmt = NumberFormat("#,###");

  print("Water consumption today: ${ifmt.format(total)} ml");

  if (total >= target) {
    print("You've reached your target. Well done!");
  } else {
    print("Target: ${ifmt.format(target)} ml");
  }
}

class HealthWaterCommand extends Command {
  @override
  final String name = "water";

  @override
  final String description = "Water consumption records";

  HealthWaterCommand() {
    addSubcommand(HealthWaterAddCommand());
    addSubcommand(HealthWaterShowCommand());
    addSubcommand(HealthWaterHistoryCommand());
  }
}

class HealthWaterShowCommand extends Command {
  @override
  final String name = "show";

  @override
  final String description = """Shows current water consumption""";

  @override
  Future<void> run() async {
    var app = di.get<WaterApp>();

    await _printTotal(app);
  }
}

class HealthWaterHistoryCommand extends Command {
  @override
  final String name = "hist";

  @override
  final String description = """Shows water consumption history""";

  @override
  Future<void> run() async {
    var clock = di.get<Clock>();
    var app = di.get<WaterApp>();

    var today = clock.now().startOfDay;
    var yesterday = today.addDays(-1, true);

    var end = today;
    var start = end.addDays(-14, true);

    var totals = await app.listTotals(start, end);
    totals.sort((a, b) => b.day.timestamp - a.day.timestamp);

    final dfmt = DateFormat().add_yMd();
    final ifmt = NumberFormat("#,###");

    var table = <List<String>>[];
    table.add(['Date', 'Total']);

    for (var total in totals) {
      String day;
      if (total.day == today) {
        day = 'Today';
      } else if (total.day == yesterday) {
        day = 'Yesterday';
      } else {
        day = dfmt.format(total.day);
      }

      table.add([day, '${ifmt.format(total.total)} ml']);
    }

    print('Water consumption history');
    print('');
    print(tabular(table, align: {'Total': Side.end}));
  }
}

class HealthWaterAddCommand extends Command {
  @override
  final String name = "add";

  @override
  final String description = """Adds a water consumption record

Arguments:
 quantity, in ml    
 glass type, optional, defaults to glass""";

  @override
  Future<void> run() async {
    var args = argResults?.rest ?? <String>[];
    int quantity = 0;
    var glass = Glass.glass;

    if (args.isEmpty) {
      quantity = int.parse(Input(
        prompt: 'Quantity (ml)',
        validator: (String x) {
          toIntGreaterThanZero(x);
          return true;
        },
      ).interact());

      var opts = glassNames.entries //
          .orderBy((e) => e.key.index)
          .map((e) => e.value)
          .toList();
      var item = Select(
        prompt: 'Glass',
        options: opts,
      ).interact();

      glass = glassNames.inverse[opts[item]]!;
    } else {
      quantity = toIntGreaterThanZero(args[0]);

      if (args.length > 1) {
        var found = glassNames.inverse[args[1]];
        if (found == null) {
          throw ValidationError("Unknown glass: " + args[1]);
        }
        glass = found;
      }
    }

    var app = di.get<WaterApp>();

    await app.add(quantity, glass);

    await _printTotal(app);
  }

  int toIntGreaterThanZero(String x) {
    final ifmt = NumberFormat("#");

    num result;

    try {
      result = ifmt.parse(x);
    } on FormatException {
      throw ValidationError('Should be a integral number greater than 0');
    }

    if (result <= 0) {
      throw ValidationError('Should greater than 0');
    }

    if (result - result.floor() > 0) {
      throw ValidationError('Should be a integral number greater than 0');
    }

    return result.toInt();
  }
}
