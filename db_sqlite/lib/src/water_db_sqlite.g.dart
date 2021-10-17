// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_db_sqlite.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class WaterConfig extends DataClass implements Insertable<WaterConfig> {
  final int id;
  final int startingHourOfTheDay;
  final int targetConsumption;
  WaterConfig(
      {required this.id,
      required this.startingHourOfTheDay,
      required this.targetConsumption});
  factory WaterConfig.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return WaterConfig(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      startingHourOfTheDay: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}starting_hour_of_the_day'])!,
      targetConsumption: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}target_consumption'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['starting_hour_of_the_day'] = Variable<int>(startingHourOfTheDay);
    map['target_consumption'] = Variable<int>(targetConsumption);
    return map;
  }

  WaterConfigsCompanion toCompanion(bool nullToAbsent) {
    return WaterConfigsCompanion(
      id: Value(id),
      startingHourOfTheDay: Value(startingHourOfTheDay),
      targetConsumption: Value(targetConsumption),
    );
  }

  factory WaterConfig.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterConfig(
      id: serializer.fromJson<int>(json['id']),
      startingHourOfTheDay:
          serializer.fromJson<int>(json['startingHourOfTheDay']),
      targetConsumption: serializer.fromJson<int>(json['targetConsumption']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startingHourOfTheDay': serializer.toJson<int>(startingHourOfTheDay),
      'targetConsumption': serializer.toJson<int>(targetConsumption),
    };
  }

  WaterConfig copyWith(
          {int? id, int? startingHourOfTheDay, int? targetConsumption}) =>
      WaterConfig(
        id: id ?? this.id,
        startingHourOfTheDay: startingHourOfTheDay ?? this.startingHourOfTheDay,
        targetConsumption: targetConsumption ?? this.targetConsumption,
      );
  @override
  String toString() {
    return (StringBuffer('WaterConfig(')
          ..write('id: $id, ')
          ..write('startingHourOfTheDay: $startingHourOfTheDay, ')
          ..write('targetConsumption: $targetConsumption')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startingHourOfTheDay, targetConsumption);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WaterConfig &&
          other.id == this.id &&
          other.startingHourOfTheDay == this.startingHourOfTheDay &&
          other.targetConsumption == this.targetConsumption);
}

class WaterConfigsCompanion extends UpdateCompanion<WaterConfig> {
  final Value<int> id;
  final Value<int> startingHourOfTheDay;
  final Value<int> targetConsumption;
  const WaterConfigsCompanion({
    this.id = const Value.absent(),
    this.startingHourOfTheDay = const Value.absent(),
    this.targetConsumption = const Value.absent(),
  });
  WaterConfigsCompanion.insert({
    this.id = const Value.absent(),
    required int startingHourOfTheDay,
    required int targetConsumption,
  })  : startingHourOfTheDay = Value(startingHourOfTheDay),
        targetConsumption = Value(targetConsumption);
  static Insertable<WaterConfig> custom({
    Expression<int>? id,
    Expression<int>? startingHourOfTheDay,
    Expression<int>? targetConsumption,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startingHourOfTheDay != null)
        'starting_hour_of_the_day': startingHourOfTheDay,
      if (targetConsumption != null) 'target_consumption': targetConsumption,
    });
  }

  WaterConfigsCompanion copyWith(
      {Value<int>? id,
      Value<int>? startingHourOfTheDay,
      Value<int>? targetConsumption}) {
    return WaterConfigsCompanion(
      id: id ?? this.id,
      startingHourOfTheDay: startingHourOfTheDay ?? this.startingHourOfTheDay,
      targetConsumption: targetConsumption ?? this.targetConsumption,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startingHourOfTheDay.present) {
      map['starting_hour_of_the_day'] =
          Variable<int>(startingHourOfTheDay.value);
    }
    if (targetConsumption.present) {
      map['target_consumption'] = Variable<int>(targetConsumption.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WaterConfigsCompanion(')
          ..write('id: $id, ')
          ..write('startingHourOfTheDay: $startingHourOfTheDay, ')
          ..write('targetConsumption: $targetConsumption')
          ..write(')'))
        .toString();
  }
}

class $WaterConfigsTable extends WaterConfigs
    with TableInfo<$WaterConfigsTable, WaterConfig> {
  final GeneratedDatabase _db;
  final String? _alias;
  $WaterConfigsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _startingHourOfTheDayMeta =
      const VerificationMeta('startingHourOfTheDay');
  late final GeneratedColumn<int?> startingHourOfTheDay = GeneratedColumn<int?>(
      'starting_hour_of_the_day', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _targetConsumptionMeta =
      const VerificationMeta('targetConsumption');
  late final GeneratedColumn<int?> targetConsumption = GeneratedColumn<int?>(
      'target_consumption', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, startingHourOfTheDay, targetConsumption];
  @override
  String get aliasedName => _alias ?? 'water_configs';
  @override
  String get actualTableName => 'water_configs';
  @override
  VerificationContext validateIntegrity(Insertable<WaterConfig> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('starting_hour_of_the_day')) {
      context.handle(
          _startingHourOfTheDayMeta,
          startingHourOfTheDay.isAcceptableOrUnknown(
              data['starting_hour_of_the_day']!, _startingHourOfTheDayMeta));
    } else if (isInserting) {
      context.missing(_startingHourOfTheDayMeta);
    }
    if (data.containsKey('target_consumption')) {
      context.handle(
          _targetConsumptionMeta,
          targetConsumption.isAcceptableOrUnknown(
              data['target_consumption']!, _targetConsumptionMeta));
    } else if (isInserting) {
      context.missing(_targetConsumptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WaterConfig map(Map<String, dynamic> data, {String? tablePrefix}) {
    return WaterConfig.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $WaterConfigsTable createAlias(String alias) {
    return $WaterConfigsTable(_db, alias);
  }
}

class WaterConsumption extends DataClass
    implements Insertable<WaterConsumption> {
  final int id;
  final DateTime date;
  final int quantity;
  final int glass;
  WaterConsumption(
      {required this.id,
      required this.date,
      required this.quantity,
      required this.glass});
  factory WaterConsumption.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return WaterConsumption(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      date: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
      quantity: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}quantity'])!,
      glass: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}glass'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['quantity'] = Variable<int>(quantity);
    map['glass'] = Variable<int>(glass);
    return map;
  }

  WaterConsumptionsCompanion toCompanion(bool nullToAbsent) {
    return WaterConsumptionsCompanion(
      id: Value(id),
      date: Value(date),
      quantity: Value(quantity),
      glass: Value(glass),
    );
  }

  factory WaterConsumption.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterConsumption(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      quantity: serializer.fromJson<int>(json['quantity']),
      glass: serializer.fromJson<int>(json['glass']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'quantity': serializer.toJson<int>(quantity),
      'glass': serializer.toJson<int>(glass),
    };
  }

  WaterConsumption copyWith(
          {int? id, DateTime? date, int? quantity, int? glass}) =>
      WaterConsumption(
        id: id ?? this.id,
        date: date ?? this.date,
        quantity: quantity ?? this.quantity,
        glass: glass ?? this.glass,
      );
  @override
  String toString() {
    return (StringBuffer('WaterConsumption(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('quantity: $quantity, ')
          ..write('glass: $glass')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, quantity, glass);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WaterConsumption &&
          other.id == this.id &&
          other.date == this.date &&
          other.quantity == this.quantity &&
          other.glass == this.glass);
}

class WaterConsumptionsCompanion extends UpdateCompanion<WaterConsumption> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> quantity;
  final Value<int> glass;
  const WaterConsumptionsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.quantity = const Value.absent(),
    this.glass = const Value.absent(),
  });
  WaterConsumptionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required int quantity,
    required int glass,
  })  : date = Value(date),
        quantity = Value(quantity),
        glass = Value(glass);
  static Insertable<WaterConsumption> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? quantity,
    Expression<int>? glass,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (quantity != null) 'quantity': quantity,
      if (glass != null) 'glass': glass,
    });
  }

  WaterConsumptionsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<int>? quantity,
      Value<int>? glass}) {
    return WaterConsumptionsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      quantity: quantity ?? this.quantity,
      glass: glass ?? this.glass,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (glass.present) {
      map['glass'] = Variable<int>(glass.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WaterConsumptionsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('quantity: $quantity, ')
          ..write('glass: $glass')
          ..write(')'))
        .toString();
  }
}

class $WaterConsumptionsTable extends WaterConsumptions
    with TableInfo<$WaterConsumptionsTable, WaterConsumption> {
  final GeneratedDatabase _db;
  final String? _alias;
  $WaterConsumptionsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  late final GeneratedColumn<DateTime?> date = GeneratedColumn<DateTime?>(
      'date', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _quantityMeta = const VerificationMeta('quantity');
  late final GeneratedColumn<int?> quantity = GeneratedColumn<int?>(
      'quantity', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _glassMeta = const VerificationMeta('glass');
  late final GeneratedColumn<int?> glass = GeneratedColumn<int?>(
      'glass', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, date, quantity, glass];
  @override
  String get aliasedName => _alias ?? 'water_consumptions';
  @override
  String get actualTableName => 'water_consumptions';
  @override
  VerificationContext validateIntegrity(Insertable<WaterConsumption> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('glass')) {
      context.handle(
          _glassMeta, glass.isAcceptableOrUnknown(data['glass']!, _glassMeta));
    } else if (isInserting) {
      context.missing(_glassMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WaterConsumption map(Map<String, dynamic> data, {String? tablePrefix}) {
    return WaterConsumption.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $WaterConsumptionsTable createAlias(String alias) {
    return $WaterConsumptionsTable(_db, alias);
  }
}

class WaterTotal extends DataClass implements Insertable<WaterTotal> {
  final DateTime date;
  final int quantity;
  WaterTotal({required this.date, required this.quantity});
  factory WaterTotal.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return WaterTotal(
      date: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
      quantity: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}quantity'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<DateTime>(date);
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  WaterTotalsCompanion toCompanion(bool nullToAbsent) {
    return WaterTotalsCompanion(
      date: Value(date),
      quantity: Value(quantity),
    );
  }

  factory WaterTotal.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterTotal(
      date: serializer.fromJson<DateTime>(json['date']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<DateTime>(date),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  WaterTotal copyWith({DateTime? date, int? quantity}) => WaterTotal(
        date: date ?? this.date,
        quantity: quantity ?? this.quantity,
      );
  @override
  String toString() {
    return (StringBuffer('WaterTotal(')
          ..write('date: $date, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WaterTotal &&
          other.date == this.date &&
          other.quantity == this.quantity);
}

class WaterTotalsCompanion extends UpdateCompanion<WaterTotal> {
  final Value<DateTime> date;
  final Value<int> quantity;
  const WaterTotalsCompanion({
    this.date = const Value.absent(),
    this.quantity = const Value.absent(),
  });
  WaterTotalsCompanion.insert({
    required DateTime date,
    required int quantity,
  })  : date = Value(date),
        quantity = Value(quantity);
  static Insertable<WaterTotal> custom({
    Expression<DateTime>? date,
    Expression<int>? quantity,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (quantity != null) 'quantity': quantity,
    });
  }

  WaterTotalsCompanion copyWith({Value<DateTime>? date, Value<int>? quantity}) {
    return WaterTotalsCompanion(
      date: date ?? this.date,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WaterTotalsCompanion(')
          ..write('date: $date, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }
}

class $WaterTotalsTable extends WaterTotals
    with TableInfo<$WaterTotalsTable, WaterTotal> {
  final GeneratedDatabase _db;
  final String? _alias;
  $WaterTotalsTable(this._db, [this._alias]);
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  late final GeneratedColumn<DateTime?> date = GeneratedColumn<DateTime?>(
      'date', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _quantityMeta = const VerificationMeta('quantity');
  late final GeneratedColumn<int?> quantity = GeneratedColumn<int?>(
      'quantity', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [date, quantity];
  @override
  String get aliasedName => _alias ?? 'water_totals';
  @override
  String get actualTableName => 'water_totals';
  @override
  VerificationContext validateIntegrity(Insertable<WaterTotal> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  WaterTotal map(Map<String, dynamic> data, {String? tablePrefix}) {
    return WaterTotal.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $WaterTotalsTable createAlias(String alias) {
    return $WaterTotalsTable(_db, alias);
  }
}

abstract class _$WaterSqliteDB extends GeneratedDatabase {
  _$WaterSqliteDB(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $WaterConfigsTable waterConfigs = $WaterConfigsTable(this);
  late final $WaterConsumptionsTable waterConsumptions =
      $WaterConsumptionsTable(this);
  late final $WaterTotalsTable waterTotals = $WaterTotalsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [waterConfigs, waterConsumptions, waterTotals];
}
