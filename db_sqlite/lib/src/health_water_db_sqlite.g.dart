// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_water_db_sqlite.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class WaterConfig extends DataClass implements Insertable<WaterConfig> {
  final int id;
  final int targetConsumption;
  WaterConfig({required this.id, required this.targetConsumption});
  factory WaterConfig.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return WaterConfig(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      targetConsumption: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}target_consumption'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['target_consumption'] = Variable<int>(targetConsumption);
    return map;
  }

  WaterConfigsCompanion toCompanion(bool nullToAbsent) {
    return WaterConfigsCompanion(
      id: Value(id),
      targetConsumption: Value(targetConsumption),
    );
  }

  factory WaterConfig.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterConfig(
      id: serializer.fromJson<int>(json['id']),
      targetConsumption: serializer.fromJson<int>(json['targetConsumption']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'targetConsumption': serializer.toJson<int>(targetConsumption),
    };
  }

  WaterConfig copyWith({int? id, int? targetConsumption}) => WaterConfig(
        id: id ?? this.id,
        targetConsumption: targetConsumption ?? this.targetConsumption,
      );
  @override
  String toString() {
    return (StringBuffer('WaterConfig(')
          ..write('id: $id, ')
          ..write('targetConsumption: $targetConsumption')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, targetConsumption);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WaterConfig &&
          other.id == this.id &&
          other.targetConsumption == this.targetConsumption);
}

class WaterConfigsCompanion extends UpdateCompanion<WaterConfig> {
  final Value<int> id;
  final Value<int> targetConsumption;
  const WaterConfigsCompanion({
    this.id = const Value.absent(),
    this.targetConsumption = const Value.absent(),
  });
  WaterConfigsCompanion.insert({
    this.id = const Value.absent(),
    required int targetConsumption,
  }) : targetConsumption = Value(targetConsumption);
  static Insertable<WaterConfig> custom({
    Expression<int>? id,
    Expression<int>? targetConsumption,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (targetConsumption != null) 'target_consumption': targetConsumption,
    });
  }

  WaterConfigsCompanion copyWith(
      {Value<int>? id, Value<int>? targetConsumption}) {
    return WaterConfigsCompanion(
      id: id ?? this.id,
      targetConsumption: targetConsumption ?? this.targetConsumption,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
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
  final VerificationMeta _targetConsumptionMeta =
      const VerificationMeta('targetConsumption');
  late final GeneratedColumn<int?> targetConsumption = GeneratedColumn<int?>(
      'target_consumption', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, targetConsumption];
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

class WaterDetail extends DataClass implements Insertable<WaterDetail> {
  final DateTime date;
  final int quantity;
  final int glass;
  WaterDetail(
      {required this.date, required this.quantity, required this.glass});
  factory WaterDetail.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return WaterDetail(
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
    map['date'] = Variable<DateTime>(date);
    map['quantity'] = Variable<int>(quantity);
    map['glass'] = Variable<int>(glass);
    return map;
  }

  WaterDetailsCompanion toCompanion(bool nullToAbsent) {
    return WaterDetailsCompanion(
      date: Value(date),
      quantity: Value(quantity),
      glass: Value(glass),
    );
  }

  factory WaterDetail.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterDetail(
      date: serializer.fromJson<DateTime>(json['date']),
      quantity: serializer.fromJson<int>(json['quantity']),
      glass: serializer.fromJson<int>(json['glass']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<DateTime>(date),
      'quantity': serializer.toJson<int>(quantity),
      'glass': serializer.toJson<int>(glass),
    };
  }

  WaterDetail copyWith({DateTime? date, int? quantity, int? glass}) =>
      WaterDetail(
        date: date ?? this.date,
        quantity: quantity ?? this.quantity,
        glass: glass ?? this.glass,
      );
  @override
  String toString() {
    return (StringBuffer('WaterDetail(')
          ..write('date: $date, ')
          ..write('quantity: $quantity, ')
          ..write('glass: $glass')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, quantity, glass);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WaterDetail &&
          other.date == this.date &&
          other.quantity == this.quantity &&
          other.glass == this.glass);
}

class WaterDetailsCompanion extends UpdateCompanion<WaterDetail> {
  final Value<DateTime> date;
  final Value<int> quantity;
  final Value<int> glass;
  const WaterDetailsCompanion({
    this.date = const Value.absent(),
    this.quantity = const Value.absent(),
    this.glass = const Value.absent(),
  });
  WaterDetailsCompanion.insert({
    required DateTime date,
    required int quantity,
    required int glass,
  })  : date = Value(date),
        quantity = Value(quantity),
        glass = Value(glass);
  static Insertable<WaterDetail> custom({
    Expression<DateTime>? date,
    Expression<int>? quantity,
    Expression<int>? glass,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (quantity != null) 'quantity': quantity,
      if (glass != null) 'glass': glass,
    });
  }

  WaterDetailsCompanion copyWith(
      {Value<DateTime>? date, Value<int>? quantity, Value<int>? glass}) {
    return WaterDetailsCompanion(
      date: date ?? this.date,
      quantity: quantity ?? this.quantity,
      glass: glass ?? this.glass,
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
    if (glass.present) {
      map['glass'] = Variable<int>(glass.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WaterDetailsCompanion(')
          ..write('date: $date, ')
          ..write('quantity: $quantity, ')
          ..write('glass: $glass')
          ..write(')'))
        .toString();
  }
}

class $WaterDetailsTable extends WaterDetails
    with TableInfo<$WaterDetailsTable, WaterDetail> {
  final GeneratedDatabase _db;
  final String? _alias;
  $WaterDetailsTable(this._db, [this._alias]);
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
  List<GeneratedColumn> get $columns => [date, quantity, glass];
  @override
  String get aliasedName => _alias ?? 'water_details';
  @override
  String get actualTableName => 'water_details';
  @override
  VerificationContext validateIntegrity(Insertable<WaterDetail> instance,
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
    if (data.containsKey('glass')) {
      context.handle(
          _glassMeta, glass.isAcceptableOrUnknown(data['glass']!, _glassMeta));
    } else if (isInserting) {
      context.missing(_glassMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  WaterDetail map(Map<String, dynamic> data, {String? tablePrefix}) {
    return WaterDetail.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $WaterDetailsTable createAlias(String alias) {
    return $WaterDetailsTable(_db, alias);
  }
}

class WaterPerDay extends DataClass implements Insertable<WaterPerDay> {
  final int date;
  final int quantity;
  WaterPerDay({required this.date, required this.quantity});
  factory WaterPerDay.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return WaterPerDay(
      date: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
      quantity: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}quantity'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<int>(date);
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  WatersPerDayCompanion toCompanion(bool nullToAbsent) {
    return WatersPerDayCompanion(
      date: Value(date),
      quantity: Value(quantity),
    );
  }

  factory WaterPerDay.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterPerDay(
      date: serializer.fromJson<int>(json['date']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<int>(date),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  WaterPerDay copyWith({int? date, int? quantity}) => WaterPerDay(
        date: date ?? this.date,
        quantity: quantity ?? this.quantity,
      );
  @override
  String toString() {
    return (StringBuffer('WaterPerDay(')
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
      (other is WaterPerDay &&
          other.date == this.date &&
          other.quantity == this.quantity);
}

class WatersPerDayCompanion extends UpdateCompanion<WaterPerDay> {
  final Value<int> date;
  final Value<int> quantity;
  const WatersPerDayCompanion({
    this.date = const Value.absent(),
    this.quantity = const Value.absent(),
  });
  WatersPerDayCompanion.insert({
    this.date = const Value.absent(),
    required int quantity,
  }) : quantity = Value(quantity);
  static Insertable<WaterPerDay> custom({
    Expression<int>? date,
    Expression<int>? quantity,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (quantity != null) 'quantity': quantity,
    });
  }

  WatersPerDayCompanion copyWith({Value<int>? date, Value<int>? quantity}) {
    return WatersPerDayCompanion(
      date: date ?? this.date,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WatersPerDayCompanion(')
          ..write('date: $date, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }
}

class $WatersPerDayTable extends WatersPerDay
    with TableInfo<$WatersPerDayTable, WaterPerDay> {
  final GeneratedDatabase _db;
  final String? _alias;
  $WatersPerDayTable(this._db, [this._alias]);
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  late final GeneratedColumn<int?> date = GeneratedColumn<int?>(
      'date', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _quantityMeta = const VerificationMeta('quantity');
  late final GeneratedColumn<int?> quantity = GeneratedColumn<int?>(
      'quantity', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [date, quantity];
  @override
  String get aliasedName => _alias ?? 'water_per_day';
  @override
  String get actualTableName => 'water_per_day';
  @override
  VerificationContext validateIntegrity(Insertable<WaterPerDay> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
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
  WaterPerDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    return WaterPerDay.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $WatersPerDayTable createAlias(String alias) {
    return $WatersPerDayTable(_db, alias);
  }
}

abstract class _$_WaterUserSqliteDB extends GeneratedDatabase {
  _$_WaterUserSqliteDB(QueryExecutor e)
      : super(SqlTypeSystem.defaultInstance, e);
  late final $WaterConfigsTable waterConfigs = $WaterConfigsTable(this);
  late final $WaterDetailsTable waterDetails = $WaterDetailsTable(this);
  late final $WatersPerDayTable watersPerDay = $WatersPerDayTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [waterConfigs, waterDetails, watersPerDay];
}
