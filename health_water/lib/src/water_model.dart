import 'package:lrk_common/common.dart';

class WaterConfig {
  final int startingHourOfTheDay;

  /// ml
  final int targetConsumption;

  const WaterConfig({this.startingHourOfTheDay = 0, this.targetConsumption = 2000});

  @override
  String toString() {
    return 'WaterConfig{start: $startingHourOfTheDay, target: $targetConsumption}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterConfig &&
          runtimeType == other.runtimeType &&
          startingHourOfTheDay == other.startingHourOfTheDay &&
          targetConsumption == other.targetConsumption;

  @override
  int get hashCode => startingHourOfTheDay.hashCode ^ targetConsumption.hashCode;
}

class WaterConsumption {
  final DateTime date;

  /// ml
  final int quantity;

  final Glass glass;

  const WaterConsumption(this.date, this.quantity, this.glass);

  @override
  String toString() {
    return 'WaterConsumption{$date, ${quantity}ml, $glass}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterConsumption &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          quantity == other.quantity &&
          glass == other.glass;

  @override
  int get hashCode => date.hashCode ^ quantity.hashCode ^ glass.hashCode;
}

enum Glass { glass, coffeeCup, cocktailGlass, wineGlass, flute, mug, sodaBottle, wineBottle, tonic }

var glassNames = BiMap<Glass, String>()
  ..putIfAbsent(Glass.glass, () => 'glass')
  ..putIfAbsent(Glass.coffeeCup, () => 'coffee cup')
  ..putIfAbsent(Glass.mug, () => 'mug')
  ..putIfAbsent(Glass.wineGlass, () => 'wine glass')
  ..putIfAbsent(Glass.cocktailGlass, () => 'cocktail glass')
  ..putIfAbsent(Glass.flute, () => 'flute')
  ..putIfAbsent(Glass.sodaBottle, () => 'soda bottle')
  ..putIfAbsent(Glass.wineBottle, () => 'wine bottle')
  ..putIfAbsent(Glass.tonic, () => 'tonic');
