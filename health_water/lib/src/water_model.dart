import 'package:lrk_common/common.dart';

class WaterConfig {
  final int userId;

  /// ml
  final int targetConsumption;

  const WaterConfig({this.userId = -1, this.targetConsumption = 2000});

  WaterConfig withUserId(int userId) {
    return WaterConfig(userId: userId, targetConsumption: targetConsumption);
  }

  @override
  String toString() {
    return 'WaterConfig{$userId, target: $targetConsumption}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterConfig &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          targetConsumption == other.targetConsumption;

  @override
  int get hashCode => userId.hashCode ^ targetConsumption.hashCode;
}

class WaterConsumption {
  final int userId;
  final int id;
  final DateTime date;

  /// ml
  final int quantity;

  final Glass glass;

  const WaterConsumption(
      {required this.userId,
      this.id = -1,
      required this.date,
      required this.quantity,
      this.glass = Glass.glass});

  WaterConsumption withId(int id) {
    return WaterConsumption(
        userId: userId, id: id, date: date, quantity: quantity, glass: glass);
  }

  @override
  String toString() {
    return 'WaterConsumption{$userId, $id, $date, ${quantity}ml, $glass}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterConsumption &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          date == other.date &&
          quantity == other.quantity &&
          glass == other.glass;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      date.hashCode ^
      quantity.hashCode ^
      glass.hashCode;
}

enum Glass {
  glass,
  coffeeCup,
  cocktailGlass,
  wineGlass,
  flute,
  mug,
  sodaBottle,
  wineBottle,
  tonic
}

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
