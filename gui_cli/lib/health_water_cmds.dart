import 'package:args/command_runner.dart';
import 'package:interact/interact.dart';
import 'package:lrk_common/common.dart';
import 'package:lrk_gui_cli/globals.dart';
import 'package:lrk_health_water/water.dart';

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

class HealthWaterCommand extends Command {
  @override
  final String name = "water";

  @override
  final String description = "Water consumption records";

  HealthWaterCommand() {
    addSubcommand(HealthWaterAddCommand());
    addSubcommand(HealthWaterShowCommand());
  }
}

class HealthWaterShowCommand extends Command {
  @override
  final String name = "show";

  @override
  final String description = """Shows current water consumption""";

  HealthWaterShowCommand() {}

  @override
  Future<void> run() async {
    var app = di.get<WaterApp>();

    var total = await app.getTotal();

    print("Water consumption today: $total ml");
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

    var total = await app.getTotal();

    print("Water consumption today: $total ml");
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
