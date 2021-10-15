import 'package:args/command_runner.dart';
import 'package:interact/interact.dart';
import 'package:lrk_common/common.dart';
import 'package:lrk_gui_cli/globals.dart';
import 'package:lrk_health_water/water.dart';

import 'globals.dart';

class HealthCommand extends Command {
  final String name = "health";
  final String description = "Health related apps";

  HealthCommand() {
    addSubcommand(HealthWaterCommand());
  }
}

class HealthWaterCommand extends Command {
  final String name = "water";
  final String description = "Water consumption records";

  HealthWaterCommand() {
    addSubcommand(HealthWaterAddCommand());
  }
}

class HealthWaterAddCommand extends Command {
  final String name = "add";
  final String description = """Adds a water consumption record

Arguments:
 quantity, in ml    
 glass type, optional, defaults to glass""";

  HealthWaterAddCommand() {
    argParser.addFlag('all', abbr: 'a');
  }

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

    var total = await app.getTotal();

    print("Water consumption today: $total ml");

    await app.close();
  }

  int toIntGreaterThanZero(String x) {
    var result = int.tryParse(x);

    if (result == null) {
      throw ValidationError('Should be a number');
    }

    if (result <= 0) {
      throw ValidationError('Should greater than 0');
    }

    return result;
  }
}
