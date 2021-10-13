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

enum Glass { coffeeCup, glass, cocktailGlass, wineGlass, flute, mug, sodaBottle, wineBottle, tonic }
