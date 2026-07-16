// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SrdSpellsTable extends SrdSpells
    with TableInfo<$SrdSpellsTable, SrdSpell> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrdSpellsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RulesetVersion, String> ruleset =
      GeneratedColumn<String>(
        'ruleset',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RulesetVersion>($SrdSpellsTable.$converterruleset);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schoolMeta = const VerificationMeta('school');
  @override
  late final GeneratedColumn<String> school = GeneratedColumn<String>(
    'school',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _castingTimeMeta = const VerificationMeta(
    'castingTime',
  );
  @override
  late final GeneratedColumn<String> castingTime = GeneratedColumn<String>(
    'casting_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rangeMeta = const VerificationMeta('range');
  @override
  late final GeneratedColumn<String> range = GeneratedColumn<String>(
    'range',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _componentsMeta = const VerificationMeta(
    'components',
  );
  @override
  late final GeneratedColumn<String> components = GeneratedColumn<String>(
    'components',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<String> duration = GeneratedColumn<String>(
    'duration',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _concentrationMeta = const VerificationMeta(
    'concentration',
  );
  @override
  late final GeneratedColumn<bool> concentration = GeneratedColumn<bool>(
    'concentration',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("concentration" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _ritualMeta = const VerificationMeta('ritual');
  @override
  late final GeneratedColumn<bool> ritual = GeneratedColumn<bool>(
    'ritual',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ritual" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _higherLevelMeta = const VerificationMeta(
    'higherLevel',
  );
  @override
  late final GeneratedColumn<String> higherLevel = GeneratedColumn<String>(
    'higher_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _classesMeta = const VerificationMeta(
    'classes',
  );
  @override
  late final GeneratedColumn<String> classes = GeneratedColumn<String>(
    'classes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ruleset,
    name,
    level,
    school,
    castingTime,
    range,
    components,
    duration,
    concentration,
    ritual,
    description,
    higherLevel,
    classes,
    isCustom,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srd_spells';
  @override
  VerificationContext validateIntegrity(
    Insertable<SrdSpell> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('school')) {
      context.handle(
        _schoolMeta,
        school.isAcceptableOrUnknown(data['school']!, _schoolMeta),
      );
    } else if (isInserting) {
      context.missing(_schoolMeta);
    }
    if (data.containsKey('casting_time')) {
      context.handle(
        _castingTimeMeta,
        castingTime.isAcceptableOrUnknown(
          data['casting_time']!,
          _castingTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_castingTimeMeta);
    }
    if (data.containsKey('range')) {
      context.handle(
        _rangeMeta,
        range.isAcceptableOrUnknown(data['range']!, _rangeMeta),
      );
    } else if (isInserting) {
      context.missing(_rangeMeta);
    }
    if (data.containsKey('components')) {
      context.handle(
        _componentsMeta,
        components.isAcceptableOrUnknown(data['components']!, _componentsMeta),
      );
    } else if (isInserting) {
      context.missing(_componentsMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (data.containsKey('concentration')) {
      context.handle(
        _concentrationMeta,
        concentration.isAcceptableOrUnknown(
          data['concentration']!,
          _concentrationMeta,
        ),
      );
    }
    if (data.containsKey('ritual')) {
      context.handle(
        _ritualMeta,
        ritual.isAcceptableOrUnknown(data['ritual']!, _ritualMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('higher_level')) {
      context.handle(
        _higherLevelMeta,
        higherLevel.isAcceptableOrUnknown(
          data['higher_level']!,
          _higherLevelMeta,
        ),
      );
    }
    if (data.containsKey('classes')) {
      context.handle(
        _classesMeta,
        classes.isAcceptableOrUnknown(data['classes']!, _classesMeta),
      );
    } else if (isInserting) {
      context.missing(_classesMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, ruleset};
  @override
  SrdSpell map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrdSpell(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ruleset: $SrdSpellsTable.$converterruleset.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}ruleset'],
        )!,
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      school: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}school'],
      )!,
      castingTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}casting_time'],
      )!,
      range: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}range'],
      )!,
      components: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}components'],
      )!,
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}duration'],
      )!,
      concentration: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}concentration'],
      )!,
      ritual: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ritual'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      higherLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}higher_level'],
      ),
      classes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}classes'],
      )!,
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
    );
  }

  @override
  $SrdSpellsTable createAlias(String alias) {
    return $SrdSpellsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RulesetVersion, String, String> $converterruleset =
      const EnumNameConverter<RulesetVersion>(RulesetVersion.values);
}

class SrdSpell extends DataClass implements Insertable<SrdSpell> {
  final String id;
  final RulesetVersion ruleset;
  final String name;
  final int level;
  final String school;
  final String castingTime;
  final String range;
  final String components;
  final String duration;
  final bool concentration;
  final bool ritual;
  final String description;
  final String? higherLevel;
  final String classes;
  final bool isCustom;
  const SrdSpell({
    required this.id,
    required this.ruleset,
    required this.name,
    required this.level,
    required this.school,
    required this.castingTime,
    required this.range,
    required this.components,
    required this.duration,
    required this.concentration,
    required this.ritual,
    required this.description,
    this.higherLevel,
    required this.classes,
    required this.isCustom,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['ruleset'] = Variable<String>(
        $SrdSpellsTable.$converterruleset.toSql(ruleset),
      );
    }
    map['name'] = Variable<String>(name);
    map['level'] = Variable<int>(level);
    map['school'] = Variable<String>(school);
    map['casting_time'] = Variable<String>(castingTime);
    map['range'] = Variable<String>(range);
    map['components'] = Variable<String>(components);
    map['duration'] = Variable<String>(duration);
    map['concentration'] = Variable<bool>(concentration);
    map['ritual'] = Variable<bool>(ritual);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || higherLevel != null) {
      map['higher_level'] = Variable<String>(higherLevel);
    }
    map['classes'] = Variable<String>(classes);
    map['is_custom'] = Variable<bool>(isCustom);
    return map;
  }

  SrdSpellsCompanion toCompanion(bool nullToAbsent) {
    return SrdSpellsCompanion(
      id: Value(id),
      ruleset: Value(ruleset),
      name: Value(name),
      level: Value(level),
      school: Value(school),
      castingTime: Value(castingTime),
      range: Value(range),
      components: Value(components),
      duration: Value(duration),
      concentration: Value(concentration),
      ritual: Value(ritual),
      description: Value(description),
      higherLevel: higherLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(higherLevel),
      classes: Value(classes),
      isCustom: Value(isCustom),
    );
  }

  factory SrdSpell.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrdSpell(
      id: serializer.fromJson<String>(json['id']),
      ruleset: $SrdSpellsTable.$converterruleset.fromJson(
        serializer.fromJson<String>(json['ruleset']),
      ),
      name: serializer.fromJson<String>(json['name']),
      level: serializer.fromJson<int>(json['level']),
      school: serializer.fromJson<String>(json['school']),
      castingTime: serializer.fromJson<String>(json['castingTime']),
      range: serializer.fromJson<String>(json['range']),
      components: serializer.fromJson<String>(json['components']),
      duration: serializer.fromJson<String>(json['duration']),
      concentration: serializer.fromJson<bool>(json['concentration']),
      ritual: serializer.fromJson<bool>(json['ritual']),
      description: serializer.fromJson<String>(json['description']),
      higherLevel: serializer.fromJson<String?>(json['higherLevel']),
      classes: serializer.fromJson<String>(json['classes']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ruleset': serializer.toJson<String>(
        $SrdSpellsTable.$converterruleset.toJson(ruleset),
      ),
      'name': serializer.toJson<String>(name),
      'level': serializer.toJson<int>(level),
      'school': serializer.toJson<String>(school),
      'castingTime': serializer.toJson<String>(castingTime),
      'range': serializer.toJson<String>(range),
      'components': serializer.toJson<String>(components),
      'duration': serializer.toJson<String>(duration),
      'concentration': serializer.toJson<bool>(concentration),
      'ritual': serializer.toJson<bool>(ritual),
      'description': serializer.toJson<String>(description),
      'higherLevel': serializer.toJson<String?>(higherLevel),
      'classes': serializer.toJson<String>(classes),
      'isCustom': serializer.toJson<bool>(isCustom),
    };
  }

  SrdSpell copyWith({
    String? id,
    RulesetVersion? ruleset,
    String? name,
    int? level,
    String? school,
    String? castingTime,
    String? range,
    String? components,
    String? duration,
    bool? concentration,
    bool? ritual,
    String? description,
    Value<String?> higherLevel = const Value.absent(),
    String? classes,
    bool? isCustom,
  }) => SrdSpell(
    id: id ?? this.id,
    ruleset: ruleset ?? this.ruleset,
    name: name ?? this.name,
    level: level ?? this.level,
    school: school ?? this.school,
    castingTime: castingTime ?? this.castingTime,
    range: range ?? this.range,
    components: components ?? this.components,
    duration: duration ?? this.duration,
    concentration: concentration ?? this.concentration,
    ritual: ritual ?? this.ritual,
    description: description ?? this.description,
    higherLevel: higherLevel.present ? higherLevel.value : this.higherLevel,
    classes: classes ?? this.classes,
    isCustom: isCustom ?? this.isCustom,
  );
  SrdSpell copyWithCompanion(SrdSpellsCompanion data) {
    return SrdSpell(
      id: data.id.present ? data.id.value : this.id,
      ruleset: data.ruleset.present ? data.ruleset.value : this.ruleset,
      name: data.name.present ? data.name.value : this.name,
      level: data.level.present ? data.level.value : this.level,
      school: data.school.present ? data.school.value : this.school,
      castingTime: data.castingTime.present
          ? data.castingTime.value
          : this.castingTime,
      range: data.range.present ? data.range.value : this.range,
      components: data.components.present
          ? data.components.value
          : this.components,
      duration: data.duration.present ? data.duration.value : this.duration,
      concentration: data.concentration.present
          ? data.concentration.value
          : this.concentration,
      ritual: data.ritual.present ? data.ritual.value : this.ritual,
      description: data.description.present
          ? data.description.value
          : this.description,
      higherLevel: data.higherLevel.present
          ? data.higherLevel.value
          : this.higherLevel,
      classes: data.classes.present ? data.classes.value : this.classes,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrdSpell(')
          ..write('id: $id, ')
          ..write('ruleset: $ruleset, ')
          ..write('name: $name, ')
          ..write('level: $level, ')
          ..write('school: $school, ')
          ..write('castingTime: $castingTime, ')
          ..write('range: $range, ')
          ..write('components: $components, ')
          ..write('duration: $duration, ')
          ..write('concentration: $concentration, ')
          ..write('ritual: $ritual, ')
          ..write('description: $description, ')
          ..write('higherLevel: $higherLevel, ')
          ..write('classes: $classes, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ruleset,
    name,
    level,
    school,
    castingTime,
    range,
    components,
    duration,
    concentration,
    ritual,
    description,
    higherLevel,
    classes,
    isCustom,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrdSpell &&
          other.id == this.id &&
          other.ruleset == this.ruleset &&
          other.name == this.name &&
          other.level == this.level &&
          other.school == this.school &&
          other.castingTime == this.castingTime &&
          other.range == this.range &&
          other.components == this.components &&
          other.duration == this.duration &&
          other.concentration == this.concentration &&
          other.ritual == this.ritual &&
          other.description == this.description &&
          other.higherLevel == this.higherLevel &&
          other.classes == this.classes &&
          other.isCustom == this.isCustom);
}

class SrdSpellsCompanion extends UpdateCompanion<SrdSpell> {
  final Value<String> id;
  final Value<RulesetVersion> ruleset;
  final Value<String> name;
  final Value<int> level;
  final Value<String> school;
  final Value<String> castingTime;
  final Value<String> range;
  final Value<String> components;
  final Value<String> duration;
  final Value<bool> concentration;
  final Value<bool> ritual;
  final Value<String> description;
  final Value<String?> higherLevel;
  final Value<String> classes;
  final Value<bool> isCustom;
  final Value<int> rowid;
  const SrdSpellsCompanion({
    this.id = const Value.absent(),
    this.ruleset = const Value.absent(),
    this.name = const Value.absent(),
    this.level = const Value.absent(),
    this.school = const Value.absent(),
    this.castingTime = const Value.absent(),
    this.range = const Value.absent(),
    this.components = const Value.absent(),
    this.duration = const Value.absent(),
    this.concentration = const Value.absent(),
    this.ritual = const Value.absent(),
    this.description = const Value.absent(),
    this.higherLevel = const Value.absent(),
    this.classes = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SrdSpellsCompanion.insert({
    required String id,
    required RulesetVersion ruleset,
    required String name,
    required int level,
    required String school,
    required String castingTime,
    required String range,
    required String components,
    required String duration,
    this.concentration = const Value.absent(),
    this.ritual = const Value.absent(),
    required String description,
    this.higherLevel = const Value.absent(),
    required String classes,
    this.isCustom = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ruleset = Value(ruleset),
       name = Value(name),
       level = Value(level),
       school = Value(school),
       castingTime = Value(castingTime),
       range = Value(range),
       components = Value(components),
       duration = Value(duration),
       description = Value(description),
       classes = Value(classes);
  static Insertable<SrdSpell> custom({
    Expression<String>? id,
    Expression<String>? ruleset,
    Expression<String>? name,
    Expression<int>? level,
    Expression<String>? school,
    Expression<String>? castingTime,
    Expression<String>? range,
    Expression<String>? components,
    Expression<String>? duration,
    Expression<bool>? concentration,
    Expression<bool>? ritual,
    Expression<String>? description,
    Expression<String>? higherLevel,
    Expression<String>? classes,
    Expression<bool>? isCustom,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ruleset != null) 'ruleset': ruleset,
      if (name != null) 'name': name,
      if (level != null) 'level': level,
      if (school != null) 'school': school,
      if (castingTime != null) 'casting_time': castingTime,
      if (range != null) 'range': range,
      if (components != null) 'components': components,
      if (duration != null) 'duration': duration,
      if (concentration != null) 'concentration': concentration,
      if (ritual != null) 'ritual': ritual,
      if (description != null) 'description': description,
      if (higherLevel != null) 'higher_level': higherLevel,
      if (classes != null) 'classes': classes,
      if (isCustom != null) 'is_custom': isCustom,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SrdSpellsCompanion copyWith({
    Value<String>? id,
    Value<RulesetVersion>? ruleset,
    Value<String>? name,
    Value<int>? level,
    Value<String>? school,
    Value<String>? castingTime,
    Value<String>? range,
    Value<String>? components,
    Value<String>? duration,
    Value<bool>? concentration,
    Value<bool>? ritual,
    Value<String>? description,
    Value<String?>? higherLevel,
    Value<String>? classes,
    Value<bool>? isCustom,
    Value<int>? rowid,
  }) {
    return SrdSpellsCompanion(
      id: id ?? this.id,
      ruleset: ruleset ?? this.ruleset,
      name: name ?? this.name,
      level: level ?? this.level,
      school: school ?? this.school,
      castingTime: castingTime ?? this.castingTime,
      range: range ?? this.range,
      components: components ?? this.components,
      duration: duration ?? this.duration,
      concentration: concentration ?? this.concentration,
      ritual: ritual ?? this.ritual,
      description: description ?? this.description,
      higherLevel: higherLevel ?? this.higherLevel,
      classes: classes ?? this.classes,
      isCustom: isCustom ?? this.isCustom,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ruleset.present) {
      map['ruleset'] = Variable<String>(
        $SrdSpellsTable.$converterruleset.toSql(ruleset.value),
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (school.present) {
      map['school'] = Variable<String>(school.value);
    }
    if (castingTime.present) {
      map['casting_time'] = Variable<String>(castingTime.value);
    }
    if (range.present) {
      map['range'] = Variable<String>(range.value);
    }
    if (components.present) {
      map['components'] = Variable<String>(components.value);
    }
    if (duration.present) {
      map['duration'] = Variable<String>(duration.value);
    }
    if (concentration.present) {
      map['concentration'] = Variable<bool>(concentration.value);
    }
    if (ritual.present) {
      map['ritual'] = Variable<bool>(ritual.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (higherLevel.present) {
      map['higher_level'] = Variable<String>(higherLevel.value);
    }
    if (classes.present) {
      map['classes'] = Variable<String>(classes.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrdSpellsCompanion(')
          ..write('id: $id, ')
          ..write('ruleset: $ruleset, ')
          ..write('name: $name, ')
          ..write('level: $level, ')
          ..write('school: $school, ')
          ..write('castingTime: $castingTime, ')
          ..write('range: $range, ')
          ..write('components: $components, ')
          ..write('duration: $duration, ')
          ..write('concentration: $concentration, ')
          ..write('ritual: $ritual, ')
          ..write('description: $description, ')
          ..write('higherLevel: $higherLevel, ')
          ..write('classes: $classes, ')
          ..write('isCustom: $isCustom, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SrdClassesTable extends SrdClasses
    with TableInfo<$SrdClassesTable, SrdClassesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrdClassesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RulesetVersion, String> ruleset =
      GeneratedColumn<String>(
        'ruleset',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RulesetVersion>($SrdClassesTable.$converterruleset);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hitDieMeta = const VerificationMeta('hitDie');
  @override
  late final GeneratedColumn<int> hitDie = GeneratedColumn<int>(
    'hit_die',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proficienciesMeta = const VerificationMeta(
    'proficiencies',
  );
  @override
  late final GeneratedColumn<String> proficiencies = GeneratedColumn<String>(
    'proficiencies',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savingThrowsMeta = const VerificationMeta(
    'savingThrows',
  );
  @override
  late final GeneratedColumn<String> savingThrows = GeneratedColumn<String>(
    'saving_throws',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spellcastingAbilityMeta =
      const VerificationMeta('spellcastingAbility');
  @override
  late final GeneratedColumn<String> spellcastingAbility =
      GeneratedColumn<String>(
        'spellcasting_ability',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isPreparedCasterMeta = const VerificationMeta(
    'isPreparedCaster',
  );
  @override
  late final GeneratedColumn<bool> isPreparedCaster = GeneratedColumn<bool>(
    'is_prepared_caster',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_prepared_caster" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ruleset,
    name,
    hitDie,
    proficiencies,
    savingThrows,
    spellcastingAbility,
    isPreparedCaster,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srd_classes';
  @override
  VerificationContext validateIntegrity(
    Insertable<SrdClassesData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('hit_die')) {
      context.handle(
        _hitDieMeta,
        hitDie.isAcceptableOrUnknown(data['hit_die']!, _hitDieMeta),
      );
    } else if (isInserting) {
      context.missing(_hitDieMeta);
    }
    if (data.containsKey('proficiencies')) {
      context.handle(
        _proficienciesMeta,
        proficiencies.isAcceptableOrUnknown(
          data['proficiencies']!,
          _proficienciesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_proficienciesMeta);
    }
    if (data.containsKey('saving_throws')) {
      context.handle(
        _savingThrowsMeta,
        savingThrows.isAcceptableOrUnknown(
          data['saving_throws']!,
          _savingThrowsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_savingThrowsMeta);
    }
    if (data.containsKey('spellcasting_ability')) {
      context.handle(
        _spellcastingAbilityMeta,
        spellcastingAbility.isAcceptableOrUnknown(
          data['spellcasting_ability']!,
          _spellcastingAbilityMeta,
        ),
      );
    }
    if (data.containsKey('is_prepared_caster')) {
      context.handle(
        _isPreparedCasterMeta,
        isPreparedCaster.isAcceptableOrUnknown(
          data['is_prepared_caster']!,
          _isPreparedCasterMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, ruleset};
  @override
  SrdClassesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrdClassesData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ruleset: $SrdClassesTable.$converterruleset.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}ruleset'],
        )!,
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      hitDie: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hit_die'],
      )!,
      proficiencies: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proficiencies'],
      )!,
      savingThrows: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}saving_throws'],
      )!,
      spellcastingAbility: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spellcasting_ability'],
      ),
      isPreparedCaster: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_prepared_caster'],
      )!,
    );
  }

  @override
  $SrdClassesTable createAlias(String alias) {
    return $SrdClassesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RulesetVersion, String, String> $converterruleset =
      const EnumNameConverter<RulesetVersion>(RulesetVersion.values);
}

class SrdClassesData extends DataClass implements Insertable<SrdClassesData> {
  final String id;
  final RulesetVersion ruleset;
  final String name;
  final int hitDie;
  final String proficiencies;
  final String savingThrows;
  final String? spellcastingAbility;
  final bool isPreparedCaster;
  const SrdClassesData({
    required this.id,
    required this.ruleset,
    required this.name,
    required this.hitDie,
    required this.proficiencies,
    required this.savingThrows,
    this.spellcastingAbility,
    required this.isPreparedCaster,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['ruleset'] = Variable<String>(
        $SrdClassesTable.$converterruleset.toSql(ruleset),
      );
    }
    map['name'] = Variable<String>(name);
    map['hit_die'] = Variable<int>(hitDie);
    map['proficiencies'] = Variable<String>(proficiencies);
    map['saving_throws'] = Variable<String>(savingThrows);
    if (!nullToAbsent || spellcastingAbility != null) {
      map['spellcasting_ability'] = Variable<String>(spellcastingAbility);
    }
    map['is_prepared_caster'] = Variable<bool>(isPreparedCaster);
    return map;
  }

  SrdClassesCompanion toCompanion(bool nullToAbsent) {
    return SrdClassesCompanion(
      id: Value(id),
      ruleset: Value(ruleset),
      name: Value(name),
      hitDie: Value(hitDie),
      proficiencies: Value(proficiencies),
      savingThrows: Value(savingThrows),
      spellcastingAbility: spellcastingAbility == null && nullToAbsent
          ? const Value.absent()
          : Value(spellcastingAbility),
      isPreparedCaster: Value(isPreparedCaster),
    );
  }

  factory SrdClassesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrdClassesData(
      id: serializer.fromJson<String>(json['id']),
      ruleset: $SrdClassesTable.$converterruleset.fromJson(
        serializer.fromJson<String>(json['ruleset']),
      ),
      name: serializer.fromJson<String>(json['name']),
      hitDie: serializer.fromJson<int>(json['hitDie']),
      proficiencies: serializer.fromJson<String>(json['proficiencies']),
      savingThrows: serializer.fromJson<String>(json['savingThrows']),
      spellcastingAbility: serializer.fromJson<String?>(
        json['spellcastingAbility'],
      ),
      isPreparedCaster: serializer.fromJson<bool>(json['isPreparedCaster']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ruleset': serializer.toJson<String>(
        $SrdClassesTable.$converterruleset.toJson(ruleset),
      ),
      'name': serializer.toJson<String>(name),
      'hitDie': serializer.toJson<int>(hitDie),
      'proficiencies': serializer.toJson<String>(proficiencies),
      'savingThrows': serializer.toJson<String>(savingThrows),
      'spellcastingAbility': serializer.toJson<String?>(spellcastingAbility),
      'isPreparedCaster': serializer.toJson<bool>(isPreparedCaster),
    };
  }

  SrdClassesData copyWith({
    String? id,
    RulesetVersion? ruleset,
    String? name,
    int? hitDie,
    String? proficiencies,
    String? savingThrows,
    Value<String?> spellcastingAbility = const Value.absent(),
    bool? isPreparedCaster,
  }) => SrdClassesData(
    id: id ?? this.id,
    ruleset: ruleset ?? this.ruleset,
    name: name ?? this.name,
    hitDie: hitDie ?? this.hitDie,
    proficiencies: proficiencies ?? this.proficiencies,
    savingThrows: savingThrows ?? this.savingThrows,
    spellcastingAbility: spellcastingAbility.present
        ? spellcastingAbility.value
        : this.spellcastingAbility,
    isPreparedCaster: isPreparedCaster ?? this.isPreparedCaster,
  );
  SrdClassesData copyWithCompanion(SrdClassesCompanion data) {
    return SrdClassesData(
      id: data.id.present ? data.id.value : this.id,
      ruleset: data.ruleset.present ? data.ruleset.value : this.ruleset,
      name: data.name.present ? data.name.value : this.name,
      hitDie: data.hitDie.present ? data.hitDie.value : this.hitDie,
      proficiencies: data.proficiencies.present
          ? data.proficiencies.value
          : this.proficiencies,
      savingThrows: data.savingThrows.present
          ? data.savingThrows.value
          : this.savingThrows,
      spellcastingAbility: data.spellcastingAbility.present
          ? data.spellcastingAbility.value
          : this.spellcastingAbility,
      isPreparedCaster: data.isPreparedCaster.present
          ? data.isPreparedCaster.value
          : this.isPreparedCaster,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrdClassesData(')
          ..write('id: $id, ')
          ..write('ruleset: $ruleset, ')
          ..write('name: $name, ')
          ..write('hitDie: $hitDie, ')
          ..write('proficiencies: $proficiencies, ')
          ..write('savingThrows: $savingThrows, ')
          ..write('spellcastingAbility: $spellcastingAbility, ')
          ..write('isPreparedCaster: $isPreparedCaster')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ruleset,
    name,
    hitDie,
    proficiencies,
    savingThrows,
    spellcastingAbility,
    isPreparedCaster,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrdClassesData &&
          other.id == this.id &&
          other.ruleset == this.ruleset &&
          other.name == this.name &&
          other.hitDie == this.hitDie &&
          other.proficiencies == this.proficiencies &&
          other.savingThrows == this.savingThrows &&
          other.spellcastingAbility == this.spellcastingAbility &&
          other.isPreparedCaster == this.isPreparedCaster);
}

class SrdClassesCompanion extends UpdateCompanion<SrdClassesData> {
  final Value<String> id;
  final Value<RulesetVersion> ruleset;
  final Value<String> name;
  final Value<int> hitDie;
  final Value<String> proficiencies;
  final Value<String> savingThrows;
  final Value<String?> spellcastingAbility;
  final Value<bool> isPreparedCaster;
  final Value<int> rowid;
  const SrdClassesCompanion({
    this.id = const Value.absent(),
    this.ruleset = const Value.absent(),
    this.name = const Value.absent(),
    this.hitDie = const Value.absent(),
    this.proficiencies = const Value.absent(),
    this.savingThrows = const Value.absent(),
    this.spellcastingAbility = const Value.absent(),
    this.isPreparedCaster = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SrdClassesCompanion.insert({
    required String id,
    required RulesetVersion ruleset,
    required String name,
    required int hitDie,
    required String proficiencies,
    required String savingThrows,
    this.spellcastingAbility = const Value.absent(),
    this.isPreparedCaster = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ruleset = Value(ruleset),
       name = Value(name),
       hitDie = Value(hitDie),
       proficiencies = Value(proficiencies),
       savingThrows = Value(savingThrows);
  static Insertable<SrdClassesData> custom({
    Expression<String>? id,
    Expression<String>? ruleset,
    Expression<String>? name,
    Expression<int>? hitDie,
    Expression<String>? proficiencies,
    Expression<String>? savingThrows,
    Expression<String>? spellcastingAbility,
    Expression<bool>? isPreparedCaster,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ruleset != null) 'ruleset': ruleset,
      if (name != null) 'name': name,
      if (hitDie != null) 'hit_die': hitDie,
      if (proficiencies != null) 'proficiencies': proficiencies,
      if (savingThrows != null) 'saving_throws': savingThrows,
      if (spellcastingAbility != null)
        'spellcasting_ability': spellcastingAbility,
      if (isPreparedCaster != null) 'is_prepared_caster': isPreparedCaster,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SrdClassesCompanion copyWith({
    Value<String>? id,
    Value<RulesetVersion>? ruleset,
    Value<String>? name,
    Value<int>? hitDie,
    Value<String>? proficiencies,
    Value<String>? savingThrows,
    Value<String?>? spellcastingAbility,
    Value<bool>? isPreparedCaster,
    Value<int>? rowid,
  }) {
    return SrdClassesCompanion(
      id: id ?? this.id,
      ruleset: ruleset ?? this.ruleset,
      name: name ?? this.name,
      hitDie: hitDie ?? this.hitDie,
      proficiencies: proficiencies ?? this.proficiencies,
      savingThrows: savingThrows ?? this.savingThrows,
      spellcastingAbility: spellcastingAbility ?? this.spellcastingAbility,
      isPreparedCaster: isPreparedCaster ?? this.isPreparedCaster,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ruleset.present) {
      map['ruleset'] = Variable<String>(
        $SrdClassesTable.$converterruleset.toSql(ruleset.value),
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (hitDie.present) {
      map['hit_die'] = Variable<int>(hitDie.value);
    }
    if (proficiencies.present) {
      map['proficiencies'] = Variable<String>(proficiencies.value);
    }
    if (savingThrows.present) {
      map['saving_throws'] = Variable<String>(savingThrows.value);
    }
    if (spellcastingAbility.present) {
      map['spellcasting_ability'] = Variable<String>(spellcastingAbility.value);
    }
    if (isPreparedCaster.present) {
      map['is_prepared_caster'] = Variable<bool>(isPreparedCaster.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrdClassesCompanion(')
          ..write('id: $id, ')
          ..write('ruleset: $ruleset, ')
          ..write('name: $name, ')
          ..write('hitDie: $hitDie, ')
          ..write('proficiencies: $proficiencies, ')
          ..write('savingThrows: $savingThrows, ')
          ..write('spellcastingAbility: $spellcastingAbility, ')
          ..write('isPreparedCaster: $isPreparedCaster, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SrdSubclassesTable extends SrdSubclasses
    with TableInfo<$SrdSubclassesTable, SrdSubclassesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrdSubclassesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RulesetVersion, String> ruleset =
      GeneratedColumn<String>(
        'ruleset',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RulesetVersion>($SrdSubclassesTable.$converterruleset);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _classIdMeta = const VerificationMeta(
    'classId',
  );
  @override
  late final GeneratedColumn<String> classId = GeneratedColumn<String>(
    'class_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ruleset,
    name,
    classId,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srd_subclasses';
  @override
  VerificationContext validateIntegrity(
    Insertable<SrdSubclassesData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('class_id')) {
      context.handle(
        _classIdMeta,
        classId.isAcceptableOrUnknown(data['class_id']!, _classIdMeta),
      );
    } else if (isInserting) {
      context.missing(_classIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, ruleset};
  @override
  SrdSubclassesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrdSubclassesData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ruleset: $SrdSubclassesTable.$converterruleset.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}ruleset'],
        )!,
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      classId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}class_id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
    );
  }

  @override
  $SrdSubclassesTable createAlias(String alias) {
    return $SrdSubclassesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RulesetVersion, String, String> $converterruleset =
      const EnumNameConverter<RulesetVersion>(RulesetVersion.values);
}

class SrdSubclassesData extends DataClass
    implements Insertable<SrdSubclassesData> {
  final String id;
  final RulesetVersion ruleset;
  final String name;
  final String classId;
  final String description;
  const SrdSubclassesData({
    required this.id,
    required this.ruleset,
    required this.name,
    required this.classId,
    required this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['ruleset'] = Variable<String>(
        $SrdSubclassesTable.$converterruleset.toSql(ruleset),
      );
    }
    map['name'] = Variable<String>(name);
    map['class_id'] = Variable<String>(classId);
    map['description'] = Variable<String>(description);
    return map;
  }

  SrdSubclassesCompanion toCompanion(bool nullToAbsent) {
    return SrdSubclassesCompanion(
      id: Value(id),
      ruleset: Value(ruleset),
      name: Value(name),
      classId: Value(classId),
      description: Value(description),
    );
  }

  factory SrdSubclassesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrdSubclassesData(
      id: serializer.fromJson<String>(json['id']),
      ruleset: $SrdSubclassesTable.$converterruleset.fromJson(
        serializer.fromJson<String>(json['ruleset']),
      ),
      name: serializer.fromJson<String>(json['name']),
      classId: serializer.fromJson<String>(json['classId']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ruleset': serializer.toJson<String>(
        $SrdSubclassesTable.$converterruleset.toJson(ruleset),
      ),
      'name': serializer.toJson<String>(name),
      'classId': serializer.toJson<String>(classId),
      'description': serializer.toJson<String>(description),
    };
  }

  SrdSubclassesData copyWith({
    String? id,
    RulesetVersion? ruleset,
    String? name,
    String? classId,
    String? description,
  }) => SrdSubclassesData(
    id: id ?? this.id,
    ruleset: ruleset ?? this.ruleset,
    name: name ?? this.name,
    classId: classId ?? this.classId,
    description: description ?? this.description,
  );
  SrdSubclassesData copyWithCompanion(SrdSubclassesCompanion data) {
    return SrdSubclassesData(
      id: data.id.present ? data.id.value : this.id,
      ruleset: data.ruleset.present ? data.ruleset.value : this.ruleset,
      name: data.name.present ? data.name.value : this.name,
      classId: data.classId.present ? data.classId.value : this.classId,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrdSubclassesData(')
          ..write('id: $id, ')
          ..write('ruleset: $ruleset, ')
          ..write('name: $name, ')
          ..write('classId: $classId, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ruleset, name, classId, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrdSubclassesData &&
          other.id == this.id &&
          other.ruleset == this.ruleset &&
          other.name == this.name &&
          other.classId == this.classId &&
          other.description == this.description);
}

class SrdSubclassesCompanion extends UpdateCompanion<SrdSubclassesData> {
  final Value<String> id;
  final Value<RulesetVersion> ruleset;
  final Value<String> name;
  final Value<String> classId;
  final Value<String> description;
  final Value<int> rowid;
  const SrdSubclassesCompanion({
    this.id = const Value.absent(),
    this.ruleset = const Value.absent(),
    this.name = const Value.absent(),
    this.classId = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SrdSubclassesCompanion.insert({
    required String id,
    required RulesetVersion ruleset,
    required String name,
    required String classId,
    required String description,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ruleset = Value(ruleset),
       name = Value(name),
       classId = Value(classId),
       description = Value(description);
  static Insertable<SrdSubclassesData> custom({
    Expression<String>? id,
    Expression<String>? ruleset,
    Expression<String>? name,
    Expression<String>? classId,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ruleset != null) 'ruleset': ruleset,
      if (name != null) 'name': name,
      if (classId != null) 'class_id': classId,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SrdSubclassesCompanion copyWith({
    Value<String>? id,
    Value<RulesetVersion>? ruleset,
    Value<String>? name,
    Value<String>? classId,
    Value<String>? description,
    Value<int>? rowid,
  }) {
    return SrdSubclassesCompanion(
      id: id ?? this.id,
      ruleset: ruleset ?? this.ruleset,
      name: name ?? this.name,
      classId: classId ?? this.classId,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ruleset.present) {
      map['ruleset'] = Variable<String>(
        $SrdSubclassesTable.$converterruleset.toSql(ruleset.value),
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (classId.present) {
      map['class_id'] = Variable<String>(classId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrdSubclassesCompanion(')
          ..write('id: $id, ')
          ..write('ruleset: $ruleset, ')
          ..write('name: $name, ')
          ..write('classId: $classId, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SrdRacesTable extends SrdRaces with TableInfo<$SrdRacesTable, SrdRace> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrdRacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RulesetVersion, String> ruleset =
      GeneratedColumn<String>(
        'ruleset',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RulesetVersion>($SrdRacesTable.$converterruleset);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speedMeta = const VerificationMeta('speed');
  @override
  late final GeneratedColumn<int> speed = GeneratedColumn<int>(
    'speed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _abilityBonusesMeta = const VerificationMeta(
    'abilityBonuses',
  );
  @override
  late final GeneratedColumn<String> abilityBonuses = GeneratedColumn<String>(
    'ability_bonuses',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languagesMeta = const VerificationMeta(
    'languages',
  );
  @override
  late final GeneratedColumn<String> languages = GeneratedColumn<String>(
    'languages',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _traitsMeta = const VerificationMeta('traits');
  @override
  late final GeneratedColumn<String> traits = GeneratedColumn<String>(
    'traits',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ruleset,
    name,
    speed,
    abilityBonuses,
    languages,
    traits,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srd_races';
  @override
  VerificationContext validateIntegrity(
    Insertable<SrdRace> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('speed')) {
      context.handle(
        _speedMeta,
        speed.isAcceptableOrUnknown(data['speed']!, _speedMeta),
      );
    } else if (isInserting) {
      context.missing(_speedMeta);
    }
    if (data.containsKey('ability_bonuses')) {
      context.handle(
        _abilityBonusesMeta,
        abilityBonuses.isAcceptableOrUnknown(
          data['ability_bonuses']!,
          _abilityBonusesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_abilityBonusesMeta);
    }
    if (data.containsKey('languages')) {
      context.handle(
        _languagesMeta,
        languages.isAcceptableOrUnknown(data['languages']!, _languagesMeta),
      );
    } else if (isInserting) {
      context.missing(_languagesMeta);
    }
    if (data.containsKey('traits')) {
      context.handle(
        _traitsMeta,
        traits.isAcceptableOrUnknown(data['traits']!, _traitsMeta),
      );
    } else if (isInserting) {
      context.missing(_traitsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, ruleset};
  @override
  SrdRace map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrdRace(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ruleset: $SrdRacesTable.$converterruleset.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}ruleset'],
        )!,
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      speed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}speed'],
      )!,
      abilityBonuses: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ability_bonuses'],
      )!,
      languages: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}languages'],
      )!,
      traits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}traits'],
      )!,
    );
  }

  @override
  $SrdRacesTable createAlias(String alias) {
    return $SrdRacesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RulesetVersion, String, String> $converterruleset =
      const EnumNameConverter<RulesetVersion>(RulesetVersion.values);
}

class SrdRace extends DataClass implements Insertable<SrdRace> {
  final String id;
  final RulesetVersion ruleset;
  final String name;
  final int speed;
  final String abilityBonuses;
  final String languages;
  final String traits;
  const SrdRace({
    required this.id,
    required this.ruleset,
    required this.name,
    required this.speed,
    required this.abilityBonuses,
    required this.languages,
    required this.traits,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['ruleset'] = Variable<String>(
        $SrdRacesTable.$converterruleset.toSql(ruleset),
      );
    }
    map['name'] = Variable<String>(name);
    map['speed'] = Variable<int>(speed);
    map['ability_bonuses'] = Variable<String>(abilityBonuses);
    map['languages'] = Variable<String>(languages);
    map['traits'] = Variable<String>(traits);
    return map;
  }

  SrdRacesCompanion toCompanion(bool nullToAbsent) {
    return SrdRacesCompanion(
      id: Value(id),
      ruleset: Value(ruleset),
      name: Value(name),
      speed: Value(speed),
      abilityBonuses: Value(abilityBonuses),
      languages: Value(languages),
      traits: Value(traits),
    );
  }

  factory SrdRace.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrdRace(
      id: serializer.fromJson<String>(json['id']),
      ruleset: $SrdRacesTable.$converterruleset.fromJson(
        serializer.fromJson<String>(json['ruleset']),
      ),
      name: serializer.fromJson<String>(json['name']),
      speed: serializer.fromJson<int>(json['speed']),
      abilityBonuses: serializer.fromJson<String>(json['abilityBonuses']),
      languages: serializer.fromJson<String>(json['languages']),
      traits: serializer.fromJson<String>(json['traits']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ruleset': serializer.toJson<String>(
        $SrdRacesTable.$converterruleset.toJson(ruleset),
      ),
      'name': serializer.toJson<String>(name),
      'speed': serializer.toJson<int>(speed),
      'abilityBonuses': serializer.toJson<String>(abilityBonuses),
      'languages': serializer.toJson<String>(languages),
      'traits': serializer.toJson<String>(traits),
    };
  }

  SrdRace copyWith({
    String? id,
    RulesetVersion? ruleset,
    String? name,
    int? speed,
    String? abilityBonuses,
    String? languages,
    String? traits,
  }) => SrdRace(
    id: id ?? this.id,
    ruleset: ruleset ?? this.ruleset,
    name: name ?? this.name,
    speed: speed ?? this.speed,
    abilityBonuses: abilityBonuses ?? this.abilityBonuses,
    languages: languages ?? this.languages,
    traits: traits ?? this.traits,
  );
  SrdRace copyWithCompanion(SrdRacesCompanion data) {
    return SrdRace(
      id: data.id.present ? data.id.value : this.id,
      ruleset: data.ruleset.present ? data.ruleset.value : this.ruleset,
      name: data.name.present ? data.name.value : this.name,
      speed: data.speed.present ? data.speed.value : this.speed,
      abilityBonuses: data.abilityBonuses.present
          ? data.abilityBonuses.value
          : this.abilityBonuses,
      languages: data.languages.present ? data.languages.value : this.languages,
      traits: data.traits.present ? data.traits.value : this.traits,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrdRace(')
          ..write('id: $id, ')
          ..write('ruleset: $ruleset, ')
          ..write('name: $name, ')
          ..write('speed: $speed, ')
          ..write('abilityBonuses: $abilityBonuses, ')
          ..write('languages: $languages, ')
          ..write('traits: $traits')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ruleset, name, speed, abilityBonuses, languages, traits);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrdRace &&
          other.id == this.id &&
          other.ruleset == this.ruleset &&
          other.name == this.name &&
          other.speed == this.speed &&
          other.abilityBonuses == this.abilityBonuses &&
          other.languages == this.languages &&
          other.traits == this.traits);
}

class SrdRacesCompanion extends UpdateCompanion<SrdRace> {
  final Value<String> id;
  final Value<RulesetVersion> ruleset;
  final Value<String> name;
  final Value<int> speed;
  final Value<String> abilityBonuses;
  final Value<String> languages;
  final Value<String> traits;
  final Value<int> rowid;
  const SrdRacesCompanion({
    this.id = const Value.absent(),
    this.ruleset = const Value.absent(),
    this.name = const Value.absent(),
    this.speed = const Value.absent(),
    this.abilityBonuses = const Value.absent(),
    this.languages = const Value.absent(),
    this.traits = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SrdRacesCompanion.insert({
    required String id,
    required RulesetVersion ruleset,
    required String name,
    required int speed,
    required String abilityBonuses,
    required String languages,
    required String traits,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ruleset = Value(ruleset),
       name = Value(name),
       speed = Value(speed),
       abilityBonuses = Value(abilityBonuses),
       languages = Value(languages),
       traits = Value(traits);
  static Insertable<SrdRace> custom({
    Expression<String>? id,
    Expression<String>? ruleset,
    Expression<String>? name,
    Expression<int>? speed,
    Expression<String>? abilityBonuses,
    Expression<String>? languages,
    Expression<String>? traits,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ruleset != null) 'ruleset': ruleset,
      if (name != null) 'name': name,
      if (speed != null) 'speed': speed,
      if (abilityBonuses != null) 'ability_bonuses': abilityBonuses,
      if (languages != null) 'languages': languages,
      if (traits != null) 'traits': traits,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SrdRacesCompanion copyWith({
    Value<String>? id,
    Value<RulesetVersion>? ruleset,
    Value<String>? name,
    Value<int>? speed,
    Value<String>? abilityBonuses,
    Value<String>? languages,
    Value<String>? traits,
    Value<int>? rowid,
  }) {
    return SrdRacesCompanion(
      id: id ?? this.id,
      ruleset: ruleset ?? this.ruleset,
      name: name ?? this.name,
      speed: speed ?? this.speed,
      abilityBonuses: abilityBonuses ?? this.abilityBonuses,
      languages: languages ?? this.languages,
      traits: traits ?? this.traits,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ruleset.present) {
      map['ruleset'] = Variable<String>(
        $SrdRacesTable.$converterruleset.toSql(ruleset.value),
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (speed.present) {
      map['speed'] = Variable<int>(speed.value);
    }
    if (abilityBonuses.present) {
      map['ability_bonuses'] = Variable<String>(abilityBonuses.value);
    }
    if (languages.present) {
      map['languages'] = Variable<String>(languages.value);
    }
    if (traits.present) {
      map['traits'] = Variable<String>(traits.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrdRacesCompanion(')
          ..write('id: $id, ')
          ..write('ruleset: $ruleset, ')
          ..write('name: $name, ')
          ..write('speed: $speed, ')
          ..write('abilityBonuses: $abilityBonuses, ')
          ..write('languages: $languages, ')
          ..write('traits: $traits, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SrdSubracesTable extends SrdSubraces
    with TableInfo<$SrdSubracesTable, SrdSubrace> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrdSubracesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RulesetVersion, String> ruleset =
      GeneratedColumn<String>(
        'ruleset',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RulesetVersion>($SrdSubracesTable.$converterruleset);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _raceIdMeta = const VerificationMeta('raceId');
  @override
  late final GeneratedColumn<String> raceId = GeneratedColumn<String>(
    'race_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _abilityBonusesMeta = const VerificationMeta(
    'abilityBonuses',
  );
  @override
  late final GeneratedColumn<String> abilityBonuses = GeneratedColumn<String>(
    'ability_bonuses',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ruleset,
    name,
    raceId,
    abilityBonuses,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srd_subraces';
  @override
  VerificationContext validateIntegrity(
    Insertable<SrdSubrace> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('race_id')) {
      context.handle(
        _raceIdMeta,
        raceId.isAcceptableOrUnknown(data['race_id']!, _raceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_raceIdMeta);
    }
    if (data.containsKey('ability_bonuses')) {
      context.handle(
        _abilityBonusesMeta,
        abilityBonuses.isAcceptableOrUnknown(
          data['ability_bonuses']!,
          _abilityBonusesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_abilityBonusesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, ruleset};
  @override
  SrdSubrace map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrdSubrace(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ruleset: $SrdSubracesTable.$converterruleset.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}ruleset'],
        )!,
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      raceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}race_id'],
      )!,
      abilityBonuses: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ability_bonuses'],
      )!,
    );
  }

  @override
  $SrdSubracesTable createAlias(String alias) {
    return $SrdSubracesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RulesetVersion, String, String> $converterruleset =
      const EnumNameConverter<RulesetVersion>(RulesetVersion.values);
}

class SrdSubrace extends DataClass implements Insertable<SrdSubrace> {
  final String id;
  final RulesetVersion ruleset;
  final String name;
  final String raceId;
  final String abilityBonuses;
  const SrdSubrace({
    required this.id,
    required this.ruleset,
    required this.name,
    required this.raceId,
    required this.abilityBonuses,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['ruleset'] = Variable<String>(
        $SrdSubracesTable.$converterruleset.toSql(ruleset),
      );
    }
    map['name'] = Variable<String>(name);
    map['race_id'] = Variable<String>(raceId);
    map['ability_bonuses'] = Variable<String>(abilityBonuses);
    return map;
  }

  SrdSubracesCompanion toCompanion(bool nullToAbsent) {
    return SrdSubracesCompanion(
      id: Value(id),
      ruleset: Value(ruleset),
      name: Value(name),
      raceId: Value(raceId),
      abilityBonuses: Value(abilityBonuses),
    );
  }

  factory SrdSubrace.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrdSubrace(
      id: serializer.fromJson<String>(json['id']),
      ruleset: $SrdSubracesTable.$converterruleset.fromJson(
        serializer.fromJson<String>(json['ruleset']),
      ),
      name: serializer.fromJson<String>(json['name']),
      raceId: serializer.fromJson<String>(json['raceId']),
      abilityBonuses: serializer.fromJson<String>(json['abilityBonuses']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ruleset': serializer.toJson<String>(
        $SrdSubracesTable.$converterruleset.toJson(ruleset),
      ),
      'name': serializer.toJson<String>(name),
      'raceId': serializer.toJson<String>(raceId),
      'abilityBonuses': serializer.toJson<String>(abilityBonuses),
    };
  }

  SrdSubrace copyWith({
    String? id,
    RulesetVersion? ruleset,
    String? name,
    String? raceId,
    String? abilityBonuses,
  }) => SrdSubrace(
    id: id ?? this.id,
    ruleset: ruleset ?? this.ruleset,
    name: name ?? this.name,
    raceId: raceId ?? this.raceId,
    abilityBonuses: abilityBonuses ?? this.abilityBonuses,
  );
  SrdSubrace copyWithCompanion(SrdSubracesCompanion data) {
    return SrdSubrace(
      id: data.id.present ? data.id.value : this.id,
      ruleset: data.ruleset.present ? data.ruleset.value : this.ruleset,
      name: data.name.present ? data.name.value : this.name,
      raceId: data.raceId.present ? data.raceId.value : this.raceId,
      abilityBonuses: data.abilityBonuses.present
          ? data.abilityBonuses.value
          : this.abilityBonuses,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrdSubrace(')
          ..write('id: $id, ')
          ..write('ruleset: $ruleset, ')
          ..write('name: $name, ')
          ..write('raceId: $raceId, ')
          ..write('abilityBonuses: $abilityBonuses')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ruleset, name, raceId, abilityBonuses);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrdSubrace &&
          other.id == this.id &&
          other.ruleset == this.ruleset &&
          other.name == this.name &&
          other.raceId == this.raceId &&
          other.abilityBonuses == this.abilityBonuses);
}

class SrdSubracesCompanion extends UpdateCompanion<SrdSubrace> {
  final Value<String> id;
  final Value<RulesetVersion> ruleset;
  final Value<String> name;
  final Value<String> raceId;
  final Value<String> abilityBonuses;
  final Value<int> rowid;
  const SrdSubracesCompanion({
    this.id = const Value.absent(),
    this.ruleset = const Value.absent(),
    this.name = const Value.absent(),
    this.raceId = const Value.absent(),
    this.abilityBonuses = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SrdSubracesCompanion.insert({
    required String id,
    required RulesetVersion ruleset,
    required String name,
    required String raceId,
    required String abilityBonuses,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ruleset = Value(ruleset),
       name = Value(name),
       raceId = Value(raceId),
       abilityBonuses = Value(abilityBonuses);
  static Insertable<SrdSubrace> custom({
    Expression<String>? id,
    Expression<String>? ruleset,
    Expression<String>? name,
    Expression<String>? raceId,
    Expression<String>? abilityBonuses,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ruleset != null) 'ruleset': ruleset,
      if (name != null) 'name': name,
      if (raceId != null) 'race_id': raceId,
      if (abilityBonuses != null) 'ability_bonuses': abilityBonuses,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SrdSubracesCompanion copyWith({
    Value<String>? id,
    Value<RulesetVersion>? ruleset,
    Value<String>? name,
    Value<String>? raceId,
    Value<String>? abilityBonuses,
    Value<int>? rowid,
  }) {
    return SrdSubracesCompanion(
      id: id ?? this.id,
      ruleset: ruleset ?? this.ruleset,
      name: name ?? this.name,
      raceId: raceId ?? this.raceId,
      abilityBonuses: abilityBonuses ?? this.abilityBonuses,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ruleset.present) {
      map['ruleset'] = Variable<String>(
        $SrdSubracesTable.$converterruleset.toSql(ruleset.value),
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (raceId.present) {
      map['race_id'] = Variable<String>(raceId.value);
    }
    if (abilityBonuses.present) {
      map['ability_bonuses'] = Variable<String>(abilityBonuses.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrdSubracesCompanion(')
          ..write('id: $id, ')
          ..write('ruleset: $ruleset, ')
          ..write('name: $name, ')
          ..write('raceId: $raceId, ')
          ..write('abilityBonuses: $abilityBonuses, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SrdBackgroundsTable extends SrdBackgrounds
    with TableInfo<$SrdBackgroundsTable, SrdBackground> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrdBackgroundsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RulesetVersion, String> ruleset =
      GeneratedColumn<String>(
        'ruleset',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RulesetVersion>($SrdBackgroundsTable.$converterruleset);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skillProficienciesMeta =
      const VerificationMeta('skillProficiencies');
  @override
  late final GeneratedColumn<String> skillProficiencies =
      GeneratedColumn<String>(
        'skill_proficiencies',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _toolProficienciesMeta = const VerificationMeta(
    'toolProficiencies',
  );
  @override
  late final GeneratedColumn<String> toolProficiencies =
      GeneratedColumn<String>(
        'tool_proficiencies',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _languagesMeta = const VerificationMeta(
    'languages',
  );
  @override
  late final GeneratedColumn<String> languages = GeneratedColumn<String>(
    'languages',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _asiJsonMeta = const VerificationMeta(
    'asiJson',
  );
  @override
  late final GeneratedColumn<String> asiJson = GeneratedColumn<String>(
    'asi_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originFeatIdMeta = const VerificationMeta(
    'originFeatId',
  );
  @override
  late final GeneratedColumn<String> originFeatId = GeneratedColumn<String>(
    'origin_feat_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ruleset,
    name,
    skillProficiencies,
    toolProficiencies,
    languages,
    asiJson,
    originFeatId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srd_backgrounds';
  @override
  VerificationContext validateIntegrity(
    Insertable<SrdBackground> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('skill_proficiencies')) {
      context.handle(
        _skillProficienciesMeta,
        skillProficiencies.isAcceptableOrUnknown(
          data['skill_proficiencies']!,
          _skillProficienciesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_skillProficienciesMeta);
    }
    if (data.containsKey('tool_proficiencies')) {
      context.handle(
        _toolProficienciesMeta,
        toolProficiencies.isAcceptableOrUnknown(
          data['tool_proficiencies']!,
          _toolProficienciesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_toolProficienciesMeta);
    }
    if (data.containsKey('languages')) {
      context.handle(
        _languagesMeta,
        languages.isAcceptableOrUnknown(data['languages']!, _languagesMeta),
      );
    } else if (isInserting) {
      context.missing(_languagesMeta);
    }
    if (data.containsKey('asi_json')) {
      context.handle(
        _asiJsonMeta,
        asiJson.isAcceptableOrUnknown(data['asi_json']!, _asiJsonMeta),
      );
    }
    if (data.containsKey('origin_feat_id')) {
      context.handle(
        _originFeatIdMeta,
        originFeatId.isAcceptableOrUnknown(
          data['origin_feat_id']!,
          _originFeatIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, ruleset};
  @override
  SrdBackground map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrdBackground(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ruleset: $SrdBackgroundsTable.$converterruleset.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}ruleset'],
        )!,
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      skillProficiencies: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}skill_proficiencies'],
      )!,
      toolProficiencies: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tool_proficiencies'],
      )!,
      languages: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}languages'],
      )!,
      asiJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asi_json'],
      ),
      originFeatId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_feat_id'],
      ),
    );
  }

  @override
  $SrdBackgroundsTable createAlias(String alias) {
    return $SrdBackgroundsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RulesetVersion, String, String> $converterruleset =
      const EnumNameConverter<RulesetVersion>(RulesetVersion.values);
}

class SrdBackground extends DataClass implements Insertable<SrdBackground> {
  final String id;
  final RulesetVersion ruleset;
  final String name;
  final String skillProficiencies;
  final String toolProficiencies;
  final String languages;
  final String? asiJson;
  final String? originFeatId;
  const SrdBackground({
    required this.id,
    required this.ruleset,
    required this.name,
    required this.skillProficiencies,
    required this.toolProficiencies,
    required this.languages,
    this.asiJson,
    this.originFeatId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['ruleset'] = Variable<String>(
        $SrdBackgroundsTable.$converterruleset.toSql(ruleset),
      );
    }
    map['name'] = Variable<String>(name);
    map['skill_proficiencies'] = Variable<String>(skillProficiencies);
    map['tool_proficiencies'] = Variable<String>(toolProficiencies);
    map['languages'] = Variable<String>(languages);
    if (!nullToAbsent || asiJson != null) {
      map['asi_json'] = Variable<String>(asiJson);
    }
    if (!nullToAbsent || originFeatId != null) {
      map['origin_feat_id'] = Variable<String>(originFeatId);
    }
    return map;
  }

  SrdBackgroundsCompanion toCompanion(bool nullToAbsent) {
    return SrdBackgroundsCompanion(
      id: Value(id),
      ruleset: Value(ruleset),
      name: Value(name),
      skillProficiencies: Value(skillProficiencies),
      toolProficiencies: Value(toolProficiencies),
      languages: Value(languages),
      asiJson: asiJson == null && nullToAbsent
          ? const Value.absent()
          : Value(asiJson),
      originFeatId: originFeatId == null && nullToAbsent
          ? const Value.absent()
          : Value(originFeatId),
    );
  }

  factory SrdBackground.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrdBackground(
      id: serializer.fromJson<String>(json['id']),
      ruleset: $SrdBackgroundsTable.$converterruleset.fromJson(
        serializer.fromJson<String>(json['ruleset']),
      ),
      name: serializer.fromJson<String>(json['name']),
      skillProficiencies: serializer.fromJson<String>(
        json['skillProficiencies'],
      ),
      toolProficiencies: serializer.fromJson<String>(json['toolProficiencies']),
      languages: serializer.fromJson<String>(json['languages']),
      asiJson: serializer.fromJson<String?>(json['asiJson']),
      originFeatId: serializer.fromJson<String?>(json['originFeatId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ruleset': serializer.toJson<String>(
        $SrdBackgroundsTable.$converterruleset.toJson(ruleset),
      ),
      'name': serializer.toJson<String>(name),
      'skillProficiencies': serializer.toJson<String>(skillProficiencies),
      'toolProficiencies': serializer.toJson<String>(toolProficiencies),
      'languages': serializer.toJson<String>(languages),
      'asiJson': serializer.toJson<String?>(asiJson),
      'originFeatId': serializer.toJson<String?>(originFeatId),
    };
  }

  SrdBackground copyWith({
    String? id,
    RulesetVersion? ruleset,
    String? name,
    String? skillProficiencies,
    String? toolProficiencies,
    String? languages,
    Value<String?> asiJson = const Value.absent(),
    Value<String?> originFeatId = const Value.absent(),
  }) => SrdBackground(
    id: id ?? this.id,
    ruleset: ruleset ?? this.ruleset,
    name: name ?? this.name,
    skillProficiencies: skillProficiencies ?? this.skillProficiencies,
    toolProficiencies: toolProficiencies ?? this.toolProficiencies,
    languages: languages ?? this.languages,
    asiJson: asiJson.present ? asiJson.value : this.asiJson,
    originFeatId: originFeatId.present ? originFeatId.value : this.originFeatId,
  );
  SrdBackground copyWithCompanion(SrdBackgroundsCompanion data) {
    return SrdBackground(
      id: data.id.present ? data.id.value : this.id,
      ruleset: data.ruleset.present ? data.ruleset.value : this.ruleset,
      name: data.name.present ? data.name.value : this.name,
      skillProficiencies: data.skillProficiencies.present
          ? data.skillProficiencies.value
          : this.skillProficiencies,
      toolProficiencies: data.toolProficiencies.present
          ? data.toolProficiencies.value
          : this.toolProficiencies,
      languages: data.languages.present ? data.languages.value : this.languages,
      asiJson: data.asiJson.present ? data.asiJson.value : this.asiJson,
      originFeatId: data.originFeatId.present
          ? data.originFeatId.value
          : this.originFeatId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrdBackground(')
          ..write('id: $id, ')
          ..write('ruleset: $ruleset, ')
          ..write('name: $name, ')
          ..write('skillProficiencies: $skillProficiencies, ')
          ..write('toolProficiencies: $toolProficiencies, ')
          ..write('languages: $languages, ')
          ..write('asiJson: $asiJson, ')
          ..write('originFeatId: $originFeatId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ruleset,
    name,
    skillProficiencies,
    toolProficiencies,
    languages,
    asiJson,
    originFeatId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrdBackground &&
          other.id == this.id &&
          other.ruleset == this.ruleset &&
          other.name == this.name &&
          other.skillProficiencies == this.skillProficiencies &&
          other.toolProficiencies == this.toolProficiencies &&
          other.languages == this.languages &&
          other.asiJson == this.asiJson &&
          other.originFeatId == this.originFeatId);
}

class SrdBackgroundsCompanion extends UpdateCompanion<SrdBackground> {
  final Value<String> id;
  final Value<RulesetVersion> ruleset;
  final Value<String> name;
  final Value<String> skillProficiencies;
  final Value<String> toolProficiencies;
  final Value<String> languages;
  final Value<String?> asiJson;
  final Value<String?> originFeatId;
  final Value<int> rowid;
  const SrdBackgroundsCompanion({
    this.id = const Value.absent(),
    this.ruleset = const Value.absent(),
    this.name = const Value.absent(),
    this.skillProficiencies = const Value.absent(),
    this.toolProficiencies = const Value.absent(),
    this.languages = const Value.absent(),
    this.asiJson = const Value.absent(),
    this.originFeatId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SrdBackgroundsCompanion.insert({
    required String id,
    required RulesetVersion ruleset,
    required String name,
    required String skillProficiencies,
    required String toolProficiencies,
    required String languages,
    this.asiJson = const Value.absent(),
    this.originFeatId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ruleset = Value(ruleset),
       name = Value(name),
       skillProficiencies = Value(skillProficiencies),
       toolProficiencies = Value(toolProficiencies),
       languages = Value(languages);
  static Insertable<SrdBackground> custom({
    Expression<String>? id,
    Expression<String>? ruleset,
    Expression<String>? name,
    Expression<String>? skillProficiencies,
    Expression<String>? toolProficiencies,
    Expression<String>? languages,
    Expression<String>? asiJson,
    Expression<String>? originFeatId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ruleset != null) 'ruleset': ruleset,
      if (name != null) 'name': name,
      if (skillProficiencies != null) 'skill_proficiencies': skillProficiencies,
      if (toolProficiencies != null) 'tool_proficiencies': toolProficiencies,
      if (languages != null) 'languages': languages,
      if (asiJson != null) 'asi_json': asiJson,
      if (originFeatId != null) 'origin_feat_id': originFeatId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SrdBackgroundsCompanion copyWith({
    Value<String>? id,
    Value<RulesetVersion>? ruleset,
    Value<String>? name,
    Value<String>? skillProficiencies,
    Value<String>? toolProficiencies,
    Value<String>? languages,
    Value<String?>? asiJson,
    Value<String?>? originFeatId,
    Value<int>? rowid,
  }) {
    return SrdBackgroundsCompanion(
      id: id ?? this.id,
      ruleset: ruleset ?? this.ruleset,
      name: name ?? this.name,
      skillProficiencies: skillProficiencies ?? this.skillProficiencies,
      toolProficiencies: toolProficiencies ?? this.toolProficiencies,
      languages: languages ?? this.languages,
      asiJson: asiJson ?? this.asiJson,
      originFeatId: originFeatId ?? this.originFeatId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ruleset.present) {
      map['ruleset'] = Variable<String>(
        $SrdBackgroundsTable.$converterruleset.toSql(ruleset.value),
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (skillProficiencies.present) {
      map['skill_proficiencies'] = Variable<String>(skillProficiencies.value);
    }
    if (toolProficiencies.present) {
      map['tool_proficiencies'] = Variable<String>(toolProficiencies.value);
    }
    if (languages.present) {
      map['languages'] = Variable<String>(languages.value);
    }
    if (asiJson.present) {
      map['asi_json'] = Variable<String>(asiJson.value);
    }
    if (originFeatId.present) {
      map['origin_feat_id'] = Variable<String>(originFeatId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrdBackgroundsCompanion(')
          ..write('id: $id, ')
          ..write('ruleset: $ruleset, ')
          ..write('name: $name, ')
          ..write('skillProficiencies: $skillProficiencies, ')
          ..write('toolProficiencies: $toolProficiencies, ')
          ..write('languages: $languages, ')
          ..write('asiJson: $asiJson, ')
          ..write('originFeatId: $originFeatId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SrdFeaturesTable extends SrdFeatures
    with TableInfo<$SrdFeaturesTable, SrdFeature> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrdFeaturesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _srdIndexMeta = const VerificationMeta(
    'srdIndex',
  );
  @override
  late final GeneratedColumn<String> srdIndex = GeneratedColumn<String>(
    'srd_index',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RulesetVersion, String> ruleset =
      GeneratedColumn<String>(
        'ruleset',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RulesetVersion>($SrdFeaturesTable.$converterruleset);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _classIdMeta = const VerificationMeta(
    'classId',
  );
  @override
  late final GeneratedColumn<String> classId = GeneratedColumn<String>(
    'class_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subclassIdMeta = const VerificationMeta(
    'subclassId',
  );
  @override
  late final GeneratedColumn<String> subclassId = GeneratedColumn<String>(
    'subclass_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    srdIndex,
    ruleset,
    name,
    classId,
    subclassId,
    level,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srd_features';
  @override
  VerificationContext validateIntegrity(
    Insertable<SrdFeature> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('srd_index')) {
      context.handle(
        _srdIndexMeta,
        srdIndex.isAcceptableOrUnknown(data['srd_index']!, _srdIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_srdIndexMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('class_id')) {
      context.handle(
        _classIdMeta,
        classId.isAcceptableOrUnknown(data['class_id']!, _classIdMeta),
      );
    }
    if (data.containsKey('subclass_id')) {
      context.handle(
        _subclassIdMeta,
        subclassId.isAcceptableOrUnknown(data['subclass_id']!, _subclassIdMeta),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SrdFeature map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrdFeature(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      srdIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}srd_index'],
      )!,
      ruleset: $SrdFeaturesTable.$converterruleset.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}ruleset'],
        )!,
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      classId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}class_id'],
      ),
      subclassId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subclass_id'],
      ),
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
    );
  }

  @override
  $SrdFeaturesTable createAlias(String alias) {
    return $SrdFeaturesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RulesetVersion, String, String> $converterruleset =
      const EnumNameConverter<RulesetVersion>(RulesetVersion.values);
}

class SrdFeature extends DataClass implements Insertable<SrdFeature> {
  final int id;
  final String srdIndex;
  final RulesetVersion ruleset;
  final String name;
  final String? classId;
  final String? subclassId;
  final int level;
  final String description;
  const SrdFeature({
    required this.id,
    required this.srdIndex,
    required this.ruleset,
    required this.name,
    this.classId,
    this.subclassId,
    required this.level,
    required this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['srd_index'] = Variable<String>(srdIndex);
    {
      map['ruleset'] = Variable<String>(
        $SrdFeaturesTable.$converterruleset.toSql(ruleset),
      );
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || classId != null) {
      map['class_id'] = Variable<String>(classId);
    }
    if (!nullToAbsent || subclassId != null) {
      map['subclass_id'] = Variable<String>(subclassId);
    }
    map['level'] = Variable<int>(level);
    map['description'] = Variable<String>(description);
    return map;
  }

  SrdFeaturesCompanion toCompanion(bool nullToAbsent) {
    return SrdFeaturesCompanion(
      id: Value(id),
      srdIndex: Value(srdIndex),
      ruleset: Value(ruleset),
      name: Value(name),
      classId: classId == null && nullToAbsent
          ? const Value.absent()
          : Value(classId),
      subclassId: subclassId == null && nullToAbsent
          ? const Value.absent()
          : Value(subclassId),
      level: Value(level),
      description: Value(description),
    );
  }

  factory SrdFeature.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrdFeature(
      id: serializer.fromJson<int>(json['id']),
      srdIndex: serializer.fromJson<String>(json['srdIndex']),
      ruleset: $SrdFeaturesTable.$converterruleset.fromJson(
        serializer.fromJson<String>(json['ruleset']),
      ),
      name: serializer.fromJson<String>(json['name']),
      classId: serializer.fromJson<String?>(json['classId']),
      subclassId: serializer.fromJson<String?>(json['subclassId']),
      level: serializer.fromJson<int>(json['level']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'srdIndex': serializer.toJson<String>(srdIndex),
      'ruleset': serializer.toJson<String>(
        $SrdFeaturesTable.$converterruleset.toJson(ruleset),
      ),
      'name': serializer.toJson<String>(name),
      'classId': serializer.toJson<String?>(classId),
      'subclassId': serializer.toJson<String?>(subclassId),
      'level': serializer.toJson<int>(level),
      'description': serializer.toJson<String>(description),
    };
  }

  SrdFeature copyWith({
    int? id,
    String? srdIndex,
    RulesetVersion? ruleset,
    String? name,
    Value<String?> classId = const Value.absent(),
    Value<String?> subclassId = const Value.absent(),
    int? level,
    String? description,
  }) => SrdFeature(
    id: id ?? this.id,
    srdIndex: srdIndex ?? this.srdIndex,
    ruleset: ruleset ?? this.ruleset,
    name: name ?? this.name,
    classId: classId.present ? classId.value : this.classId,
    subclassId: subclassId.present ? subclassId.value : this.subclassId,
    level: level ?? this.level,
    description: description ?? this.description,
  );
  SrdFeature copyWithCompanion(SrdFeaturesCompanion data) {
    return SrdFeature(
      id: data.id.present ? data.id.value : this.id,
      srdIndex: data.srdIndex.present ? data.srdIndex.value : this.srdIndex,
      ruleset: data.ruleset.present ? data.ruleset.value : this.ruleset,
      name: data.name.present ? data.name.value : this.name,
      classId: data.classId.present ? data.classId.value : this.classId,
      subclassId: data.subclassId.present
          ? data.subclassId.value
          : this.subclassId,
      level: data.level.present ? data.level.value : this.level,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrdFeature(')
          ..write('id: $id, ')
          ..write('srdIndex: $srdIndex, ')
          ..write('ruleset: $ruleset, ')
          ..write('name: $name, ')
          ..write('classId: $classId, ')
          ..write('subclassId: $subclassId, ')
          ..write('level: $level, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    srdIndex,
    ruleset,
    name,
    classId,
    subclassId,
    level,
    description,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrdFeature &&
          other.id == this.id &&
          other.srdIndex == this.srdIndex &&
          other.ruleset == this.ruleset &&
          other.name == this.name &&
          other.classId == this.classId &&
          other.subclassId == this.subclassId &&
          other.level == this.level &&
          other.description == this.description);
}

class SrdFeaturesCompanion extends UpdateCompanion<SrdFeature> {
  final Value<int> id;
  final Value<String> srdIndex;
  final Value<RulesetVersion> ruleset;
  final Value<String> name;
  final Value<String?> classId;
  final Value<String?> subclassId;
  final Value<int> level;
  final Value<String> description;
  const SrdFeaturesCompanion({
    this.id = const Value.absent(),
    this.srdIndex = const Value.absent(),
    this.ruleset = const Value.absent(),
    this.name = const Value.absent(),
    this.classId = const Value.absent(),
    this.subclassId = const Value.absent(),
    this.level = const Value.absent(),
    this.description = const Value.absent(),
  });
  SrdFeaturesCompanion.insert({
    this.id = const Value.absent(),
    required String srdIndex,
    required RulesetVersion ruleset,
    required String name,
    this.classId = const Value.absent(),
    this.subclassId = const Value.absent(),
    required int level,
    required String description,
  }) : srdIndex = Value(srdIndex),
       ruleset = Value(ruleset),
       name = Value(name),
       level = Value(level),
       description = Value(description);
  static Insertable<SrdFeature> custom({
    Expression<int>? id,
    Expression<String>? srdIndex,
    Expression<String>? ruleset,
    Expression<String>? name,
    Expression<String>? classId,
    Expression<String>? subclassId,
    Expression<int>? level,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (srdIndex != null) 'srd_index': srdIndex,
      if (ruleset != null) 'ruleset': ruleset,
      if (name != null) 'name': name,
      if (classId != null) 'class_id': classId,
      if (subclassId != null) 'subclass_id': subclassId,
      if (level != null) 'level': level,
      if (description != null) 'description': description,
    });
  }

  SrdFeaturesCompanion copyWith({
    Value<int>? id,
    Value<String>? srdIndex,
    Value<RulesetVersion>? ruleset,
    Value<String>? name,
    Value<String?>? classId,
    Value<String?>? subclassId,
    Value<int>? level,
    Value<String>? description,
  }) {
    return SrdFeaturesCompanion(
      id: id ?? this.id,
      srdIndex: srdIndex ?? this.srdIndex,
      ruleset: ruleset ?? this.ruleset,
      name: name ?? this.name,
      classId: classId ?? this.classId,
      subclassId: subclassId ?? this.subclassId,
      level: level ?? this.level,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (srdIndex.present) {
      map['srd_index'] = Variable<String>(srdIndex.value);
    }
    if (ruleset.present) {
      map['ruleset'] = Variable<String>(
        $SrdFeaturesTable.$converterruleset.toSql(ruleset.value),
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (classId.present) {
      map['class_id'] = Variable<String>(classId.value);
    }
    if (subclassId.present) {
      map['subclass_id'] = Variable<String>(subclassId.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrdFeaturesCompanion(')
          ..write('id: $id, ')
          ..write('srdIndex: $srdIndex, ')
          ..write('ruleset: $ruleset, ')
          ..write('name: $name, ')
          ..write('classId: $classId, ')
          ..write('subclassId: $subclassId, ')
          ..write('level: $level, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $SrdFeatsTable extends SrdFeats with TableInfo<$SrdFeatsTable, SrdFeat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrdFeatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RulesetVersion, String> ruleset =
      GeneratedColumn<String>(
        'ruleset',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RulesetVersion>($SrdFeatsTable.$converterruleset);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repeatableMeta = const VerificationMeta(
    'repeatable',
  );
  @override
  late final GeneratedColumn<bool> repeatable = GeneratedColumn<bool>(
    'repeatable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("repeatable" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ruleset,
    name,
    description,
    type,
    repeatable,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srd_feats';
  @override
  VerificationContext validateIntegrity(
    Insertable<SrdFeat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('repeatable')) {
      context.handle(
        _repeatableMeta,
        repeatable.isAcceptableOrUnknown(data['repeatable']!, _repeatableMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, ruleset};
  @override
  SrdFeat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrdFeat(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ruleset: $SrdFeatsTable.$converterruleset.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}ruleset'],
        )!,
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      repeatable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}repeatable'],
      )!,
    );
  }

  @override
  $SrdFeatsTable createAlias(String alias) {
    return $SrdFeatsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RulesetVersion, String, String> $converterruleset =
      const EnumNameConverter<RulesetVersion>(RulesetVersion.values);
}

class SrdFeat extends DataClass implements Insertable<SrdFeat> {
  final String id;
  final RulesetVersion ruleset;
  final String name;
  final String description;
  final String type;
  final bool repeatable;
  const SrdFeat({
    required this.id,
    required this.ruleset,
    required this.name,
    required this.description,
    required this.type,
    required this.repeatable,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['ruleset'] = Variable<String>(
        $SrdFeatsTable.$converterruleset.toSql(ruleset),
      );
    }
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['type'] = Variable<String>(type);
    map['repeatable'] = Variable<bool>(repeatable);
    return map;
  }

  SrdFeatsCompanion toCompanion(bool nullToAbsent) {
    return SrdFeatsCompanion(
      id: Value(id),
      ruleset: Value(ruleset),
      name: Value(name),
      description: Value(description),
      type: Value(type),
      repeatable: Value(repeatable),
    );
  }

  factory SrdFeat.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrdFeat(
      id: serializer.fromJson<String>(json['id']),
      ruleset: $SrdFeatsTable.$converterruleset.fromJson(
        serializer.fromJson<String>(json['ruleset']),
      ),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      type: serializer.fromJson<String>(json['type']),
      repeatable: serializer.fromJson<bool>(json['repeatable']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ruleset': serializer.toJson<String>(
        $SrdFeatsTable.$converterruleset.toJson(ruleset),
      ),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'type': serializer.toJson<String>(type),
      'repeatable': serializer.toJson<bool>(repeatable),
    };
  }

  SrdFeat copyWith({
    String? id,
    RulesetVersion? ruleset,
    String? name,
    String? description,
    String? type,
    bool? repeatable,
  }) => SrdFeat(
    id: id ?? this.id,
    ruleset: ruleset ?? this.ruleset,
    name: name ?? this.name,
    description: description ?? this.description,
    type: type ?? this.type,
    repeatable: repeatable ?? this.repeatable,
  );
  SrdFeat copyWithCompanion(SrdFeatsCompanion data) {
    return SrdFeat(
      id: data.id.present ? data.id.value : this.id,
      ruleset: data.ruleset.present ? data.ruleset.value : this.ruleset,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      type: data.type.present ? data.type.value : this.type,
      repeatable: data.repeatable.present
          ? data.repeatable.value
          : this.repeatable,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrdFeat(')
          ..write('id: $id, ')
          ..write('ruleset: $ruleset, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('repeatable: $repeatable')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ruleset, name, description, type, repeatable);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrdFeat &&
          other.id == this.id &&
          other.ruleset == this.ruleset &&
          other.name == this.name &&
          other.description == this.description &&
          other.type == this.type &&
          other.repeatable == this.repeatable);
}

class SrdFeatsCompanion extends UpdateCompanion<SrdFeat> {
  final Value<String> id;
  final Value<RulesetVersion> ruleset;
  final Value<String> name;
  final Value<String> description;
  final Value<String> type;
  final Value<bool> repeatable;
  final Value<int> rowid;
  const SrdFeatsCompanion({
    this.id = const Value.absent(),
    this.ruleset = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.repeatable = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SrdFeatsCompanion.insert({
    required String id,
    required RulesetVersion ruleset,
    required String name,
    required String description,
    required String type,
    this.repeatable = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ruleset = Value(ruleset),
       name = Value(name),
       description = Value(description),
       type = Value(type);
  static Insertable<SrdFeat> custom({
    Expression<String>? id,
    Expression<String>? ruleset,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? type,
    Expression<bool>? repeatable,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ruleset != null) 'ruleset': ruleset,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (repeatable != null) 'repeatable': repeatable,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SrdFeatsCompanion copyWith({
    Value<String>? id,
    Value<RulesetVersion>? ruleset,
    Value<String>? name,
    Value<String>? description,
    Value<String>? type,
    Value<bool>? repeatable,
    Value<int>? rowid,
  }) {
    return SrdFeatsCompanion(
      id: id ?? this.id,
      ruleset: ruleset ?? this.ruleset,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      repeatable: repeatable ?? this.repeatable,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ruleset.present) {
      map['ruleset'] = Variable<String>(
        $SrdFeatsTable.$converterruleset.toSql(ruleset.value),
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (repeatable.present) {
      map['repeatable'] = Variable<bool>(repeatable.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrdFeatsCompanion(')
          ..write('id: $id, ')
          ..write('ruleset: $ruleset, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('repeatable: $repeatable, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SrdWeaponMasteriesTable extends SrdWeaponMasteries
    with TableInfo<$SrdWeaponMasteriesTable, SrdWeaponMastery> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrdWeaponMasteriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srd_weapon_masteries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SrdWeaponMastery> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SrdWeaponMastery map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrdWeaponMastery(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
    );
  }

  @override
  $SrdWeaponMasteriesTable createAlias(String alias) {
    return $SrdWeaponMasteriesTable(attachedDatabase, alias);
  }
}

class SrdWeaponMastery extends DataClass
    implements Insertable<SrdWeaponMastery> {
  final String id;
  final String name;
  final String description;
  const SrdWeaponMastery({
    required this.id,
    required this.name,
    required this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    return map;
  }

  SrdWeaponMasteriesCompanion toCompanion(bool nullToAbsent) {
    return SrdWeaponMasteriesCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
    );
  }

  factory SrdWeaponMastery.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrdWeaponMastery(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
    };
  }

  SrdWeaponMastery copyWith({String? id, String? name, String? description}) =>
      SrdWeaponMastery(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
      );
  SrdWeaponMastery copyWithCompanion(SrdWeaponMasteriesCompanion data) {
    return SrdWeaponMastery(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrdWeaponMastery(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrdWeaponMastery &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description);
}

class SrdWeaponMasteriesCompanion extends UpdateCompanion<SrdWeaponMastery> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<int> rowid;
  const SrdWeaponMasteriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SrdWeaponMasteriesCompanion.insert({
    required String id,
    required String name,
    required String description,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       description = Value(description);
  static Insertable<SrdWeaponMastery> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SrdWeaponMasteriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? description,
    Value<int>? rowid,
  }) {
    return SrdWeaponMasteriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrdWeaponMasteriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BatmanProfilesTable extends BatmanProfiles
    with TableInfo<$BatmanProfilesTable, BatmanProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BatmanProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hitDieMeta = const VerificationMeta('hitDie');
  @override
  late final GeneratedColumn<String> hitDie = GeneratedColumn<String>(
    'hit_die',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atcBonusMeta = const VerificationMeta(
    'atcBonus',
  );
  @override
  late final GeneratedColumn<int> atcBonus = GeneratedColumn<int>(
    'atc_bonus',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _atdBonusMeta = const VerificationMeta(
    'atdBonus',
  );
  @override
  late final GeneratedColumn<int> atdBonus = GeneratedColumn<int>(
    'atd_bonus',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _atsBonusMeta = const VerificationMeta(
    'atsBonus',
  );
  @override
  late final GeneratedColumn<int> atsBonus = GeneratedColumn<int>(
    'ats_bonus',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _exploitPointsMeta = const VerificationMeta(
    'exploitPoints',
  );
  @override
  late final GeneratedColumn<int> exploitPoints = GeneratedColumn<int>(
    'exploit_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _capabilityPointsMeta = const VerificationMeta(
    'capabilityPoints',
  );
  @override
  late final GeneratedColumn<int> capabilityPoints = GeneratedColumn<int>(
    'capability_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _primaryAbilityWithEdgeMeta =
      const VerificationMeta('primaryAbilityWithEdge');
  @override
  late final GeneratedColumn<String> primaryAbilityWithEdge =
      GeneratedColumn<String>(
        'primary_ability_with_edge',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _initialWaysMeta = const VerificationMeta(
    'initialWays',
  );
  @override
  late final GeneratedColumn<String> initialWays = GeneratedColumn<String>(
    'initial_ways',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extraWaysMeta = const VerificationMeta(
    'extraWays',
  );
  @override
  late final GeneratedColumn<int> extraWays = GeneratedColumn<int>(
    'extra_ways',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _extraWaysPoolMeta = const VerificationMeta(
    'extraWaysPool',
  );
  @override
  late final GeneratedColumn<String> extraWaysPool = GeneratedColumn<String>(
    'extra_ways_pool',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _livingStandardMeta = const VerificationMeta(
    'livingStandard',
  );
  @override
  late final GeneratedColumn<String> livingStandard = GeneratedColumn<String>(
    'living_standard',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    mode,
    hitDie,
    atcBonus,
    atdBonus,
    atsBonus,
    exploitPoints,
    capabilityPoints,
    primaryAbilityWithEdge,
    initialWays,
    extraWays,
    extraWaysPool,
    livingStandard,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'batman_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<BatmanProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('hit_die')) {
      context.handle(
        _hitDieMeta,
        hitDie.isAcceptableOrUnknown(data['hit_die']!, _hitDieMeta),
      );
    } else if (isInserting) {
      context.missing(_hitDieMeta);
    }
    if (data.containsKey('atc_bonus')) {
      context.handle(
        _atcBonusMeta,
        atcBonus.isAcceptableOrUnknown(data['atc_bonus']!, _atcBonusMeta),
      );
    }
    if (data.containsKey('atd_bonus')) {
      context.handle(
        _atdBonusMeta,
        atdBonus.isAcceptableOrUnknown(data['atd_bonus']!, _atdBonusMeta),
      );
    }
    if (data.containsKey('ats_bonus')) {
      context.handle(
        _atsBonusMeta,
        atsBonus.isAcceptableOrUnknown(data['ats_bonus']!, _atsBonusMeta),
      );
    }
    if (data.containsKey('exploit_points')) {
      context.handle(
        _exploitPointsMeta,
        exploitPoints.isAcceptableOrUnknown(
          data['exploit_points']!,
          _exploitPointsMeta,
        ),
      );
    }
    if (data.containsKey('capability_points')) {
      context.handle(
        _capabilityPointsMeta,
        capabilityPoints.isAcceptableOrUnknown(
          data['capability_points']!,
          _capabilityPointsMeta,
        ),
      );
    }
    if (data.containsKey('primary_ability_with_edge')) {
      context.handle(
        _primaryAbilityWithEdgeMeta,
        primaryAbilityWithEdge.isAcceptableOrUnknown(
          data['primary_ability_with_edge']!,
          _primaryAbilityWithEdgeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_primaryAbilityWithEdgeMeta);
    }
    if (data.containsKey('initial_ways')) {
      context.handle(
        _initialWaysMeta,
        initialWays.isAcceptableOrUnknown(
          data['initial_ways']!,
          _initialWaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_initialWaysMeta);
    }
    if (data.containsKey('extra_ways')) {
      context.handle(
        _extraWaysMeta,
        extraWays.isAcceptableOrUnknown(data['extra_ways']!, _extraWaysMeta),
      );
    }
    if (data.containsKey('extra_ways_pool')) {
      context.handle(
        _extraWaysPoolMeta,
        extraWaysPool.isAcceptableOrUnknown(
          data['extra_ways_pool']!,
          _extraWaysPoolMeta,
        ),
      );
    }
    if (data.containsKey('living_standard')) {
      context.handle(
        _livingStandardMeta,
        livingStandard.isAcceptableOrUnknown(
          data['living_standard']!,
          _livingStandardMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_livingStandardMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BatmanProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BatmanProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      hitDie: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hit_die'],
      )!,
      atcBonus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}atc_bonus'],
      )!,
      atdBonus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}atd_bonus'],
      )!,
      atsBonus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ats_bonus'],
      )!,
      exploitPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exploit_points'],
      )!,
      capabilityPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}capability_points'],
      )!,
      primaryAbilityWithEdge: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_ability_with_edge'],
      )!,
      initialWays: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}initial_ways'],
      )!,
      extraWays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}extra_ways'],
      )!,
      extraWaysPool: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extra_ways_pool'],
      ),
      livingStandard: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}living_standard'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
    );
  }

  @override
  $BatmanProfilesTable createAlias(String alias) {
    return $BatmanProfilesTable(attachedDatabase, alias);
  }
}

class BatmanProfile extends DataClass implements Insertable<BatmanProfile> {
  final String id;
  final String name;
  final String mode;
  final String hitDie;
  final int atcBonus;
  final int atdBonus;
  final int atsBonus;
  final int exploitPoints;
  final int capabilityPoints;
  final String primaryAbilityWithEdge;
  final String initialWays;
  final int extraWays;
  final String? extraWaysPool;
  final String livingStandard;
  final String description;
  const BatmanProfile({
    required this.id,
    required this.name,
    required this.mode,
    required this.hitDie,
    required this.atcBonus,
    required this.atdBonus,
    required this.atsBonus,
    required this.exploitPoints,
    required this.capabilityPoints,
    required this.primaryAbilityWithEdge,
    required this.initialWays,
    required this.extraWays,
    this.extraWaysPool,
    required this.livingStandard,
    required this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['mode'] = Variable<String>(mode);
    map['hit_die'] = Variable<String>(hitDie);
    map['atc_bonus'] = Variable<int>(atcBonus);
    map['atd_bonus'] = Variable<int>(atdBonus);
    map['ats_bonus'] = Variable<int>(atsBonus);
    map['exploit_points'] = Variable<int>(exploitPoints);
    map['capability_points'] = Variable<int>(capabilityPoints);
    map['primary_ability_with_edge'] = Variable<String>(primaryAbilityWithEdge);
    map['initial_ways'] = Variable<String>(initialWays);
    map['extra_ways'] = Variable<int>(extraWays);
    if (!nullToAbsent || extraWaysPool != null) {
      map['extra_ways_pool'] = Variable<String>(extraWaysPool);
    }
    map['living_standard'] = Variable<String>(livingStandard);
    map['description'] = Variable<String>(description);
    return map;
  }

  BatmanProfilesCompanion toCompanion(bool nullToAbsent) {
    return BatmanProfilesCompanion(
      id: Value(id),
      name: Value(name),
      mode: Value(mode),
      hitDie: Value(hitDie),
      atcBonus: Value(atcBonus),
      atdBonus: Value(atdBonus),
      atsBonus: Value(atsBonus),
      exploitPoints: Value(exploitPoints),
      capabilityPoints: Value(capabilityPoints),
      primaryAbilityWithEdge: Value(primaryAbilityWithEdge),
      initialWays: Value(initialWays),
      extraWays: Value(extraWays),
      extraWaysPool: extraWaysPool == null && nullToAbsent
          ? const Value.absent()
          : Value(extraWaysPool),
      livingStandard: Value(livingStandard),
      description: Value(description),
    );
  }

  factory BatmanProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BatmanProfile(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      mode: serializer.fromJson<String>(json['mode']),
      hitDie: serializer.fromJson<String>(json['hitDie']),
      atcBonus: serializer.fromJson<int>(json['atcBonus']),
      atdBonus: serializer.fromJson<int>(json['atdBonus']),
      atsBonus: serializer.fromJson<int>(json['atsBonus']),
      exploitPoints: serializer.fromJson<int>(json['exploitPoints']),
      capabilityPoints: serializer.fromJson<int>(json['capabilityPoints']),
      primaryAbilityWithEdge: serializer.fromJson<String>(
        json['primaryAbilityWithEdge'],
      ),
      initialWays: serializer.fromJson<String>(json['initialWays']),
      extraWays: serializer.fromJson<int>(json['extraWays']),
      extraWaysPool: serializer.fromJson<String?>(json['extraWaysPool']),
      livingStandard: serializer.fromJson<String>(json['livingStandard']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'mode': serializer.toJson<String>(mode),
      'hitDie': serializer.toJson<String>(hitDie),
      'atcBonus': serializer.toJson<int>(atcBonus),
      'atdBonus': serializer.toJson<int>(atdBonus),
      'atsBonus': serializer.toJson<int>(atsBonus),
      'exploitPoints': serializer.toJson<int>(exploitPoints),
      'capabilityPoints': serializer.toJson<int>(capabilityPoints),
      'primaryAbilityWithEdge': serializer.toJson<String>(
        primaryAbilityWithEdge,
      ),
      'initialWays': serializer.toJson<String>(initialWays),
      'extraWays': serializer.toJson<int>(extraWays),
      'extraWaysPool': serializer.toJson<String?>(extraWaysPool),
      'livingStandard': serializer.toJson<String>(livingStandard),
      'description': serializer.toJson<String>(description),
    };
  }

  BatmanProfile copyWith({
    String? id,
    String? name,
    String? mode,
    String? hitDie,
    int? atcBonus,
    int? atdBonus,
    int? atsBonus,
    int? exploitPoints,
    int? capabilityPoints,
    String? primaryAbilityWithEdge,
    String? initialWays,
    int? extraWays,
    Value<String?> extraWaysPool = const Value.absent(),
    String? livingStandard,
    String? description,
  }) => BatmanProfile(
    id: id ?? this.id,
    name: name ?? this.name,
    mode: mode ?? this.mode,
    hitDie: hitDie ?? this.hitDie,
    atcBonus: atcBonus ?? this.atcBonus,
    atdBonus: atdBonus ?? this.atdBonus,
    atsBonus: atsBonus ?? this.atsBonus,
    exploitPoints: exploitPoints ?? this.exploitPoints,
    capabilityPoints: capabilityPoints ?? this.capabilityPoints,
    primaryAbilityWithEdge:
        primaryAbilityWithEdge ?? this.primaryAbilityWithEdge,
    initialWays: initialWays ?? this.initialWays,
    extraWays: extraWays ?? this.extraWays,
    extraWaysPool: extraWaysPool.present
        ? extraWaysPool.value
        : this.extraWaysPool,
    livingStandard: livingStandard ?? this.livingStandard,
    description: description ?? this.description,
  );
  BatmanProfile copyWithCompanion(BatmanProfilesCompanion data) {
    return BatmanProfile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      mode: data.mode.present ? data.mode.value : this.mode,
      hitDie: data.hitDie.present ? data.hitDie.value : this.hitDie,
      atcBonus: data.atcBonus.present ? data.atcBonus.value : this.atcBonus,
      atdBonus: data.atdBonus.present ? data.atdBonus.value : this.atdBonus,
      atsBonus: data.atsBonus.present ? data.atsBonus.value : this.atsBonus,
      exploitPoints: data.exploitPoints.present
          ? data.exploitPoints.value
          : this.exploitPoints,
      capabilityPoints: data.capabilityPoints.present
          ? data.capabilityPoints.value
          : this.capabilityPoints,
      primaryAbilityWithEdge: data.primaryAbilityWithEdge.present
          ? data.primaryAbilityWithEdge.value
          : this.primaryAbilityWithEdge,
      initialWays: data.initialWays.present
          ? data.initialWays.value
          : this.initialWays,
      extraWays: data.extraWays.present ? data.extraWays.value : this.extraWays,
      extraWaysPool: data.extraWaysPool.present
          ? data.extraWaysPool.value
          : this.extraWaysPool,
      livingStandard: data.livingStandard.present
          ? data.livingStandard.value
          : this.livingStandard,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BatmanProfile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mode: $mode, ')
          ..write('hitDie: $hitDie, ')
          ..write('atcBonus: $atcBonus, ')
          ..write('atdBonus: $atdBonus, ')
          ..write('atsBonus: $atsBonus, ')
          ..write('exploitPoints: $exploitPoints, ')
          ..write('capabilityPoints: $capabilityPoints, ')
          ..write('primaryAbilityWithEdge: $primaryAbilityWithEdge, ')
          ..write('initialWays: $initialWays, ')
          ..write('extraWays: $extraWays, ')
          ..write('extraWaysPool: $extraWaysPool, ')
          ..write('livingStandard: $livingStandard, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    mode,
    hitDie,
    atcBonus,
    atdBonus,
    atsBonus,
    exploitPoints,
    capabilityPoints,
    primaryAbilityWithEdge,
    initialWays,
    extraWays,
    extraWaysPool,
    livingStandard,
    description,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BatmanProfile &&
          other.id == this.id &&
          other.name == this.name &&
          other.mode == this.mode &&
          other.hitDie == this.hitDie &&
          other.atcBonus == this.atcBonus &&
          other.atdBonus == this.atdBonus &&
          other.atsBonus == this.atsBonus &&
          other.exploitPoints == this.exploitPoints &&
          other.capabilityPoints == this.capabilityPoints &&
          other.primaryAbilityWithEdge == this.primaryAbilityWithEdge &&
          other.initialWays == this.initialWays &&
          other.extraWays == this.extraWays &&
          other.extraWaysPool == this.extraWaysPool &&
          other.livingStandard == this.livingStandard &&
          other.description == this.description);
}

class BatmanProfilesCompanion extends UpdateCompanion<BatmanProfile> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> mode;
  final Value<String> hitDie;
  final Value<int> atcBonus;
  final Value<int> atdBonus;
  final Value<int> atsBonus;
  final Value<int> exploitPoints;
  final Value<int> capabilityPoints;
  final Value<String> primaryAbilityWithEdge;
  final Value<String> initialWays;
  final Value<int> extraWays;
  final Value<String?> extraWaysPool;
  final Value<String> livingStandard;
  final Value<String> description;
  final Value<int> rowid;
  const BatmanProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.mode = const Value.absent(),
    this.hitDie = const Value.absent(),
    this.atcBonus = const Value.absent(),
    this.atdBonus = const Value.absent(),
    this.atsBonus = const Value.absent(),
    this.exploitPoints = const Value.absent(),
    this.capabilityPoints = const Value.absent(),
    this.primaryAbilityWithEdge = const Value.absent(),
    this.initialWays = const Value.absent(),
    this.extraWays = const Value.absent(),
    this.extraWaysPool = const Value.absent(),
    this.livingStandard = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BatmanProfilesCompanion.insert({
    required String id,
    required String name,
    required String mode,
    required String hitDie,
    this.atcBonus = const Value.absent(),
    this.atdBonus = const Value.absent(),
    this.atsBonus = const Value.absent(),
    this.exploitPoints = const Value.absent(),
    this.capabilityPoints = const Value.absent(),
    required String primaryAbilityWithEdge,
    required String initialWays,
    this.extraWays = const Value.absent(),
    this.extraWaysPool = const Value.absent(),
    required String livingStandard,
    required String description,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       mode = Value(mode),
       hitDie = Value(hitDie),
       primaryAbilityWithEdge = Value(primaryAbilityWithEdge),
       initialWays = Value(initialWays),
       livingStandard = Value(livingStandard),
       description = Value(description);
  static Insertable<BatmanProfile> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? mode,
    Expression<String>? hitDie,
    Expression<int>? atcBonus,
    Expression<int>? atdBonus,
    Expression<int>? atsBonus,
    Expression<int>? exploitPoints,
    Expression<int>? capabilityPoints,
    Expression<String>? primaryAbilityWithEdge,
    Expression<String>? initialWays,
    Expression<int>? extraWays,
    Expression<String>? extraWaysPool,
    Expression<String>? livingStandard,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (mode != null) 'mode': mode,
      if (hitDie != null) 'hit_die': hitDie,
      if (atcBonus != null) 'atc_bonus': atcBonus,
      if (atdBonus != null) 'atd_bonus': atdBonus,
      if (atsBonus != null) 'ats_bonus': atsBonus,
      if (exploitPoints != null) 'exploit_points': exploitPoints,
      if (capabilityPoints != null) 'capability_points': capabilityPoints,
      if (primaryAbilityWithEdge != null)
        'primary_ability_with_edge': primaryAbilityWithEdge,
      if (initialWays != null) 'initial_ways': initialWays,
      if (extraWays != null) 'extra_ways': extraWays,
      if (extraWaysPool != null) 'extra_ways_pool': extraWaysPool,
      if (livingStandard != null) 'living_standard': livingStandard,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BatmanProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? mode,
    Value<String>? hitDie,
    Value<int>? atcBonus,
    Value<int>? atdBonus,
    Value<int>? atsBonus,
    Value<int>? exploitPoints,
    Value<int>? capabilityPoints,
    Value<String>? primaryAbilityWithEdge,
    Value<String>? initialWays,
    Value<int>? extraWays,
    Value<String?>? extraWaysPool,
    Value<String>? livingStandard,
    Value<String>? description,
    Value<int>? rowid,
  }) {
    return BatmanProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      mode: mode ?? this.mode,
      hitDie: hitDie ?? this.hitDie,
      atcBonus: atcBonus ?? this.atcBonus,
      atdBonus: atdBonus ?? this.atdBonus,
      atsBonus: atsBonus ?? this.atsBonus,
      exploitPoints: exploitPoints ?? this.exploitPoints,
      capabilityPoints: capabilityPoints ?? this.capabilityPoints,
      primaryAbilityWithEdge:
          primaryAbilityWithEdge ?? this.primaryAbilityWithEdge,
      initialWays: initialWays ?? this.initialWays,
      extraWays: extraWays ?? this.extraWays,
      extraWaysPool: extraWaysPool ?? this.extraWaysPool,
      livingStandard: livingStandard ?? this.livingStandard,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (hitDie.present) {
      map['hit_die'] = Variable<String>(hitDie.value);
    }
    if (atcBonus.present) {
      map['atc_bonus'] = Variable<int>(atcBonus.value);
    }
    if (atdBonus.present) {
      map['atd_bonus'] = Variable<int>(atdBonus.value);
    }
    if (atsBonus.present) {
      map['ats_bonus'] = Variable<int>(atsBonus.value);
    }
    if (exploitPoints.present) {
      map['exploit_points'] = Variable<int>(exploitPoints.value);
    }
    if (capabilityPoints.present) {
      map['capability_points'] = Variable<int>(capabilityPoints.value);
    }
    if (primaryAbilityWithEdge.present) {
      map['primary_ability_with_edge'] = Variable<String>(
        primaryAbilityWithEdge.value,
      );
    }
    if (initialWays.present) {
      map['initial_ways'] = Variable<String>(initialWays.value);
    }
    if (extraWays.present) {
      map['extra_ways'] = Variable<int>(extraWays.value);
    }
    if (extraWaysPool.present) {
      map['extra_ways_pool'] = Variable<String>(extraWaysPool.value);
    }
    if (livingStandard.present) {
      map['living_standard'] = Variable<String>(livingStandard.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BatmanProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mode: $mode, ')
          ..write('hitDie: $hitDie, ')
          ..write('atcBonus: $atcBonus, ')
          ..write('atdBonus: $atdBonus, ')
          ..write('atsBonus: $atsBonus, ')
          ..write('exploitPoints: $exploitPoints, ')
          ..write('capabilityPoints: $capabilityPoints, ')
          ..write('primaryAbilityWithEdge: $primaryAbilityWithEdge, ')
          ..write('initialWays: $initialWays, ')
          ..write('extraWays: $extraWays, ')
          ..write('extraWaysPool: $extraWaysPool, ')
          ..write('livingStandard: $livingStandard, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BatmanWaysTable extends BatmanWays
    with TableInfo<$BatmanWaysTable, BatmanWay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BatmanWaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prerequisiteMeta = const VerificationMeta(
    'prerequisite',
  );
  @override
  late final GeneratedColumn<String> prerequisite = GeneratedColumn<String>(
    'prerequisite',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ranksJsonMeta = const VerificationMeta(
    'ranksJson',
  );
  @override
  late final GeneratedColumn<String> ranksJson = GeneratedColumn<String>(
    'ranks_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    prerequisite,
    ranksJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'batman_ways';
  @override
  VerificationContext validateIntegrity(
    Insertable<BatmanWay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('prerequisite')) {
      context.handle(
        _prerequisiteMeta,
        prerequisite.isAcceptableOrUnknown(
          data['prerequisite']!,
          _prerequisiteMeta,
        ),
      );
    }
    if (data.containsKey('ranks_json')) {
      context.handle(
        _ranksJsonMeta,
        ranksJson.isAcceptableOrUnknown(data['ranks_json']!, _ranksJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_ranksJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BatmanWay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BatmanWay(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      prerequisite: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prerequisite'],
      ),
      ranksJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ranks_json'],
      )!,
    );
  }

  @override
  $BatmanWaysTable createAlias(String alias) {
    return $BatmanWaysTable(attachedDatabase, alias);
  }
}

class BatmanWay extends DataClass implements Insertable<BatmanWay> {
  final String id;
  final String name;
  final String type;
  final String? prerequisite;
  final String ranksJson;
  const BatmanWay({
    required this.id,
    required this.name,
    required this.type,
    this.prerequisite,
    required this.ranksJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || prerequisite != null) {
      map['prerequisite'] = Variable<String>(prerequisite);
    }
    map['ranks_json'] = Variable<String>(ranksJson);
    return map;
  }

  BatmanWaysCompanion toCompanion(bool nullToAbsent) {
    return BatmanWaysCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      prerequisite: prerequisite == null && nullToAbsent
          ? const Value.absent()
          : Value(prerequisite),
      ranksJson: Value(ranksJson),
    );
  }

  factory BatmanWay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BatmanWay(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      prerequisite: serializer.fromJson<String?>(json['prerequisite']),
      ranksJson: serializer.fromJson<String>(json['ranksJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'prerequisite': serializer.toJson<String?>(prerequisite),
      'ranksJson': serializer.toJson<String>(ranksJson),
    };
  }

  BatmanWay copyWith({
    String? id,
    String? name,
    String? type,
    Value<String?> prerequisite = const Value.absent(),
    String? ranksJson,
  }) => BatmanWay(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    prerequisite: prerequisite.present ? prerequisite.value : this.prerequisite,
    ranksJson: ranksJson ?? this.ranksJson,
  );
  BatmanWay copyWithCompanion(BatmanWaysCompanion data) {
    return BatmanWay(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      prerequisite: data.prerequisite.present
          ? data.prerequisite.value
          : this.prerequisite,
      ranksJson: data.ranksJson.present ? data.ranksJson.value : this.ranksJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BatmanWay(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('prerequisite: $prerequisite, ')
          ..write('ranksJson: $ranksJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, prerequisite, ranksJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BatmanWay &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.prerequisite == this.prerequisite &&
          other.ranksJson == this.ranksJson);
}

class BatmanWaysCompanion extends UpdateCompanion<BatmanWay> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String?> prerequisite;
  final Value<String> ranksJson;
  final Value<int> rowid;
  const BatmanWaysCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.prerequisite = const Value.absent(),
    this.ranksJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BatmanWaysCompanion.insert({
    required String id,
    required String name,
    required String type,
    this.prerequisite = const Value.absent(),
    required String ranksJson,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       ranksJson = Value(ranksJson);
  static Insertable<BatmanWay> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? prerequisite,
    Expression<String>? ranksJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (prerequisite != null) 'prerequisite': prerequisite,
      if (ranksJson != null) 'ranks_json': ranksJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BatmanWaysCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? type,
    Value<String?>? prerequisite,
    Value<String>? ranksJson,
    Value<int>? rowid,
  }) {
    return BatmanWaysCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      prerequisite: prerequisite ?? this.prerequisite,
      ranksJson: ranksJson ?? this.ranksJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (prerequisite.present) {
      map['prerequisite'] = Variable<String>(prerequisite.value);
    }
    if (ranksJson.present) {
      map['ranks_json'] = Variable<String>(ranksJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BatmanWaysCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('prerequisite: $prerequisite, ')
          ..write('ranksJson: $ranksJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CharactersTable extends Characters
    with TableInfo<$CharactersTable, Character> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharactersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _playerNameMeta = const VerificationMeta(
    'playerName',
  );
  @override
  late final GeneratedColumn<String> playerName = GeneratedColumn<String>(
    'player_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<RulesetVersion, String> ruleset =
      GeneratedColumn<String>(
        'ruleset',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RulesetVersion>($CharactersTable.$converterruleset);
  static const VerificationMeta _alignmentMeta = const VerificationMeta(
    'alignment',
  );
  @override
  late final GeneratedColumn<String> alignment = GeneratedColumn<String>(
    'alignment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _xpMeta = const VerificationMeta('xp');
  @override
  late final GeneratedColumn<int> xp = GeneratedColumn<int>(
    'xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _speciesIdMeta = const VerificationMeta(
    'speciesId',
  );
  @override
  late final GeneratedColumn<String> speciesId = GeneratedColumn<String>(
    'species_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subspeciesIdMeta = const VerificationMeta(
    'subspeciesId',
  );
  @override
  late final GeneratedColumn<String> subspeciesId = GeneratedColumn<String>(
    'subspecies_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _backgroundIdMeta = const VerificationMeta(
    'backgroundId',
  );
  @override
  late final GeneratedColumn<String> backgroundId = GeneratedColumn<String>(
    'background_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hpMaxMeta = const VerificationMeta('hpMax');
  @override
  late final GeneratedColumn<int> hpMax = GeneratedColumn<int>(
    'hp_max',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hpCurrentMeta = const VerificationMeta(
    'hpCurrent',
  );
  @override
  late final GeneratedColumn<int> hpCurrent = GeneratedColumn<int>(
    'hp_current',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hpTempMeta = const VerificationMeta('hpTemp');
  @override
  late final GeneratedColumn<int> hpTemp = GeneratedColumn<int>(
    'hp_temp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _armorClassMeta = const VerificationMeta(
    'armorClass',
  );
  @override
  late final GeneratedColumn<int> armorClass = GeneratedColumn<int>(
    'armor_class',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _speedMeta = const VerificationMeta('speed');
  @override
  late final GeneratedColumn<int> speed = GeneratedColumn<int>(
    'speed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _exhaustionLevelMeta = const VerificationMeta(
    'exhaustionLevel',
  );
  @override
  late final GeneratedColumn<int> exhaustionLevel = GeneratedColumn<int>(
    'exhaustion_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _heroicInspirationMeta = const VerificationMeta(
    'heroicInspiration',
  );
  @override
  late final GeneratedColumn<bool> heroicInspiration = GeneratedColumn<bool>(
    'heroic_inspiration',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("heroic_inspiration" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deathSaveSuccessesMeta =
      const VerificationMeta('deathSaveSuccesses');
  @override
  late final GeneratedColumn<int> deathSaveSuccesses = GeneratedColumn<int>(
    'death_save_successes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deathSaveFailuresMeta = const VerificationMeta(
    'deathSaveFailures',
  );
  @override
  late final GeneratedColumn<int> deathSaveFailures = GeneratedColumn<int>(
    'death_save_failures',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _personalityTraitsMeta = const VerificationMeta(
    'personalityTraits',
  );
  @override
  late final GeneratedColumn<String> personalityTraits =
      GeneratedColumn<String>(
        'personality_traits',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _idealsMeta = const VerificationMeta('ideals');
  @override
  late final GeneratedColumn<String> ideals = GeneratedColumn<String>(
    'ideals',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _bondsMeta = const VerificationMeta('bonds');
  @override
  late final GeneratedColumn<String> bonds = GeneratedColumn<String>(
    'bonds',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _flawsMeta = const VerificationMeta('flaws');
  @override
  late final GeneratedColumn<String> flaws = GeneratedColumn<String>(
    'flaws',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _backstoryMeta = const VerificationMeta(
    'backstory',
  );
  @override
  late final GeneratedColumn<String> backstory = GeneratedColumn<String>(
    'backstory',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _appearanceMeta = const VerificationMeta(
    'appearance',
  );
  @override
  late final GeneratedColumn<String> appearance = GeneratedColumn<String>(
    'appearance',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{"cp":0,"sp":0,"ep":0,"gp":0,"pp":0}'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    playerName,
    ruleset,
    alignment,
    xp,
    speciesId,
    subspeciesId,
    backgroundId,
    hpMax,
    hpCurrent,
    hpTemp,
    armorClass,
    speed,
    exhaustionLevel,
    heroicInspiration,
    deathSaveSuccesses,
    deathSaveFailures,
    personalityTraits,
    ideals,
    bonds,
    flaws,
    backstory,
    appearance,
    currency,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'characters';
  @override
  VerificationContext validateIntegrity(
    Insertable<Character> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('player_name')) {
      context.handle(
        _playerNameMeta,
        playerName.isAcceptableOrUnknown(data['player_name']!, _playerNameMeta),
      );
    }
    if (data.containsKey('alignment')) {
      context.handle(
        _alignmentMeta,
        alignment.isAcceptableOrUnknown(data['alignment']!, _alignmentMeta),
      );
    }
    if (data.containsKey('xp')) {
      context.handle(_xpMeta, xp.isAcceptableOrUnknown(data['xp']!, _xpMeta));
    }
    if (data.containsKey('species_id')) {
      context.handle(
        _speciesIdMeta,
        speciesId.isAcceptableOrUnknown(data['species_id']!, _speciesIdMeta),
      );
    }
    if (data.containsKey('subspecies_id')) {
      context.handle(
        _subspeciesIdMeta,
        subspeciesId.isAcceptableOrUnknown(
          data['subspecies_id']!,
          _subspeciesIdMeta,
        ),
      );
    }
    if (data.containsKey('background_id')) {
      context.handle(
        _backgroundIdMeta,
        backgroundId.isAcceptableOrUnknown(
          data['background_id']!,
          _backgroundIdMeta,
        ),
      );
    }
    if (data.containsKey('hp_max')) {
      context.handle(
        _hpMaxMeta,
        hpMax.isAcceptableOrUnknown(data['hp_max']!, _hpMaxMeta),
      );
    }
    if (data.containsKey('hp_current')) {
      context.handle(
        _hpCurrentMeta,
        hpCurrent.isAcceptableOrUnknown(data['hp_current']!, _hpCurrentMeta),
      );
    }
    if (data.containsKey('hp_temp')) {
      context.handle(
        _hpTempMeta,
        hpTemp.isAcceptableOrUnknown(data['hp_temp']!, _hpTempMeta),
      );
    }
    if (data.containsKey('armor_class')) {
      context.handle(
        _armorClassMeta,
        armorClass.isAcceptableOrUnknown(data['armor_class']!, _armorClassMeta),
      );
    }
    if (data.containsKey('speed')) {
      context.handle(
        _speedMeta,
        speed.isAcceptableOrUnknown(data['speed']!, _speedMeta),
      );
    }
    if (data.containsKey('exhaustion_level')) {
      context.handle(
        _exhaustionLevelMeta,
        exhaustionLevel.isAcceptableOrUnknown(
          data['exhaustion_level']!,
          _exhaustionLevelMeta,
        ),
      );
    }
    if (data.containsKey('heroic_inspiration')) {
      context.handle(
        _heroicInspirationMeta,
        heroicInspiration.isAcceptableOrUnknown(
          data['heroic_inspiration']!,
          _heroicInspirationMeta,
        ),
      );
    }
    if (data.containsKey('death_save_successes')) {
      context.handle(
        _deathSaveSuccessesMeta,
        deathSaveSuccesses.isAcceptableOrUnknown(
          data['death_save_successes']!,
          _deathSaveSuccessesMeta,
        ),
      );
    }
    if (data.containsKey('death_save_failures')) {
      context.handle(
        _deathSaveFailuresMeta,
        deathSaveFailures.isAcceptableOrUnknown(
          data['death_save_failures']!,
          _deathSaveFailuresMeta,
        ),
      );
    }
    if (data.containsKey('personality_traits')) {
      context.handle(
        _personalityTraitsMeta,
        personalityTraits.isAcceptableOrUnknown(
          data['personality_traits']!,
          _personalityTraitsMeta,
        ),
      );
    }
    if (data.containsKey('ideals')) {
      context.handle(
        _idealsMeta,
        ideals.isAcceptableOrUnknown(data['ideals']!, _idealsMeta),
      );
    }
    if (data.containsKey('bonds')) {
      context.handle(
        _bondsMeta,
        bonds.isAcceptableOrUnknown(data['bonds']!, _bondsMeta),
      );
    }
    if (data.containsKey('flaws')) {
      context.handle(
        _flawsMeta,
        flaws.isAcceptableOrUnknown(data['flaws']!, _flawsMeta),
      );
    }
    if (data.containsKey('backstory')) {
      context.handle(
        _backstoryMeta,
        backstory.isAcceptableOrUnknown(data['backstory']!, _backstoryMeta),
      );
    }
    if (data.containsKey('appearance')) {
      context.handle(
        _appearanceMeta,
        appearance.isAcceptableOrUnknown(data['appearance']!, _appearanceMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Character map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Character(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      playerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}player_name'],
      )!,
      ruleset: $CharactersTable.$converterruleset.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}ruleset'],
        )!,
      ),
      alignment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alignment'],
      )!,
      xp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp'],
      )!,
      speciesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}species_id'],
      ),
      subspeciesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subspecies_id'],
      ),
      backgroundId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}background_id'],
      ),
      hpMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hp_max'],
      )!,
      hpCurrent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hp_current'],
      )!,
      hpTemp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hp_temp'],
      )!,
      armorClass: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}armor_class'],
      )!,
      speed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}speed'],
      )!,
      exhaustionLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exhaustion_level'],
      )!,
      heroicInspiration: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}heroic_inspiration'],
      )!,
      deathSaveSuccesses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}death_save_successes'],
      )!,
      deathSaveFailures: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}death_save_failures'],
      )!,
      personalityTraits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}personality_traits'],
      )!,
      ideals: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ideals'],
      )!,
      bonds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bonds'],
      )!,
      flaws: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flaws'],
      )!,
      backstory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}backstory'],
      )!,
      appearance: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}appearance'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CharactersTable createAlias(String alias) {
    return $CharactersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RulesetVersion, String, String> $converterruleset =
      const EnumNameConverter<RulesetVersion>(RulesetVersion.values);
}

class Character extends DataClass implements Insertable<Character> {
  final int id;
  final String name;
  final String playerName;
  final RulesetVersion ruleset;
  final String alignment;
  final int xp;
  final String? speciesId;
  final String? subspeciesId;
  final String? backgroundId;
  final int hpMax;
  final int hpCurrent;
  final int hpTemp;
  final int armorClass;
  final int speed;
  final int exhaustionLevel;
  final bool heroicInspiration;
  final int deathSaveSuccesses;
  final int deathSaveFailures;
  final String personalityTraits;
  final String ideals;
  final String bonds;
  final String flaws;
  final String backstory;
  final String appearance;
  final String currency;
  final String createdAt;
  final String updatedAt;
  const Character({
    required this.id,
    required this.name,
    required this.playerName,
    required this.ruleset,
    required this.alignment,
    required this.xp,
    this.speciesId,
    this.subspeciesId,
    this.backgroundId,
    required this.hpMax,
    required this.hpCurrent,
    required this.hpTemp,
    required this.armorClass,
    required this.speed,
    required this.exhaustionLevel,
    required this.heroicInspiration,
    required this.deathSaveSuccesses,
    required this.deathSaveFailures,
    required this.personalityTraits,
    required this.ideals,
    required this.bonds,
    required this.flaws,
    required this.backstory,
    required this.appearance,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['player_name'] = Variable<String>(playerName);
    {
      map['ruleset'] = Variable<String>(
        $CharactersTable.$converterruleset.toSql(ruleset),
      );
    }
    map['alignment'] = Variable<String>(alignment);
    map['xp'] = Variable<int>(xp);
    if (!nullToAbsent || speciesId != null) {
      map['species_id'] = Variable<String>(speciesId);
    }
    if (!nullToAbsent || subspeciesId != null) {
      map['subspecies_id'] = Variable<String>(subspeciesId);
    }
    if (!nullToAbsent || backgroundId != null) {
      map['background_id'] = Variable<String>(backgroundId);
    }
    map['hp_max'] = Variable<int>(hpMax);
    map['hp_current'] = Variable<int>(hpCurrent);
    map['hp_temp'] = Variable<int>(hpTemp);
    map['armor_class'] = Variable<int>(armorClass);
    map['speed'] = Variable<int>(speed);
    map['exhaustion_level'] = Variable<int>(exhaustionLevel);
    map['heroic_inspiration'] = Variable<bool>(heroicInspiration);
    map['death_save_successes'] = Variable<int>(deathSaveSuccesses);
    map['death_save_failures'] = Variable<int>(deathSaveFailures);
    map['personality_traits'] = Variable<String>(personalityTraits);
    map['ideals'] = Variable<String>(ideals);
    map['bonds'] = Variable<String>(bonds);
    map['flaws'] = Variable<String>(flaws);
    map['backstory'] = Variable<String>(backstory);
    map['appearance'] = Variable<String>(appearance);
    map['currency'] = Variable<String>(currency);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  CharactersCompanion toCompanion(bool nullToAbsent) {
    return CharactersCompanion(
      id: Value(id),
      name: Value(name),
      playerName: Value(playerName),
      ruleset: Value(ruleset),
      alignment: Value(alignment),
      xp: Value(xp),
      speciesId: speciesId == null && nullToAbsent
          ? const Value.absent()
          : Value(speciesId),
      subspeciesId: subspeciesId == null && nullToAbsent
          ? const Value.absent()
          : Value(subspeciesId),
      backgroundId: backgroundId == null && nullToAbsent
          ? const Value.absent()
          : Value(backgroundId),
      hpMax: Value(hpMax),
      hpCurrent: Value(hpCurrent),
      hpTemp: Value(hpTemp),
      armorClass: Value(armorClass),
      speed: Value(speed),
      exhaustionLevel: Value(exhaustionLevel),
      heroicInspiration: Value(heroicInspiration),
      deathSaveSuccesses: Value(deathSaveSuccesses),
      deathSaveFailures: Value(deathSaveFailures),
      personalityTraits: Value(personalityTraits),
      ideals: Value(ideals),
      bonds: Value(bonds),
      flaws: Value(flaws),
      backstory: Value(backstory),
      appearance: Value(appearance),
      currency: Value(currency),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Character.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Character(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      playerName: serializer.fromJson<String>(json['playerName']),
      ruleset: $CharactersTable.$converterruleset.fromJson(
        serializer.fromJson<String>(json['ruleset']),
      ),
      alignment: serializer.fromJson<String>(json['alignment']),
      xp: serializer.fromJson<int>(json['xp']),
      speciesId: serializer.fromJson<String?>(json['speciesId']),
      subspeciesId: serializer.fromJson<String?>(json['subspeciesId']),
      backgroundId: serializer.fromJson<String?>(json['backgroundId']),
      hpMax: serializer.fromJson<int>(json['hpMax']),
      hpCurrent: serializer.fromJson<int>(json['hpCurrent']),
      hpTemp: serializer.fromJson<int>(json['hpTemp']),
      armorClass: serializer.fromJson<int>(json['armorClass']),
      speed: serializer.fromJson<int>(json['speed']),
      exhaustionLevel: serializer.fromJson<int>(json['exhaustionLevel']),
      heroicInspiration: serializer.fromJson<bool>(json['heroicInspiration']),
      deathSaveSuccesses: serializer.fromJson<int>(json['deathSaveSuccesses']),
      deathSaveFailures: serializer.fromJson<int>(json['deathSaveFailures']),
      personalityTraits: serializer.fromJson<String>(json['personalityTraits']),
      ideals: serializer.fromJson<String>(json['ideals']),
      bonds: serializer.fromJson<String>(json['bonds']),
      flaws: serializer.fromJson<String>(json['flaws']),
      backstory: serializer.fromJson<String>(json['backstory']),
      appearance: serializer.fromJson<String>(json['appearance']),
      currency: serializer.fromJson<String>(json['currency']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'playerName': serializer.toJson<String>(playerName),
      'ruleset': serializer.toJson<String>(
        $CharactersTable.$converterruleset.toJson(ruleset),
      ),
      'alignment': serializer.toJson<String>(alignment),
      'xp': serializer.toJson<int>(xp),
      'speciesId': serializer.toJson<String?>(speciesId),
      'subspeciesId': serializer.toJson<String?>(subspeciesId),
      'backgroundId': serializer.toJson<String?>(backgroundId),
      'hpMax': serializer.toJson<int>(hpMax),
      'hpCurrent': serializer.toJson<int>(hpCurrent),
      'hpTemp': serializer.toJson<int>(hpTemp),
      'armorClass': serializer.toJson<int>(armorClass),
      'speed': serializer.toJson<int>(speed),
      'exhaustionLevel': serializer.toJson<int>(exhaustionLevel),
      'heroicInspiration': serializer.toJson<bool>(heroicInspiration),
      'deathSaveSuccesses': serializer.toJson<int>(deathSaveSuccesses),
      'deathSaveFailures': serializer.toJson<int>(deathSaveFailures),
      'personalityTraits': serializer.toJson<String>(personalityTraits),
      'ideals': serializer.toJson<String>(ideals),
      'bonds': serializer.toJson<String>(bonds),
      'flaws': serializer.toJson<String>(flaws),
      'backstory': serializer.toJson<String>(backstory),
      'appearance': serializer.toJson<String>(appearance),
      'currency': serializer.toJson<String>(currency),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Character copyWith({
    int? id,
    String? name,
    String? playerName,
    RulesetVersion? ruleset,
    String? alignment,
    int? xp,
    Value<String?> speciesId = const Value.absent(),
    Value<String?> subspeciesId = const Value.absent(),
    Value<String?> backgroundId = const Value.absent(),
    int? hpMax,
    int? hpCurrent,
    int? hpTemp,
    int? armorClass,
    int? speed,
    int? exhaustionLevel,
    bool? heroicInspiration,
    int? deathSaveSuccesses,
    int? deathSaveFailures,
    String? personalityTraits,
    String? ideals,
    String? bonds,
    String? flaws,
    String? backstory,
    String? appearance,
    String? currency,
    String? createdAt,
    String? updatedAt,
  }) => Character(
    id: id ?? this.id,
    name: name ?? this.name,
    playerName: playerName ?? this.playerName,
    ruleset: ruleset ?? this.ruleset,
    alignment: alignment ?? this.alignment,
    xp: xp ?? this.xp,
    speciesId: speciesId.present ? speciesId.value : this.speciesId,
    subspeciesId: subspeciesId.present ? subspeciesId.value : this.subspeciesId,
    backgroundId: backgroundId.present ? backgroundId.value : this.backgroundId,
    hpMax: hpMax ?? this.hpMax,
    hpCurrent: hpCurrent ?? this.hpCurrent,
    hpTemp: hpTemp ?? this.hpTemp,
    armorClass: armorClass ?? this.armorClass,
    speed: speed ?? this.speed,
    exhaustionLevel: exhaustionLevel ?? this.exhaustionLevel,
    heroicInspiration: heroicInspiration ?? this.heroicInspiration,
    deathSaveSuccesses: deathSaveSuccesses ?? this.deathSaveSuccesses,
    deathSaveFailures: deathSaveFailures ?? this.deathSaveFailures,
    personalityTraits: personalityTraits ?? this.personalityTraits,
    ideals: ideals ?? this.ideals,
    bonds: bonds ?? this.bonds,
    flaws: flaws ?? this.flaws,
    backstory: backstory ?? this.backstory,
    appearance: appearance ?? this.appearance,
    currency: currency ?? this.currency,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Character copyWithCompanion(CharactersCompanion data) {
    return Character(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      playerName: data.playerName.present
          ? data.playerName.value
          : this.playerName,
      ruleset: data.ruleset.present ? data.ruleset.value : this.ruleset,
      alignment: data.alignment.present ? data.alignment.value : this.alignment,
      xp: data.xp.present ? data.xp.value : this.xp,
      speciesId: data.speciesId.present ? data.speciesId.value : this.speciesId,
      subspeciesId: data.subspeciesId.present
          ? data.subspeciesId.value
          : this.subspeciesId,
      backgroundId: data.backgroundId.present
          ? data.backgroundId.value
          : this.backgroundId,
      hpMax: data.hpMax.present ? data.hpMax.value : this.hpMax,
      hpCurrent: data.hpCurrent.present ? data.hpCurrent.value : this.hpCurrent,
      hpTemp: data.hpTemp.present ? data.hpTemp.value : this.hpTemp,
      armorClass: data.armorClass.present
          ? data.armorClass.value
          : this.armorClass,
      speed: data.speed.present ? data.speed.value : this.speed,
      exhaustionLevel: data.exhaustionLevel.present
          ? data.exhaustionLevel.value
          : this.exhaustionLevel,
      heroicInspiration: data.heroicInspiration.present
          ? data.heroicInspiration.value
          : this.heroicInspiration,
      deathSaveSuccesses: data.deathSaveSuccesses.present
          ? data.deathSaveSuccesses.value
          : this.deathSaveSuccesses,
      deathSaveFailures: data.deathSaveFailures.present
          ? data.deathSaveFailures.value
          : this.deathSaveFailures,
      personalityTraits: data.personalityTraits.present
          ? data.personalityTraits.value
          : this.personalityTraits,
      ideals: data.ideals.present ? data.ideals.value : this.ideals,
      bonds: data.bonds.present ? data.bonds.value : this.bonds,
      flaws: data.flaws.present ? data.flaws.value : this.flaws,
      backstory: data.backstory.present ? data.backstory.value : this.backstory,
      appearance: data.appearance.present
          ? data.appearance.value
          : this.appearance,
      currency: data.currency.present ? data.currency.value : this.currency,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Character(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('playerName: $playerName, ')
          ..write('ruleset: $ruleset, ')
          ..write('alignment: $alignment, ')
          ..write('xp: $xp, ')
          ..write('speciesId: $speciesId, ')
          ..write('subspeciesId: $subspeciesId, ')
          ..write('backgroundId: $backgroundId, ')
          ..write('hpMax: $hpMax, ')
          ..write('hpCurrent: $hpCurrent, ')
          ..write('hpTemp: $hpTemp, ')
          ..write('armorClass: $armorClass, ')
          ..write('speed: $speed, ')
          ..write('exhaustionLevel: $exhaustionLevel, ')
          ..write('heroicInspiration: $heroicInspiration, ')
          ..write('deathSaveSuccesses: $deathSaveSuccesses, ')
          ..write('deathSaveFailures: $deathSaveFailures, ')
          ..write('personalityTraits: $personalityTraits, ')
          ..write('ideals: $ideals, ')
          ..write('bonds: $bonds, ')
          ..write('flaws: $flaws, ')
          ..write('backstory: $backstory, ')
          ..write('appearance: $appearance, ')
          ..write('currency: $currency, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    playerName,
    ruleset,
    alignment,
    xp,
    speciesId,
    subspeciesId,
    backgroundId,
    hpMax,
    hpCurrent,
    hpTemp,
    armorClass,
    speed,
    exhaustionLevel,
    heroicInspiration,
    deathSaveSuccesses,
    deathSaveFailures,
    personalityTraits,
    ideals,
    bonds,
    flaws,
    backstory,
    appearance,
    currency,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Character &&
          other.id == this.id &&
          other.name == this.name &&
          other.playerName == this.playerName &&
          other.ruleset == this.ruleset &&
          other.alignment == this.alignment &&
          other.xp == this.xp &&
          other.speciesId == this.speciesId &&
          other.subspeciesId == this.subspeciesId &&
          other.backgroundId == this.backgroundId &&
          other.hpMax == this.hpMax &&
          other.hpCurrent == this.hpCurrent &&
          other.hpTemp == this.hpTemp &&
          other.armorClass == this.armorClass &&
          other.speed == this.speed &&
          other.exhaustionLevel == this.exhaustionLevel &&
          other.heroicInspiration == this.heroicInspiration &&
          other.deathSaveSuccesses == this.deathSaveSuccesses &&
          other.deathSaveFailures == this.deathSaveFailures &&
          other.personalityTraits == this.personalityTraits &&
          other.ideals == this.ideals &&
          other.bonds == this.bonds &&
          other.flaws == this.flaws &&
          other.backstory == this.backstory &&
          other.appearance == this.appearance &&
          other.currency == this.currency &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CharactersCompanion extends UpdateCompanion<Character> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> playerName;
  final Value<RulesetVersion> ruleset;
  final Value<String> alignment;
  final Value<int> xp;
  final Value<String?> speciesId;
  final Value<String?> subspeciesId;
  final Value<String?> backgroundId;
  final Value<int> hpMax;
  final Value<int> hpCurrent;
  final Value<int> hpTemp;
  final Value<int> armorClass;
  final Value<int> speed;
  final Value<int> exhaustionLevel;
  final Value<bool> heroicInspiration;
  final Value<int> deathSaveSuccesses;
  final Value<int> deathSaveFailures;
  final Value<String> personalityTraits;
  final Value<String> ideals;
  final Value<String> bonds;
  final Value<String> flaws;
  final Value<String> backstory;
  final Value<String> appearance;
  final Value<String> currency;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  const CharactersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.playerName = const Value.absent(),
    this.ruleset = const Value.absent(),
    this.alignment = const Value.absent(),
    this.xp = const Value.absent(),
    this.speciesId = const Value.absent(),
    this.subspeciesId = const Value.absent(),
    this.backgroundId = const Value.absent(),
    this.hpMax = const Value.absent(),
    this.hpCurrent = const Value.absent(),
    this.hpTemp = const Value.absent(),
    this.armorClass = const Value.absent(),
    this.speed = const Value.absent(),
    this.exhaustionLevel = const Value.absent(),
    this.heroicInspiration = const Value.absent(),
    this.deathSaveSuccesses = const Value.absent(),
    this.deathSaveFailures = const Value.absent(),
    this.personalityTraits = const Value.absent(),
    this.ideals = const Value.absent(),
    this.bonds = const Value.absent(),
    this.flaws = const Value.absent(),
    this.backstory = const Value.absent(),
    this.appearance = const Value.absent(),
    this.currency = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CharactersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.playerName = const Value.absent(),
    required RulesetVersion ruleset,
    this.alignment = const Value.absent(),
    this.xp = const Value.absent(),
    this.speciesId = const Value.absent(),
    this.subspeciesId = const Value.absent(),
    this.backgroundId = const Value.absent(),
    this.hpMax = const Value.absent(),
    this.hpCurrent = const Value.absent(),
    this.hpTemp = const Value.absent(),
    this.armorClass = const Value.absent(),
    this.speed = const Value.absent(),
    this.exhaustionLevel = const Value.absent(),
    this.heroicInspiration = const Value.absent(),
    this.deathSaveSuccesses = const Value.absent(),
    this.deathSaveFailures = const Value.absent(),
    this.personalityTraits = const Value.absent(),
    this.ideals = const Value.absent(),
    this.bonds = const Value.absent(),
    this.flaws = const Value.absent(),
    this.backstory = const Value.absent(),
    this.appearance = const Value.absent(),
    this.currency = const Value.absent(),
    required String createdAt,
    required String updatedAt,
  }) : name = Value(name),
       ruleset = Value(ruleset),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Character> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? playerName,
    Expression<String>? ruleset,
    Expression<String>? alignment,
    Expression<int>? xp,
    Expression<String>? speciesId,
    Expression<String>? subspeciesId,
    Expression<String>? backgroundId,
    Expression<int>? hpMax,
    Expression<int>? hpCurrent,
    Expression<int>? hpTemp,
    Expression<int>? armorClass,
    Expression<int>? speed,
    Expression<int>? exhaustionLevel,
    Expression<bool>? heroicInspiration,
    Expression<int>? deathSaveSuccesses,
    Expression<int>? deathSaveFailures,
    Expression<String>? personalityTraits,
    Expression<String>? ideals,
    Expression<String>? bonds,
    Expression<String>? flaws,
    Expression<String>? backstory,
    Expression<String>? appearance,
    Expression<String>? currency,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (playerName != null) 'player_name': playerName,
      if (ruleset != null) 'ruleset': ruleset,
      if (alignment != null) 'alignment': alignment,
      if (xp != null) 'xp': xp,
      if (speciesId != null) 'species_id': speciesId,
      if (subspeciesId != null) 'subspecies_id': subspeciesId,
      if (backgroundId != null) 'background_id': backgroundId,
      if (hpMax != null) 'hp_max': hpMax,
      if (hpCurrent != null) 'hp_current': hpCurrent,
      if (hpTemp != null) 'hp_temp': hpTemp,
      if (armorClass != null) 'armor_class': armorClass,
      if (speed != null) 'speed': speed,
      if (exhaustionLevel != null) 'exhaustion_level': exhaustionLevel,
      if (heroicInspiration != null) 'heroic_inspiration': heroicInspiration,
      if (deathSaveSuccesses != null)
        'death_save_successes': deathSaveSuccesses,
      if (deathSaveFailures != null) 'death_save_failures': deathSaveFailures,
      if (personalityTraits != null) 'personality_traits': personalityTraits,
      if (ideals != null) 'ideals': ideals,
      if (bonds != null) 'bonds': bonds,
      if (flaws != null) 'flaws': flaws,
      if (backstory != null) 'backstory': backstory,
      if (appearance != null) 'appearance': appearance,
      if (currency != null) 'currency': currency,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CharactersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? playerName,
    Value<RulesetVersion>? ruleset,
    Value<String>? alignment,
    Value<int>? xp,
    Value<String?>? speciesId,
    Value<String?>? subspeciesId,
    Value<String?>? backgroundId,
    Value<int>? hpMax,
    Value<int>? hpCurrent,
    Value<int>? hpTemp,
    Value<int>? armorClass,
    Value<int>? speed,
    Value<int>? exhaustionLevel,
    Value<bool>? heroicInspiration,
    Value<int>? deathSaveSuccesses,
    Value<int>? deathSaveFailures,
    Value<String>? personalityTraits,
    Value<String>? ideals,
    Value<String>? bonds,
    Value<String>? flaws,
    Value<String>? backstory,
    Value<String>? appearance,
    Value<String>? currency,
    Value<String>? createdAt,
    Value<String>? updatedAt,
  }) {
    return CharactersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      playerName: playerName ?? this.playerName,
      ruleset: ruleset ?? this.ruleset,
      alignment: alignment ?? this.alignment,
      xp: xp ?? this.xp,
      speciesId: speciesId ?? this.speciesId,
      subspeciesId: subspeciesId ?? this.subspeciesId,
      backgroundId: backgroundId ?? this.backgroundId,
      hpMax: hpMax ?? this.hpMax,
      hpCurrent: hpCurrent ?? this.hpCurrent,
      hpTemp: hpTemp ?? this.hpTemp,
      armorClass: armorClass ?? this.armorClass,
      speed: speed ?? this.speed,
      exhaustionLevel: exhaustionLevel ?? this.exhaustionLevel,
      heroicInspiration: heroicInspiration ?? this.heroicInspiration,
      deathSaveSuccesses: deathSaveSuccesses ?? this.deathSaveSuccesses,
      deathSaveFailures: deathSaveFailures ?? this.deathSaveFailures,
      personalityTraits: personalityTraits ?? this.personalityTraits,
      ideals: ideals ?? this.ideals,
      bonds: bonds ?? this.bonds,
      flaws: flaws ?? this.flaws,
      backstory: backstory ?? this.backstory,
      appearance: appearance ?? this.appearance,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (playerName.present) {
      map['player_name'] = Variable<String>(playerName.value);
    }
    if (ruleset.present) {
      map['ruleset'] = Variable<String>(
        $CharactersTable.$converterruleset.toSql(ruleset.value),
      );
    }
    if (alignment.present) {
      map['alignment'] = Variable<String>(alignment.value);
    }
    if (xp.present) {
      map['xp'] = Variable<int>(xp.value);
    }
    if (speciesId.present) {
      map['species_id'] = Variable<String>(speciesId.value);
    }
    if (subspeciesId.present) {
      map['subspecies_id'] = Variable<String>(subspeciesId.value);
    }
    if (backgroundId.present) {
      map['background_id'] = Variable<String>(backgroundId.value);
    }
    if (hpMax.present) {
      map['hp_max'] = Variable<int>(hpMax.value);
    }
    if (hpCurrent.present) {
      map['hp_current'] = Variable<int>(hpCurrent.value);
    }
    if (hpTemp.present) {
      map['hp_temp'] = Variable<int>(hpTemp.value);
    }
    if (armorClass.present) {
      map['armor_class'] = Variable<int>(armorClass.value);
    }
    if (speed.present) {
      map['speed'] = Variable<int>(speed.value);
    }
    if (exhaustionLevel.present) {
      map['exhaustion_level'] = Variable<int>(exhaustionLevel.value);
    }
    if (heroicInspiration.present) {
      map['heroic_inspiration'] = Variable<bool>(heroicInspiration.value);
    }
    if (deathSaveSuccesses.present) {
      map['death_save_successes'] = Variable<int>(deathSaveSuccesses.value);
    }
    if (deathSaveFailures.present) {
      map['death_save_failures'] = Variable<int>(deathSaveFailures.value);
    }
    if (personalityTraits.present) {
      map['personality_traits'] = Variable<String>(personalityTraits.value);
    }
    if (ideals.present) {
      map['ideals'] = Variable<String>(ideals.value);
    }
    if (bonds.present) {
      map['bonds'] = Variable<String>(bonds.value);
    }
    if (flaws.present) {
      map['flaws'] = Variable<String>(flaws.value);
    }
    if (backstory.present) {
      map['backstory'] = Variable<String>(backstory.value);
    }
    if (appearance.present) {
      map['appearance'] = Variable<String>(appearance.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharactersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('playerName: $playerName, ')
          ..write('ruleset: $ruleset, ')
          ..write('alignment: $alignment, ')
          ..write('xp: $xp, ')
          ..write('speciesId: $speciesId, ')
          ..write('subspeciesId: $subspeciesId, ')
          ..write('backgroundId: $backgroundId, ')
          ..write('hpMax: $hpMax, ')
          ..write('hpCurrent: $hpCurrent, ')
          ..write('hpTemp: $hpTemp, ')
          ..write('armorClass: $armorClass, ')
          ..write('speed: $speed, ')
          ..write('exhaustionLevel: $exhaustionLevel, ')
          ..write('heroicInspiration: $heroicInspiration, ')
          ..write('deathSaveSuccesses: $deathSaveSuccesses, ')
          ..write('deathSaveFailures: $deathSaveFailures, ')
          ..write('personalityTraits: $personalityTraits, ')
          ..write('ideals: $ideals, ')
          ..write('bonds: $bonds, ')
          ..write('flaws: $flaws, ')
          ..write('backstory: $backstory, ')
          ..write('appearance: $appearance, ')
          ..write('currency: $currency, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CharacterClassesTable extends CharacterClasses
    with TableInfo<$CharacterClassesTable, CharacterClassesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharacterClassesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<int> characterId = GeneratedColumn<int>(
    'character_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES characters (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _classIdMeta = const VerificationMeta(
    'classId',
  );
  @override
  late final GeneratedColumn<String> classId = GeneratedColumn<String>(
    'class_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subclassIdMeta = const VerificationMeta(
    'subclassId',
  );
  @override
  late final GeneratedColumn<String> subclassId = GeneratedColumn<String>(
    'subclass_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    characterId,
    classId,
    subclassId,
    level,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'character_classes';
  @override
  VerificationContext validateIntegrity(
    Insertable<CharacterClassesData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('class_id')) {
      context.handle(
        _classIdMeta,
        classId.isAcceptableOrUnknown(data['class_id']!, _classIdMeta),
      );
    } else if (isInserting) {
      context.missing(_classIdMeta);
    }
    if (data.containsKey('subclass_id')) {
      context.handle(
        _subclassIdMeta,
        subclassId.isAcceptableOrUnknown(data['subclass_id']!, _subclassIdMeta),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CharacterClassesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharacterClassesData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}character_id'],
      )!,
      classId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}class_id'],
      )!,
      subclassId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subclass_id'],
      ),
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
    );
  }

  @override
  $CharacterClassesTable createAlias(String alias) {
    return $CharacterClassesTable(attachedDatabase, alias);
  }
}

class CharacterClassesData extends DataClass
    implements Insertable<CharacterClassesData> {
  final int id;
  final int characterId;
  final String classId;
  final String? subclassId;
  final int level;
  const CharacterClassesData({
    required this.id,
    required this.characterId,
    required this.classId,
    this.subclassId,
    required this.level,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['character_id'] = Variable<int>(characterId);
    map['class_id'] = Variable<String>(classId);
    if (!nullToAbsent || subclassId != null) {
      map['subclass_id'] = Variable<String>(subclassId);
    }
    map['level'] = Variable<int>(level);
    return map;
  }

  CharacterClassesCompanion toCompanion(bool nullToAbsent) {
    return CharacterClassesCompanion(
      id: Value(id),
      characterId: Value(characterId),
      classId: Value(classId),
      subclassId: subclassId == null && nullToAbsent
          ? const Value.absent()
          : Value(subclassId),
      level: Value(level),
    );
  }

  factory CharacterClassesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharacterClassesData(
      id: serializer.fromJson<int>(json['id']),
      characterId: serializer.fromJson<int>(json['characterId']),
      classId: serializer.fromJson<String>(json['classId']),
      subclassId: serializer.fromJson<String?>(json['subclassId']),
      level: serializer.fromJson<int>(json['level']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'characterId': serializer.toJson<int>(characterId),
      'classId': serializer.toJson<String>(classId),
      'subclassId': serializer.toJson<String?>(subclassId),
      'level': serializer.toJson<int>(level),
    };
  }

  CharacterClassesData copyWith({
    int? id,
    int? characterId,
    String? classId,
    Value<String?> subclassId = const Value.absent(),
    int? level,
  }) => CharacterClassesData(
    id: id ?? this.id,
    characterId: characterId ?? this.characterId,
    classId: classId ?? this.classId,
    subclassId: subclassId.present ? subclassId.value : this.subclassId,
    level: level ?? this.level,
  );
  CharacterClassesData copyWithCompanion(CharacterClassesCompanion data) {
    return CharacterClassesData(
      id: data.id.present ? data.id.value : this.id,
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      classId: data.classId.present ? data.classId.value : this.classId,
      subclassId: data.subclassId.present
          ? data.subclassId.value
          : this.subclassId,
      level: data.level.present ? data.level.value : this.level,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharacterClassesData(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('classId: $classId, ')
          ..write('subclassId: $subclassId, ')
          ..write('level: $level')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, characterId, classId, subclassId, level);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharacterClassesData &&
          other.id == this.id &&
          other.characterId == this.characterId &&
          other.classId == this.classId &&
          other.subclassId == this.subclassId &&
          other.level == this.level);
}

class CharacterClassesCompanion extends UpdateCompanion<CharacterClassesData> {
  final Value<int> id;
  final Value<int> characterId;
  final Value<String> classId;
  final Value<String?> subclassId;
  final Value<int> level;
  const CharacterClassesCompanion({
    this.id = const Value.absent(),
    this.characterId = const Value.absent(),
    this.classId = const Value.absent(),
    this.subclassId = const Value.absent(),
    this.level = const Value.absent(),
  });
  CharacterClassesCompanion.insert({
    this.id = const Value.absent(),
    required int characterId,
    required String classId,
    this.subclassId = const Value.absent(),
    required int level,
  }) : characterId = Value(characterId),
       classId = Value(classId),
       level = Value(level);
  static Insertable<CharacterClassesData> custom({
    Expression<int>? id,
    Expression<int>? characterId,
    Expression<String>? classId,
    Expression<String>? subclassId,
    Expression<int>? level,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (characterId != null) 'character_id': characterId,
      if (classId != null) 'class_id': classId,
      if (subclassId != null) 'subclass_id': subclassId,
      if (level != null) 'level': level,
    });
  }

  CharacterClassesCompanion copyWith({
    Value<int>? id,
    Value<int>? characterId,
    Value<String>? classId,
    Value<String?>? subclassId,
    Value<int>? level,
  }) {
    return CharacterClassesCompanion(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      classId: classId ?? this.classId,
      subclassId: subclassId ?? this.subclassId,
      level: level ?? this.level,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<int>(characterId.value);
    }
    if (classId.present) {
      map['class_id'] = Variable<String>(classId.value);
    }
    if (subclassId.present) {
      map['subclass_id'] = Variable<String>(subclassId.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharacterClassesCompanion(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('classId: $classId, ')
          ..write('subclassId: $subclassId, ')
          ..write('level: $level')
          ..write(')'))
        .toString();
  }
}

class $CharacterAbilityScoresTable extends CharacterAbilityScores
    with TableInfo<$CharacterAbilityScoresTable, CharacterAbilityScore> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharacterAbilityScoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<int> characterId = GeneratedColumn<int>(
    'character_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES characters (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _strengthMeta = const VerificationMeta(
    'strength',
  );
  @override
  late final GeneratedColumn<int> strength = GeneratedColumn<int>(
    'strength',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _dexterityMeta = const VerificationMeta(
    'dexterity',
  );
  @override
  late final GeneratedColumn<int> dexterity = GeneratedColumn<int>(
    'dexterity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _constitutionMeta = const VerificationMeta(
    'constitution',
  );
  @override
  late final GeneratedColumn<int> constitution = GeneratedColumn<int>(
    'constitution',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _intelligenceMeta = const VerificationMeta(
    'intelligence',
  );
  @override
  late final GeneratedColumn<int> intelligence = GeneratedColumn<int>(
    'intelligence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _wisdomMeta = const VerificationMeta('wisdom');
  @override
  late final GeneratedColumn<int> wisdom = GeneratedColumn<int>(
    'wisdom',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _charismaMeta = const VerificationMeta(
    'charisma',
  );
  @override
  late final GeneratedColumn<int> charisma = GeneratedColumn<int>(
    'charisma',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    characterId,
    strength,
    dexterity,
    constitution,
    intelligence,
    wisdom,
    charisma,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'character_ability_scores';
  @override
  VerificationContext validateIntegrity(
    Insertable<CharacterAbilityScore> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('strength')) {
      context.handle(
        _strengthMeta,
        strength.isAcceptableOrUnknown(data['strength']!, _strengthMeta),
      );
    }
    if (data.containsKey('dexterity')) {
      context.handle(
        _dexterityMeta,
        dexterity.isAcceptableOrUnknown(data['dexterity']!, _dexterityMeta),
      );
    }
    if (data.containsKey('constitution')) {
      context.handle(
        _constitutionMeta,
        constitution.isAcceptableOrUnknown(
          data['constitution']!,
          _constitutionMeta,
        ),
      );
    }
    if (data.containsKey('intelligence')) {
      context.handle(
        _intelligenceMeta,
        intelligence.isAcceptableOrUnknown(
          data['intelligence']!,
          _intelligenceMeta,
        ),
      );
    }
    if (data.containsKey('wisdom')) {
      context.handle(
        _wisdomMeta,
        wisdom.isAcceptableOrUnknown(data['wisdom']!, _wisdomMeta),
      );
    }
    if (data.containsKey('charisma')) {
      context.handle(
        _charismaMeta,
        charisma.isAcceptableOrUnknown(data['charisma']!, _charismaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CharacterAbilityScore map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharacterAbilityScore(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}character_id'],
      )!,
      strength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}strength'],
      )!,
      dexterity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dexterity'],
      )!,
      constitution: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}constitution'],
      )!,
      intelligence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intelligence'],
      )!,
      wisdom: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wisdom'],
      )!,
      charisma: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}charisma'],
      )!,
    );
  }

  @override
  $CharacterAbilityScoresTable createAlias(String alias) {
    return $CharacterAbilityScoresTable(attachedDatabase, alias);
  }
}

class CharacterAbilityScore extends DataClass
    implements Insertable<CharacterAbilityScore> {
  final int id;
  final int characterId;
  final int strength;
  final int dexterity;
  final int constitution;
  final int intelligence;
  final int wisdom;
  final int charisma;
  const CharacterAbilityScore({
    required this.id,
    required this.characterId,
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['character_id'] = Variable<int>(characterId);
    map['strength'] = Variable<int>(strength);
    map['dexterity'] = Variable<int>(dexterity);
    map['constitution'] = Variable<int>(constitution);
    map['intelligence'] = Variable<int>(intelligence);
    map['wisdom'] = Variable<int>(wisdom);
    map['charisma'] = Variable<int>(charisma);
    return map;
  }

  CharacterAbilityScoresCompanion toCompanion(bool nullToAbsent) {
    return CharacterAbilityScoresCompanion(
      id: Value(id),
      characterId: Value(characterId),
      strength: Value(strength),
      dexterity: Value(dexterity),
      constitution: Value(constitution),
      intelligence: Value(intelligence),
      wisdom: Value(wisdom),
      charisma: Value(charisma),
    );
  }

  factory CharacterAbilityScore.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharacterAbilityScore(
      id: serializer.fromJson<int>(json['id']),
      characterId: serializer.fromJson<int>(json['characterId']),
      strength: serializer.fromJson<int>(json['strength']),
      dexterity: serializer.fromJson<int>(json['dexterity']),
      constitution: serializer.fromJson<int>(json['constitution']),
      intelligence: serializer.fromJson<int>(json['intelligence']),
      wisdom: serializer.fromJson<int>(json['wisdom']),
      charisma: serializer.fromJson<int>(json['charisma']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'characterId': serializer.toJson<int>(characterId),
      'strength': serializer.toJson<int>(strength),
      'dexterity': serializer.toJson<int>(dexterity),
      'constitution': serializer.toJson<int>(constitution),
      'intelligence': serializer.toJson<int>(intelligence),
      'wisdom': serializer.toJson<int>(wisdom),
      'charisma': serializer.toJson<int>(charisma),
    };
  }

  CharacterAbilityScore copyWith({
    int? id,
    int? characterId,
    int? strength,
    int? dexterity,
    int? constitution,
    int? intelligence,
    int? wisdom,
    int? charisma,
  }) => CharacterAbilityScore(
    id: id ?? this.id,
    characterId: characterId ?? this.characterId,
    strength: strength ?? this.strength,
    dexterity: dexterity ?? this.dexterity,
    constitution: constitution ?? this.constitution,
    intelligence: intelligence ?? this.intelligence,
    wisdom: wisdom ?? this.wisdom,
    charisma: charisma ?? this.charisma,
  );
  CharacterAbilityScore copyWithCompanion(
    CharacterAbilityScoresCompanion data,
  ) {
    return CharacterAbilityScore(
      id: data.id.present ? data.id.value : this.id,
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      strength: data.strength.present ? data.strength.value : this.strength,
      dexterity: data.dexterity.present ? data.dexterity.value : this.dexterity,
      constitution: data.constitution.present
          ? data.constitution.value
          : this.constitution,
      intelligence: data.intelligence.present
          ? data.intelligence.value
          : this.intelligence,
      wisdom: data.wisdom.present ? data.wisdom.value : this.wisdom,
      charisma: data.charisma.present ? data.charisma.value : this.charisma,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharacterAbilityScore(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('strength: $strength, ')
          ..write('dexterity: $dexterity, ')
          ..write('constitution: $constitution, ')
          ..write('intelligence: $intelligence, ')
          ..write('wisdom: $wisdom, ')
          ..write('charisma: $charisma')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    characterId,
    strength,
    dexterity,
    constitution,
    intelligence,
    wisdom,
    charisma,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharacterAbilityScore &&
          other.id == this.id &&
          other.characterId == this.characterId &&
          other.strength == this.strength &&
          other.dexterity == this.dexterity &&
          other.constitution == this.constitution &&
          other.intelligence == this.intelligence &&
          other.wisdom == this.wisdom &&
          other.charisma == this.charisma);
}

class CharacterAbilityScoresCompanion
    extends UpdateCompanion<CharacterAbilityScore> {
  final Value<int> id;
  final Value<int> characterId;
  final Value<int> strength;
  final Value<int> dexterity;
  final Value<int> constitution;
  final Value<int> intelligence;
  final Value<int> wisdom;
  final Value<int> charisma;
  const CharacterAbilityScoresCompanion({
    this.id = const Value.absent(),
    this.characterId = const Value.absent(),
    this.strength = const Value.absent(),
    this.dexterity = const Value.absent(),
    this.constitution = const Value.absent(),
    this.intelligence = const Value.absent(),
    this.wisdom = const Value.absent(),
    this.charisma = const Value.absent(),
  });
  CharacterAbilityScoresCompanion.insert({
    this.id = const Value.absent(),
    required int characterId,
    this.strength = const Value.absent(),
    this.dexterity = const Value.absent(),
    this.constitution = const Value.absent(),
    this.intelligence = const Value.absent(),
    this.wisdom = const Value.absent(),
    this.charisma = const Value.absent(),
  }) : characterId = Value(characterId);
  static Insertable<CharacterAbilityScore> custom({
    Expression<int>? id,
    Expression<int>? characterId,
    Expression<int>? strength,
    Expression<int>? dexterity,
    Expression<int>? constitution,
    Expression<int>? intelligence,
    Expression<int>? wisdom,
    Expression<int>? charisma,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (characterId != null) 'character_id': characterId,
      if (strength != null) 'strength': strength,
      if (dexterity != null) 'dexterity': dexterity,
      if (constitution != null) 'constitution': constitution,
      if (intelligence != null) 'intelligence': intelligence,
      if (wisdom != null) 'wisdom': wisdom,
      if (charisma != null) 'charisma': charisma,
    });
  }

  CharacterAbilityScoresCompanion copyWith({
    Value<int>? id,
    Value<int>? characterId,
    Value<int>? strength,
    Value<int>? dexterity,
    Value<int>? constitution,
    Value<int>? intelligence,
    Value<int>? wisdom,
    Value<int>? charisma,
  }) {
    return CharacterAbilityScoresCompanion(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      strength: strength ?? this.strength,
      dexterity: dexterity ?? this.dexterity,
      constitution: constitution ?? this.constitution,
      intelligence: intelligence ?? this.intelligence,
      wisdom: wisdom ?? this.wisdom,
      charisma: charisma ?? this.charisma,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<int>(characterId.value);
    }
    if (strength.present) {
      map['strength'] = Variable<int>(strength.value);
    }
    if (dexterity.present) {
      map['dexterity'] = Variable<int>(dexterity.value);
    }
    if (constitution.present) {
      map['constitution'] = Variable<int>(constitution.value);
    }
    if (intelligence.present) {
      map['intelligence'] = Variable<int>(intelligence.value);
    }
    if (wisdom.present) {
      map['wisdom'] = Variable<int>(wisdom.value);
    }
    if (charisma.present) {
      map['charisma'] = Variable<int>(charisma.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharacterAbilityScoresCompanion(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('strength: $strength, ')
          ..write('dexterity: $dexterity, ')
          ..write('constitution: $constitution, ')
          ..write('intelligence: $intelligence, ')
          ..write('wisdom: $wisdom, ')
          ..write('charisma: $charisma')
          ..write(')'))
        .toString();
  }
}

class $CharacterProficienciesTable extends CharacterProficiencies
    with TableInfo<$CharacterProficienciesTable, CharacterProficiency> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharacterProficienciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<int> characterId = GeneratedColumn<int>(
    'character_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES characters (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _proficiencyKeyMeta = const VerificationMeta(
    'proficiencyKey',
  );
  @override
  late final GeneratedColumn<String> proficiencyKey = GeneratedColumn<String>(
    'proficiency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hasExpertiseMeta = const VerificationMeta(
    'hasExpertise',
  );
  @override
  late final GeneratedColumn<bool> hasExpertise = GeneratedColumn<bool>(
    'has_expertise',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_expertise" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    characterId,
    proficiencyKey,
    hasExpertise,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'character_proficiencies';
  @override
  VerificationContext validateIntegrity(
    Insertable<CharacterProficiency> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('proficiency_key')) {
      context.handle(
        _proficiencyKeyMeta,
        proficiencyKey.isAcceptableOrUnknown(
          data['proficiency_key']!,
          _proficiencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_proficiencyKeyMeta);
    }
    if (data.containsKey('has_expertise')) {
      context.handle(
        _hasExpertiseMeta,
        hasExpertise.isAcceptableOrUnknown(
          data['has_expertise']!,
          _hasExpertiseMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CharacterProficiency map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharacterProficiency(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}character_id'],
      )!,
      proficiencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proficiency_key'],
      )!,
      hasExpertise: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_expertise'],
      )!,
    );
  }

  @override
  $CharacterProficienciesTable createAlias(String alias) {
    return $CharacterProficienciesTable(attachedDatabase, alias);
  }
}

class CharacterProficiency extends DataClass
    implements Insertable<CharacterProficiency> {
  final int id;
  final int characterId;
  final String proficiencyKey;
  final bool hasExpertise;
  const CharacterProficiency({
    required this.id,
    required this.characterId,
    required this.proficiencyKey,
    required this.hasExpertise,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['character_id'] = Variable<int>(characterId);
    map['proficiency_key'] = Variable<String>(proficiencyKey);
    map['has_expertise'] = Variable<bool>(hasExpertise);
    return map;
  }

  CharacterProficienciesCompanion toCompanion(bool nullToAbsent) {
    return CharacterProficienciesCompanion(
      id: Value(id),
      characterId: Value(characterId),
      proficiencyKey: Value(proficiencyKey),
      hasExpertise: Value(hasExpertise),
    );
  }

  factory CharacterProficiency.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharacterProficiency(
      id: serializer.fromJson<int>(json['id']),
      characterId: serializer.fromJson<int>(json['characterId']),
      proficiencyKey: serializer.fromJson<String>(json['proficiencyKey']),
      hasExpertise: serializer.fromJson<bool>(json['hasExpertise']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'characterId': serializer.toJson<int>(characterId),
      'proficiencyKey': serializer.toJson<String>(proficiencyKey),
      'hasExpertise': serializer.toJson<bool>(hasExpertise),
    };
  }

  CharacterProficiency copyWith({
    int? id,
    int? characterId,
    String? proficiencyKey,
    bool? hasExpertise,
  }) => CharacterProficiency(
    id: id ?? this.id,
    characterId: characterId ?? this.characterId,
    proficiencyKey: proficiencyKey ?? this.proficiencyKey,
    hasExpertise: hasExpertise ?? this.hasExpertise,
  );
  CharacterProficiency copyWithCompanion(CharacterProficienciesCompanion data) {
    return CharacterProficiency(
      id: data.id.present ? data.id.value : this.id,
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      proficiencyKey: data.proficiencyKey.present
          ? data.proficiencyKey.value
          : this.proficiencyKey,
      hasExpertise: data.hasExpertise.present
          ? data.hasExpertise.value
          : this.hasExpertise,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharacterProficiency(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('proficiencyKey: $proficiencyKey, ')
          ..write('hasExpertise: $hasExpertise')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, characterId, proficiencyKey, hasExpertise);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharacterProficiency &&
          other.id == this.id &&
          other.characterId == this.characterId &&
          other.proficiencyKey == this.proficiencyKey &&
          other.hasExpertise == this.hasExpertise);
}

class CharacterProficienciesCompanion
    extends UpdateCompanion<CharacterProficiency> {
  final Value<int> id;
  final Value<int> characterId;
  final Value<String> proficiencyKey;
  final Value<bool> hasExpertise;
  const CharacterProficienciesCompanion({
    this.id = const Value.absent(),
    this.characterId = const Value.absent(),
    this.proficiencyKey = const Value.absent(),
    this.hasExpertise = const Value.absent(),
  });
  CharacterProficienciesCompanion.insert({
    this.id = const Value.absent(),
    required int characterId,
    required String proficiencyKey,
    this.hasExpertise = const Value.absent(),
  }) : characterId = Value(characterId),
       proficiencyKey = Value(proficiencyKey);
  static Insertable<CharacterProficiency> custom({
    Expression<int>? id,
    Expression<int>? characterId,
    Expression<String>? proficiencyKey,
    Expression<bool>? hasExpertise,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (characterId != null) 'character_id': characterId,
      if (proficiencyKey != null) 'proficiency_key': proficiencyKey,
      if (hasExpertise != null) 'has_expertise': hasExpertise,
    });
  }

  CharacterProficienciesCompanion copyWith({
    Value<int>? id,
    Value<int>? characterId,
    Value<String>? proficiencyKey,
    Value<bool>? hasExpertise,
  }) {
    return CharacterProficienciesCompanion(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      proficiencyKey: proficiencyKey ?? this.proficiencyKey,
      hasExpertise: hasExpertise ?? this.hasExpertise,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<int>(characterId.value);
    }
    if (proficiencyKey.present) {
      map['proficiency_key'] = Variable<String>(proficiencyKey.value);
    }
    if (hasExpertise.present) {
      map['has_expertise'] = Variable<bool>(hasExpertise.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharacterProficienciesCompanion(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('proficiencyKey: $proficiencyKey, ')
          ..write('hasExpertise: $hasExpertise')
          ..write(')'))
        .toString();
  }
}

class $CharacterSpellsTable extends CharacterSpells
    with TableInfo<$CharacterSpellsTable, CharacterSpell> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharacterSpellsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<int> characterId = GeneratedColumn<int>(
    'character_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES characters (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _spellIdMeta = const VerificationMeta(
    'spellId',
  );
  @override
  late final GeneratedColumn<String> spellId = GeneratedColumn<String>(
    'spell_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RulesetVersion, String> ruleset =
      GeneratedColumn<String>(
        'ruleset',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RulesetVersion>($CharacterSpellsTable.$converterruleset);
  static const VerificationMeta _preparedMeta = const VerificationMeta(
    'prepared',
  );
  @override
  late final GeneratedColumn<bool> prepared = GeneratedColumn<bool>(
    'prepared',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("prepared" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _alwaysPreparedMeta = const VerificationMeta(
    'alwaysPrepared',
  );
  @override
  late final GeneratedColumn<bool> alwaysPrepared = GeneratedColumn<bool>(
    'always_prepared',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("always_prepared" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    characterId,
    spellId,
    ruleset,
    prepared,
    alwaysPrepared,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'character_spells';
  @override
  VerificationContext validateIntegrity(
    Insertable<CharacterSpell> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('spell_id')) {
      context.handle(
        _spellIdMeta,
        spellId.isAcceptableOrUnknown(data['spell_id']!, _spellIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spellIdMeta);
    }
    if (data.containsKey('prepared')) {
      context.handle(
        _preparedMeta,
        prepared.isAcceptableOrUnknown(data['prepared']!, _preparedMeta),
      );
    }
    if (data.containsKey('always_prepared')) {
      context.handle(
        _alwaysPreparedMeta,
        alwaysPrepared.isAcceptableOrUnknown(
          data['always_prepared']!,
          _alwaysPreparedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CharacterSpell map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharacterSpell(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}character_id'],
      )!,
      spellId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spell_id'],
      )!,
      ruleset: $CharacterSpellsTable.$converterruleset.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}ruleset'],
        )!,
      ),
      prepared: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}prepared'],
      )!,
      alwaysPrepared: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}always_prepared'],
      )!,
    );
  }

  @override
  $CharacterSpellsTable createAlias(String alias) {
    return $CharacterSpellsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RulesetVersion, String, String> $converterruleset =
      const EnumNameConverter<RulesetVersion>(RulesetVersion.values);
}

class CharacterSpell extends DataClass implements Insertable<CharacterSpell> {
  final int id;
  final int characterId;
  final String spellId;
  final RulesetVersion ruleset;
  final bool prepared;
  final bool alwaysPrepared;
  const CharacterSpell({
    required this.id,
    required this.characterId,
    required this.spellId,
    required this.ruleset,
    required this.prepared,
    required this.alwaysPrepared,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['character_id'] = Variable<int>(characterId);
    map['spell_id'] = Variable<String>(spellId);
    {
      map['ruleset'] = Variable<String>(
        $CharacterSpellsTable.$converterruleset.toSql(ruleset),
      );
    }
    map['prepared'] = Variable<bool>(prepared);
    map['always_prepared'] = Variable<bool>(alwaysPrepared);
    return map;
  }

  CharacterSpellsCompanion toCompanion(bool nullToAbsent) {
    return CharacterSpellsCompanion(
      id: Value(id),
      characterId: Value(characterId),
      spellId: Value(spellId),
      ruleset: Value(ruleset),
      prepared: Value(prepared),
      alwaysPrepared: Value(alwaysPrepared),
    );
  }

  factory CharacterSpell.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharacterSpell(
      id: serializer.fromJson<int>(json['id']),
      characterId: serializer.fromJson<int>(json['characterId']),
      spellId: serializer.fromJson<String>(json['spellId']),
      ruleset: $CharacterSpellsTable.$converterruleset.fromJson(
        serializer.fromJson<String>(json['ruleset']),
      ),
      prepared: serializer.fromJson<bool>(json['prepared']),
      alwaysPrepared: serializer.fromJson<bool>(json['alwaysPrepared']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'characterId': serializer.toJson<int>(characterId),
      'spellId': serializer.toJson<String>(spellId),
      'ruleset': serializer.toJson<String>(
        $CharacterSpellsTable.$converterruleset.toJson(ruleset),
      ),
      'prepared': serializer.toJson<bool>(prepared),
      'alwaysPrepared': serializer.toJson<bool>(alwaysPrepared),
    };
  }

  CharacterSpell copyWith({
    int? id,
    int? characterId,
    String? spellId,
    RulesetVersion? ruleset,
    bool? prepared,
    bool? alwaysPrepared,
  }) => CharacterSpell(
    id: id ?? this.id,
    characterId: characterId ?? this.characterId,
    spellId: spellId ?? this.spellId,
    ruleset: ruleset ?? this.ruleset,
    prepared: prepared ?? this.prepared,
    alwaysPrepared: alwaysPrepared ?? this.alwaysPrepared,
  );
  CharacterSpell copyWithCompanion(CharacterSpellsCompanion data) {
    return CharacterSpell(
      id: data.id.present ? data.id.value : this.id,
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      spellId: data.spellId.present ? data.spellId.value : this.spellId,
      ruleset: data.ruleset.present ? data.ruleset.value : this.ruleset,
      prepared: data.prepared.present ? data.prepared.value : this.prepared,
      alwaysPrepared: data.alwaysPrepared.present
          ? data.alwaysPrepared.value
          : this.alwaysPrepared,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharacterSpell(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('spellId: $spellId, ')
          ..write('ruleset: $ruleset, ')
          ..write('prepared: $prepared, ')
          ..write('alwaysPrepared: $alwaysPrepared')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, characterId, spellId, ruleset, prepared, alwaysPrepared);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharacterSpell &&
          other.id == this.id &&
          other.characterId == this.characterId &&
          other.spellId == this.spellId &&
          other.ruleset == this.ruleset &&
          other.prepared == this.prepared &&
          other.alwaysPrepared == this.alwaysPrepared);
}

class CharacterSpellsCompanion extends UpdateCompanion<CharacterSpell> {
  final Value<int> id;
  final Value<int> characterId;
  final Value<String> spellId;
  final Value<RulesetVersion> ruleset;
  final Value<bool> prepared;
  final Value<bool> alwaysPrepared;
  const CharacterSpellsCompanion({
    this.id = const Value.absent(),
    this.characterId = const Value.absent(),
    this.spellId = const Value.absent(),
    this.ruleset = const Value.absent(),
    this.prepared = const Value.absent(),
    this.alwaysPrepared = const Value.absent(),
  });
  CharacterSpellsCompanion.insert({
    this.id = const Value.absent(),
    required int characterId,
    required String spellId,
    required RulesetVersion ruleset,
    this.prepared = const Value.absent(),
    this.alwaysPrepared = const Value.absent(),
  }) : characterId = Value(characterId),
       spellId = Value(spellId),
       ruleset = Value(ruleset);
  static Insertable<CharacterSpell> custom({
    Expression<int>? id,
    Expression<int>? characterId,
    Expression<String>? spellId,
    Expression<String>? ruleset,
    Expression<bool>? prepared,
    Expression<bool>? alwaysPrepared,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (characterId != null) 'character_id': characterId,
      if (spellId != null) 'spell_id': spellId,
      if (ruleset != null) 'ruleset': ruleset,
      if (prepared != null) 'prepared': prepared,
      if (alwaysPrepared != null) 'always_prepared': alwaysPrepared,
    });
  }

  CharacterSpellsCompanion copyWith({
    Value<int>? id,
    Value<int>? characterId,
    Value<String>? spellId,
    Value<RulesetVersion>? ruleset,
    Value<bool>? prepared,
    Value<bool>? alwaysPrepared,
  }) {
    return CharacterSpellsCompanion(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      spellId: spellId ?? this.spellId,
      ruleset: ruleset ?? this.ruleset,
      prepared: prepared ?? this.prepared,
      alwaysPrepared: alwaysPrepared ?? this.alwaysPrepared,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<int>(characterId.value);
    }
    if (spellId.present) {
      map['spell_id'] = Variable<String>(spellId.value);
    }
    if (ruleset.present) {
      map['ruleset'] = Variable<String>(
        $CharacterSpellsTable.$converterruleset.toSql(ruleset.value),
      );
    }
    if (prepared.present) {
      map['prepared'] = Variable<bool>(prepared.value);
    }
    if (alwaysPrepared.present) {
      map['always_prepared'] = Variable<bool>(alwaysPrepared.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharacterSpellsCompanion(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('spellId: $spellId, ')
          ..write('ruleset: $ruleset, ')
          ..write('prepared: $prepared, ')
          ..write('alwaysPrepared: $alwaysPrepared')
          ..write(')'))
        .toString();
  }
}

class $CharacterFeatsTable extends CharacterFeats
    with TableInfo<$CharacterFeatsTable, CharacterFeat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharacterFeatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<int> characterId = GeneratedColumn<int>(
    'character_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES characters (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _featIdMeta = const VerificationMeta('featId');
  @override
  late final GeneratedColumn<String> featId = GeneratedColumn<String>(
    'feat_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RulesetVersion, String> ruleset =
      GeneratedColumn<String>(
        'ruleset',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RulesetVersion>($CharacterFeatsTable.$converterruleset);
  static const VerificationMeta _choicesJsonMeta = const VerificationMeta(
    'choicesJson',
  );
  @override
  late final GeneratedColumn<String> choicesJson = GeneratedColumn<String>(
    'choices_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    characterId,
    featId,
    ruleset,
    choicesJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'character_feats';
  @override
  VerificationContext validateIntegrity(
    Insertable<CharacterFeat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('feat_id')) {
      context.handle(
        _featIdMeta,
        featId.isAcceptableOrUnknown(data['feat_id']!, _featIdMeta),
      );
    } else if (isInserting) {
      context.missing(_featIdMeta);
    }
    if (data.containsKey('choices_json')) {
      context.handle(
        _choicesJsonMeta,
        choicesJson.isAcceptableOrUnknown(
          data['choices_json']!,
          _choicesJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CharacterFeat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharacterFeat(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}character_id'],
      )!,
      featId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feat_id'],
      )!,
      ruleset: $CharacterFeatsTable.$converterruleset.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}ruleset'],
        )!,
      ),
      choicesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}choices_json'],
      ),
    );
  }

  @override
  $CharacterFeatsTable createAlias(String alias) {
    return $CharacterFeatsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RulesetVersion, String, String> $converterruleset =
      const EnumNameConverter<RulesetVersion>(RulesetVersion.values);
}

class CharacterFeat extends DataClass implements Insertable<CharacterFeat> {
  final int id;
  final int characterId;
  final String featId;
  final RulesetVersion ruleset;
  final String? choicesJson;
  const CharacterFeat({
    required this.id,
    required this.characterId,
    required this.featId,
    required this.ruleset,
    this.choicesJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['character_id'] = Variable<int>(characterId);
    map['feat_id'] = Variable<String>(featId);
    {
      map['ruleset'] = Variable<String>(
        $CharacterFeatsTable.$converterruleset.toSql(ruleset),
      );
    }
    if (!nullToAbsent || choicesJson != null) {
      map['choices_json'] = Variable<String>(choicesJson);
    }
    return map;
  }

  CharacterFeatsCompanion toCompanion(bool nullToAbsent) {
    return CharacterFeatsCompanion(
      id: Value(id),
      characterId: Value(characterId),
      featId: Value(featId),
      ruleset: Value(ruleset),
      choicesJson: choicesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(choicesJson),
    );
  }

  factory CharacterFeat.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharacterFeat(
      id: serializer.fromJson<int>(json['id']),
      characterId: serializer.fromJson<int>(json['characterId']),
      featId: serializer.fromJson<String>(json['featId']),
      ruleset: $CharacterFeatsTable.$converterruleset.fromJson(
        serializer.fromJson<String>(json['ruleset']),
      ),
      choicesJson: serializer.fromJson<String?>(json['choicesJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'characterId': serializer.toJson<int>(characterId),
      'featId': serializer.toJson<String>(featId),
      'ruleset': serializer.toJson<String>(
        $CharacterFeatsTable.$converterruleset.toJson(ruleset),
      ),
      'choicesJson': serializer.toJson<String?>(choicesJson),
    };
  }

  CharacterFeat copyWith({
    int? id,
    int? characterId,
    String? featId,
    RulesetVersion? ruleset,
    Value<String?> choicesJson = const Value.absent(),
  }) => CharacterFeat(
    id: id ?? this.id,
    characterId: characterId ?? this.characterId,
    featId: featId ?? this.featId,
    ruleset: ruleset ?? this.ruleset,
    choicesJson: choicesJson.present ? choicesJson.value : this.choicesJson,
  );
  CharacterFeat copyWithCompanion(CharacterFeatsCompanion data) {
    return CharacterFeat(
      id: data.id.present ? data.id.value : this.id,
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      featId: data.featId.present ? data.featId.value : this.featId,
      ruleset: data.ruleset.present ? data.ruleset.value : this.ruleset,
      choicesJson: data.choicesJson.present
          ? data.choicesJson.value
          : this.choicesJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharacterFeat(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('featId: $featId, ')
          ..write('ruleset: $ruleset, ')
          ..write('choicesJson: $choicesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, characterId, featId, ruleset, choicesJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharacterFeat &&
          other.id == this.id &&
          other.characterId == this.characterId &&
          other.featId == this.featId &&
          other.ruleset == this.ruleset &&
          other.choicesJson == this.choicesJson);
}

class CharacterFeatsCompanion extends UpdateCompanion<CharacterFeat> {
  final Value<int> id;
  final Value<int> characterId;
  final Value<String> featId;
  final Value<RulesetVersion> ruleset;
  final Value<String?> choicesJson;
  const CharacterFeatsCompanion({
    this.id = const Value.absent(),
    this.characterId = const Value.absent(),
    this.featId = const Value.absent(),
    this.ruleset = const Value.absent(),
    this.choicesJson = const Value.absent(),
  });
  CharacterFeatsCompanion.insert({
    this.id = const Value.absent(),
    required int characterId,
    required String featId,
    required RulesetVersion ruleset,
    this.choicesJson = const Value.absent(),
  }) : characterId = Value(characterId),
       featId = Value(featId),
       ruleset = Value(ruleset);
  static Insertable<CharacterFeat> custom({
    Expression<int>? id,
    Expression<int>? characterId,
    Expression<String>? featId,
    Expression<String>? ruleset,
    Expression<String>? choicesJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (characterId != null) 'character_id': characterId,
      if (featId != null) 'feat_id': featId,
      if (ruleset != null) 'ruleset': ruleset,
      if (choicesJson != null) 'choices_json': choicesJson,
    });
  }

  CharacterFeatsCompanion copyWith({
    Value<int>? id,
    Value<int>? characterId,
    Value<String>? featId,
    Value<RulesetVersion>? ruleset,
    Value<String?>? choicesJson,
  }) {
    return CharacterFeatsCompanion(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      featId: featId ?? this.featId,
      ruleset: ruleset ?? this.ruleset,
      choicesJson: choicesJson ?? this.choicesJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<int>(characterId.value);
    }
    if (featId.present) {
      map['feat_id'] = Variable<String>(featId.value);
    }
    if (ruleset.present) {
      map['ruleset'] = Variable<String>(
        $CharacterFeatsTable.$converterruleset.toSql(ruleset.value),
      );
    }
    if (choicesJson.present) {
      map['choices_json'] = Variable<String>(choicesJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharacterFeatsCompanion(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('featId: $featId, ')
          ..write('ruleset: $ruleset, ')
          ..write('choicesJson: $choicesJson')
          ..write(')'))
        .toString();
  }
}

class $CharacterSpellSlotsTable extends CharacterSpellSlots
    with TableInfo<$CharacterSpellSlotsTable, CharacterSpellSlot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharacterSpellSlotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<int> characterId = GeneratedColumn<int>(
    'character_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES characters (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _slotLevelMeta = const VerificationMeta(
    'slotLevel',
  );
  @override
  late final GeneratedColumn<int> slotLevel = GeneratedColumn<int>(
    'slot_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slotMaxMeta = const VerificationMeta(
    'slotMax',
  );
  @override
  late final GeneratedColumn<int> slotMax = GeneratedColumn<int>(
    'slot_max',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slotCurrentMeta = const VerificationMeta(
    'slotCurrent',
  );
  @override
  late final GeneratedColumn<int> slotCurrent = GeneratedColumn<int>(
    'slot_current',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    characterId,
    slotLevel,
    slotMax,
    slotCurrent,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'character_spell_slots';
  @override
  VerificationContext validateIntegrity(
    Insertable<CharacterSpellSlot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('slot_level')) {
      context.handle(
        _slotLevelMeta,
        slotLevel.isAcceptableOrUnknown(data['slot_level']!, _slotLevelMeta),
      );
    } else if (isInserting) {
      context.missing(_slotLevelMeta);
    }
    if (data.containsKey('slot_max')) {
      context.handle(
        _slotMaxMeta,
        slotMax.isAcceptableOrUnknown(data['slot_max']!, _slotMaxMeta),
      );
    } else if (isInserting) {
      context.missing(_slotMaxMeta);
    }
    if (data.containsKey('slot_current')) {
      context.handle(
        _slotCurrentMeta,
        slotCurrent.isAcceptableOrUnknown(
          data['slot_current']!,
          _slotCurrentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_slotCurrentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CharacterSpellSlot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharacterSpellSlot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}character_id'],
      )!,
      slotLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}slot_level'],
      )!,
      slotMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}slot_max'],
      )!,
      slotCurrent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}slot_current'],
      )!,
    );
  }

  @override
  $CharacterSpellSlotsTable createAlias(String alias) {
    return $CharacterSpellSlotsTable(attachedDatabase, alias);
  }
}

class CharacterSpellSlot extends DataClass
    implements Insertable<CharacterSpellSlot> {
  final int id;
  final int characterId;
  final int slotLevel;
  final int slotMax;
  final int slotCurrent;
  const CharacterSpellSlot({
    required this.id,
    required this.characterId,
    required this.slotLevel,
    required this.slotMax,
    required this.slotCurrent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['character_id'] = Variable<int>(characterId);
    map['slot_level'] = Variable<int>(slotLevel);
    map['slot_max'] = Variable<int>(slotMax);
    map['slot_current'] = Variable<int>(slotCurrent);
    return map;
  }

  CharacterSpellSlotsCompanion toCompanion(bool nullToAbsent) {
    return CharacterSpellSlotsCompanion(
      id: Value(id),
      characterId: Value(characterId),
      slotLevel: Value(slotLevel),
      slotMax: Value(slotMax),
      slotCurrent: Value(slotCurrent),
    );
  }

  factory CharacterSpellSlot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharacterSpellSlot(
      id: serializer.fromJson<int>(json['id']),
      characterId: serializer.fromJson<int>(json['characterId']),
      slotLevel: serializer.fromJson<int>(json['slotLevel']),
      slotMax: serializer.fromJson<int>(json['slotMax']),
      slotCurrent: serializer.fromJson<int>(json['slotCurrent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'characterId': serializer.toJson<int>(characterId),
      'slotLevel': serializer.toJson<int>(slotLevel),
      'slotMax': serializer.toJson<int>(slotMax),
      'slotCurrent': serializer.toJson<int>(slotCurrent),
    };
  }

  CharacterSpellSlot copyWith({
    int? id,
    int? characterId,
    int? slotLevel,
    int? slotMax,
    int? slotCurrent,
  }) => CharacterSpellSlot(
    id: id ?? this.id,
    characterId: characterId ?? this.characterId,
    slotLevel: slotLevel ?? this.slotLevel,
    slotMax: slotMax ?? this.slotMax,
    slotCurrent: slotCurrent ?? this.slotCurrent,
  );
  CharacterSpellSlot copyWithCompanion(CharacterSpellSlotsCompanion data) {
    return CharacterSpellSlot(
      id: data.id.present ? data.id.value : this.id,
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      slotLevel: data.slotLevel.present ? data.slotLevel.value : this.slotLevel,
      slotMax: data.slotMax.present ? data.slotMax.value : this.slotMax,
      slotCurrent: data.slotCurrent.present
          ? data.slotCurrent.value
          : this.slotCurrent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharacterSpellSlot(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('slotLevel: $slotLevel, ')
          ..write('slotMax: $slotMax, ')
          ..write('slotCurrent: $slotCurrent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, characterId, slotLevel, slotMax, slotCurrent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharacterSpellSlot &&
          other.id == this.id &&
          other.characterId == this.characterId &&
          other.slotLevel == this.slotLevel &&
          other.slotMax == this.slotMax &&
          other.slotCurrent == this.slotCurrent);
}

class CharacterSpellSlotsCompanion extends UpdateCompanion<CharacterSpellSlot> {
  final Value<int> id;
  final Value<int> characterId;
  final Value<int> slotLevel;
  final Value<int> slotMax;
  final Value<int> slotCurrent;
  const CharacterSpellSlotsCompanion({
    this.id = const Value.absent(),
    this.characterId = const Value.absent(),
    this.slotLevel = const Value.absent(),
    this.slotMax = const Value.absent(),
    this.slotCurrent = const Value.absent(),
  });
  CharacterSpellSlotsCompanion.insert({
    this.id = const Value.absent(),
    required int characterId,
    required int slotLevel,
    required int slotMax,
    required int slotCurrent,
  }) : characterId = Value(characterId),
       slotLevel = Value(slotLevel),
       slotMax = Value(slotMax),
       slotCurrent = Value(slotCurrent);
  static Insertable<CharacterSpellSlot> custom({
    Expression<int>? id,
    Expression<int>? characterId,
    Expression<int>? slotLevel,
    Expression<int>? slotMax,
    Expression<int>? slotCurrent,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (characterId != null) 'character_id': characterId,
      if (slotLevel != null) 'slot_level': slotLevel,
      if (slotMax != null) 'slot_max': slotMax,
      if (slotCurrent != null) 'slot_current': slotCurrent,
    });
  }

  CharacterSpellSlotsCompanion copyWith({
    Value<int>? id,
    Value<int>? characterId,
    Value<int>? slotLevel,
    Value<int>? slotMax,
    Value<int>? slotCurrent,
  }) {
    return CharacterSpellSlotsCompanion(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      slotLevel: slotLevel ?? this.slotLevel,
      slotMax: slotMax ?? this.slotMax,
      slotCurrent: slotCurrent ?? this.slotCurrent,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<int>(characterId.value);
    }
    if (slotLevel.present) {
      map['slot_level'] = Variable<int>(slotLevel.value);
    }
    if (slotMax.present) {
      map['slot_max'] = Variable<int>(slotMax.value);
    }
    if (slotCurrent.present) {
      map['slot_current'] = Variable<int>(slotCurrent.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharacterSpellSlotsCompanion(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('slotLevel: $slotLevel, ')
          ..write('slotMax: $slotMax, ')
          ..write('slotCurrent: $slotCurrent')
          ..write(')'))
        .toString();
  }
}

class $CharacterResourcesTable extends CharacterResources
    with TableInfo<$CharacterResourcesTable, CharacterResource> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharacterResourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<int> characterId = GeneratedColumn<int>(
    'character_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES characters (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _resourceNameMeta = const VerificationMeta(
    'resourceName',
  );
  @override
  late final GeneratedColumn<String> resourceName = GeneratedColumn<String>(
    'resource_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentMeta = const VerificationMeta(
    'current',
  );
  @override
  late final GeneratedColumn<int> current = GeneratedColumn<int>(
    'current',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maximumMeta = const VerificationMeta(
    'maximum',
  );
  @override
  late final GeneratedColumn<int> maximum = GeneratedColumn<int>(
    'maximum',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    characterId,
    resourceName,
    current,
    maximum,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'character_resources';
  @override
  VerificationContext validateIntegrity(
    Insertable<CharacterResource> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('resource_name')) {
      context.handle(
        _resourceNameMeta,
        resourceName.isAcceptableOrUnknown(
          data['resource_name']!,
          _resourceNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_resourceNameMeta);
    }
    if (data.containsKey('current')) {
      context.handle(
        _currentMeta,
        current.isAcceptableOrUnknown(data['current']!, _currentMeta),
      );
    } else if (isInserting) {
      context.missing(_currentMeta);
    }
    if (data.containsKey('maximum')) {
      context.handle(
        _maximumMeta,
        maximum.isAcceptableOrUnknown(data['maximum']!, _maximumMeta),
      );
    } else if (isInserting) {
      context.missing(_maximumMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CharacterResource map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharacterResource(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}character_id'],
      )!,
      resourceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resource_name'],
      )!,
      current: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current'],
      )!,
      maximum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}maximum'],
      )!,
    );
  }

  @override
  $CharacterResourcesTable createAlias(String alias) {
    return $CharacterResourcesTable(attachedDatabase, alias);
  }
}

class CharacterResource extends DataClass
    implements Insertable<CharacterResource> {
  final int id;
  final int characterId;
  final String resourceName;
  final int current;
  final int maximum;
  const CharacterResource({
    required this.id,
    required this.characterId,
    required this.resourceName,
    required this.current,
    required this.maximum,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['character_id'] = Variable<int>(characterId);
    map['resource_name'] = Variable<String>(resourceName);
    map['current'] = Variable<int>(current);
    map['maximum'] = Variable<int>(maximum);
    return map;
  }

  CharacterResourcesCompanion toCompanion(bool nullToAbsent) {
    return CharacterResourcesCompanion(
      id: Value(id),
      characterId: Value(characterId),
      resourceName: Value(resourceName),
      current: Value(current),
      maximum: Value(maximum),
    );
  }

  factory CharacterResource.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharacterResource(
      id: serializer.fromJson<int>(json['id']),
      characterId: serializer.fromJson<int>(json['characterId']),
      resourceName: serializer.fromJson<String>(json['resourceName']),
      current: serializer.fromJson<int>(json['current']),
      maximum: serializer.fromJson<int>(json['maximum']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'characterId': serializer.toJson<int>(characterId),
      'resourceName': serializer.toJson<String>(resourceName),
      'current': serializer.toJson<int>(current),
      'maximum': serializer.toJson<int>(maximum),
    };
  }

  CharacterResource copyWith({
    int? id,
    int? characterId,
    String? resourceName,
    int? current,
    int? maximum,
  }) => CharacterResource(
    id: id ?? this.id,
    characterId: characterId ?? this.characterId,
    resourceName: resourceName ?? this.resourceName,
    current: current ?? this.current,
    maximum: maximum ?? this.maximum,
  );
  CharacterResource copyWithCompanion(CharacterResourcesCompanion data) {
    return CharacterResource(
      id: data.id.present ? data.id.value : this.id,
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      resourceName: data.resourceName.present
          ? data.resourceName.value
          : this.resourceName,
      current: data.current.present ? data.current.value : this.current,
      maximum: data.maximum.present ? data.maximum.value : this.maximum,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharacterResource(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('resourceName: $resourceName, ')
          ..write('current: $current, ')
          ..write('maximum: $maximum')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, characterId, resourceName, current, maximum);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharacterResource &&
          other.id == this.id &&
          other.characterId == this.characterId &&
          other.resourceName == this.resourceName &&
          other.current == this.current &&
          other.maximum == this.maximum);
}

class CharacterResourcesCompanion extends UpdateCompanion<CharacterResource> {
  final Value<int> id;
  final Value<int> characterId;
  final Value<String> resourceName;
  final Value<int> current;
  final Value<int> maximum;
  const CharacterResourcesCompanion({
    this.id = const Value.absent(),
    this.characterId = const Value.absent(),
    this.resourceName = const Value.absent(),
    this.current = const Value.absent(),
    this.maximum = const Value.absent(),
  });
  CharacterResourcesCompanion.insert({
    this.id = const Value.absent(),
    required int characterId,
    required String resourceName,
    required int current,
    required int maximum,
  }) : characterId = Value(characterId),
       resourceName = Value(resourceName),
       current = Value(current),
       maximum = Value(maximum);
  static Insertable<CharacterResource> custom({
    Expression<int>? id,
    Expression<int>? characterId,
    Expression<String>? resourceName,
    Expression<int>? current,
    Expression<int>? maximum,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (characterId != null) 'character_id': characterId,
      if (resourceName != null) 'resource_name': resourceName,
      if (current != null) 'current': current,
      if (maximum != null) 'maximum': maximum,
    });
  }

  CharacterResourcesCompanion copyWith({
    Value<int>? id,
    Value<int>? characterId,
    Value<String>? resourceName,
    Value<int>? current,
    Value<int>? maximum,
  }) {
    return CharacterResourcesCompanion(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      resourceName: resourceName ?? this.resourceName,
      current: current ?? this.current,
      maximum: maximum ?? this.maximum,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<int>(characterId.value);
    }
    if (resourceName.present) {
      map['resource_name'] = Variable<String>(resourceName.value);
    }
    if (current.present) {
      map['current'] = Variable<int>(current.value);
    }
    if (maximum.present) {
      map['maximum'] = Variable<int>(maximum.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharacterResourcesCompanion(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('resourceName: $resourceName, ')
          ..write('current: $current, ')
          ..write('maximum: $maximum')
          ..write(')'))
        .toString();
  }
}

class $CharacterAttacksTable extends CharacterAttacks
    with TableInfo<$CharacterAttacksTable, CharacterAttack> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharacterAttacksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<int> characterId = GeneratedColumn<int>(
    'character_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES characters (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attackBonusMeta = const VerificationMeta(
    'attackBonus',
  );
  @override
  late final GeneratedColumn<String> attackBonus = GeneratedColumn<String>(
    'attack_bonus',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _damageDiceMeta = const VerificationMeta(
    'damageDice',
  );
  @override
  late final GeneratedColumn<String> damageDice = GeneratedColumn<String>(
    'damage_dice',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _damageTypeMeta = const VerificationMeta(
    'damageType',
  );
  @override
  late final GeneratedColumn<String> damageType = GeneratedColumn<String>(
    'damage_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _masteryPropertyMeta = const VerificationMeta(
    'masteryProperty',
  );
  @override
  late final GeneratedColumn<String> masteryProperty = GeneratedColumn<String>(
    'mastery_property',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    characterId,
    name,
    attackBonus,
    damageDice,
    damageType,
    masteryProperty,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'character_attacks';
  @override
  VerificationContext validateIntegrity(
    Insertable<CharacterAttack> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('attack_bonus')) {
      context.handle(
        _attackBonusMeta,
        attackBonus.isAcceptableOrUnknown(
          data['attack_bonus']!,
          _attackBonusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_attackBonusMeta);
    }
    if (data.containsKey('damage_dice')) {
      context.handle(
        _damageDiceMeta,
        damageDice.isAcceptableOrUnknown(data['damage_dice']!, _damageDiceMeta),
      );
    } else if (isInserting) {
      context.missing(_damageDiceMeta);
    }
    if (data.containsKey('damage_type')) {
      context.handle(
        _damageTypeMeta,
        damageType.isAcceptableOrUnknown(data['damage_type']!, _damageTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_damageTypeMeta);
    }
    if (data.containsKey('mastery_property')) {
      context.handle(
        _masteryPropertyMeta,
        masteryProperty.isAcceptableOrUnknown(
          data['mastery_property']!,
          _masteryPropertyMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CharacterAttack map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharacterAttack(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}character_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      attackBonus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attack_bonus'],
      )!,
      damageDice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}damage_dice'],
      )!,
      damageType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}damage_type'],
      )!,
      masteryProperty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mastery_property'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
    );
  }

  @override
  $CharacterAttacksTable createAlias(String alias) {
    return $CharacterAttacksTable(attachedDatabase, alias);
  }
}

class CharacterAttack extends DataClass implements Insertable<CharacterAttack> {
  final int id;
  final int characterId;
  final String name;
  final String attackBonus;
  final String damageDice;
  final String damageType;
  final String? masteryProperty;
  final String notes;
  const CharacterAttack({
    required this.id,
    required this.characterId,
    required this.name,
    required this.attackBonus,
    required this.damageDice,
    required this.damageType,
    this.masteryProperty,
    required this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['character_id'] = Variable<int>(characterId);
    map['name'] = Variable<String>(name);
    map['attack_bonus'] = Variable<String>(attackBonus);
    map['damage_dice'] = Variable<String>(damageDice);
    map['damage_type'] = Variable<String>(damageType);
    if (!nullToAbsent || masteryProperty != null) {
      map['mastery_property'] = Variable<String>(masteryProperty);
    }
    map['notes'] = Variable<String>(notes);
    return map;
  }

  CharacterAttacksCompanion toCompanion(bool nullToAbsent) {
    return CharacterAttacksCompanion(
      id: Value(id),
      characterId: Value(characterId),
      name: Value(name),
      attackBonus: Value(attackBonus),
      damageDice: Value(damageDice),
      damageType: Value(damageType),
      masteryProperty: masteryProperty == null && nullToAbsent
          ? const Value.absent()
          : Value(masteryProperty),
      notes: Value(notes),
    );
  }

  factory CharacterAttack.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharacterAttack(
      id: serializer.fromJson<int>(json['id']),
      characterId: serializer.fromJson<int>(json['characterId']),
      name: serializer.fromJson<String>(json['name']),
      attackBonus: serializer.fromJson<String>(json['attackBonus']),
      damageDice: serializer.fromJson<String>(json['damageDice']),
      damageType: serializer.fromJson<String>(json['damageType']),
      masteryProperty: serializer.fromJson<String?>(json['masteryProperty']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'characterId': serializer.toJson<int>(characterId),
      'name': serializer.toJson<String>(name),
      'attackBonus': serializer.toJson<String>(attackBonus),
      'damageDice': serializer.toJson<String>(damageDice),
      'damageType': serializer.toJson<String>(damageType),
      'masteryProperty': serializer.toJson<String?>(masteryProperty),
      'notes': serializer.toJson<String>(notes),
    };
  }

  CharacterAttack copyWith({
    int? id,
    int? characterId,
    String? name,
    String? attackBonus,
    String? damageDice,
    String? damageType,
    Value<String?> masteryProperty = const Value.absent(),
    String? notes,
  }) => CharacterAttack(
    id: id ?? this.id,
    characterId: characterId ?? this.characterId,
    name: name ?? this.name,
    attackBonus: attackBonus ?? this.attackBonus,
    damageDice: damageDice ?? this.damageDice,
    damageType: damageType ?? this.damageType,
    masteryProperty: masteryProperty.present
        ? masteryProperty.value
        : this.masteryProperty,
    notes: notes ?? this.notes,
  );
  CharacterAttack copyWithCompanion(CharacterAttacksCompanion data) {
    return CharacterAttack(
      id: data.id.present ? data.id.value : this.id,
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      name: data.name.present ? data.name.value : this.name,
      attackBonus: data.attackBonus.present
          ? data.attackBonus.value
          : this.attackBonus,
      damageDice: data.damageDice.present
          ? data.damageDice.value
          : this.damageDice,
      damageType: data.damageType.present
          ? data.damageType.value
          : this.damageType,
      masteryProperty: data.masteryProperty.present
          ? data.masteryProperty.value
          : this.masteryProperty,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharacterAttack(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('name: $name, ')
          ..write('attackBonus: $attackBonus, ')
          ..write('damageDice: $damageDice, ')
          ..write('damageType: $damageType, ')
          ..write('masteryProperty: $masteryProperty, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    characterId,
    name,
    attackBonus,
    damageDice,
    damageType,
    masteryProperty,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharacterAttack &&
          other.id == this.id &&
          other.characterId == this.characterId &&
          other.name == this.name &&
          other.attackBonus == this.attackBonus &&
          other.damageDice == this.damageDice &&
          other.damageType == this.damageType &&
          other.masteryProperty == this.masteryProperty &&
          other.notes == this.notes);
}

class CharacterAttacksCompanion extends UpdateCompanion<CharacterAttack> {
  final Value<int> id;
  final Value<int> characterId;
  final Value<String> name;
  final Value<String> attackBonus;
  final Value<String> damageDice;
  final Value<String> damageType;
  final Value<String?> masteryProperty;
  final Value<String> notes;
  const CharacterAttacksCompanion({
    this.id = const Value.absent(),
    this.characterId = const Value.absent(),
    this.name = const Value.absent(),
    this.attackBonus = const Value.absent(),
    this.damageDice = const Value.absent(),
    this.damageType = const Value.absent(),
    this.masteryProperty = const Value.absent(),
    this.notes = const Value.absent(),
  });
  CharacterAttacksCompanion.insert({
    this.id = const Value.absent(),
    required int characterId,
    required String name,
    required String attackBonus,
    required String damageDice,
    required String damageType,
    this.masteryProperty = const Value.absent(),
    this.notes = const Value.absent(),
  }) : characterId = Value(characterId),
       name = Value(name),
       attackBonus = Value(attackBonus),
       damageDice = Value(damageDice),
       damageType = Value(damageType);
  static Insertable<CharacterAttack> custom({
    Expression<int>? id,
    Expression<int>? characterId,
    Expression<String>? name,
    Expression<String>? attackBonus,
    Expression<String>? damageDice,
    Expression<String>? damageType,
    Expression<String>? masteryProperty,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (characterId != null) 'character_id': characterId,
      if (name != null) 'name': name,
      if (attackBonus != null) 'attack_bonus': attackBonus,
      if (damageDice != null) 'damage_dice': damageDice,
      if (damageType != null) 'damage_type': damageType,
      if (masteryProperty != null) 'mastery_property': masteryProperty,
      if (notes != null) 'notes': notes,
    });
  }

  CharacterAttacksCompanion copyWith({
    Value<int>? id,
    Value<int>? characterId,
    Value<String>? name,
    Value<String>? attackBonus,
    Value<String>? damageDice,
    Value<String>? damageType,
    Value<String?>? masteryProperty,
    Value<String>? notes,
  }) {
    return CharacterAttacksCompanion(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      name: name ?? this.name,
      attackBonus: attackBonus ?? this.attackBonus,
      damageDice: damageDice ?? this.damageDice,
      damageType: damageType ?? this.damageType,
      masteryProperty: masteryProperty ?? this.masteryProperty,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<int>(characterId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (attackBonus.present) {
      map['attack_bonus'] = Variable<String>(attackBonus.value);
    }
    if (damageDice.present) {
      map['damage_dice'] = Variable<String>(damageDice.value);
    }
    if (damageType.present) {
      map['damage_type'] = Variable<String>(damageType.value);
    }
    if (masteryProperty.present) {
      map['mastery_property'] = Variable<String>(masteryProperty.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharacterAttacksCompanion(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('name: $name, ')
          ..write('attackBonus: $attackBonus, ')
          ..write('damageDice: $damageDice, ')
          ..write('damageType: $damageType, ')
          ..write('masteryProperty: $masteryProperty, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $CharacterEquipmentTable extends CharacterEquipment
    with TableInfo<$CharacterEquipmentTable, CharacterEquipmentData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharacterEquipmentTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<int> characterId = GeneratedColumn<int>(
    'character_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES characters (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _itemNameMeta = const VerificationMeta(
    'itemName',
  );
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
    'item_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _equippedMeta = const VerificationMeta(
    'equipped',
  );
  @override
  late final GeneratedColumn<bool> equipped = GeneratedColumn<bool>(
    'equipped',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("equipped" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _attunedMeta = const VerificationMeta(
    'attuned',
  );
  @override
  late final GeneratedColumn<bool> attuned = GeneratedColumn<bool>(
    'attuned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("attuned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    characterId,
    itemName,
    quantity,
    weight,
    equipped,
    attuned,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'character_equipment';
  @override
  VerificationContext validateIntegrity(
    Insertable<CharacterEquipmentData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('item_name')) {
      context.handle(
        _itemNameMeta,
        itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta),
      );
    } else if (isInserting) {
      context.missing(_itemNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    }
    if (data.containsKey('equipped')) {
      context.handle(
        _equippedMeta,
        equipped.isAcceptableOrUnknown(data['equipped']!, _equippedMeta),
      );
    }
    if (data.containsKey('attuned')) {
      context.handle(
        _attunedMeta,
        attuned.isAcceptableOrUnknown(data['attuned']!, _attunedMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CharacterEquipmentData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharacterEquipmentData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}character_id'],
      )!,
      itemName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      )!,
      equipped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}equipped'],
      )!,
      attuned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}attuned'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
    );
  }

  @override
  $CharacterEquipmentTable createAlias(String alias) {
    return $CharacterEquipmentTable(attachedDatabase, alias);
  }
}

class CharacterEquipmentData extends DataClass
    implements Insertable<CharacterEquipmentData> {
  final int id;
  final int characterId;
  final String itemName;
  final int quantity;
  final double weight;
  final bool equipped;
  final bool attuned;
  final String notes;
  const CharacterEquipmentData({
    required this.id,
    required this.characterId,
    required this.itemName,
    required this.quantity,
    required this.weight,
    required this.equipped,
    required this.attuned,
    required this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['character_id'] = Variable<int>(characterId);
    map['item_name'] = Variable<String>(itemName);
    map['quantity'] = Variable<int>(quantity);
    map['weight'] = Variable<double>(weight);
    map['equipped'] = Variable<bool>(equipped);
    map['attuned'] = Variable<bool>(attuned);
    map['notes'] = Variable<String>(notes);
    return map;
  }

  CharacterEquipmentCompanion toCompanion(bool nullToAbsent) {
    return CharacterEquipmentCompanion(
      id: Value(id),
      characterId: Value(characterId),
      itemName: Value(itemName),
      quantity: Value(quantity),
      weight: Value(weight),
      equipped: Value(equipped),
      attuned: Value(attuned),
      notes: Value(notes),
    );
  }

  factory CharacterEquipmentData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharacterEquipmentData(
      id: serializer.fromJson<int>(json['id']),
      characterId: serializer.fromJson<int>(json['characterId']),
      itemName: serializer.fromJson<String>(json['itemName']),
      quantity: serializer.fromJson<int>(json['quantity']),
      weight: serializer.fromJson<double>(json['weight']),
      equipped: serializer.fromJson<bool>(json['equipped']),
      attuned: serializer.fromJson<bool>(json['attuned']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'characterId': serializer.toJson<int>(characterId),
      'itemName': serializer.toJson<String>(itemName),
      'quantity': serializer.toJson<int>(quantity),
      'weight': serializer.toJson<double>(weight),
      'equipped': serializer.toJson<bool>(equipped),
      'attuned': serializer.toJson<bool>(attuned),
      'notes': serializer.toJson<String>(notes),
    };
  }

  CharacterEquipmentData copyWith({
    int? id,
    int? characterId,
    String? itemName,
    int? quantity,
    double? weight,
    bool? equipped,
    bool? attuned,
    String? notes,
  }) => CharacterEquipmentData(
    id: id ?? this.id,
    characterId: characterId ?? this.characterId,
    itemName: itemName ?? this.itemName,
    quantity: quantity ?? this.quantity,
    weight: weight ?? this.weight,
    equipped: equipped ?? this.equipped,
    attuned: attuned ?? this.attuned,
    notes: notes ?? this.notes,
  );
  CharacterEquipmentData copyWithCompanion(CharacterEquipmentCompanion data) {
    return CharacterEquipmentData(
      id: data.id.present ? data.id.value : this.id,
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      weight: data.weight.present ? data.weight.value : this.weight,
      equipped: data.equipped.present ? data.equipped.value : this.equipped,
      attuned: data.attuned.present ? data.attuned.value : this.attuned,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharacterEquipmentData(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('itemName: $itemName, ')
          ..write('quantity: $quantity, ')
          ..write('weight: $weight, ')
          ..write('equipped: $equipped, ')
          ..write('attuned: $attuned, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    characterId,
    itemName,
    quantity,
    weight,
    equipped,
    attuned,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharacterEquipmentData &&
          other.id == this.id &&
          other.characterId == this.characterId &&
          other.itemName == this.itemName &&
          other.quantity == this.quantity &&
          other.weight == this.weight &&
          other.equipped == this.equipped &&
          other.attuned == this.attuned &&
          other.notes == this.notes);
}

class CharacterEquipmentCompanion
    extends UpdateCompanion<CharacterEquipmentData> {
  final Value<int> id;
  final Value<int> characterId;
  final Value<String> itemName;
  final Value<int> quantity;
  final Value<double> weight;
  final Value<bool> equipped;
  final Value<bool> attuned;
  final Value<String> notes;
  const CharacterEquipmentCompanion({
    this.id = const Value.absent(),
    this.characterId = const Value.absent(),
    this.itemName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.weight = const Value.absent(),
    this.equipped = const Value.absent(),
    this.attuned = const Value.absent(),
    this.notes = const Value.absent(),
  });
  CharacterEquipmentCompanion.insert({
    this.id = const Value.absent(),
    required int characterId,
    required String itemName,
    this.quantity = const Value.absent(),
    this.weight = const Value.absent(),
    this.equipped = const Value.absent(),
    this.attuned = const Value.absent(),
    this.notes = const Value.absent(),
  }) : characterId = Value(characterId),
       itemName = Value(itemName);
  static Insertable<CharacterEquipmentData> custom({
    Expression<int>? id,
    Expression<int>? characterId,
    Expression<String>? itemName,
    Expression<int>? quantity,
    Expression<double>? weight,
    Expression<bool>? equipped,
    Expression<bool>? attuned,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (characterId != null) 'character_id': characterId,
      if (itemName != null) 'item_name': itemName,
      if (quantity != null) 'quantity': quantity,
      if (weight != null) 'weight': weight,
      if (equipped != null) 'equipped': equipped,
      if (attuned != null) 'attuned': attuned,
      if (notes != null) 'notes': notes,
    });
  }

  CharacterEquipmentCompanion copyWith({
    Value<int>? id,
    Value<int>? characterId,
    Value<String>? itemName,
    Value<int>? quantity,
    Value<double>? weight,
    Value<bool>? equipped,
    Value<bool>? attuned,
    Value<String>? notes,
  }) {
    return CharacterEquipmentCompanion(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      weight: weight ?? this.weight,
      equipped: equipped ?? this.equipped,
      attuned: attuned ?? this.attuned,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<int>(characterId.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (equipped.present) {
      map['equipped'] = Variable<bool>(equipped.value);
    }
    if (attuned.present) {
      map['attuned'] = Variable<bool>(attuned.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharacterEquipmentCompanion(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('itemName: $itemName, ')
          ..write('quantity: $quantity, ')
          ..write('weight: $weight, ')
          ..write('equipped: $equipped, ')
          ..write('attuned: $attuned, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $BatmanCharactersTable extends BatmanCharacters
    with TableInfo<$BatmanCharactersTable, BatmanCharacter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BatmanCharactersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<int> characterId = GeneratedColumn<int>(
    'character_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES characters (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _secretIdentityMeta = const VerificationMeta(
    'secretIdentity',
  );
  @override
  late final GeneratedColumn<String> secretIdentity = GeneratedColumn<String>(
    'secret_identity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _forceMeta = const VerificationMeta('force');
  @override
  late final GeneratedColumn<int> force = GeneratedColumn<int>(
    'force',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(8),
  );
  static const VerificationMeta _constitutionMeta = const VerificationMeta(
    'constitution',
  );
  @override
  late final GeneratedColumn<int> constitution = GeneratedColumn<int>(
    'constitution',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(8),
  );
  static const VerificationMeta _dexteriteMeta = const VerificationMeta(
    'dexterite',
  );
  @override
  late final GeneratedColumn<int> dexterite = GeneratedColumn<int>(
    'dexterite',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(8),
  );
  static const VerificationMeta _intelligenceMeta = const VerificationMeta(
    'intelligence',
  );
  @override
  late final GeneratedColumn<int> intelligence = GeneratedColumn<int>(
    'intelligence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(8),
  );
  static const VerificationMeta _perceptionMeta = const VerificationMeta(
    'perception',
  );
  @override
  late final GeneratedColumn<int> perception = GeneratedColumn<int>(
    'perception',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(8),
  );
  static const VerificationMeta _volonteMeta = const VerificationMeta(
    'volonte',
  );
  @override
  late final GeneratedColumn<int> volonte = GeneratedColumn<int>(
    'volonte',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(8),
  );
  static const VerificationMeta _atcTotalMeta = const VerificationMeta(
    'atcTotal',
  );
  @override
  late final GeneratedColumn<int> atcTotal = GeneratedColumn<int>(
    'atc_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _atdTotalMeta = const VerificationMeta(
    'atdTotal',
  );
  @override
  late final GeneratedColumn<int> atdTotal = GeneratedColumn<int>(
    'atd_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _defenseMeta = const VerificationMeta(
    'defense',
  );
  @override
  late final GeneratedColumn<int> defense = GeneratedColumn<int>(
    'defense',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _initiativeMeta = const VerificationMeta(
    'initiative',
  );
  @override
  late final GeneratedColumn<int> initiative = GeneratedColumn<int>(
    'initiative',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _exploitPointsCurrentMeta =
      const VerificationMeta('exploitPointsCurrent');
  @override
  late final GeneratedColumn<int> exploitPointsCurrent = GeneratedColumn<int>(
    'exploit_points_current',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _exploitPointsMaxMeta = const VerificationMeta(
    'exploitPointsMax',
  );
  @override
  late final GeneratedColumn<int> exploitPointsMax = GeneratedColumn<int>(
    'exploit_points_max',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ethicsOrderMeta = const VerificationMeta(
    'ethicsOrder',
  );
  @override
  late final GeneratedColumn<int> ethicsOrder = GeneratedColumn<int>(
    'ethics_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ethicsJusticeMeta = const VerificationMeta(
    'ethicsJustice',
  );
  @override
  late final GeneratedColumn<int> ethicsJustice = GeneratedColumn<int>(
    'ethics_justice',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ethicsAnarchyMeta = const VerificationMeta(
    'ethicsAnarchy',
  );
  @override
  late final GeneratedColumn<int> ethicsAnarchy = GeneratedColumn<int>(
    'ethics_anarchy',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ethicsCrimeMeta = const VerificationMeta(
    'ethicsCrime',
  );
  @override
  late final GeneratedColumn<int> ethicsCrime = GeneratedColumn<int>(
    'ethics_crime',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _livingStandardMeta = const VerificationMeta(
    'livingStandard',
  );
  @override
  late final GeneratedColumn<String> livingStandard = GeneratedColumn<String>(
    'living_standard',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('modeste'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    characterId,
    profileId,
    secretIdentity,
    mode,
    force,
    constitution,
    dexterite,
    intelligence,
    perception,
    volonte,
    atcTotal,
    atdTotal,
    defense,
    initiative,
    exploitPointsCurrent,
    exploitPointsMax,
    ethicsOrder,
    ethicsJustice,
    ethicsAnarchy,
    ethicsCrime,
    livingStandard,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'batman_characters';
  @override
  VerificationContext validateIntegrity(
    Insertable<BatmanCharacter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('secret_identity')) {
      context.handle(
        _secretIdentityMeta,
        secretIdentity.isAcceptableOrUnknown(
          data['secret_identity']!,
          _secretIdentityMeta,
        ),
      );
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    }
    if (data.containsKey('force')) {
      context.handle(
        _forceMeta,
        force.isAcceptableOrUnknown(data['force']!, _forceMeta),
      );
    }
    if (data.containsKey('constitution')) {
      context.handle(
        _constitutionMeta,
        constitution.isAcceptableOrUnknown(
          data['constitution']!,
          _constitutionMeta,
        ),
      );
    }
    if (data.containsKey('dexterite')) {
      context.handle(
        _dexteriteMeta,
        dexterite.isAcceptableOrUnknown(data['dexterite']!, _dexteriteMeta),
      );
    }
    if (data.containsKey('intelligence')) {
      context.handle(
        _intelligenceMeta,
        intelligence.isAcceptableOrUnknown(
          data['intelligence']!,
          _intelligenceMeta,
        ),
      );
    }
    if (data.containsKey('perception')) {
      context.handle(
        _perceptionMeta,
        perception.isAcceptableOrUnknown(data['perception']!, _perceptionMeta),
      );
    }
    if (data.containsKey('volonte')) {
      context.handle(
        _volonteMeta,
        volonte.isAcceptableOrUnknown(data['volonte']!, _volonteMeta),
      );
    }
    if (data.containsKey('atc_total')) {
      context.handle(
        _atcTotalMeta,
        atcTotal.isAcceptableOrUnknown(data['atc_total']!, _atcTotalMeta),
      );
    }
    if (data.containsKey('atd_total')) {
      context.handle(
        _atdTotalMeta,
        atdTotal.isAcceptableOrUnknown(data['atd_total']!, _atdTotalMeta),
      );
    }
    if (data.containsKey('defense')) {
      context.handle(
        _defenseMeta,
        defense.isAcceptableOrUnknown(data['defense']!, _defenseMeta),
      );
    }
    if (data.containsKey('initiative')) {
      context.handle(
        _initiativeMeta,
        initiative.isAcceptableOrUnknown(data['initiative']!, _initiativeMeta),
      );
    }
    if (data.containsKey('exploit_points_current')) {
      context.handle(
        _exploitPointsCurrentMeta,
        exploitPointsCurrent.isAcceptableOrUnknown(
          data['exploit_points_current']!,
          _exploitPointsCurrentMeta,
        ),
      );
    }
    if (data.containsKey('exploit_points_max')) {
      context.handle(
        _exploitPointsMaxMeta,
        exploitPointsMax.isAcceptableOrUnknown(
          data['exploit_points_max']!,
          _exploitPointsMaxMeta,
        ),
      );
    }
    if (data.containsKey('ethics_order')) {
      context.handle(
        _ethicsOrderMeta,
        ethicsOrder.isAcceptableOrUnknown(
          data['ethics_order']!,
          _ethicsOrderMeta,
        ),
      );
    }
    if (data.containsKey('ethics_justice')) {
      context.handle(
        _ethicsJusticeMeta,
        ethicsJustice.isAcceptableOrUnknown(
          data['ethics_justice']!,
          _ethicsJusticeMeta,
        ),
      );
    }
    if (data.containsKey('ethics_anarchy')) {
      context.handle(
        _ethicsAnarchyMeta,
        ethicsAnarchy.isAcceptableOrUnknown(
          data['ethics_anarchy']!,
          _ethicsAnarchyMeta,
        ),
      );
    }
    if (data.containsKey('ethics_crime')) {
      context.handle(
        _ethicsCrimeMeta,
        ethicsCrime.isAcceptableOrUnknown(
          data['ethics_crime']!,
          _ethicsCrimeMeta,
        ),
      );
    }
    if (data.containsKey('living_standard')) {
      context.handle(
        _livingStandardMeta,
        livingStandard.isAcceptableOrUnknown(
          data['living_standard']!,
          _livingStandardMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BatmanCharacter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BatmanCharacter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}character_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      secretIdentity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secret_identity'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      force: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}force'],
      )!,
      constitution: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}constitution'],
      )!,
      dexterite: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dexterite'],
      )!,
      intelligence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intelligence'],
      )!,
      perception: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}perception'],
      )!,
      volonte: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}volonte'],
      )!,
      atcTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}atc_total'],
      )!,
      atdTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}atd_total'],
      )!,
      defense: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}defense'],
      )!,
      initiative: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}initiative'],
      )!,
      exploitPointsCurrent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exploit_points_current'],
      )!,
      exploitPointsMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exploit_points_max'],
      )!,
      ethicsOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ethics_order'],
      )!,
      ethicsJustice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ethics_justice'],
      )!,
      ethicsAnarchy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ethics_anarchy'],
      )!,
      ethicsCrime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ethics_crime'],
      )!,
      livingStandard: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}living_standard'],
      )!,
    );
  }

  @override
  $BatmanCharactersTable createAlias(String alias) {
    return $BatmanCharactersTable(attachedDatabase, alias);
  }
}

class BatmanCharacter extends DataClass implements Insertable<BatmanCharacter> {
  final int id;
  final int characterId;
  final String profileId;
  final String secretIdentity;
  final String mode;
  final int force;
  final int constitution;
  final int dexterite;
  final int intelligence;
  final int perception;
  final int volonte;
  final int atcTotal;
  final int atdTotal;
  final int defense;
  final int initiative;
  final int exploitPointsCurrent;
  final int exploitPointsMax;
  final int ethicsOrder;
  final int ethicsJustice;
  final int ethicsAnarchy;
  final int ethicsCrime;
  final String livingStandard;
  const BatmanCharacter({
    required this.id,
    required this.characterId,
    required this.profileId,
    required this.secretIdentity,
    required this.mode,
    required this.force,
    required this.constitution,
    required this.dexterite,
    required this.intelligence,
    required this.perception,
    required this.volonte,
    required this.atcTotal,
    required this.atdTotal,
    required this.defense,
    required this.initiative,
    required this.exploitPointsCurrent,
    required this.exploitPointsMax,
    required this.ethicsOrder,
    required this.ethicsJustice,
    required this.ethicsAnarchy,
    required this.ethicsCrime,
    required this.livingStandard,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['character_id'] = Variable<int>(characterId);
    map['profile_id'] = Variable<String>(profileId);
    map['secret_identity'] = Variable<String>(secretIdentity);
    map['mode'] = Variable<String>(mode);
    map['force'] = Variable<int>(force);
    map['constitution'] = Variable<int>(constitution);
    map['dexterite'] = Variable<int>(dexterite);
    map['intelligence'] = Variable<int>(intelligence);
    map['perception'] = Variable<int>(perception);
    map['volonte'] = Variable<int>(volonte);
    map['atc_total'] = Variable<int>(atcTotal);
    map['atd_total'] = Variable<int>(atdTotal);
    map['defense'] = Variable<int>(defense);
    map['initiative'] = Variable<int>(initiative);
    map['exploit_points_current'] = Variable<int>(exploitPointsCurrent);
    map['exploit_points_max'] = Variable<int>(exploitPointsMax);
    map['ethics_order'] = Variable<int>(ethicsOrder);
    map['ethics_justice'] = Variable<int>(ethicsJustice);
    map['ethics_anarchy'] = Variable<int>(ethicsAnarchy);
    map['ethics_crime'] = Variable<int>(ethicsCrime);
    map['living_standard'] = Variable<String>(livingStandard);
    return map;
  }

  BatmanCharactersCompanion toCompanion(bool nullToAbsent) {
    return BatmanCharactersCompanion(
      id: Value(id),
      characterId: Value(characterId),
      profileId: Value(profileId),
      secretIdentity: Value(secretIdentity),
      mode: Value(mode),
      force: Value(force),
      constitution: Value(constitution),
      dexterite: Value(dexterite),
      intelligence: Value(intelligence),
      perception: Value(perception),
      volonte: Value(volonte),
      atcTotal: Value(atcTotal),
      atdTotal: Value(atdTotal),
      defense: Value(defense),
      initiative: Value(initiative),
      exploitPointsCurrent: Value(exploitPointsCurrent),
      exploitPointsMax: Value(exploitPointsMax),
      ethicsOrder: Value(ethicsOrder),
      ethicsJustice: Value(ethicsJustice),
      ethicsAnarchy: Value(ethicsAnarchy),
      ethicsCrime: Value(ethicsCrime),
      livingStandard: Value(livingStandard),
    );
  }

  factory BatmanCharacter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BatmanCharacter(
      id: serializer.fromJson<int>(json['id']),
      characterId: serializer.fromJson<int>(json['characterId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      secretIdentity: serializer.fromJson<String>(json['secretIdentity']),
      mode: serializer.fromJson<String>(json['mode']),
      force: serializer.fromJson<int>(json['force']),
      constitution: serializer.fromJson<int>(json['constitution']),
      dexterite: serializer.fromJson<int>(json['dexterite']),
      intelligence: serializer.fromJson<int>(json['intelligence']),
      perception: serializer.fromJson<int>(json['perception']),
      volonte: serializer.fromJson<int>(json['volonte']),
      atcTotal: serializer.fromJson<int>(json['atcTotal']),
      atdTotal: serializer.fromJson<int>(json['atdTotal']),
      defense: serializer.fromJson<int>(json['defense']),
      initiative: serializer.fromJson<int>(json['initiative']),
      exploitPointsCurrent: serializer.fromJson<int>(
        json['exploitPointsCurrent'],
      ),
      exploitPointsMax: serializer.fromJson<int>(json['exploitPointsMax']),
      ethicsOrder: serializer.fromJson<int>(json['ethicsOrder']),
      ethicsJustice: serializer.fromJson<int>(json['ethicsJustice']),
      ethicsAnarchy: serializer.fromJson<int>(json['ethicsAnarchy']),
      ethicsCrime: serializer.fromJson<int>(json['ethicsCrime']),
      livingStandard: serializer.fromJson<String>(json['livingStandard']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'characterId': serializer.toJson<int>(characterId),
      'profileId': serializer.toJson<String>(profileId),
      'secretIdentity': serializer.toJson<String>(secretIdentity),
      'mode': serializer.toJson<String>(mode),
      'force': serializer.toJson<int>(force),
      'constitution': serializer.toJson<int>(constitution),
      'dexterite': serializer.toJson<int>(dexterite),
      'intelligence': serializer.toJson<int>(intelligence),
      'perception': serializer.toJson<int>(perception),
      'volonte': serializer.toJson<int>(volonte),
      'atcTotal': serializer.toJson<int>(atcTotal),
      'atdTotal': serializer.toJson<int>(atdTotal),
      'defense': serializer.toJson<int>(defense),
      'initiative': serializer.toJson<int>(initiative),
      'exploitPointsCurrent': serializer.toJson<int>(exploitPointsCurrent),
      'exploitPointsMax': serializer.toJson<int>(exploitPointsMax),
      'ethicsOrder': serializer.toJson<int>(ethicsOrder),
      'ethicsJustice': serializer.toJson<int>(ethicsJustice),
      'ethicsAnarchy': serializer.toJson<int>(ethicsAnarchy),
      'ethicsCrime': serializer.toJson<int>(ethicsCrime),
      'livingStandard': serializer.toJson<String>(livingStandard),
    };
  }

  BatmanCharacter copyWith({
    int? id,
    int? characterId,
    String? profileId,
    String? secretIdentity,
    String? mode,
    int? force,
    int? constitution,
    int? dexterite,
    int? intelligence,
    int? perception,
    int? volonte,
    int? atcTotal,
    int? atdTotal,
    int? defense,
    int? initiative,
    int? exploitPointsCurrent,
    int? exploitPointsMax,
    int? ethicsOrder,
    int? ethicsJustice,
    int? ethicsAnarchy,
    int? ethicsCrime,
    String? livingStandard,
  }) => BatmanCharacter(
    id: id ?? this.id,
    characterId: characterId ?? this.characterId,
    profileId: profileId ?? this.profileId,
    secretIdentity: secretIdentity ?? this.secretIdentity,
    mode: mode ?? this.mode,
    force: force ?? this.force,
    constitution: constitution ?? this.constitution,
    dexterite: dexterite ?? this.dexterite,
    intelligence: intelligence ?? this.intelligence,
    perception: perception ?? this.perception,
    volonte: volonte ?? this.volonte,
    atcTotal: atcTotal ?? this.atcTotal,
    atdTotal: atdTotal ?? this.atdTotal,
    defense: defense ?? this.defense,
    initiative: initiative ?? this.initiative,
    exploitPointsCurrent: exploitPointsCurrent ?? this.exploitPointsCurrent,
    exploitPointsMax: exploitPointsMax ?? this.exploitPointsMax,
    ethicsOrder: ethicsOrder ?? this.ethicsOrder,
    ethicsJustice: ethicsJustice ?? this.ethicsJustice,
    ethicsAnarchy: ethicsAnarchy ?? this.ethicsAnarchy,
    ethicsCrime: ethicsCrime ?? this.ethicsCrime,
    livingStandard: livingStandard ?? this.livingStandard,
  );
  BatmanCharacter copyWithCompanion(BatmanCharactersCompanion data) {
    return BatmanCharacter(
      id: data.id.present ? data.id.value : this.id,
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      secretIdentity: data.secretIdentity.present
          ? data.secretIdentity.value
          : this.secretIdentity,
      mode: data.mode.present ? data.mode.value : this.mode,
      force: data.force.present ? data.force.value : this.force,
      constitution: data.constitution.present
          ? data.constitution.value
          : this.constitution,
      dexterite: data.dexterite.present ? data.dexterite.value : this.dexterite,
      intelligence: data.intelligence.present
          ? data.intelligence.value
          : this.intelligence,
      perception: data.perception.present
          ? data.perception.value
          : this.perception,
      volonte: data.volonte.present ? data.volonte.value : this.volonte,
      atcTotal: data.atcTotal.present ? data.atcTotal.value : this.atcTotal,
      atdTotal: data.atdTotal.present ? data.atdTotal.value : this.atdTotal,
      defense: data.defense.present ? data.defense.value : this.defense,
      initiative: data.initiative.present
          ? data.initiative.value
          : this.initiative,
      exploitPointsCurrent: data.exploitPointsCurrent.present
          ? data.exploitPointsCurrent.value
          : this.exploitPointsCurrent,
      exploitPointsMax: data.exploitPointsMax.present
          ? data.exploitPointsMax.value
          : this.exploitPointsMax,
      ethicsOrder: data.ethicsOrder.present
          ? data.ethicsOrder.value
          : this.ethicsOrder,
      ethicsJustice: data.ethicsJustice.present
          ? data.ethicsJustice.value
          : this.ethicsJustice,
      ethicsAnarchy: data.ethicsAnarchy.present
          ? data.ethicsAnarchy.value
          : this.ethicsAnarchy,
      ethicsCrime: data.ethicsCrime.present
          ? data.ethicsCrime.value
          : this.ethicsCrime,
      livingStandard: data.livingStandard.present
          ? data.livingStandard.value
          : this.livingStandard,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BatmanCharacter(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('profileId: $profileId, ')
          ..write('secretIdentity: $secretIdentity, ')
          ..write('mode: $mode, ')
          ..write('force: $force, ')
          ..write('constitution: $constitution, ')
          ..write('dexterite: $dexterite, ')
          ..write('intelligence: $intelligence, ')
          ..write('perception: $perception, ')
          ..write('volonte: $volonte, ')
          ..write('atcTotal: $atcTotal, ')
          ..write('atdTotal: $atdTotal, ')
          ..write('defense: $defense, ')
          ..write('initiative: $initiative, ')
          ..write('exploitPointsCurrent: $exploitPointsCurrent, ')
          ..write('exploitPointsMax: $exploitPointsMax, ')
          ..write('ethicsOrder: $ethicsOrder, ')
          ..write('ethicsJustice: $ethicsJustice, ')
          ..write('ethicsAnarchy: $ethicsAnarchy, ')
          ..write('ethicsCrime: $ethicsCrime, ')
          ..write('livingStandard: $livingStandard')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    characterId,
    profileId,
    secretIdentity,
    mode,
    force,
    constitution,
    dexterite,
    intelligence,
    perception,
    volonte,
    atcTotal,
    atdTotal,
    defense,
    initiative,
    exploitPointsCurrent,
    exploitPointsMax,
    ethicsOrder,
    ethicsJustice,
    ethicsAnarchy,
    ethicsCrime,
    livingStandard,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BatmanCharacter &&
          other.id == this.id &&
          other.characterId == this.characterId &&
          other.profileId == this.profileId &&
          other.secretIdentity == this.secretIdentity &&
          other.mode == this.mode &&
          other.force == this.force &&
          other.constitution == this.constitution &&
          other.dexterite == this.dexterite &&
          other.intelligence == this.intelligence &&
          other.perception == this.perception &&
          other.volonte == this.volonte &&
          other.atcTotal == this.atcTotal &&
          other.atdTotal == this.atdTotal &&
          other.defense == this.defense &&
          other.initiative == this.initiative &&
          other.exploitPointsCurrent == this.exploitPointsCurrent &&
          other.exploitPointsMax == this.exploitPointsMax &&
          other.ethicsOrder == this.ethicsOrder &&
          other.ethicsJustice == this.ethicsJustice &&
          other.ethicsAnarchy == this.ethicsAnarchy &&
          other.ethicsCrime == this.ethicsCrime &&
          other.livingStandard == this.livingStandard);
}

class BatmanCharactersCompanion extends UpdateCompanion<BatmanCharacter> {
  final Value<int> id;
  final Value<int> characterId;
  final Value<String> profileId;
  final Value<String> secretIdentity;
  final Value<String> mode;
  final Value<int> force;
  final Value<int> constitution;
  final Value<int> dexterite;
  final Value<int> intelligence;
  final Value<int> perception;
  final Value<int> volonte;
  final Value<int> atcTotal;
  final Value<int> atdTotal;
  final Value<int> defense;
  final Value<int> initiative;
  final Value<int> exploitPointsCurrent;
  final Value<int> exploitPointsMax;
  final Value<int> ethicsOrder;
  final Value<int> ethicsJustice;
  final Value<int> ethicsAnarchy;
  final Value<int> ethicsCrime;
  final Value<String> livingStandard;
  const BatmanCharactersCompanion({
    this.id = const Value.absent(),
    this.characterId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.secretIdentity = const Value.absent(),
    this.mode = const Value.absent(),
    this.force = const Value.absent(),
    this.constitution = const Value.absent(),
    this.dexterite = const Value.absent(),
    this.intelligence = const Value.absent(),
    this.perception = const Value.absent(),
    this.volonte = const Value.absent(),
    this.atcTotal = const Value.absent(),
    this.atdTotal = const Value.absent(),
    this.defense = const Value.absent(),
    this.initiative = const Value.absent(),
    this.exploitPointsCurrent = const Value.absent(),
    this.exploitPointsMax = const Value.absent(),
    this.ethicsOrder = const Value.absent(),
    this.ethicsJustice = const Value.absent(),
    this.ethicsAnarchy = const Value.absent(),
    this.ethicsCrime = const Value.absent(),
    this.livingStandard = const Value.absent(),
  });
  BatmanCharactersCompanion.insert({
    this.id = const Value.absent(),
    required int characterId,
    required String profileId,
    this.secretIdentity = const Value.absent(),
    this.mode = const Value.absent(),
    this.force = const Value.absent(),
    this.constitution = const Value.absent(),
    this.dexterite = const Value.absent(),
    this.intelligence = const Value.absent(),
    this.perception = const Value.absent(),
    this.volonte = const Value.absent(),
    this.atcTotal = const Value.absent(),
    this.atdTotal = const Value.absent(),
    this.defense = const Value.absent(),
    this.initiative = const Value.absent(),
    this.exploitPointsCurrent = const Value.absent(),
    this.exploitPointsMax = const Value.absent(),
    this.ethicsOrder = const Value.absent(),
    this.ethicsJustice = const Value.absent(),
    this.ethicsAnarchy = const Value.absent(),
    this.ethicsCrime = const Value.absent(),
    this.livingStandard = const Value.absent(),
  }) : characterId = Value(characterId),
       profileId = Value(profileId);
  static Insertable<BatmanCharacter> custom({
    Expression<int>? id,
    Expression<int>? characterId,
    Expression<String>? profileId,
    Expression<String>? secretIdentity,
    Expression<String>? mode,
    Expression<int>? force,
    Expression<int>? constitution,
    Expression<int>? dexterite,
    Expression<int>? intelligence,
    Expression<int>? perception,
    Expression<int>? volonte,
    Expression<int>? atcTotal,
    Expression<int>? atdTotal,
    Expression<int>? defense,
    Expression<int>? initiative,
    Expression<int>? exploitPointsCurrent,
    Expression<int>? exploitPointsMax,
    Expression<int>? ethicsOrder,
    Expression<int>? ethicsJustice,
    Expression<int>? ethicsAnarchy,
    Expression<int>? ethicsCrime,
    Expression<String>? livingStandard,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (characterId != null) 'character_id': characterId,
      if (profileId != null) 'profile_id': profileId,
      if (secretIdentity != null) 'secret_identity': secretIdentity,
      if (mode != null) 'mode': mode,
      if (force != null) 'force': force,
      if (constitution != null) 'constitution': constitution,
      if (dexterite != null) 'dexterite': dexterite,
      if (intelligence != null) 'intelligence': intelligence,
      if (perception != null) 'perception': perception,
      if (volonte != null) 'volonte': volonte,
      if (atcTotal != null) 'atc_total': atcTotal,
      if (atdTotal != null) 'atd_total': atdTotal,
      if (defense != null) 'defense': defense,
      if (initiative != null) 'initiative': initiative,
      if (exploitPointsCurrent != null)
        'exploit_points_current': exploitPointsCurrent,
      if (exploitPointsMax != null) 'exploit_points_max': exploitPointsMax,
      if (ethicsOrder != null) 'ethics_order': ethicsOrder,
      if (ethicsJustice != null) 'ethics_justice': ethicsJustice,
      if (ethicsAnarchy != null) 'ethics_anarchy': ethicsAnarchy,
      if (ethicsCrime != null) 'ethics_crime': ethicsCrime,
      if (livingStandard != null) 'living_standard': livingStandard,
    });
  }

  BatmanCharactersCompanion copyWith({
    Value<int>? id,
    Value<int>? characterId,
    Value<String>? profileId,
    Value<String>? secretIdentity,
    Value<String>? mode,
    Value<int>? force,
    Value<int>? constitution,
    Value<int>? dexterite,
    Value<int>? intelligence,
    Value<int>? perception,
    Value<int>? volonte,
    Value<int>? atcTotal,
    Value<int>? atdTotal,
    Value<int>? defense,
    Value<int>? initiative,
    Value<int>? exploitPointsCurrent,
    Value<int>? exploitPointsMax,
    Value<int>? ethicsOrder,
    Value<int>? ethicsJustice,
    Value<int>? ethicsAnarchy,
    Value<int>? ethicsCrime,
    Value<String>? livingStandard,
  }) {
    return BatmanCharactersCompanion(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      profileId: profileId ?? this.profileId,
      secretIdentity: secretIdentity ?? this.secretIdentity,
      mode: mode ?? this.mode,
      force: force ?? this.force,
      constitution: constitution ?? this.constitution,
      dexterite: dexterite ?? this.dexterite,
      intelligence: intelligence ?? this.intelligence,
      perception: perception ?? this.perception,
      volonte: volonte ?? this.volonte,
      atcTotal: atcTotal ?? this.atcTotal,
      atdTotal: atdTotal ?? this.atdTotal,
      defense: defense ?? this.defense,
      initiative: initiative ?? this.initiative,
      exploitPointsCurrent: exploitPointsCurrent ?? this.exploitPointsCurrent,
      exploitPointsMax: exploitPointsMax ?? this.exploitPointsMax,
      ethicsOrder: ethicsOrder ?? this.ethicsOrder,
      ethicsJustice: ethicsJustice ?? this.ethicsJustice,
      ethicsAnarchy: ethicsAnarchy ?? this.ethicsAnarchy,
      ethicsCrime: ethicsCrime ?? this.ethicsCrime,
      livingStandard: livingStandard ?? this.livingStandard,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<int>(characterId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (secretIdentity.present) {
      map['secret_identity'] = Variable<String>(secretIdentity.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (force.present) {
      map['force'] = Variable<int>(force.value);
    }
    if (constitution.present) {
      map['constitution'] = Variable<int>(constitution.value);
    }
    if (dexterite.present) {
      map['dexterite'] = Variable<int>(dexterite.value);
    }
    if (intelligence.present) {
      map['intelligence'] = Variable<int>(intelligence.value);
    }
    if (perception.present) {
      map['perception'] = Variable<int>(perception.value);
    }
    if (volonte.present) {
      map['volonte'] = Variable<int>(volonte.value);
    }
    if (atcTotal.present) {
      map['atc_total'] = Variable<int>(atcTotal.value);
    }
    if (atdTotal.present) {
      map['atd_total'] = Variable<int>(atdTotal.value);
    }
    if (defense.present) {
      map['defense'] = Variable<int>(defense.value);
    }
    if (initiative.present) {
      map['initiative'] = Variable<int>(initiative.value);
    }
    if (exploitPointsCurrent.present) {
      map['exploit_points_current'] = Variable<int>(exploitPointsCurrent.value);
    }
    if (exploitPointsMax.present) {
      map['exploit_points_max'] = Variable<int>(exploitPointsMax.value);
    }
    if (ethicsOrder.present) {
      map['ethics_order'] = Variable<int>(ethicsOrder.value);
    }
    if (ethicsJustice.present) {
      map['ethics_justice'] = Variable<int>(ethicsJustice.value);
    }
    if (ethicsAnarchy.present) {
      map['ethics_anarchy'] = Variable<int>(ethicsAnarchy.value);
    }
    if (ethicsCrime.present) {
      map['ethics_crime'] = Variable<int>(ethicsCrime.value);
    }
    if (livingStandard.present) {
      map['living_standard'] = Variable<String>(livingStandard.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BatmanCharactersCompanion(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('profileId: $profileId, ')
          ..write('secretIdentity: $secretIdentity, ')
          ..write('mode: $mode, ')
          ..write('force: $force, ')
          ..write('constitution: $constitution, ')
          ..write('dexterite: $dexterite, ')
          ..write('intelligence: $intelligence, ')
          ..write('perception: $perception, ')
          ..write('volonte: $volonte, ')
          ..write('atcTotal: $atcTotal, ')
          ..write('atdTotal: $atdTotal, ')
          ..write('defense: $defense, ')
          ..write('initiative: $initiative, ')
          ..write('exploitPointsCurrent: $exploitPointsCurrent, ')
          ..write('exploitPointsMax: $exploitPointsMax, ')
          ..write('ethicsOrder: $ethicsOrder, ')
          ..write('ethicsJustice: $ethicsJustice, ')
          ..write('ethicsAnarchy: $ethicsAnarchy, ')
          ..write('ethicsCrime: $ethicsCrime, ')
          ..write('livingStandard: $livingStandard')
          ..write(')'))
        .toString();
  }
}

class $BatmanCharacterWaysTable extends BatmanCharacterWays
    with TableInfo<$BatmanCharacterWaysTable, BatmanCharacterWay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BatmanCharacterWaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<int> characterId = GeneratedColumn<int>(
    'character_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES characters (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _wayIdMeta = const VerificationMeta('wayId');
  @override
  late final GeneratedColumn<String> wayId = GeneratedColumn<String>(
    'way_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rankAcquiredMeta = const VerificationMeta(
    'rankAcquired',
  );
  @override
  late final GeneratedColumn<int> rankAcquired = GeneratedColumn<int>(
    'rank_acquired',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _acquiredCapabilitiesMeta =
      const VerificationMeta('acquiredCapabilities');
  @override
  late final GeneratedColumn<String> acquiredCapabilities =
      GeneratedColumn<String>(
        'acquired_capabilities',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    characterId,
    wayId,
    rankAcquired,
    acquiredCapabilities,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'batman_character_ways';
  @override
  VerificationContext validateIntegrity(
    Insertable<BatmanCharacterWay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('way_id')) {
      context.handle(
        _wayIdMeta,
        wayId.isAcceptableOrUnknown(data['way_id']!, _wayIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wayIdMeta);
    }
    if (data.containsKey('rank_acquired')) {
      context.handle(
        _rankAcquiredMeta,
        rankAcquired.isAcceptableOrUnknown(
          data['rank_acquired']!,
          _rankAcquiredMeta,
        ),
      );
    }
    if (data.containsKey('acquired_capabilities')) {
      context.handle(
        _acquiredCapabilitiesMeta,
        acquiredCapabilities.isAcceptableOrUnknown(
          data['acquired_capabilities']!,
          _acquiredCapabilitiesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BatmanCharacterWay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BatmanCharacterWay(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}character_id'],
      )!,
      wayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}way_id'],
      )!,
      rankAcquired: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rank_acquired'],
      )!,
      acquiredCapabilities: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}acquired_capabilities'],
      )!,
    );
  }

  @override
  $BatmanCharacterWaysTable createAlias(String alias) {
    return $BatmanCharacterWaysTable(attachedDatabase, alias);
  }
}

class BatmanCharacterWay extends DataClass
    implements Insertable<BatmanCharacterWay> {
  final int id;
  final int characterId;
  final String wayId;
  final int rankAcquired;
  final String acquiredCapabilities;
  const BatmanCharacterWay({
    required this.id,
    required this.characterId,
    required this.wayId,
    required this.rankAcquired,
    required this.acquiredCapabilities,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['character_id'] = Variable<int>(characterId);
    map['way_id'] = Variable<String>(wayId);
    map['rank_acquired'] = Variable<int>(rankAcquired);
    map['acquired_capabilities'] = Variable<String>(acquiredCapabilities);
    return map;
  }

  BatmanCharacterWaysCompanion toCompanion(bool nullToAbsent) {
    return BatmanCharacterWaysCompanion(
      id: Value(id),
      characterId: Value(characterId),
      wayId: Value(wayId),
      rankAcquired: Value(rankAcquired),
      acquiredCapabilities: Value(acquiredCapabilities),
    );
  }

  factory BatmanCharacterWay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BatmanCharacterWay(
      id: serializer.fromJson<int>(json['id']),
      characterId: serializer.fromJson<int>(json['characterId']),
      wayId: serializer.fromJson<String>(json['wayId']),
      rankAcquired: serializer.fromJson<int>(json['rankAcquired']),
      acquiredCapabilities: serializer.fromJson<String>(
        json['acquiredCapabilities'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'characterId': serializer.toJson<int>(characterId),
      'wayId': serializer.toJson<String>(wayId),
      'rankAcquired': serializer.toJson<int>(rankAcquired),
      'acquiredCapabilities': serializer.toJson<String>(acquiredCapabilities),
    };
  }

  BatmanCharacterWay copyWith({
    int? id,
    int? characterId,
    String? wayId,
    int? rankAcquired,
    String? acquiredCapabilities,
  }) => BatmanCharacterWay(
    id: id ?? this.id,
    characterId: characterId ?? this.characterId,
    wayId: wayId ?? this.wayId,
    rankAcquired: rankAcquired ?? this.rankAcquired,
    acquiredCapabilities: acquiredCapabilities ?? this.acquiredCapabilities,
  );
  BatmanCharacterWay copyWithCompanion(BatmanCharacterWaysCompanion data) {
    return BatmanCharacterWay(
      id: data.id.present ? data.id.value : this.id,
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      wayId: data.wayId.present ? data.wayId.value : this.wayId,
      rankAcquired: data.rankAcquired.present
          ? data.rankAcquired.value
          : this.rankAcquired,
      acquiredCapabilities: data.acquiredCapabilities.present
          ? data.acquiredCapabilities.value
          : this.acquiredCapabilities,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BatmanCharacterWay(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('wayId: $wayId, ')
          ..write('rankAcquired: $rankAcquired, ')
          ..write('acquiredCapabilities: $acquiredCapabilities')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, characterId, wayId, rankAcquired, acquiredCapabilities);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BatmanCharacterWay &&
          other.id == this.id &&
          other.characterId == this.characterId &&
          other.wayId == this.wayId &&
          other.rankAcquired == this.rankAcquired &&
          other.acquiredCapabilities == this.acquiredCapabilities);
}

class BatmanCharacterWaysCompanion extends UpdateCompanion<BatmanCharacterWay> {
  final Value<int> id;
  final Value<int> characterId;
  final Value<String> wayId;
  final Value<int> rankAcquired;
  final Value<String> acquiredCapabilities;
  const BatmanCharacterWaysCompanion({
    this.id = const Value.absent(),
    this.characterId = const Value.absent(),
    this.wayId = const Value.absent(),
    this.rankAcquired = const Value.absent(),
    this.acquiredCapabilities = const Value.absent(),
  });
  BatmanCharacterWaysCompanion.insert({
    this.id = const Value.absent(),
    required int characterId,
    required String wayId,
    this.rankAcquired = const Value.absent(),
    this.acquiredCapabilities = const Value.absent(),
  }) : characterId = Value(characterId),
       wayId = Value(wayId);
  static Insertable<BatmanCharacterWay> custom({
    Expression<int>? id,
    Expression<int>? characterId,
    Expression<String>? wayId,
    Expression<int>? rankAcquired,
    Expression<String>? acquiredCapabilities,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (characterId != null) 'character_id': characterId,
      if (wayId != null) 'way_id': wayId,
      if (rankAcquired != null) 'rank_acquired': rankAcquired,
      if (acquiredCapabilities != null)
        'acquired_capabilities': acquiredCapabilities,
    });
  }

  BatmanCharacterWaysCompanion copyWith({
    Value<int>? id,
    Value<int>? characterId,
    Value<String>? wayId,
    Value<int>? rankAcquired,
    Value<String>? acquiredCapabilities,
  }) {
    return BatmanCharacterWaysCompanion(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      wayId: wayId ?? this.wayId,
      rankAcquired: rankAcquired ?? this.rankAcquired,
      acquiredCapabilities: acquiredCapabilities ?? this.acquiredCapabilities,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<int>(characterId.value);
    }
    if (wayId.present) {
      map['way_id'] = Variable<String>(wayId.value);
    }
    if (rankAcquired.present) {
      map['rank_acquired'] = Variable<int>(rankAcquired.value);
    }
    if (acquiredCapabilities.present) {
      map['acquired_capabilities'] = Variable<String>(
        acquiredCapabilities.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BatmanCharacterWaysCompanion(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('wayId: $wayId, ')
          ..write('rankAcquired: $rankAcquired, ')
          ..write('acquiredCapabilities: $acquiredCapabilities')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SrdSpellsTable srdSpells = $SrdSpellsTable(this);
  late final $SrdClassesTable srdClasses = $SrdClassesTable(this);
  late final $SrdSubclassesTable srdSubclasses = $SrdSubclassesTable(this);
  late final $SrdRacesTable srdRaces = $SrdRacesTable(this);
  late final $SrdSubracesTable srdSubraces = $SrdSubracesTable(this);
  late final $SrdBackgroundsTable srdBackgrounds = $SrdBackgroundsTable(this);
  late final $SrdFeaturesTable srdFeatures = $SrdFeaturesTable(this);
  late final $SrdFeatsTable srdFeats = $SrdFeatsTable(this);
  late final $SrdWeaponMasteriesTable srdWeaponMasteries =
      $SrdWeaponMasteriesTable(this);
  late final $BatmanProfilesTable batmanProfiles = $BatmanProfilesTable(this);
  late final $BatmanWaysTable batmanWays = $BatmanWaysTable(this);
  late final $CharactersTable characters = $CharactersTable(this);
  late final $CharacterClassesTable characterClasses = $CharacterClassesTable(
    this,
  );
  late final $CharacterAbilityScoresTable characterAbilityScores =
      $CharacterAbilityScoresTable(this);
  late final $CharacterProficienciesTable characterProficiencies =
      $CharacterProficienciesTable(this);
  late final $CharacterSpellsTable characterSpells = $CharacterSpellsTable(
    this,
  );
  late final $CharacterFeatsTable characterFeats = $CharacterFeatsTable(this);
  late final $CharacterSpellSlotsTable characterSpellSlots =
      $CharacterSpellSlotsTable(this);
  late final $CharacterResourcesTable characterResources =
      $CharacterResourcesTable(this);
  late final $CharacterAttacksTable characterAttacks = $CharacterAttacksTable(
    this,
  );
  late final $CharacterEquipmentTable characterEquipment =
      $CharacterEquipmentTable(this);
  late final $BatmanCharactersTable batmanCharacters = $BatmanCharactersTable(
    this,
  );
  late final $BatmanCharacterWaysTable batmanCharacterWays =
      $BatmanCharacterWaysTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final CompendiumDao compendiumDao = CompendiumDao(this as AppDatabase);
  late final CharacterDao characterDao = CharacterDao(this as AppDatabase);
  late final BatmanDao batmanDao = BatmanDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    srdSpells,
    srdClasses,
    srdSubclasses,
    srdRaces,
    srdSubraces,
    srdBackgrounds,
    srdFeatures,
    srdFeats,
    srdWeaponMasteries,
    batmanProfiles,
    batmanWays,
    characters,
    characterClasses,
    characterAbilityScores,
    characterProficiencies,
    characterSpells,
    characterFeats,
    characterSpellSlots,
    characterResources,
    characterAttacks,
    characterEquipment,
    batmanCharacters,
    batmanCharacterWays,
    appSettings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'characters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('character_classes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'characters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('character_ability_scores', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'characters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('character_proficiencies', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'characters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('character_spells', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'characters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('character_feats', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'characters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('character_spell_slots', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'characters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('character_resources', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'characters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('character_attacks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'characters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('character_equipment', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'characters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('batman_characters', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'characters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('batman_character_ways', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$SrdSpellsTableCreateCompanionBuilder =
    SrdSpellsCompanion Function({
      required String id,
      required RulesetVersion ruleset,
      required String name,
      required int level,
      required String school,
      required String castingTime,
      required String range,
      required String components,
      required String duration,
      Value<bool> concentration,
      Value<bool> ritual,
      required String description,
      Value<String?> higherLevel,
      required String classes,
      Value<bool> isCustom,
      Value<int> rowid,
    });
typedef $$SrdSpellsTableUpdateCompanionBuilder =
    SrdSpellsCompanion Function({
      Value<String> id,
      Value<RulesetVersion> ruleset,
      Value<String> name,
      Value<int> level,
      Value<String> school,
      Value<String> castingTime,
      Value<String> range,
      Value<String> components,
      Value<String> duration,
      Value<bool> concentration,
      Value<bool> ritual,
      Value<String> description,
      Value<String?> higherLevel,
      Value<String> classes,
      Value<bool> isCustom,
      Value<int> rowid,
    });

class $$SrdSpellsTableFilterComposer
    extends Composer<_$AppDatabase, $SrdSpellsTable> {
  $$SrdSpellsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RulesetVersion, RulesetVersion, String>
  get ruleset => $composableBuilder(
    column: $table.ruleset,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get school => $composableBuilder(
    column: $table.school,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get castingTime => $composableBuilder(
    column: $table.castingTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get range => $composableBuilder(
    column: $table.range,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get components => $composableBuilder(
    column: $table.components,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get concentration => $composableBuilder(
    column: $table.concentration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ritual => $composableBuilder(
    column: $table.ritual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get higherLevel => $composableBuilder(
    column: $table.higherLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classes => $composableBuilder(
    column: $table.classes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SrdSpellsTableOrderingComposer
    extends Composer<_$AppDatabase, $SrdSpellsTable> {
  $$SrdSpellsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruleset => $composableBuilder(
    column: $table.ruleset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get school => $composableBuilder(
    column: $table.school,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get castingTime => $composableBuilder(
    column: $table.castingTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get range => $composableBuilder(
    column: $table.range,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get components => $composableBuilder(
    column: $table.components,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get concentration => $composableBuilder(
    column: $table.concentration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ritual => $composableBuilder(
    column: $table.ritual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get higherLevel => $composableBuilder(
    column: $table.higherLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classes => $composableBuilder(
    column: $table.classes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SrdSpellsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SrdSpellsTable> {
  $$SrdSpellsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RulesetVersion, String> get ruleset =>
      $composableBuilder(column: $table.ruleset, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get school =>
      $composableBuilder(column: $table.school, builder: (column) => column);

  GeneratedColumn<String> get castingTime => $composableBuilder(
    column: $table.castingTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get range =>
      $composableBuilder(column: $table.range, builder: (column) => column);

  GeneratedColumn<String> get components => $composableBuilder(
    column: $table.components,
    builder: (column) => column,
  );

  GeneratedColumn<String> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<bool> get concentration => $composableBuilder(
    column: $table.concentration,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get ritual =>
      $composableBuilder(column: $table.ritual, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get higherLevel => $composableBuilder(
    column: $table.higherLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get classes =>
      $composableBuilder(column: $table.classes, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);
}

class $$SrdSpellsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SrdSpellsTable,
          SrdSpell,
          $$SrdSpellsTableFilterComposer,
          $$SrdSpellsTableOrderingComposer,
          $$SrdSpellsTableAnnotationComposer,
          $$SrdSpellsTableCreateCompanionBuilder,
          $$SrdSpellsTableUpdateCompanionBuilder,
          (SrdSpell, BaseReferences<_$AppDatabase, $SrdSpellsTable, SrdSpell>),
          SrdSpell,
          PrefetchHooks Function()
        > {
  $$SrdSpellsTableTableManager(_$AppDatabase db, $SrdSpellsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SrdSpellsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SrdSpellsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SrdSpellsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<RulesetVersion> ruleset = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<String> school = const Value.absent(),
                Value<String> castingTime = const Value.absent(),
                Value<String> range = const Value.absent(),
                Value<String> components = const Value.absent(),
                Value<String> duration = const Value.absent(),
                Value<bool> concentration = const Value.absent(),
                Value<bool> ritual = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> higherLevel = const Value.absent(),
                Value<String> classes = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SrdSpellsCompanion(
                id: id,
                ruleset: ruleset,
                name: name,
                level: level,
                school: school,
                castingTime: castingTime,
                range: range,
                components: components,
                duration: duration,
                concentration: concentration,
                ritual: ritual,
                description: description,
                higherLevel: higherLevel,
                classes: classes,
                isCustom: isCustom,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required RulesetVersion ruleset,
                required String name,
                required int level,
                required String school,
                required String castingTime,
                required String range,
                required String components,
                required String duration,
                Value<bool> concentration = const Value.absent(),
                Value<bool> ritual = const Value.absent(),
                required String description,
                Value<String?> higherLevel = const Value.absent(),
                required String classes,
                Value<bool> isCustom = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SrdSpellsCompanion.insert(
                id: id,
                ruleset: ruleset,
                name: name,
                level: level,
                school: school,
                castingTime: castingTime,
                range: range,
                components: components,
                duration: duration,
                concentration: concentration,
                ritual: ritual,
                description: description,
                higherLevel: higherLevel,
                classes: classes,
                isCustom: isCustom,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SrdSpellsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SrdSpellsTable,
      SrdSpell,
      $$SrdSpellsTableFilterComposer,
      $$SrdSpellsTableOrderingComposer,
      $$SrdSpellsTableAnnotationComposer,
      $$SrdSpellsTableCreateCompanionBuilder,
      $$SrdSpellsTableUpdateCompanionBuilder,
      (SrdSpell, BaseReferences<_$AppDatabase, $SrdSpellsTable, SrdSpell>),
      SrdSpell,
      PrefetchHooks Function()
    >;
typedef $$SrdClassesTableCreateCompanionBuilder =
    SrdClassesCompanion Function({
      required String id,
      required RulesetVersion ruleset,
      required String name,
      required int hitDie,
      required String proficiencies,
      required String savingThrows,
      Value<String?> spellcastingAbility,
      Value<bool> isPreparedCaster,
      Value<int> rowid,
    });
typedef $$SrdClassesTableUpdateCompanionBuilder =
    SrdClassesCompanion Function({
      Value<String> id,
      Value<RulesetVersion> ruleset,
      Value<String> name,
      Value<int> hitDie,
      Value<String> proficiencies,
      Value<String> savingThrows,
      Value<String?> spellcastingAbility,
      Value<bool> isPreparedCaster,
      Value<int> rowid,
    });

class $$SrdClassesTableFilterComposer
    extends Composer<_$AppDatabase, $SrdClassesTable> {
  $$SrdClassesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RulesetVersion, RulesetVersion, String>
  get ruleset => $composableBuilder(
    column: $table.ruleset,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hitDie => $composableBuilder(
    column: $table.hitDie,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proficiencies => $composableBuilder(
    column: $table.proficiencies,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get savingThrows => $composableBuilder(
    column: $table.savingThrows,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spellcastingAbility => $composableBuilder(
    column: $table.spellcastingAbility,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPreparedCaster => $composableBuilder(
    column: $table.isPreparedCaster,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SrdClassesTableOrderingComposer
    extends Composer<_$AppDatabase, $SrdClassesTable> {
  $$SrdClassesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruleset => $composableBuilder(
    column: $table.ruleset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hitDie => $composableBuilder(
    column: $table.hitDie,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proficiencies => $composableBuilder(
    column: $table.proficiencies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get savingThrows => $composableBuilder(
    column: $table.savingThrows,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spellcastingAbility => $composableBuilder(
    column: $table.spellcastingAbility,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPreparedCaster => $composableBuilder(
    column: $table.isPreparedCaster,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SrdClassesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SrdClassesTable> {
  $$SrdClassesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RulesetVersion, String> get ruleset =>
      $composableBuilder(column: $table.ruleset, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get hitDie =>
      $composableBuilder(column: $table.hitDie, builder: (column) => column);

  GeneratedColumn<String> get proficiencies => $composableBuilder(
    column: $table.proficiencies,
    builder: (column) => column,
  );

  GeneratedColumn<String> get savingThrows => $composableBuilder(
    column: $table.savingThrows,
    builder: (column) => column,
  );

  GeneratedColumn<String> get spellcastingAbility => $composableBuilder(
    column: $table.spellcastingAbility,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPreparedCaster => $composableBuilder(
    column: $table.isPreparedCaster,
    builder: (column) => column,
  );
}

class $$SrdClassesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SrdClassesTable,
          SrdClassesData,
          $$SrdClassesTableFilterComposer,
          $$SrdClassesTableOrderingComposer,
          $$SrdClassesTableAnnotationComposer,
          $$SrdClassesTableCreateCompanionBuilder,
          $$SrdClassesTableUpdateCompanionBuilder,
          (
            SrdClassesData,
            BaseReferences<_$AppDatabase, $SrdClassesTable, SrdClassesData>,
          ),
          SrdClassesData,
          PrefetchHooks Function()
        > {
  $$SrdClassesTableTableManager(_$AppDatabase db, $SrdClassesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SrdClassesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SrdClassesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SrdClassesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<RulesetVersion> ruleset = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> hitDie = const Value.absent(),
                Value<String> proficiencies = const Value.absent(),
                Value<String> savingThrows = const Value.absent(),
                Value<String?> spellcastingAbility = const Value.absent(),
                Value<bool> isPreparedCaster = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SrdClassesCompanion(
                id: id,
                ruleset: ruleset,
                name: name,
                hitDie: hitDie,
                proficiencies: proficiencies,
                savingThrows: savingThrows,
                spellcastingAbility: spellcastingAbility,
                isPreparedCaster: isPreparedCaster,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required RulesetVersion ruleset,
                required String name,
                required int hitDie,
                required String proficiencies,
                required String savingThrows,
                Value<String?> spellcastingAbility = const Value.absent(),
                Value<bool> isPreparedCaster = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SrdClassesCompanion.insert(
                id: id,
                ruleset: ruleset,
                name: name,
                hitDie: hitDie,
                proficiencies: proficiencies,
                savingThrows: savingThrows,
                spellcastingAbility: spellcastingAbility,
                isPreparedCaster: isPreparedCaster,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SrdClassesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SrdClassesTable,
      SrdClassesData,
      $$SrdClassesTableFilterComposer,
      $$SrdClassesTableOrderingComposer,
      $$SrdClassesTableAnnotationComposer,
      $$SrdClassesTableCreateCompanionBuilder,
      $$SrdClassesTableUpdateCompanionBuilder,
      (
        SrdClassesData,
        BaseReferences<_$AppDatabase, $SrdClassesTable, SrdClassesData>,
      ),
      SrdClassesData,
      PrefetchHooks Function()
    >;
typedef $$SrdSubclassesTableCreateCompanionBuilder =
    SrdSubclassesCompanion Function({
      required String id,
      required RulesetVersion ruleset,
      required String name,
      required String classId,
      required String description,
      Value<int> rowid,
    });
typedef $$SrdSubclassesTableUpdateCompanionBuilder =
    SrdSubclassesCompanion Function({
      Value<String> id,
      Value<RulesetVersion> ruleset,
      Value<String> name,
      Value<String> classId,
      Value<String> description,
      Value<int> rowid,
    });

class $$SrdSubclassesTableFilterComposer
    extends Composer<_$AppDatabase, $SrdSubclassesTable> {
  $$SrdSubclassesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RulesetVersion, RulesetVersion, String>
  get ruleset => $composableBuilder(
    column: $table.ruleset,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classId => $composableBuilder(
    column: $table.classId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SrdSubclassesTableOrderingComposer
    extends Composer<_$AppDatabase, $SrdSubclassesTable> {
  $$SrdSubclassesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruleset => $composableBuilder(
    column: $table.ruleset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classId => $composableBuilder(
    column: $table.classId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SrdSubclassesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SrdSubclassesTable> {
  $$SrdSubclassesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RulesetVersion, String> get ruleset =>
      $composableBuilder(column: $table.ruleset, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get classId =>
      $composableBuilder(column: $table.classId, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );
}

class $$SrdSubclassesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SrdSubclassesTable,
          SrdSubclassesData,
          $$SrdSubclassesTableFilterComposer,
          $$SrdSubclassesTableOrderingComposer,
          $$SrdSubclassesTableAnnotationComposer,
          $$SrdSubclassesTableCreateCompanionBuilder,
          $$SrdSubclassesTableUpdateCompanionBuilder,
          (
            SrdSubclassesData,
            BaseReferences<
              _$AppDatabase,
              $SrdSubclassesTable,
              SrdSubclassesData
            >,
          ),
          SrdSubclassesData,
          PrefetchHooks Function()
        > {
  $$SrdSubclassesTableTableManager(_$AppDatabase db, $SrdSubclassesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SrdSubclassesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SrdSubclassesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SrdSubclassesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<RulesetVersion> ruleset = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> classId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SrdSubclassesCompanion(
                id: id,
                ruleset: ruleset,
                name: name,
                classId: classId,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required RulesetVersion ruleset,
                required String name,
                required String classId,
                required String description,
                Value<int> rowid = const Value.absent(),
              }) => SrdSubclassesCompanion.insert(
                id: id,
                ruleset: ruleset,
                name: name,
                classId: classId,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SrdSubclassesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SrdSubclassesTable,
      SrdSubclassesData,
      $$SrdSubclassesTableFilterComposer,
      $$SrdSubclassesTableOrderingComposer,
      $$SrdSubclassesTableAnnotationComposer,
      $$SrdSubclassesTableCreateCompanionBuilder,
      $$SrdSubclassesTableUpdateCompanionBuilder,
      (
        SrdSubclassesData,
        BaseReferences<_$AppDatabase, $SrdSubclassesTable, SrdSubclassesData>,
      ),
      SrdSubclassesData,
      PrefetchHooks Function()
    >;
typedef $$SrdRacesTableCreateCompanionBuilder =
    SrdRacesCompanion Function({
      required String id,
      required RulesetVersion ruleset,
      required String name,
      required int speed,
      required String abilityBonuses,
      required String languages,
      required String traits,
      Value<int> rowid,
    });
typedef $$SrdRacesTableUpdateCompanionBuilder =
    SrdRacesCompanion Function({
      Value<String> id,
      Value<RulesetVersion> ruleset,
      Value<String> name,
      Value<int> speed,
      Value<String> abilityBonuses,
      Value<String> languages,
      Value<String> traits,
      Value<int> rowid,
    });

class $$SrdRacesTableFilterComposer
    extends Composer<_$AppDatabase, $SrdRacesTable> {
  $$SrdRacesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RulesetVersion, RulesetVersion, String>
  get ruleset => $composableBuilder(
    column: $table.ruleset,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get abilityBonuses => $composableBuilder(
    column: $table.abilityBonuses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get languages => $composableBuilder(
    column: $table.languages,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get traits => $composableBuilder(
    column: $table.traits,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SrdRacesTableOrderingComposer
    extends Composer<_$AppDatabase, $SrdRacesTable> {
  $$SrdRacesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruleset => $composableBuilder(
    column: $table.ruleset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get abilityBonuses => $composableBuilder(
    column: $table.abilityBonuses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languages => $composableBuilder(
    column: $table.languages,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get traits => $composableBuilder(
    column: $table.traits,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SrdRacesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SrdRacesTable> {
  $$SrdRacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RulesetVersion, String> get ruleset =>
      $composableBuilder(column: $table.ruleset, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get speed =>
      $composableBuilder(column: $table.speed, builder: (column) => column);

  GeneratedColumn<String> get abilityBonuses => $composableBuilder(
    column: $table.abilityBonuses,
    builder: (column) => column,
  );

  GeneratedColumn<String> get languages =>
      $composableBuilder(column: $table.languages, builder: (column) => column);

  GeneratedColumn<String> get traits =>
      $composableBuilder(column: $table.traits, builder: (column) => column);
}

class $$SrdRacesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SrdRacesTable,
          SrdRace,
          $$SrdRacesTableFilterComposer,
          $$SrdRacesTableOrderingComposer,
          $$SrdRacesTableAnnotationComposer,
          $$SrdRacesTableCreateCompanionBuilder,
          $$SrdRacesTableUpdateCompanionBuilder,
          (SrdRace, BaseReferences<_$AppDatabase, $SrdRacesTable, SrdRace>),
          SrdRace,
          PrefetchHooks Function()
        > {
  $$SrdRacesTableTableManager(_$AppDatabase db, $SrdRacesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SrdRacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SrdRacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SrdRacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<RulesetVersion> ruleset = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> speed = const Value.absent(),
                Value<String> abilityBonuses = const Value.absent(),
                Value<String> languages = const Value.absent(),
                Value<String> traits = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SrdRacesCompanion(
                id: id,
                ruleset: ruleset,
                name: name,
                speed: speed,
                abilityBonuses: abilityBonuses,
                languages: languages,
                traits: traits,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required RulesetVersion ruleset,
                required String name,
                required int speed,
                required String abilityBonuses,
                required String languages,
                required String traits,
                Value<int> rowid = const Value.absent(),
              }) => SrdRacesCompanion.insert(
                id: id,
                ruleset: ruleset,
                name: name,
                speed: speed,
                abilityBonuses: abilityBonuses,
                languages: languages,
                traits: traits,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SrdRacesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SrdRacesTable,
      SrdRace,
      $$SrdRacesTableFilterComposer,
      $$SrdRacesTableOrderingComposer,
      $$SrdRacesTableAnnotationComposer,
      $$SrdRacesTableCreateCompanionBuilder,
      $$SrdRacesTableUpdateCompanionBuilder,
      (SrdRace, BaseReferences<_$AppDatabase, $SrdRacesTable, SrdRace>),
      SrdRace,
      PrefetchHooks Function()
    >;
typedef $$SrdSubracesTableCreateCompanionBuilder =
    SrdSubracesCompanion Function({
      required String id,
      required RulesetVersion ruleset,
      required String name,
      required String raceId,
      required String abilityBonuses,
      Value<int> rowid,
    });
typedef $$SrdSubracesTableUpdateCompanionBuilder =
    SrdSubracesCompanion Function({
      Value<String> id,
      Value<RulesetVersion> ruleset,
      Value<String> name,
      Value<String> raceId,
      Value<String> abilityBonuses,
      Value<int> rowid,
    });

class $$SrdSubracesTableFilterComposer
    extends Composer<_$AppDatabase, $SrdSubracesTable> {
  $$SrdSubracesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RulesetVersion, RulesetVersion, String>
  get ruleset => $composableBuilder(
    column: $table.ruleset,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get raceId => $composableBuilder(
    column: $table.raceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get abilityBonuses => $composableBuilder(
    column: $table.abilityBonuses,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SrdSubracesTableOrderingComposer
    extends Composer<_$AppDatabase, $SrdSubracesTable> {
  $$SrdSubracesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruleset => $composableBuilder(
    column: $table.ruleset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get raceId => $composableBuilder(
    column: $table.raceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get abilityBonuses => $composableBuilder(
    column: $table.abilityBonuses,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SrdSubracesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SrdSubracesTable> {
  $$SrdSubracesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RulesetVersion, String> get ruleset =>
      $composableBuilder(column: $table.ruleset, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get raceId =>
      $composableBuilder(column: $table.raceId, builder: (column) => column);

  GeneratedColumn<String> get abilityBonuses => $composableBuilder(
    column: $table.abilityBonuses,
    builder: (column) => column,
  );
}

class $$SrdSubracesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SrdSubracesTable,
          SrdSubrace,
          $$SrdSubracesTableFilterComposer,
          $$SrdSubracesTableOrderingComposer,
          $$SrdSubracesTableAnnotationComposer,
          $$SrdSubracesTableCreateCompanionBuilder,
          $$SrdSubracesTableUpdateCompanionBuilder,
          (
            SrdSubrace,
            BaseReferences<_$AppDatabase, $SrdSubracesTable, SrdSubrace>,
          ),
          SrdSubrace,
          PrefetchHooks Function()
        > {
  $$SrdSubracesTableTableManager(_$AppDatabase db, $SrdSubracesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SrdSubracesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SrdSubracesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SrdSubracesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<RulesetVersion> ruleset = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> raceId = const Value.absent(),
                Value<String> abilityBonuses = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SrdSubracesCompanion(
                id: id,
                ruleset: ruleset,
                name: name,
                raceId: raceId,
                abilityBonuses: abilityBonuses,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required RulesetVersion ruleset,
                required String name,
                required String raceId,
                required String abilityBonuses,
                Value<int> rowid = const Value.absent(),
              }) => SrdSubracesCompanion.insert(
                id: id,
                ruleset: ruleset,
                name: name,
                raceId: raceId,
                abilityBonuses: abilityBonuses,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SrdSubracesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SrdSubracesTable,
      SrdSubrace,
      $$SrdSubracesTableFilterComposer,
      $$SrdSubracesTableOrderingComposer,
      $$SrdSubracesTableAnnotationComposer,
      $$SrdSubracesTableCreateCompanionBuilder,
      $$SrdSubracesTableUpdateCompanionBuilder,
      (
        SrdSubrace,
        BaseReferences<_$AppDatabase, $SrdSubracesTable, SrdSubrace>,
      ),
      SrdSubrace,
      PrefetchHooks Function()
    >;
typedef $$SrdBackgroundsTableCreateCompanionBuilder =
    SrdBackgroundsCompanion Function({
      required String id,
      required RulesetVersion ruleset,
      required String name,
      required String skillProficiencies,
      required String toolProficiencies,
      required String languages,
      Value<String?> asiJson,
      Value<String?> originFeatId,
      Value<int> rowid,
    });
typedef $$SrdBackgroundsTableUpdateCompanionBuilder =
    SrdBackgroundsCompanion Function({
      Value<String> id,
      Value<RulesetVersion> ruleset,
      Value<String> name,
      Value<String> skillProficiencies,
      Value<String> toolProficiencies,
      Value<String> languages,
      Value<String?> asiJson,
      Value<String?> originFeatId,
      Value<int> rowid,
    });

class $$SrdBackgroundsTableFilterComposer
    extends Composer<_$AppDatabase, $SrdBackgroundsTable> {
  $$SrdBackgroundsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RulesetVersion, RulesetVersion, String>
  get ruleset => $composableBuilder(
    column: $table.ruleset,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get skillProficiencies => $composableBuilder(
    column: $table.skillProficiencies,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toolProficiencies => $composableBuilder(
    column: $table.toolProficiencies,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get languages => $composableBuilder(
    column: $table.languages,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get asiJson => $composableBuilder(
    column: $table.asiJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originFeatId => $composableBuilder(
    column: $table.originFeatId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SrdBackgroundsTableOrderingComposer
    extends Composer<_$AppDatabase, $SrdBackgroundsTable> {
  $$SrdBackgroundsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruleset => $composableBuilder(
    column: $table.ruleset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get skillProficiencies => $composableBuilder(
    column: $table.skillProficiencies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toolProficiencies => $composableBuilder(
    column: $table.toolProficiencies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languages => $composableBuilder(
    column: $table.languages,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get asiJson => $composableBuilder(
    column: $table.asiJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originFeatId => $composableBuilder(
    column: $table.originFeatId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SrdBackgroundsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SrdBackgroundsTable> {
  $$SrdBackgroundsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RulesetVersion, String> get ruleset =>
      $composableBuilder(column: $table.ruleset, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get skillProficiencies => $composableBuilder(
    column: $table.skillProficiencies,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toolProficiencies => $composableBuilder(
    column: $table.toolProficiencies,
    builder: (column) => column,
  );

  GeneratedColumn<String> get languages =>
      $composableBuilder(column: $table.languages, builder: (column) => column);

  GeneratedColumn<String> get asiJson =>
      $composableBuilder(column: $table.asiJson, builder: (column) => column);

  GeneratedColumn<String> get originFeatId => $composableBuilder(
    column: $table.originFeatId,
    builder: (column) => column,
  );
}

class $$SrdBackgroundsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SrdBackgroundsTable,
          SrdBackground,
          $$SrdBackgroundsTableFilterComposer,
          $$SrdBackgroundsTableOrderingComposer,
          $$SrdBackgroundsTableAnnotationComposer,
          $$SrdBackgroundsTableCreateCompanionBuilder,
          $$SrdBackgroundsTableUpdateCompanionBuilder,
          (
            SrdBackground,
            BaseReferences<_$AppDatabase, $SrdBackgroundsTable, SrdBackground>,
          ),
          SrdBackground,
          PrefetchHooks Function()
        > {
  $$SrdBackgroundsTableTableManager(
    _$AppDatabase db,
    $SrdBackgroundsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SrdBackgroundsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SrdBackgroundsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SrdBackgroundsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<RulesetVersion> ruleset = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> skillProficiencies = const Value.absent(),
                Value<String> toolProficiencies = const Value.absent(),
                Value<String> languages = const Value.absent(),
                Value<String?> asiJson = const Value.absent(),
                Value<String?> originFeatId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SrdBackgroundsCompanion(
                id: id,
                ruleset: ruleset,
                name: name,
                skillProficiencies: skillProficiencies,
                toolProficiencies: toolProficiencies,
                languages: languages,
                asiJson: asiJson,
                originFeatId: originFeatId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required RulesetVersion ruleset,
                required String name,
                required String skillProficiencies,
                required String toolProficiencies,
                required String languages,
                Value<String?> asiJson = const Value.absent(),
                Value<String?> originFeatId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SrdBackgroundsCompanion.insert(
                id: id,
                ruleset: ruleset,
                name: name,
                skillProficiencies: skillProficiencies,
                toolProficiencies: toolProficiencies,
                languages: languages,
                asiJson: asiJson,
                originFeatId: originFeatId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SrdBackgroundsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SrdBackgroundsTable,
      SrdBackground,
      $$SrdBackgroundsTableFilterComposer,
      $$SrdBackgroundsTableOrderingComposer,
      $$SrdBackgroundsTableAnnotationComposer,
      $$SrdBackgroundsTableCreateCompanionBuilder,
      $$SrdBackgroundsTableUpdateCompanionBuilder,
      (
        SrdBackground,
        BaseReferences<_$AppDatabase, $SrdBackgroundsTable, SrdBackground>,
      ),
      SrdBackground,
      PrefetchHooks Function()
    >;
typedef $$SrdFeaturesTableCreateCompanionBuilder =
    SrdFeaturesCompanion Function({
      Value<int> id,
      required String srdIndex,
      required RulesetVersion ruleset,
      required String name,
      Value<String?> classId,
      Value<String?> subclassId,
      required int level,
      required String description,
    });
typedef $$SrdFeaturesTableUpdateCompanionBuilder =
    SrdFeaturesCompanion Function({
      Value<int> id,
      Value<String> srdIndex,
      Value<RulesetVersion> ruleset,
      Value<String> name,
      Value<String?> classId,
      Value<String?> subclassId,
      Value<int> level,
      Value<String> description,
    });

class $$SrdFeaturesTableFilterComposer
    extends Composer<_$AppDatabase, $SrdFeaturesTable> {
  $$SrdFeaturesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get srdIndex => $composableBuilder(
    column: $table.srdIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RulesetVersion, RulesetVersion, String>
  get ruleset => $composableBuilder(
    column: $table.ruleset,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classId => $composableBuilder(
    column: $table.classId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subclassId => $composableBuilder(
    column: $table.subclassId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SrdFeaturesTableOrderingComposer
    extends Composer<_$AppDatabase, $SrdFeaturesTable> {
  $$SrdFeaturesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get srdIndex => $composableBuilder(
    column: $table.srdIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruleset => $composableBuilder(
    column: $table.ruleset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classId => $composableBuilder(
    column: $table.classId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subclassId => $composableBuilder(
    column: $table.subclassId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SrdFeaturesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SrdFeaturesTable> {
  $$SrdFeaturesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get srdIndex =>
      $composableBuilder(column: $table.srdIndex, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RulesetVersion, String> get ruleset =>
      $composableBuilder(column: $table.ruleset, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get classId =>
      $composableBuilder(column: $table.classId, builder: (column) => column);

  GeneratedColumn<String> get subclassId => $composableBuilder(
    column: $table.subclassId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );
}

class $$SrdFeaturesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SrdFeaturesTable,
          SrdFeature,
          $$SrdFeaturesTableFilterComposer,
          $$SrdFeaturesTableOrderingComposer,
          $$SrdFeaturesTableAnnotationComposer,
          $$SrdFeaturesTableCreateCompanionBuilder,
          $$SrdFeaturesTableUpdateCompanionBuilder,
          (
            SrdFeature,
            BaseReferences<_$AppDatabase, $SrdFeaturesTable, SrdFeature>,
          ),
          SrdFeature,
          PrefetchHooks Function()
        > {
  $$SrdFeaturesTableTableManager(_$AppDatabase db, $SrdFeaturesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SrdFeaturesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SrdFeaturesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SrdFeaturesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> srdIndex = const Value.absent(),
                Value<RulesetVersion> ruleset = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> classId = const Value.absent(),
                Value<String?> subclassId = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<String> description = const Value.absent(),
              }) => SrdFeaturesCompanion(
                id: id,
                srdIndex: srdIndex,
                ruleset: ruleset,
                name: name,
                classId: classId,
                subclassId: subclassId,
                level: level,
                description: description,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String srdIndex,
                required RulesetVersion ruleset,
                required String name,
                Value<String?> classId = const Value.absent(),
                Value<String?> subclassId = const Value.absent(),
                required int level,
                required String description,
              }) => SrdFeaturesCompanion.insert(
                id: id,
                srdIndex: srdIndex,
                ruleset: ruleset,
                name: name,
                classId: classId,
                subclassId: subclassId,
                level: level,
                description: description,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SrdFeaturesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SrdFeaturesTable,
      SrdFeature,
      $$SrdFeaturesTableFilterComposer,
      $$SrdFeaturesTableOrderingComposer,
      $$SrdFeaturesTableAnnotationComposer,
      $$SrdFeaturesTableCreateCompanionBuilder,
      $$SrdFeaturesTableUpdateCompanionBuilder,
      (
        SrdFeature,
        BaseReferences<_$AppDatabase, $SrdFeaturesTable, SrdFeature>,
      ),
      SrdFeature,
      PrefetchHooks Function()
    >;
typedef $$SrdFeatsTableCreateCompanionBuilder =
    SrdFeatsCompanion Function({
      required String id,
      required RulesetVersion ruleset,
      required String name,
      required String description,
      required String type,
      Value<bool> repeatable,
      Value<int> rowid,
    });
typedef $$SrdFeatsTableUpdateCompanionBuilder =
    SrdFeatsCompanion Function({
      Value<String> id,
      Value<RulesetVersion> ruleset,
      Value<String> name,
      Value<String> description,
      Value<String> type,
      Value<bool> repeatable,
      Value<int> rowid,
    });

class $$SrdFeatsTableFilterComposer
    extends Composer<_$AppDatabase, $SrdFeatsTable> {
  $$SrdFeatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RulesetVersion, RulesetVersion, String>
  get ruleset => $composableBuilder(
    column: $table.ruleset,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get repeatable => $composableBuilder(
    column: $table.repeatable,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SrdFeatsTableOrderingComposer
    extends Composer<_$AppDatabase, $SrdFeatsTable> {
  $$SrdFeatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruleset => $composableBuilder(
    column: $table.ruleset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get repeatable => $composableBuilder(
    column: $table.repeatable,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SrdFeatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SrdFeatsTable> {
  $$SrdFeatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RulesetVersion, String> get ruleset =>
      $composableBuilder(column: $table.ruleset, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get repeatable => $composableBuilder(
    column: $table.repeatable,
    builder: (column) => column,
  );
}

class $$SrdFeatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SrdFeatsTable,
          SrdFeat,
          $$SrdFeatsTableFilterComposer,
          $$SrdFeatsTableOrderingComposer,
          $$SrdFeatsTableAnnotationComposer,
          $$SrdFeatsTableCreateCompanionBuilder,
          $$SrdFeatsTableUpdateCompanionBuilder,
          (SrdFeat, BaseReferences<_$AppDatabase, $SrdFeatsTable, SrdFeat>),
          SrdFeat,
          PrefetchHooks Function()
        > {
  $$SrdFeatsTableTableManager(_$AppDatabase db, $SrdFeatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SrdFeatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SrdFeatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SrdFeatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<RulesetVersion> ruleset = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<bool> repeatable = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SrdFeatsCompanion(
                id: id,
                ruleset: ruleset,
                name: name,
                description: description,
                type: type,
                repeatable: repeatable,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required RulesetVersion ruleset,
                required String name,
                required String description,
                required String type,
                Value<bool> repeatable = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SrdFeatsCompanion.insert(
                id: id,
                ruleset: ruleset,
                name: name,
                description: description,
                type: type,
                repeatable: repeatable,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SrdFeatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SrdFeatsTable,
      SrdFeat,
      $$SrdFeatsTableFilterComposer,
      $$SrdFeatsTableOrderingComposer,
      $$SrdFeatsTableAnnotationComposer,
      $$SrdFeatsTableCreateCompanionBuilder,
      $$SrdFeatsTableUpdateCompanionBuilder,
      (SrdFeat, BaseReferences<_$AppDatabase, $SrdFeatsTable, SrdFeat>),
      SrdFeat,
      PrefetchHooks Function()
    >;
typedef $$SrdWeaponMasteriesTableCreateCompanionBuilder =
    SrdWeaponMasteriesCompanion Function({
      required String id,
      required String name,
      required String description,
      Value<int> rowid,
    });
typedef $$SrdWeaponMasteriesTableUpdateCompanionBuilder =
    SrdWeaponMasteriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> description,
      Value<int> rowid,
    });

class $$SrdWeaponMasteriesTableFilterComposer
    extends Composer<_$AppDatabase, $SrdWeaponMasteriesTable> {
  $$SrdWeaponMasteriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SrdWeaponMasteriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SrdWeaponMasteriesTable> {
  $$SrdWeaponMasteriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SrdWeaponMasteriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SrdWeaponMasteriesTable> {
  $$SrdWeaponMasteriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );
}

class $$SrdWeaponMasteriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SrdWeaponMasteriesTable,
          SrdWeaponMastery,
          $$SrdWeaponMasteriesTableFilterComposer,
          $$SrdWeaponMasteriesTableOrderingComposer,
          $$SrdWeaponMasteriesTableAnnotationComposer,
          $$SrdWeaponMasteriesTableCreateCompanionBuilder,
          $$SrdWeaponMasteriesTableUpdateCompanionBuilder,
          (
            SrdWeaponMastery,
            BaseReferences<
              _$AppDatabase,
              $SrdWeaponMasteriesTable,
              SrdWeaponMastery
            >,
          ),
          SrdWeaponMastery,
          PrefetchHooks Function()
        > {
  $$SrdWeaponMasteriesTableTableManager(
    _$AppDatabase db,
    $SrdWeaponMasteriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SrdWeaponMasteriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SrdWeaponMasteriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SrdWeaponMasteriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SrdWeaponMasteriesCompanion(
                id: id,
                name: name,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String description,
                Value<int> rowid = const Value.absent(),
              }) => SrdWeaponMasteriesCompanion.insert(
                id: id,
                name: name,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SrdWeaponMasteriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SrdWeaponMasteriesTable,
      SrdWeaponMastery,
      $$SrdWeaponMasteriesTableFilterComposer,
      $$SrdWeaponMasteriesTableOrderingComposer,
      $$SrdWeaponMasteriesTableAnnotationComposer,
      $$SrdWeaponMasteriesTableCreateCompanionBuilder,
      $$SrdWeaponMasteriesTableUpdateCompanionBuilder,
      (
        SrdWeaponMastery,
        BaseReferences<
          _$AppDatabase,
          $SrdWeaponMasteriesTable,
          SrdWeaponMastery
        >,
      ),
      SrdWeaponMastery,
      PrefetchHooks Function()
    >;
typedef $$BatmanProfilesTableCreateCompanionBuilder =
    BatmanProfilesCompanion Function({
      required String id,
      required String name,
      required String mode,
      required String hitDie,
      Value<int> atcBonus,
      Value<int> atdBonus,
      Value<int> atsBonus,
      Value<int> exploitPoints,
      Value<int> capabilityPoints,
      required String primaryAbilityWithEdge,
      required String initialWays,
      Value<int> extraWays,
      Value<String?> extraWaysPool,
      required String livingStandard,
      required String description,
      Value<int> rowid,
    });
typedef $$BatmanProfilesTableUpdateCompanionBuilder =
    BatmanProfilesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> mode,
      Value<String> hitDie,
      Value<int> atcBonus,
      Value<int> atdBonus,
      Value<int> atsBonus,
      Value<int> exploitPoints,
      Value<int> capabilityPoints,
      Value<String> primaryAbilityWithEdge,
      Value<String> initialWays,
      Value<int> extraWays,
      Value<String?> extraWaysPool,
      Value<String> livingStandard,
      Value<String> description,
      Value<int> rowid,
    });

class $$BatmanProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $BatmanProfilesTable> {
  $$BatmanProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hitDie => $composableBuilder(
    column: $table.hitDie,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get atcBonus => $composableBuilder(
    column: $table.atcBonus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get atdBonus => $composableBuilder(
    column: $table.atdBonus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get atsBonus => $composableBuilder(
    column: $table.atsBonus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exploitPoints => $composableBuilder(
    column: $table.exploitPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get capabilityPoints => $composableBuilder(
    column: $table.capabilityPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryAbilityWithEdge => $composableBuilder(
    column: $table.primaryAbilityWithEdge,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get initialWays => $composableBuilder(
    column: $table.initialWays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get extraWays => $composableBuilder(
    column: $table.extraWays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extraWaysPool => $composableBuilder(
    column: $table.extraWaysPool,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get livingStandard => $composableBuilder(
    column: $table.livingStandard,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BatmanProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $BatmanProfilesTable> {
  $$BatmanProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hitDie => $composableBuilder(
    column: $table.hitDie,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get atcBonus => $composableBuilder(
    column: $table.atcBonus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get atdBonus => $composableBuilder(
    column: $table.atdBonus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get atsBonus => $composableBuilder(
    column: $table.atsBonus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exploitPoints => $composableBuilder(
    column: $table.exploitPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get capabilityPoints => $composableBuilder(
    column: $table.capabilityPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryAbilityWithEdge => $composableBuilder(
    column: $table.primaryAbilityWithEdge,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get initialWays => $composableBuilder(
    column: $table.initialWays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get extraWays => $composableBuilder(
    column: $table.extraWays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extraWaysPool => $composableBuilder(
    column: $table.extraWaysPool,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get livingStandard => $composableBuilder(
    column: $table.livingStandard,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BatmanProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BatmanProfilesTable> {
  $$BatmanProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get hitDie =>
      $composableBuilder(column: $table.hitDie, builder: (column) => column);

  GeneratedColumn<int> get atcBonus =>
      $composableBuilder(column: $table.atcBonus, builder: (column) => column);

  GeneratedColumn<int> get atdBonus =>
      $composableBuilder(column: $table.atdBonus, builder: (column) => column);

  GeneratedColumn<int> get atsBonus =>
      $composableBuilder(column: $table.atsBonus, builder: (column) => column);

  GeneratedColumn<int> get exploitPoints => $composableBuilder(
    column: $table.exploitPoints,
    builder: (column) => column,
  );

  GeneratedColumn<int> get capabilityPoints => $composableBuilder(
    column: $table.capabilityPoints,
    builder: (column) => column,
  );

  GeneratedColumn<String> get primaryAbilityWithEdge => $composableBuilder(
    column: $table.primaryAbilityWithEdge,
    builder: (column) => column,
  );

  GeneratedColumn<String> get initialWays => $composableBuilder(
    column: $table.initialWays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get extraWays =>
      $composableBuilder(column: $table.extraWays, builder: (column) => column);

  GeneratedColumn<String> get extraWaysPool => $composableBuilder(
    column: $table.extraWaysPool,
    builder: (column) => column,
  );

  GeneratedColumn<String> get livingStandard => $composableBuilder(
    column: $table.livingStandard,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );
}

class $$BatmanProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BatmanProfilesTable,
          BatmanProfile,
          $$BatmanProfilesTableFilterComposer,
          $$BatmanProfilesTableOrderingComposer,
          $$BatmanProfilesTableAnnotationComposer,
          $$BatmanProfilesTableCreateCompanionBuilder,
          $$BatmanProfilesTableUpdateCompanionBuilder,
          (
            BatmanProfile,
            BaseReferences<_$AppDatabase, $BatmanProfilesTable, BatmanProfile>,
          ),
          BatmanProfile,
          PrefetchHooks Function()
        > {
  $$BatmanProfilesTableTableManager(
    _$AppDatabase db,
    $BatmanProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BatmanProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BatmanProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BatmanProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<String> hitDie = const Value.absent(),
                Value<int> atcBonus = const Value.absent(),
                Value<int> atdBonus = const Value.absent(),
                Value<int> atsBonus = const Value.absent(),
                Value<int> exploitPoints = const Value.absent(),
                Value<int> capabilityPoints = const Value.absent(),
                Value<String> primaryAbilityWithEdge = const Value.absent(),
                Value<String> initialWays = const Value.absent(),
                Value<int> extraWays = const Value.absent(),
                Value<String?> extraWaysPool = const Value.absent(),
                Value<String> livingStandard = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BatmanProfilesCompanion(
                id: id,
                name: name,
                mode: mode,
                hitDie: hitDie,
                atcBonus: atcBonus,
                atdBonus: atdBonus,
                atsBonus: atsBonus,
                exploitPoints: exploitPoints,
                capabilityPoints: capabilityPoints,
                primaryAbilityWithEdge: primaryAbilityWithEdge,
                initialWays: initialWays,
                extraWays: extraWays,
                extraWaysPool: extraWaysPool,
                livingStandard: livingStandard,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String mode,
                required String hitDie,
                Value<int> atcBonus = const Value.absent(),
                Value<int> atdBonus = const Value.absent(),
                Value<int> atsBonus = const Value.absent(),
                Value<int> exploitPoints = const Value.absent(),
                Value<int> capabilityPoints = const Value.absent(),
                required String primaryAbilityWithEdge,
                required String initialWays,
                Value<int> extraWays = const Value.absent(),
                Value<String?> extraWaysPool = const Value.absent(),
                required String livingStandard,
                required String description,
                Value<int> rowid = const Value.absent(),
              }) => BatmanProfilesCompanion.insert(
                id: id,
                name: name,
                mode: mode,
                hitDie: hitDie,
                atcBonus: atcBonus,
                atdBonus: atdBonus,
                atsBonus: atsBonus,
                exploitPoints: exploitPoints,
                capabilityPoints: capabilityPoints,
                primaryAbilityWithEdge: primaryAbilityWithEdge,
                initialWays: initialWays,
                extraWays: extraWays,
                extraWaysPool: extraWaysPool,
                livingStandard: livingStandard,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BatmanProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BatmanProfilesTable,
      BatmanProfile,
      $$BatmanProfilesTableFilterComposer,
      $$BatmanProfilesTableOrderingComposer,
      $$BatmanProfilesTableAnnotationComposer,
      $$BatmanProfilesTableCreateCompanionBuilder,
      $$BatmanProfilesTableUpdateCompanionBuilder,
      (
        BatmanProfile,
        BaseReferences<_$AppDatabase, $BatmanProfilesTable, BatmanProfile>,
      ),
      BatmanProfile,
      PrefetchHooks Function()
    >;
typedef $$BatmanWaysTableCreateCompanionBuilder =
    BatmanWaysCompanion Function({
      required String id,
      required String name,
      required String type,
      Value<String?> prerequisite,
      required String ranksJson,
      Value<int> rowid,
    });
typedef $$BatmanWaysTableUpdateCompanionBuilder =
    BatmanWaysCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> type,
      Value<String?> prerequisite,
      Value<String> ranksJson,
      Value<int> rowid,
    });

class $$BatmanWaysTableFilterComposer
    extends Composer<_$AppDatabase, $BatmanWaysTable> {
  $$BatmanWaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prerequisite => $composableBuilder(
    column: $table.prerequisite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ranksJson => $composableBuilder(
    column: $table.ranksJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BatmanWaysTableOrderingComposer
    extends Composer<_$AppDatabase, $BatmanWaysTable> {
  $$BatmanWaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prerequisite => $composableBuilder(
    column: $table.prerequisite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ranksJson => $composableBuilder(
    column: $table.ranksJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BatmanWaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $BatmanWaysTable> {
  $$BatmanWaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get prerequisite => $composableBuilder(
    column: $table.prerequisite,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ranksJson =>
      $composableBuilder(column: $table.ranksJson, builder: (column) => column);
}

class $$BatmanWaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BatmanWaysTable,
          BatmanWay,
          $$BatmanWaysTableFilterComposer,
          $$BatmanWaysTableOrderingComposer,
          $$BatmanWaysTableAnnotationComposer,
          $$BatmanWaysTableCreateCompanionBuilder,
          $$BatmanWaysTableUpdateCompanionBuilder,
          (
            BatmanWay,
            BaseReferences<_$AppDatabase, $BatmanWaysTable, BatmanWay>,
          ),
          BatmanWay,
          PrefetchHooks Function()
        > {
  $$BatmanWaysTableTableManager(_$AppDatabase db, $BatmanWaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BatmanWaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BatmanWaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BatmanWaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> prerequisite = const Value.absent(),
                Value<String> ranksJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BatmanWaysCompanion(
                id: id,
                name: name,
                type: type,
                prerequisite: prerequisite,
                ranksJson: ranksJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String type,
                Value<String?> prerequisite = const Value.absent(),
                required String ranksJson,
                Value<int> rowid = const Value.absent(),
              }) => BatmanWaysCompanion.insert(
                id: id,
                name: name,
                type: type,
                prerequisite: prerequisite,
                ranksJson: ranksJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BatmanWaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BatmanWaysTable,
      BatmanWay,
      $$BatmanWaysTableFilterComposer,
      $$BatmanWaysTableOrderingComposer,
      $$BatmanWaysTableAnnotationComposer,
      $$BatmanWaysTableCreateCompanionBuilder,
      $$BatmanWaysTableUpdateCompanionBuilder,
      (BatmanWay, BaseReferences<_$AppDatabase, $BatmanWaysTable, BatmanWay>),
      BatmanWay,
      PrefetchHooks Function()
    >;
typedef $$CharactersTableCreateCompanionBuilder =
    CharactersCompanion Function({
      Value<int> id,
      required String name,
      Value<String> playerName,
      required RulesetVersion ruleset,
      Value<String> alignment,
      Value<int> xp,
      Value<String?> speciesId,
      Value<String?> subspeciesId,
      Value<String?> backgroundId,
      Value<int> hpMax,
      Value<int> hpCurrent,
      Value<int> hpTemp,
      Value<int> armorClass,
      Value<int> speed,
      Value<int> exhaustionLevel,
      Value<bool> heroicInspiration,
      Value<int> deathSaveSuccesses,
      Value<int> deathSaveFailures,
      Value<String> personalityTraits,
      Value<String> ideals,
      Value<String> bonds,
      Value<String> flaws,
      Value<String> backstory,
      Value<String> appearance,
      Value<String> currency,
      required String createdAt,
      required String updatedAt,
    });
typedef $$CharactersTableUpdateCompanionBuilder =
    CharactersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> playerName,
      Value<RulesetVersion> ruleset,
      Value<String> alignment,
      Value<int> xp,
      Value<String?> speciesId,
      Value<String?> subspeciesId,
      Value<String?> backgroundId,
      Value<int> hpMax,
      Value<int> hpCurrent,
      Value<int> hpTemp,
      Value<int> armorClass,
      Value<int> speed,
      Value<int> exhaustionLevel,
      Value<bool> heroicInspiration,
      Value<int> deathSaveSuccesses,
      Value<int> deathSaveFailures,
      Value<String> personalityTraits,
      Value<String> ideals,
      Value<String> bonds,
      Value<String> flaws,
      Value<String> backstory,
      Value<String> appearance,
      Value<String> currency,
      Value<String> createdAt,
      Value<String> updatedAt,
    });

final class $$CharactersTableReferences
    extends BaseReferences<_$AppDatabase, $CharactersTable, Character> {
  $$CharactersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CharacterClassesTable, List<CharacterClassesData>>
  _characterClassesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.characterClasses,
    aliasName: $_aliasNameGenerator(
      db.characters.id,
      db.characterClasses.characterId,
    ),
  );

  $$CharacterClassesTableProcessedTableManager get characterClassesRefs {
    final manager = $$CharacterClassesTableTableManager(
      $_db,
      $_db.characterClasses,
    ).filter((f) => f.characterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _characterClassesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $CharacterAbilityScoresTable,
    List<CharacterAbilityScore>
  >
  _characterAbilityScoresRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.characterAbilityScores,
        aliasName: $_aliasNameGenerator(
          db.characters.id,
          db.characterAbilityScores.characterId,
        ),
      );

  $$CharacterAbilityScoresTableProcessedTableManager
  get characterAbilityScoresRefs {
    final manager = $$CharacterAbilityScoresTableTableManager(
      $_db,
      $_db.characterAbilityScores,
    ).filter((f) => f.characterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _characterAbilityScoresRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $CharacterProficienciesTable,
    List<CharacterProficiency>
  >
  _characterProficienciesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.characterProficiencies,
        aliasName: $_aliasNameGenerator(
          db.characters.id,
          db.characterProficiencies.characterId,
        ),
      );

  $$CharacterProficienciesTableProcessedTableManager
  get characterProficienciesRefs {
    final manager = $$CharacterProficienciesTableTableManager(
      $_db,
      $_db.characterProficiencies,
    ).filter((f) => f.characterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _characterProficienciesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CharacterSpellsTable, List<CharacterSpell>>
  _characterSpellsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.characterSpells,
    aliasName: $_aliasNameGenerator(
      db.characters.id,
      db.characterSpells.characterId,
    ),
  );

  $$CharacterSpellsTableProcessedTableManager get characterSpellsRefs {
    final manager = $$CharacterSpellsTableTableManager(
      $_db,
      $_db.characterSpells,
    ).filter((f) => f.characterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _characterSpellsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CharacterFeatsTable, List<CharacterFeat>>
  _characterFeatsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.characterFeats,
    aliasName: $_aliasNameGenerator(
      db.characters.id,
      db.characterFeats.characterId,
    ),
  );

  $$CharacterFeatsTableProcessedTableManager get characterFeatsRefs {
    final manager = $$CharacterFeatsTableTableManager(
      $_db,
      $_db.characterFeats,
    ).filter((f) => f.characterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_characterFeatsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $CharacterSpellSlotsTable,
    List<CharacterSpellSlot>
  >
  _characterSpellSlotsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.characterSpellSlots,
        aliasName: $_aliasNameGenerator(
          db.characters.id,
          db.characterSpellSlots.characterId,
        ),
      );

  $$CharacterSpellSlotsTableProcessedTableManager get characterSpellSlotsRefs {
    final manager = $$CharacterSpellSlotsTableTableManager(
      $_db,
      $_db.characterSpellSlots,
    ).filter((f) => f.characterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _characterSpellSlotsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CharacterResourcesTable, List<CharacterResource>>
  _characterResourcesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.characterResources,
        aliasName: $_aliasNameGenerator(
          db.characters.id,
          db.characterResources.characterId,
        ),
      );

  $$CharacterResourcesTableProcessedTableManager get characterResourcesRefs {
    final manager = $$CharacterResourcesTableTableManager(
      $_db,
      $_db.characterResources,
    ).filter((f) => f.characterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _characterResourcesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CharacterAttacksTable, List<CharacterAttack>>
  _characterAttacksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.characterAttacks,
    aliasName: $_aliasNameGenerator(
      db.characters.id,
      db.characterAttacks.characterId,
    ),
  );

  $$CharacterAttacksTableProcessedTableManager get characterAttacksRefs {
    final manager = $$CharacterAttacksTableTableManager(
      $_db,
      $_db.characterAttacks,
    ).filter((f) => f.characterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _characterAttacksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $CharacterEquipmentTable,
    List<CharacterEquipmentData>
  >
  _characterEquipmentRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.characterEquipment,
        aliasName: $_aliasNameGenerator(
          db.characters.id,
          db.characterEquipment.characterId,
        ),
      );

  $$CharacterEquipmentTableProcessedTableManager get characterEquipmentRefs {
    final manager = $$CharacterEquipmentTableTableManager(
      $_db,
      $_db.characterEquipment,
    ).filter((f) => f.characterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _characterEquipmentRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BatmanCharactersTable, List<BatmanCharacter>>
  _batmanCharactersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.batmanCharacters,
    aliasName: $_aliasNameGenerator(
      db.characters.id,
      db.batmanCharacters.characterId,
    ),
  );

  $$BatmanCharactersTableProcessedTableManager get batmanCharactersRefs {
    final manager = $$BatmanCharactersTableTableManager(
      $_db,
      $_db.batmanCharacters,
    ).filter((f) => f.characterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _batmanCharactersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $BatmanCharacterWaysTable,
    List<BatmanCharacterWay>
  >
  _batmanCharacterWaysRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.batmanCharacterWays,
        aliasName: $_aliasNameGenerator(
          db.characters.id,
          db.batmanCharacterWays.characterId,
        ),
      );

  $$BatmanCharacterWaysTableProcessedTableManager get batmanCharacterWaysRefs {
    final manager = $$BatmanCharacterWaysTableTableManager(
      $_db,
      $_db.batmanCharacterWays,
    ).filter((f) => f.characterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _batmanCharacterWaysRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CharactersTableFilterComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get playerName => $composableBuilder(
    column: $table.playerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RulesetVersion, RulesetVersion, String>
  get ruleset => $composableBuilder(
    column: $table.ruleset,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get alignment => $composableBuilder(
    column: $table.alignment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get speciesId => $composableBuilder(
    column: $table.speciesId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subspeciesId => $composableBuilder(
    column: $table.subspeciesId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get backgroundId => $composableBuilder(
    column: $table.backgroundId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hpMax => $composableBuilder(
    column: $table.hpMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hpCurrent => $composableBuilder(
    column: $table.hpCurrent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hpTemp => $composableBuilder(
    column: $table.hpTemp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get armorClass => $composableBuilder(
    column: $table.armorClass,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exhaustionLevel => $composableBuilder(
    column: $table.exhaustionLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get heroicInspiration => $composableBuilder(
    column: $table.heroicInspiration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deathSaveSuccesses => $composableBuilder(
    column: $table.deathSaveSuccesses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deathSaveFailures => $composableBuilder(
    column: $table.deathSaveFailures,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get personalityTraits => $composableBuilder(
    column: $table.personalityTraits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ideals => $composableBuilder(
    column: $table.ideals,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bonds => $composableBuilder(
    column: $table.bonds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get flaws => $composableBuilder(
    column: $table.flaws,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get backstory => $composableBuilder(
    column: $table.backstory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appearance => $composableBuilder(
    column: $table.appearance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> characterClassesRefs(
    Expression<bool> Function($$CharacterClassesTableFilterComposer f) f,
  ) {
    final $$CharacterClassesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characterClasses,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharacterClassesTableFilterComposer(
            $db: $db,
            $table: $db.characterClasses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> characterAbilityScoresRefs(
    Expression<bool> Function($$CharacterAbilityScoresTableFilterComposer f) f,
  ) {
    final $$CharacterAbilityScoresTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.characterAbilityScores,
          getReferencedColumn: (t) => t.characterId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CharacterAbilityScoresTableFilterComposer(
                $db: $db,
                $table: $db.characterAbilityScores,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> characterProficienciesRefs(
    Expression<bool> Function($$CharacterProficienciesTableFilterComposer f) f,
  ) {
    final $$CharacterProficienciesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.characterProficiencies,
          getReferencedColumn: (t) => t.characterId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CharacterProficienciesTableFilterComposer(
                $db: $db,
                $table: $db.characterProficiencies,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> characterSpellsRefs(
    Expression<bool> Function($$CharacterSpellsTableFilterComposer f) f,
  ) {
    final $$CharacterSpellsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characterSpells,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharacterSpellsTableFilterComposer(
            $db: $db,
            $table: $db.characterSpells,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> characterFeatsRefs(
    Expression<bool> Function($$CharacterFeatsTableFilterComposer f) f,
  ) {
    final $$CharacterFeatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characterFeats,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharacterFeatsTableFilterComposer(
            $db: $db,
            $table: $db.characterFeats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> characterSpellSlotsRefs(
    Expression<bool> Function($$CharacterSpellSlotsTableFilterComposer f) f,
  ) {
    final $$CharacterSpellSlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characterSpellSlots,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharacterSpellSlotsTableFilterComposer(
            $db: $db,
            $table: $db.characterSpellSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> characterResourcesRefs(
    Expression<bool> Function($$CharacterResourcesTableFilterComposer f) f,
  ) {
    final $$CharacterResourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characterResources,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharacterResourcesTableFilterComposer(
            $db: $db,
            $table: $db.characterResources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> characterAttacksRefs(
    Expression<bool> Function($$CharacterAttacksTableFilterComposer f) f,
  ) {
    final $$CharacterAttacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characterAttacks,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharacterAttacksTableFilterComposer(
            $db: $db,
            $table: $db.characterAttacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> characterEquipmentRefs(
    Expression<bool> Function($$CharacterEquipmentTableFilterComposer f) f,
  ) {
    final $$CharacterEquipmentTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characterEquipment,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharacterEquipmentTableFilterComposer(
            $db: $db,
            $table: $db.characterEquipment,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> batmanCharactersRefs(
    Expression<bool> Function($$BatmanCharactersTableFilterComposer f) f,
  ) {
    final $$BatmanCharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.batmanCharacters,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BatmanCharactersTableFilterComposer(
            $db: $db,
            $table: $db.batmanCharacters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> batmanCharacterWaysRefs(
    Expression<bool> Function($$BatmanCharacterWaysTableFilterComposer f) f,
  ) {
    final $$BatmanCharacterWaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.batmanCharacterWays,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BatmanCharacterWaysTableFilterComposer(
            $db: $db,
            $table: $db.batmanCharacterWays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CharactersTableOrderingComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get playerName => $composableBuilder(
    column: $table.playerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruleset => $composableBuilder(
    column: $table.ruleset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alignment => $composableBuilder(
    column: $table.alignment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get speciesId => $composableBuilder(
    column: $table.speciesId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subspeciesId => $composableBuilder(
    column: $table.subspeciesId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get backgroundId => $composableBuilder(
    column: $table.backgroundId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hpMax => $composableBuilder(
    column: $table.hpMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hpCurrent => $composableBuilder(
    column: $table.hpCurrent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hpTemp => $composableBuilder(
    column: $table.hpTemp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get armorClass => $composableBuilder(
    column: $table.armorClass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exhaustionLevel => $composableBuilder(
    column: $table.exhaustionLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get heroicInspiration => $composableBuilder(
    column: $table.heroicInspiration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deathSaveSuccesses => $composableBuilder(
    column: $table.deathSaveSuccesses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deathSaveFailures => $composableBuilder(
    column: $table.deathSaveFailures,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get personalityTraits => $composableBuilder(
    column: $table.personalityTraits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ideals => $composableBuilder(
    column: $table.ideals,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bonds => $composableBuilder(
    column: $table.bonds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flaws => $composableBuilder(
    column: $table.flaws,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get backstory => $composableBuilder(
    column: $table.backstory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appearance => $composableBuilder(
    column: $table.appearance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CharactersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get playerName => $composableBuilder(
    column: $table.playerName,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<RulesetVersion, String> get ruleset =>
      $composableBuilder(column: $table.ruleset, builder: (column) => column);

  GeneratedColumn<String> get alignment =>
      $composableBuilder(column: $table.alignment, builder: (column) => column);

  GeneratedColumn<int> get xp =>
      $composableBuilder(column: $table.xp, builder: (column) => column);

  GeneratedColumn<String> get speciesId =>
      $composableBuilder(column: $table.speciesId, builder: (column) => column);

  GeneratedColumn<String> get subspeciesId => $composableBuilder(
    column: $table.subspeciesId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get backgroundId => $composableBuilder(
    column: $table.backgroundId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hpMax =>
      $composableBuilder(column: $table.hpMax, builder: (column) => column);

  GeneratedColumn<int> get hpCurrent =>
      $composableBuilder(column: $table.hpCurrent, builder: (column) => column);

  GeneratedColumn<int> get hpTemp =>
      $composableBuilder(column: $table.hpTemp, builder: (column) => column);

  GeneratedColumn<int> get armorClass => $composableBuilder(
    column: $table.armorClass,
    builder: (column) => column,
  );

  GeneratedColumn<int> get speed =>
      $composableBuilder(column: $table.speed, builder: (column) => column);

  GeneratedColumn<int> get exhaustionLevel => $composableBuilder(
    column: $table.exhaustionLevel,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get heroicInspiration => $composableBuilder(
    column: $table.heroicInspiration,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deathSaveSuccesses => $composableBuilder(
    column: $table.deathSaveSuccesses,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deathSaveFailures => $composableBuilder(
    column: $table.deathSaveFailures,
    builder: (column) => column,
  );

  GeneratedColumn<String> get personalityTraits => $composableBuilder(
    column: $table.personalityTraits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ideals =>
      $composableBuilder(column: $table.ideals, builder: (column) => column);

  GeneratedColumn<String> get bonds =>
      $composableBuilder(column: $table.bonds, builder: (column) => column);

  GeneratedColumn<String> get flaws =>
      $composableBuilder(column: $table.flaws, builder: (column) => column);

  GeneratedColumn<String> get backstory =>
      $composableBuilder(column: $table.backstory, builder: (column) => column);

  GeneratedColumn<String> get appearance => $composableBuilder(
    column: $table.appearance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> characterClassesRefs<T extends Object>(
    Expression<T> Function($$CharacterClassesTableAnnotationComposer a) f,
  ) {
    final $$CharacterClassesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characterClasses,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharacterClassesTableAnnotationComposer(
            $db: $db,
            $table: $db.characterClasses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> characterAbilityScoresRefs<T extends Object>(
    Expression<T> Function($$CharacterAbilityScoresTableAnnotationComposer a) f,
  ) {
    final $$CharacterAbilityScoresTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.characterAbilityScores,
          getReferencedColumn: (t) => t.characterId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CharacterAbilityScoresTableAnnotationComposer(
                $db: $db,
                $table: $db.characterAbilityScores,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> characterProficienciesRefs<T extends Object>(
    Expression<T> Function($$CharacterProficienciesTableAnnotationComposer a) f,
  ) {
    final $$CharacterProficienciesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.characterProficiencies,
          getReferencedColumn: (t) => t.characterId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CharacterProficienciesTableAnnotationComposer(
                $db: $db,
                $table: $db.characterProficiencies,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> characterSpellsRefs<T extends Object>(
    Expression<T> Function($$CharacterSpellsTableAnnotationComposer a) f,
  ) {
    final $$CharacterSpellsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characterSpells,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharacterSpellsTableAnnotationComposer(
            $db: $db,
            $table: $db.characterSpells,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> characterFeatsRefs<T extends Object>(
    Expression<T> Function($$CharacterFeatsTableAnnotationComposer a) f,
  ) {
    final $$CharacterFeatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characterFeats,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharacterFeatsTableAnnotationComposer(
            $db: $db,
            $table: $db.characterFeats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> characterSpellSlotsRefs<T extends Object>(
    Expression<T> Function($$CharacterSpellSlotsTableAnnotationComposer a) f,
  ) {
    final $$CharacterSpellSlotsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.characterSpellSlots,
          getReferencedColumn: (t) => t.characterId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CharacterSpellSlotsTableAnnotationComposer(
                $db: $db,
                $table: $db.characterSpellSlots,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> characterResourcesRefs<T extends Object>(
    Expression<T> Function($$CharacterResourcesTableAnnotationComposer a) f,
  ) {
    final $$CharacterResourcesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.characterResources,
          getReferencedColumn: (t) => t.characterId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CharacterResourcesTableAnnotationComposer(
                $db: $db,
                $table: $db.characterResources,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> characterAttacksRefs<T extends Object>(
    Expression<T> Function($$CharacterAttacksTableAnnotationComposer a) f,
  ) {
    final $$CharacterAttacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characterAttacks,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharacterAttacksTableAnnotationComposer(
            $db: $db,
            $table: $db.characterAttacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> characterEquipmentRefs<T extends Object>(
    Expression<T> Function($$CharacterEquipmentTableAnnotationComposer a) f,
  ) {
    final $$CharacterEquipmentTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.characterEquipment,
          getReferencedColumn: (t) => t.characterId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CharacterEquipmentTableAnnotationComposer(
                $db: $db,
                $table: $db.characterEquipment,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> batmanCharactersRefs<T extends Object>(
    Expression<T> Function($$BatmanCharactersTableAnnotationComposer a) f,
  ) {
    final $$BatmanCharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.batmanCharacters,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BatmanCharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.batmanCharacters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> batmanCharacterWaysRefs<T extends Object>(
    Expression<T> Function($$BatmanCharacterWaysTableAnnotationComposer a) f,
  ) {
    final $$BatmanCharacterWaysTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.batmanCharacterWays,
          getReferencedColumn: (t) => t.characterId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BatmanCharacterWaysTableAnnotationComposer(
                $db: $db,
                $table: $db.batmanCharacterWays,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CharactersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharactersTable,
          Character,
          $$CharactersTableFilterComposer,
          $$CharactersTableOrderingComposer,
          $$CharactersTableAnnotationComposer,
          $$CharactersTableCreateCompanionBuilder,
          $$CharactersTableUpdateCompanionBuilder,
          (Character, $$CharactersTableReferences),
          Character,
          PrefetchHooks Function({
            bool characterClassesRefs,
            bool characterAbilityScoresRefs,
            bool characterProficienciesRefs,
            bool characterSpellsRefs,
            bool characterFeatsRefs,
            bool characterSpellSlotsRefs,
            bool characterResourcesRefs,
            bool characterAttacksRefs,
            bool characterEquipmentRefs,
            bool batmanCharactersRefs,
            bool batmanCharacterWaysRefs,
          })
        > {
  $$CharactersTableTableManager(_$AppDatabase db, $CharactersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharactersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharactersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharactersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> playerName = const Value.absent(),
                Value<RulesetVersion> ruleset = const Value.absent(),
                Value<String> alignment = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<String?> speciesId = const Value.absent(),
                Value<String?> subspeciesId = const Value.absent(),
                Value<String?> backgroundId = const Value.absent(),
                Value<int> hpMax = const Value.absent(),
                Value<int> hpCurrent = const Value.absent(),
                Value<int> hpTemp = const Value.absent(),
                Value<int> armorClass = const Value.absent(),
                Value<int> speed = const Value.absent(),
                Value<int> exhaustionLevel = const Value.absent(),
                Value<bool> heroicInspiration = const Value.absent(),
                Value<int> deathSaveSuccesses = const Value.absent(),
                Value<int> deathSaveFailures = const Value.absent(),
                Value<String> personalityTraits = const Value.absent(),
                Value<String> ideals = const Value.absent(),
                Value<String> bonds = const Value.absent(),
                Value<String> flaws = const Value.absent(),
                Value<String> backstory = const Value.absent(),
                Value<String> appearance = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
              }) => CharactersCompanion(
                id: id,
                name: name,
                playerName: playerName,
                ruleset: ruleset,
                alignment: alignment,
                xp: xp,
                speciesId: speciesId,
                subspeciesId: subspeciesId,
                backgroundId: backgroundId,
                hpMax: hpMax,
                hpCurrent: hpCurrent,
                hpTemp: hpTemp,
                armorClass: armorClass,
                speed: speed,
                exhaustionLevel: exhaustionLevel,
                heroicInspiration: heroicInspiration,
                deathSaveSuccesses: deathSaveSuccesses,
                deathSaveFailures: deathSaveFailures,
                personalityTraits: personalityTraits,
                ideals: ideals,
                bonds: bonds,
                flaws: flaws,
                backstory: backstory,
                appearance: appearance,
                currency: currency,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> playerName = const Value.absent(),
                required RulesetVersion ruleset,
                Value<String> alignment = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<String?> speciesId = const Value.absent(),
                Value<String?> subspeciesId = const Value.absent(),
                Value<String?> backgroundId = const Value.absent(),
                Value<int> hpMax = const Value.absent(),
                Value<int> hpCurrent = const Value.absent(),
                Value<int> hpTemp = const Value.absent(),
                Value<int> armorClass = const Value.absent(),
                Value<int> speed = const Value.absent(),
                Value<int> exhaustionLevel = const Value.absent(),
                Value<bool> heroicInspiration = const Value.absent(),
                Value<int> deathSaveSuccesses = const Value.absent(),
                Value<int> deathSaveFailures = const Value.absent(),
                Value<String> personalityTraits = const Value.absent(),
                Value<String> ideals = const Value.absent(),
                Value<String> bonds = const Value.absent(),
                Value<String> flaws = const Value.absent(),
                Value<String> backstory = const Value.absent(),
                Value<String> appearance = const Value.absent(),
                Value<String> currency = const Value.absent(),
                required String createdAt,
                required String updatedAt,
              }) => CharactersCompanion.insert(
                id: id,
                name: name,
                playerName: playerName,
                ruleset: ruleset,
                alignment: alignment,
                xp: xp,
                speciesId: speciesId,
                subspeciesId: subspeciesId,
                backgroundId: backgroundId,
                hpMax: hpMax,
                hpCurrent: hpCurrent,
                hpTemp: hpTemp,
                armorClass: armorClass,
                speed: speed,
                exhaustionLevel: exhaustionLevel,
                heroicInspiration: heroicInspiration,
                deathSaveSuccesses: deathSaveSuccesses,
                deathSaveFailures: deathSaveFailures,
                personalityTraits: personalityTraits,
                ideals: ideals,
                bonds: bonds,
                flaws: flaws,
                backstory: backstory,
                appearance: appearance,
                currency: currency,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CharactersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                characterClassesRefs = false,
                characterAbilityScoresRefs = false,
                characterProficienciesRefs = false,
                characterSpellsRefs = false,
                characterFeatsRefs = false,
                characterSpellSlotsRefs = false,
                characterResourcesRefs = false,
                characterAttacksRefs = false,
                characterEquipmentRefs = false,
                batmanCharactersRefs = false,
                batmanCharacterWaysRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (characterClassesRefs) db.characterClasses,
                    if (characterAbilityScoresRefs) db.characterAbilityScores,
                    if (characterProficienciesRefs) db.characterProficiencies,
                    if (characterSpellsRefs) db.characterSpells,
                    if (characterFeatsRefs) db.characterFeats,
                    if (characterSpellSlotsRefs) db.characterSpellSlots,
                    if (characterResourcesRefs) db.characterResources,
                    if (characterAttacksRefs) db.characterAttacks,
                    if (characterEquipmentRefs) db.characterEquipment,
                    if (batmanCharactersRefs) db.batmanCharacters,
                    if (batmanCharacterWaysRefs) db.batmanCharacterWays,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (characterClassesRefs)
                        await $_getPrefetchedData<
                          Character,
                          $CharactersTable,
                          CharacterClassesData
                        >(
                          currentTable: table,
                          referencedTable: $$CharactersTableReferences
                              ._characterClassesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharactersTableReferences(
                                db,
                                table,
                                p0,
                              ).characterClassesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.characterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (characterAbilityScoresRefs)
                        await $_getPrefetchedData<
                          Character,
                          $CharactersTable,
                          CharacterAbilityScore
                        >(
                          currentTable: table,
                          referencedTable: $$CharactersTableReferences
                              ._characterAbilityScoresRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharactersTableReferences(
                                db,
                                table,
                                p0,
                              ).characterAbilityScoresRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.characterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (characterProficienciesRefs)
                        await $_getPrefetchedData<
                          Character,
                          $CharactersTable,
                          CharacterProficiency
                        >(
                          currentTable: table,
                          referencedTable: $$CharactersTableReferences
                              ._characterProficienciesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharactersTableReferences(
                                db,
                                table,
                                p0,
                              ).characterProficienciesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.characterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (characterSpellsRefs)
                        await $_getPrefetchedData<
                          Character,
                          $CharactersTable,
                          CharacterSpell
                        >(
                          currentTable: table,
                          referencedTable: $$CharactersTableReferences
                              ._characterSpellsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharactersTableReferences(
                                db,
                                table,
                                p0,
                              ).characterSpellsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.characterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (characterFeatsRefs)
                        await $_getPrefetchedData<
                          Character,
                          $CharactersTable,
                          CharacterFeat
                        >(
                          currentTable: table,
                          referencedTable: $$CharactersTableReferences
                              ._characterFeatsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharactersTableReferences(
                                db,
                                table,
                                p0,
                              ).characterFeatsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.characterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (characterSpellSlotsRefs)
                        await $_getPrefetchedData<
                          Character,
                          $CharactersTable,
                          CharacterSpellSlot
                        >(
                          currentTable: table,
                          referencedTable: $$CharactersTableReferences
                              ._characterSpellSlotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharactersTableReferences(
                                db,
                                table,
                                p0,
                              ).characterSpellSlotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.characterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (characterResourcesRefs)
                        await $_getPrefetchedData<
                          Character,
                          $CharactersTable,
                          CharacterResource
                        >(
                          currentTable: table,
                          referencedTable: $$CharactersTableReferences
                              ._characterResourcesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharactersTableReferences(
                                db,
                                table,
                                p0,
                              ).characterResourcesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.characterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (characterAttacksRefs)
                        await $_getPrefetchedData<
                          Character,
                          $CharactersTable,
                          CharacterAttack
                        >(
                          currentTable: table,
                          referencedTable: $$CharactersTableReferences
                              ._characterAttacksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharactersTableReferences(
                                db,
                                table,
                                p0,
                              ).characterAttacksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.characterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (characterEquipmentRefs)
                        await $_getPrefetchedData<
                          Character,
                          $CharactersTable,
                          CharacterEquipmentData
                        >(
                          currentTable: table,
                          referencedTable: $$CharactersTableReferences
                              ._characterEquipmentRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharactersTableReferences(
                                db,
                                table,
                                p0,
                              ).characterEquipmentRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.characterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (batmanCharactersRefs)
                        await $_getPrefetchedData<
                          Character,
                          $CharactersTable,
                          BatmanCharacter
                        >(
                          currentTable: table,
                          referencedTable: $$CharactersTableReferences
                              ._batmanCharactersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharactersTableReferences(
                                db,
                                table,
                                p0,
                              ).batmanCharactersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.characterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (batmanCharacterWaysRefs)
                        await $_getPrefetchedData<
                          Character,
                          $CharactersTable,
                          BatmanCharacterWay
                        >(
                          currentTable: table,
                          referencedTable: $$CharactersTableReferences
                              ._batmanCharacterWaysRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharactersTableReferences(
                                db,
                                table,
                                p0,
                              ).batmanCharacterWaysRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.characterId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CharactersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharactersTable,
      Character,
      $$CharactersTableFilterComposer,
      $$CharactersTableOrderingComposer,
      $$CharactersTableAnnotationComposer,
      $$CharactersTableCreateCompanionBuilder,
      $$CharactersTableUpdateCompanionBuilder,
      (Character, $$CharactersTableReferences),
      Character,
      PrefetchHooks Function({
        bool characterClassesRefs,
        bool characterAbilityScoresRefs,
        bool characterProficienciesRefs,
        bool characterSpellsRefs,
        bool characterFeatsRefs,
        bool characterSpellSlotsRefs,
        bool characterResourcesRefs,
        bool characterAttacksRefs,
        bool characterEquipmentRefs,
        bool batmanCharactersRefs,
        bool batmanCharacterWaysRefs,
      })
    >;
typedef $$CharacterClassesTableCreateCompanionBuilder =
    CharacterClassesCompanion Function({
      Value<int> id,
      required int characterId,
      required String classId,
      Value<String?> subclassId,
      required int level,
    });
typedef $$CharacterClassesTableUpdateCompanionBuilder =
    CharacterClassesCompanion Function({
      Value<int> id,
      Value<int> characterId,
      Value<String> classId,
      Value<String?> subclassId,
      Value<int> level,
    });

final class $$CharacterClassesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CharacterClassesTable,
          CharacterClassesData
        > {
  $$CharacterClassesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CharactersTable _characterIdTable(_$AppDatabase db) =>
      db.characters.createAlias(
        $_aliasNameGenerator(db.characterClasses.characterId, db.characters.id),
      );

  $$CharactersTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<int>('character_id')!;

    final manager = $$CharactersTableTableManager(
      $_db,
      $_db.characters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CharacterClassesTableFilterComposer
    extends Composer<_$AppDatabase, $CharacterClassesTable> {
  $$CharacterClassesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classId => $composableBuilder(
    column: $table.classId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subclassId => $composableBuilder(
    column: $table.subclassId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  $$CharactersTableFilterComposer get characterId {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterClassesTableOrderingComposer
    extends Composer<_$AppDatabase, $CharacterClassesTable> {
  $$CharacterClassesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classId => $composableBuilder(
    column: $table.classId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subclassId => $composableBuilder(
    column: $table.subclassId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  $$CharactersTableOrderingComposer get characterId {
    final $$CharactersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableOrderingComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterClassesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharacterClassesTable> {
  $$CharacterClassesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get classId =>
      $composableBuilder(column: $table.classId, builder: (column) => column);

  GeneratedColumn<String> get subclassId => $composableBuilder(
    column: $table.subclassId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  $$CharactersTableAnnotationComposer get characterId {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterClassesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharacterClassesTable,
          CharacterClassesData,
          $$CharacterClassesTableFilterComposer,
          $$CharacterClassesTableOrderingComposer,
          $$CharacterClassesTableAnnotationComposer,
          $$CharacterClassesTableCreateCompanionBuilder,
          $$CharacterClassesTableUpdateCompanionBuilder,
          (CharacterClassesData, $$CharacterClassesTableReferences),
          CharacterClassesData,
          PrefetchHooks Function({bool characterId})
        > {
  $$CharacterClassesTableTableManager(
    _$AppDatabase db,
    $CharacterClassesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharacterClassesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharacterClassesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharacterClassesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> characterId = const Value.absent(),
                Value<String> classId = const Value.absent(),
                Value<String?> subclassId = const Value.absent(),
                Value<int> level = const Value.absent(),
              }) => CharacterClassesCompanion(
                id: id,
                characterId: characterId,
                classId: classId,
                subclassId: subclassId,
                level: level,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int characterId,
                required String classId,
                Value<String?> subclassId = const Value.absent(),
                required int level,
              }) => CharacterClassesCompanion.insert(
                id: id,
                characterId: characterId,
                classId: classId,
                subclassId: subclassId,
                level: level,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CharacterClassesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({characterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (characterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.characterId,
                                referencedTable:
                                    $$CharacterClassesTableReferences
                                        ._characterIdTable(db),
                                referencedColumn:
                                    $$CharacterClassesTableReferences
                                        ._characterIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CharacterClassesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharacterClassesTable,
      CharacterClassesData,
      $$CharacterClassesTableFilterComposer,
      $$CharacterClassesTableOrderingComposer,
      $$CharacterClassesTableAnnotationComposer,
      $$CharacterClassesTableCreateCompanionBuilder,
      $$CharacterClassesTableUpdateCompanionBuilder,
      (CharacterClassesData, $$CharacterClassesTableReferences),
      CharacterClassesData,
      PrefetchHooks Function({bool characterId})
    >;
typedef $$CharacterAbilityScoresTableCreateCompanionBuilder =
    CharacterAbilityScoresCompanion Function({
      Value<int> id,
      required int characterId,
      Value<int> strength,
      Value<int> dexterity,
      Value<int> constitution,
      Value<int> intelligence,
      Value<int> wisdom,
      Value<int> charisma,
    });
typedef $$CharacterAbilityScoresTableUpdateCompanionBuilder =
    CharacterAbilityScoresCompanion Function({
      Value<int> id,
      Value<int> characterId,
      Value<int> strength,
      Value<int> dexterity,
      Value<int> constitution,
      Value<int> intelligence,
      Value<int> wisdom,
      Value<int> charisma,
    });

final class $$CharacterAbilityScoresTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CharacterAbilityScoresTable,
          CharacterAbilityScore
        > {
  $$CharacterAbilityScoresTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CharactersTable _characterIdTable(_$AppDatabase db) =>
      db.characters.createAlias(
        $_aliasNameGenerator(
          db.characterAbilityScores.characterId,
          db.characters.id,
        ),
      );

  $$CharactersTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<int>('character_id')!;

    final manager = $$CharactersTableTableManager(
      $_db,
      $_db.characters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CharacterAbilityScoresTableFilterComposer
    extends Composer<_$AppDatabase, $CharacterAbilityScoresTable> {
  $$CharacterAbilityScoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dexterity => $composableBuilder(
    column: $table.dexterity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get constitution => $composableBuilder(
    column: $table.constitution,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intelligence => $composableBuilder(
    column: $table.intelligence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wisdom => $composableBuilder(
    column: $table.wisdom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get charisma => $composableBuilder(
    column: $table.charisma,
    builder: (column) => ColumnFilters(column),
  );

  $$CharactersTableFilterComposer get characterId {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterAbilityScoresTableOrderingComposer
    extends Composer<_$AppDatabase, $CharacterAbilityScoresTable> {
  $$CharacterAbilityScoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dexterity => $composableBuilder(
    column: $table.dexterity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get constitution => $composableBuilder(
    column: $table.constitution,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intelligence => $composableBuilder(
    column: $table.intelligence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wisdom => $composableBuilder(
    column: $table.wisdom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get charisma => $composableBuilder(
    column: $table.charisma,
    builder: (column) => ColumnOrderings(column),
  );

  $$CharactersTableOrderingComposer get characterId {
    final $$CharactersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableOrderingComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterAbilityScoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharacterAbilityScoresTable> {
  $$CharacterAbilityScoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get strength =>
      $composableBuilder(column: $table.strength, builder: (column) => column);

  GeneratedColumn<int> get dexterity =>
      $composableBuilder(column: $table.dexterity, builder: (column) => column);

  GeneratedColumn<int> get constitution => $composableBuilder(
    column: $table.constitution,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intelligence => $composableBuilder(
    column: $table.intelligence,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wisdom =>
      $composableBuilder(column: $table.wisdom, builder: (column) => column);

  GeneratedColumn<int> get charisma =>
      $composableBuilder(column: $table.charisma, builder: (column) => column);

  $$CharactersTableAnnotationComposer get characterId {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterAbilityScoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharacterAbilityScoresTable,
          CharacterAbilityScore,
          $$CharacterAbilityScoresTableFilterComposer,
          $$CharacterAbilityScoresTableOrderingComposer,
          $$CharacterAbilityScoresTableAnnotationComposer,
          $$CharacterAbilityScoresTableCreateCompanionBuilder,
          $$CharacterAbilityScoresTableUpdateCompanionBuilder,
          (CharacterAbilityScore, $$CharacterAbilityScoresTableReferences),
          CharacterAbilityScore,
          PrefetchHooks Function({bool characterId})
        > {
  $$CharacterAbilityScoresTableTableManager(
    _$AppDatabase db,
    $CharacterAbilityScoresTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharacterAbilityScoresTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CharacterAbilityScoresTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CharacterAbilityScoresTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> characterId = const Value.absent(),
                Value<int> strength = const Value.absent(),
                Value<int> dexterity = const Value.absent(),
                Value<int> constitution = const Value.absent(),
                Value<int> intelligence = const Value.absent(),
                Value<int> wisdom = const Value.absent(),
                Value<int> charisma = const Value.absent(),
              }) => CharacterAbilityScoresCompanion(
                id: id,
                characterId: characterId,
                strength: strength,
                dexterity: dexterity,
                constitution: constitution,
                intelligence: intelligence,
                wisdom: wisdom,
                charisma: charisma,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int characterId,
                Value<int> strength = const Value.absent(),
                Value<int> dexterity = const Value.absent(),
                Value<int> constitution = const Value.absent(),
                Value<int> intelligence = const Value.absent(),
                Value<int> wisdom = const Value.absent(),
                Value<int> charisma = const Value.absent(),
              }) => CharacterAbilityScoresCompanion.insert(
                id: id,
                characterId: characterId,
                strength: strength,
                dexterity: dexterity,
                constitution: constitution,
                intelligence: intelligence,
                wisdom: wisdom,
                charisma: charisma,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CharacterAbilityScoresTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({characterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (characterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.characterId,
                                referencedTable:
                                    $$CharacterAbilityScoresTableReferences
                                        ._characterIdTable(db),
                                referencedColumn:
                                    $$CharacterAbilityScoresTableReferences
                                        ._characterIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CharacterAbilityScoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharacterAbilityScoresTable,
      CharacterAbilityScore,
      $$CharacterAbilityScoresTableFilterComposer,
      $$CharacterAbilityScoresTableOrderingComposer,
      $$CharacterAbilityScoresTableAnnotationComposer,
      $$CharacterAbilityScoresTableCreateCompanionBuilder,
      $$CharacterAbilityScoresTableUpdateCompanionBuilder,
      (CharacterAbilityScore, $$CharacterAbilityScoresTableReferences),
      CharacterAbilityScore,
      PrefetchHooks Function({bool characterId})
    >;
typedef $$CharacterProficienciesTableCreateCompanionBuilder =
    CharacterProficienciesCompanion Function({
      Value<int> id,
      required int characterId,
      required String proficiencyKey,
      Value<bool> hasExpertise,
    });
typedef $$CharacterProficienciesTableUpdateCompanionBuilder =
    CharacterProficienciesCompanion Function({
      Value<int> id,
      Value<int> characterId,
      Value<String> proficiencyKey,
      Value<bool> hasExpertise,
    });

final class $$CharacterProficienciesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CharacterProficienciesTable,
          CharacterProficiency
        > {
  $$CharacterProficienciesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CharactersTable _characterIdTable(_$AppDatabase db) =>
      db.characters.createAlias(
        $_aliasNameGenerator(
          db.characterProficiencies.characterId,
          db.characters.id,
        ),
      );

  $$CharactersTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<int>('character_id')!;

    final manager = $$CharactersTableTableManager(
      $_db,
      $_db.characters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CharacterProficienciesTableFilterComposer
    extends Composer<_$AppDatabase, $CharacterProficienciesTable> {
  $$CharacterProficienciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proficiencyKey => $composableBuilder(
    column: $table.proficiencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasExpertise => $composableBuilder(
    column: $table.hasExpertise,
    builder: (column) => ColumnFilters(column),
  );

  $$CharactersTableFilterComposer get characterId {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterProficienciesTableOrderingComposer
    extends Composer<_$AppDatabase, $CharacterProficienciesTable> {
  $$CharacterProficienciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proficiencyKey => $composableBuilder(
    column: $table.proficiencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasExpertise => $composableBuilder(
    column: $table.hasExpertise,
    builder: (column) => ColumnOrderings(column),
  );

  $$CharactersTableOrderingComposer get characterId {
    final $$CharactersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableOrderingComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterProficienciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharacterProficienciesTable> {
  $$CharacterProficienciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get proficiencyKey => $composableBuilder(
    column: $table.proficiencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasExpertise => $composableBuilder(
    column: $table.hasExpertise,
    builder: (column) => column,
  );

  $$CharactersTableAnnotationComposer get characterId {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterProficienciesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharacterProficienciesTable,
          CharacterProficiency,
          $$CharacterProficienciesTableFilterComposer,
          $$CharacterProficienciesTableOrderingComposer,
          $$CharacterProficienciesTableAnnotationComposer,
          $$CharacterProficienciesTableCreateCompanionBuilder,
          $$CharacterProficienciesTableUpdateCompanionBuilder,
          (CharacterProficiency, $$CharacterProficienciesTableReferences),
          CharacterProficiency,
          PrefetchHooks Function({bool characterId})
        > {
  $$CharacterProficienciesTableTableManager(
    _$AppDatabase db,
    $CharacterProficienciesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharacterProficienciesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CharacterProficienciesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CharacterProficienciesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> characterId = const Value.absent(),
                Value<String> proficiencyKey = const Value.absent(),
                Value<bool> hasExpertise = const Value.absent(),
              }) => CharacterProficienciesCompanion(
                id: id,
                characterId: characterId,
                proficiencyKey: proficiencyKey,
                hasExpertise: hasExpertise,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int characterId,
                required String proficiencyKey,
                Value<bool> hasExpertise = const Value.absent(),
              }) => CharacterProficienciesCompanion.insert(
                id: id,
                characterId: characterId,
                proficiencyKey: proficiencyKey,
                hasExpertise: hasExpertise,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CharacterProficienciesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({characterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (characterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.characterId,
                                referencedTable:
                                    $$CharacterProficienciesTableReferences
                                        ._characterIdTable(db),
                                referencedColumn:
                                    $$CharacterProficienciesTableReferences
                                        ._characterIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CharacterProficienciesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharacterProficienciesTable,
      CharacterProficiency,
      $$CharacterProficienciesTableFilterComposer,
      $$CharacterProficienciesTableOrderingComposer,
      $$CharacterProficienciesTableAnnotationComposer,
      $$CharacterProficienciesTableCreateCompanionBuilder,
      $$CharacterProficienciesTableUpdateCompanionBuilder,
      (CharacterProficiency, $$CharacterProficienciesTableReferences),
      CharacterProficiency,
      PrefetchHooks Function({bool characterId})
    >;
typedef $$CharacterSpellsTableCreateCompanionBuilder =
    CharacterSpellsCompanion Function({
      Value<int> id,
      required int characterId,
      required String spellId,
      required RulesetVersion ruleset,
      Value<bool> prepared,
      Value<bool> alwaysPrepared,
    });
typedef $$CharacterSpellsTableUpdateCompanionBuilder =
    CharacterSpellsCompanion Function({
      Value<int> id,
      Value<int> characterId,
      Value<String> spellId,
      Value<RulesetVersion> ruleset,
      Value<bool> prepared,
      Value<bool> alwaysPrepared,
    });

final class $$CharacterSpellsTableReferences
    extends
        BaseReferences<_$AppDatabase, $CharacterSpellsTable, CharacterSpell> {
  $$CharacterSpellsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CharactersTable _characterIdTable(_$AppDatabase db) =>
      db.characters.createAlias(
        $_aliasNameGenerator(db.characterSpells.characterId, db.characters.id),
      );

  $$CharactersTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<int>('character_id')!;

    final manager = $$CharactersTableTableManager(
      $_db,
      $_db.characters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CharacterSpellsTableFilterComposer
    extends Composer<_$AppDatabase, $CharacterSpellsTable> {
  $$CharacterSpellsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spellId => $composableBuilder(
    column: $table.spellId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RulesetVersion, RulesetVersion, String>
  get ruleset => $composableBuilder(
    column: $table.ruleset,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get prepared => $composableBuilder(
    column: $table.prepared,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get alwaysPrepared => $composableBuilder(
    column: $table.alwaysPrepared,
    builder: (column) => ColumnFilters(column),
  );

  $$CharactersTableFilterComposer get characterId {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterSpellsTableOrderingComposer
    extends Composer<_$AppDatabase, $CharacterSpellsTable> {
  $$CharacterSpellsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spellId => $composableBuilder(
    column: $table.spellId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruleset => $composableBuilder(
    column: $table.ruleset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get prepared => $composableBuilder(
    column: $table.prepared,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get alwaysPrepared => $composableBuilder(
    column: $table.alwaysPrepared,
    builder: (column) => ColumnOrderings(column),
  );

  $$CharactersTableOrderingComposer get characterId {
    final $$CharactersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableOrderingComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterSpellsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharacterSpellsTable> {
  $$CharacterSpellsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get spellId =>
      $composableBuilder(column: $table.spellId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RulesetVersion, String> get ruleset =>
      $composableBuilder(column: $table.ruleset, builder: (column) => column);

  GeneratedColumn<bool> get prepared =>
      $composableBuilder(column: $table.prepared, builder: (column) => column);

  GeneratedColumn<bool> get alwaysPrepared => $composableBuilder(
    column: $table.alwaysPrepared,
    builder: (column) => column,
  );

  $$CharactersTableAnnotationComposer get characterId {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterSpellsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharacterSpellsTable,
          CharacterSpell,
          $$CharacterSpellsTableFilterComposer,
          $$CharacterSpellsTableOrderingComposer,
          $$CharacterSpellsTableAnnotationComposer,
          $$CharacterSpellsTableCreateCompanionBuilder,
          $$CharacterSpellsTableUpdateCompanionBuilder,
          (CharacterSpell, $$CharacterSpellsTableReferences),
          CharacterSpell,
          PrefetchHooks Function({bool characterId})
        > {
  $$CharacterSpellsTableTableManager(
    _$AppDatabase db,
    $CharacterSpellsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharacterSpellsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharacterSpellsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharacterSpellsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> characterId = const Value.absent(),
                Value<String> spellId = const Value.absent(),
                Value<RulesetVersion> ruleset = const Value.absent(),
                Value<bool> prepared = const Value.absent(),
                Value<bool> alwaysPrepared = const Value.absent(),
              }) => CharacterSpellsCompanion(
                id: id,
                characterId: characterId,
                spellId: spellId,
                ruleset: ruleset,
                prepared: prepared,
                alwaysPrepared: alwaysPrepared,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int characterId,
                required String spellId,
                required RulesetVersion ruleset,
                Value<bool> prepared = const Value.absent(),
                Value<bool> alwaysPrepared = const Value.absent(),
              }) => CharacterSpellsCompanion.insert(
                id: id,
                characterId: characterId,
                spellId: spellId,
                ruleset: ruleset,
                prepared: prepared,
                alwaysPrepared: alwaysPrepared,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CharacterSpellsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({characterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (characterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.characterId,
                                referencedTable:
                                    $$CharacterSpellsTableReferences
                                        ._characterIdTable(db),
                                referencedColumn:
                                    $$CharacterSpellsTableReferences
                                        ._characterIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CharacterSpellsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharacterSpellsTable,
      CharacterSpell,
      $$CharacterSpellsTableFilterComposer,
      $$CharacterSpellsTableOrderingComposer,
      $$CharacterSpellsTableAnnotationComposer,
      $$CharacterSpellsTableCreateCompanionBuilder,
      $$CharacterSpellsTableUpdateCompanionBuilder,
      (CharacterSpell, $$CharacterSpellsTableReferences),
      CharacterSpell,
      PrefetchHooks Function({bool characterId})
    >;
typedef $$CharacterFeatsTableCreateCompanionBuilder =
    CharacterFeatsCompanion Function({
      Value<int> id,
      required int characterId,
      required String featId,
      required RulesetVersion ruleset,
      Value<String?> choicesJson,
    });
typedef $$CharacterFeatsTableUpdateCompanionBuilder =
    CharacterFeatsCompanion Function({
      Value<int> id,
      Value<int> characterId,
      Value<String> featId,
      Value<RulesetVersion> ruleset,
      Value<String?> choicesJson,
    });

final class $$CharacterFeatsTableReferences
    extends BaseReferences<_$AppDatabase, $CharacterFeatsTable, CharacterFeat> {
  $$CharacterFeatsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CharactersTable _characterIdTable(_$AppDatabase db) =>
      db.characters.createAlias(
        $_aliasNameGenerator(db.characterFeats.characterId, db.characters.id),
      );

  $$CharactersTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<int>('character_id')!;

    final manager = $$CharactersTableTableManager(
      $_db,
      $_db.characters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CharacterFeatsTableFilterComposer
    extends Composer<_$AppDatabase, $CharacterFeatsTable> {
  $$CharacterFeatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get featId => $composableBuilder(
    column: $table.featId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RulesetVersion, RulesetVersion, String>
  get ruleset => $composableBuilder(
    column: $table.ruleset,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get choicesJson => $composableBuilder(
    column: $table.choicesJson,
    builder: (column) => ColumnFilters(column),
  );

  $$CharactersTableFilterComposer get characterId {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterFeatsTableOrderingComposer
    extends Composer<_$AppDatabase, $CharacterFeatsTable> {
  $$CharacterFeatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get featId => $composableBuilder(
    column: $table.featId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruleset => $composableBuilder(
    column: $table.ruleset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get choicesJson => $composableBuilder(
    column: $table.choicesJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$CharactersTableOrderingComposer get characterId {
    final $$CharactersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableOrderingComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterFeatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharacterFeatsTable> {
  $$CharacterFeatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get featId =>
      $composableBuilder(column: $table.featId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RulesetVersion, String> get ruleset =>
      $composableBuilder(column: $table.ruleset, builder: (column) => column);

  GeneratedColumn<String> get choicesJson => $composableBuilder(
    column: $table.choicesJson,
    builder: (column) => column,
  );

  $$CharactersTableAnnotationComposer get characterId {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterFeatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharacterFeatsTable,
          CharacterFeat,
          $$CharacterFeatsTableFilterComposer,
          $$CharacterFeatsTableOrderingComposer,
          $$CharacterFeatsTableAnnotationComposer,
          $$CharacterFeatsTableCreateCompanionBuilder,
          $$CharacterFeatsTableUpdateCompanionBuilder,
          (CharacterFeat, $$CharacterFeatsTableReferences),
          CharacterFeat,
          PrefetchHooks Function({bool characterId})
        > {
  $$CharacterFeatsTableTableManager(
    _$AppDatabase db,
    $CharacterFeatsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharacterFeatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharacterFeatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharacterFeatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> characterId = const Value.absent(),
                Value<String> featId = const Value.absent(),
                Value<RulesetVersion> ruleset = const Value.absent(),
                Value<String?> choicesJson = const Value.absent(),
              }) => CharacterFeatsCompanion(
                id: id,
                characterId: characterId,
                featId: featId,
                ruleset: ruleset,
                choicesJson: choicesJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int characterId,
                required String featId,
                required RulesetVersion ruleset,
                Value<String?> choicesJson = const Value.absent(),
              }) => CharacterFeatsCompanion.insert(
                id: id,
                characterId: characterId,
                featId: featId,
                ruleset: ruleset,
                choicesJson: choicesJson,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CharacterFeatsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({characterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (characterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.characterId,
                                referencedTable: $$CharacterFeatsTableReferences
                                    ._characterIdTable(db),
                                referencedColumn:
                                    $$CharacterFeatsTableReferences
                                        ._characterIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CharacterFeatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharacterFeatsTable,
      CharacterFeat,
      $$CharacterFeatsTableFilterComposer,
      $$CharacterFeatsTableOrderingComposer,
      $$CharacterFeatsTableAnnotationComposer,
      $$CharacterFeatsTableCreateCompanionBuilder,
      $$CharacterFeatsTableUpdateCompanionBuilder,
      (CharacterFeat, $$CharacterFeatsTableReferences),
      CharacterFeat,
      PrefetchHooks Function({bool characterId})
    >;
typedef $$CharacterSpellSlotsTableCreateCompanionBuilder =
    CharacterSpellSlotsCompanion Function({
      Value<int> id,
      required int characterId,
      required int slotLevel,
      required int slotMax,
      required int slotCurrent,
    });
typedef $$CharacterSpellSlotsTableUpdateCompanionBuilder =
    CharacterSpellSlotsCompanion Function({
      Value<int> id,
      Value<int> characterId,
      Value<int> slotLevel,
      Value<int> slotMax,
      Value<int> slotCurrent,
    });

final class $$CharacterSpellSlotsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CharacterSpellSlotsTable,
          CharacterSpellSlot
        > {
  $$CharacterSpellSlotsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CharactersTable _characterIdTable(_$AppDatabase db) =>
      db.characters.createAlias(
        $_aliasNameGenerator(
          db.characterSpellSlots.characterId,
          db.characters.id,
        ),
      );

  $$CharactersTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<int>('character_id')!;

    final manager = $$CharactersTableTableManager(
      $_db,
      $_db.characters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CharacterSpellSlotsTableFilterComposer
    extends Composer<_$AppDatabase, $CharacterSpellSlotsTable> {
  $$CharacterSpellSlotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get slotLevel => $composableBuilder(
    column: $table.slotLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get slotMax => $composableBuilder(
    column: $table.slotMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get slotCurrent => $composableBuilder(
    column: $table.slotCurrent,
    builder: (column) => ColumnFilters(column),
  );

  $$CharactersTableFilterComposer get characterId {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterSpellSlotsTableOrderingComposer
    extends Composer<_$AppDatabase, $CharacterSpellSlotsTable> {
  $$CharacterSpellSlotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get slotLevel => $composableBuilder(
    column: $table.slotLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get slotMax => $composableBuilder(
    column: $table.slotMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get slotCurrent => $composableBuilder(
    column: $table.slotCurrent,
    builder: (column) => ColumnOrderings(column),
  );

  $$CharactersTableOrderingComposer get characterId {
    final $$CharactersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableOrderingComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterSpellSlotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharacterSpellSlotsTable> {
  $$CharacterSpellSlotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get slotLevel =>
      $composableBuilder(column: $table.slotLevel, builder: (column) => column);

  GeneratedColumn<int> get slotMax =>
      $composableBuilder(column: $table.slotMax, builder: (column) => column);

  GeneratedColumn<int> get slotCurrent => $composableBuilder(
    column: $table.slotCurrent,
    builder: (column) => column,
  );

  $$CharactersTableAnnotationComposer get characterId {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterSpellSlotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharacterSpellSlotsTable,
          CharacterSpellSlot,
          $$CharacterSpellSlotsTableFilterComposer,
          $$CharacterSpellSlotsTableOrderingComposer,
          $$CharacterSpellSlotsTableAnnotationComposer,
          $$CharacterSpellSlotsTableCreateCompanionBuilder,
          $$CharacterSpellSlotsTableUpdateCompanionBuilder,
          (CharacterSpellSlot, $$CharacterSpellSlotsTableReferences),
          CharacterSpellSlot,
          PrefetchHooks Function({bool characterId})
        > {
  $$CharacterSpellSlotsTableTableManager(
    _$AppDatabase db,
    $CharacterSpellSlotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharacterSpellSlotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharacterSpellSlotsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CharacterSpellSlotsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> characterId = const Value.absent(),
                Value<int> slotLevel = const Value.absent(),
                Value<int> slotMax = const Value.absent(),
                Value<int> slotCurrent = const Value.absent(),
              }) => CharacterSpellSlotsCompanion(
                id: id,
                characterId: characterId,
                slotLevel: slotLevel,
                slotMax: slotMax,
                slotCurrent: slotCurrent,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int characterId,
                required int slotLevel,
                required int slotMax,
                required int slotCurrent,
              }) => CharacterSpellSlotsCompanion.insert(
                id: id,
                characterId: characterId,
                slotLevel: slotLevel,
                slotMax: slotMax,
                slotCurrent: slotCurrent,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CharacterSpellSlotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({characterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (characterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.characterId,
                                referencedTable:
                                    $$CharacterSpellSlotsTableReferences
                                        ._characterIdTable(db),
                                referencedColumn:
                                    $$CharacterSpellSlotsTableReferences
                                        ._characterIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CharacterSpellSlotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharacterSpellSlotsTable,
      CharacterSpellSlot,
      $$CharacterSpellSlotsTableFilterComposer,
      $$CharacterSpellSlotsTableOrderingComposer,
      $$CharacterSpellSlotsTableAnnotationComposer,
      $$CharacterSpellSlotsTableCreateCompanionBuilder,
      $$CharacterSpellSlotsTableUpdateCompanionBuilder,
      (CharacterSpellSlot, $$CharacterSpellSlotsTableReferences),
      CharacterSpellSlot,
      PrefetchHooks Function({bool characterId})
    >;
typedef $$CharacterResourcesTableCreateCompanionBuilder =
    CharacterResourcesCompanion Function({
      Value<int> id,
      required int characterId,
      required String resourceName,
      required int current,
      required int maximum,
    });
typedef $$CharacterResourcesTableUpdateCompanionBuilder =
    CharacterResourcesCompanion Function({
      Value<int> id,
      Value<int> characterId,
      Value<String> resourceName,
      Value<int> current,
      Value<int> maximum,
    });

final class $$CharacterResourcesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CharacterResourcesTable,
          CharacterResource
        > {
  $$CharacterResourcesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CharactersTable _characterIdTable(_$AppDatabase db) =>
      db.characters.createAlias(
        $_aliasNameGenerator(
          db.characterResources.characterId,
          db.characters.id,
        ),
      );

  $$CharactersTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<int>('character_id')!;

    final manager = $$CharactersTableTableManager(
      $_db,
      $_db.characters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CharacterResourcesTableFilterComposer
    extends Composer<_$AppDatabase, $CharacterResourcesTable> {
  $$CharacterResourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resourceName => $composableBuilder(
    column: $table.resourceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get current => $composableBuilder(
    column: $table.current,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maximum => $composableBuilder(
    column: $table.maximum,
    builder: (column) => ColumnFilters(column),
  );

  $$CharactersTableFilterComposer get characterId {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterResourcesTableOrderingComposer
    extends Composer<_$AppDatabase, $CharacterResourcesTable> {
  $$CharacterResourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resourceName => $composableBuilder(
    column: $table.resourceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get current => $composableBuilder(
    column: $table.current,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maximum => $composableBuilder(
    column: $table.maximum,
    builder: (column) => ColumnOrderings(column),
  );

  $$CharactersTableOrderingComposer get characterId {
    final $$CharactersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableOrderingComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterResourcesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharacterResourcesTable> {
  $$CharacterResourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get resourceName => $composableBuilder(
    column: $table.resourceName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get current =>
      $composableBuilder(column: $table.current, builder: (column) => column);

  GeneratedColumn<int> get maximum =>
      $composableBuilder(column: $table.maximum, builder: (column) => column);

  $$CharactersTableAnnotationComposer get characterId {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterResourcesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharacterResourcesTable,
          CharacterResource,
          $$CharacterResourcesTableFilterComposer,
          $$CharacterResourcesTableOrderingComposer,
          $$CharacterResourcesTableAnnotationComposer,
          $$CharacterResourcesTableCreateCompanionBuilder,
          $$CharacterResourcesTableUpdateCompanionBuilder,
          (CharacterResource, $$CharacterResourcesTableReferences),
          CharacterResource,
          PrefetchHooks Function({bool characterId})
        > {
  $$CharacterResourcesTableTableManager(
    _$AppDatabase db,
    $CharacterResourcesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharacterResourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharacterResourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharacterResourcesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> characterId = const Value.absent(),
                Value<String> resourceName = const Value.absent(),
                Value<int> current = const Value.absent(),
                Value<int> maximum = const Value.absent(),
              }) => CharacterResourcesCompanion(
                id: id,
                characterId: characterId,
                resourceName: resourceName,
                current: current,
                maximum: maximum,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int characterId,
                required String resourceName,
                required int current,
                required int maximum,
              }) => CharacterResourcesCompanion.insert(
                id: id,
                characterId: characterId,
                resourceName: resourceName,
                current: current,
                maximum: maximum,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CharacterResourcesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({characterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (characterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.characterId,
                                referencedTable:
                                    $$CharacterResourcesTableReferences
                                        ._characterIdTable(db),
                                referencedColumn:
                                    $$CharacterResourcesTableReferences
                                        ._characterIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CharacterResourcesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharacterResourcesTable,
      CharacterResource,
      $$CharacterResourcesTableFilterComposer,
      $$CharacterResourcesTableOrderingComposer,
      $$CharacterResourcesTableAnnotationComposer,
      $$CharacterResourcesTableCreateCompanionBuilder,
      $$CharacterResourcesTableUpdateCompanionBuilder,
      (CharacterResource, $$CharacterResourcesTableReferences),
      CharacterResource,
      PrefetchHooks Function({bool characterId})
    >;
typedef $$CharacterAttacksTableCreateCompanionBuilder =
    CharacterAttacksCompanion Function({
      Value<int> id,
      required int characterId,
      required String name,
      required String attackBonus,
      required String damageDice,
      required String damageType,
      Value<String?> masteryProperty,
      Value<String> notes,
    });
typedef $$CharacterAttacksTableUpdateCompanionBuilder =
    CharacterAttacksCompanion Function({
      Value<int> id,
      Value<int> characterId,
      Value<String> name,
      Value<String> attackBonus,
      Value<String> damageDice,
      Value<String> damageType,
      Value<String?> masteryProperty,
      Value<String> notes,
    });

final class $$CharacterAttacksTableReferences
    extends
        BaseReferences<_$AppDatabase, $CharacterAttacksTable, CharacterAttack> {
  $$CharacterAttacksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CharactersTable _characterIdTable(_$AppDatabase db) =>
      db.characters.createAlias(
        $_aliasNameGenerator(db.characterAttacks.characterId, db.characters.id),
      );

  $$CharactersTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<int>('character_id')!;

    final manager = $$CharactersTableTableManager(
      $_db,
      $_db.characters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CharacterAttacksTableFilterComposer
    extends Composer<_$AppDatabase, $CharacterAttacksTable> {
  $$CharacterAttacksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attackBonus => $composableBuilder(
    column: $table.attackBonus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get damageDice => $composableBuilder(
    column: $table.damageDice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get damageType => $composableBuilder(
    column: $table.damageType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get masteryProperty => $composableBuilder(
    column: $table.masteryProperty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$CharactersTableFilterComposer get characterId {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterAttacksTableOrderingComposer
    extends Composer<_$AppDatabase, $CharacterAttacksTable> {
  $$CharacterAttacksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attackBonus => $composableBuilder(
    column: $table.attackBonus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get damageDice => $composableBuilder(
    column: $table.damageDice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get damageType => $composableBuilder(
    column: $table.damageType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get masteryProperty => $composableBuilder(
    column: $table.masteryProperty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$CharactersTableOrderingComposer get characterId {
    final $$CharactersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableOrderingComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterAttacksTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharacterAttacksTable> {
  $$CharacterAttacksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get attackBonus => $composableBuilder(
    column: $table.attackBonus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get damageDice => $composableBuilder(
    column: $table.damageDice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get damageType => $composableBuilder(
    column: $table.damageType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get masteryProperty => $composableBuilder(
    column: $table.masteryProperty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$CharactersTableAnnotationComposer get characterId {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterAttacksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharacterAttacksTable,
          CharacterAttack,
          $$CharacterAttacksTableFilterComposer,
          $$CharacterAttacksTableOrderingComposer,
          $$CharacterAttacksTableAnnotationComposer,
          $$CharacterAttacksTableCreateCompanionBuilder,
          $$CharacterAttacksTableUpdateCompanionBuilder,
          (CharacterAttack, $$CharacterAttacksTableReferences),
          CharacterAttack,
          PrefetchHooks Function({bool characterId})
        > {
  $$CharacterAttacksTableTableManager(
    _$AppDatabase db,
    $CharacterAttacksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharacterAttacksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharacterAttacksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharacterAttacksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> characterId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> attackBonus = const Value.absent(),
                Value<String> damageDice = const Value.absent(),
                Value<String> damageType = const Value.absent(),
                Value<String?> masteryProperty = const Value.absent(),
                Value<String> notes = const Value.absent(),
              }) => CharacterAttacksCompanion(
                id: id,
                characterId: characterId,
                name: name,
                attackBonus: attackBonus,
                damageDice: damageDice,
                damageType: damageType,
                masteryProperty: masteryProperty,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int characterId,
                required String name,
                required String attackBonus,
                required String damageDice,
                required String damageType,
                Value<String?> masteryProperty = const Value.absent(),
                Value<String> notes = const Value.absent(),
              }) => CharacterAttacksCompanion.insert(
                id: id,
                characterId: characterId,
                name: name,
                attackBonus: attackBonus,
                damageDice: damageDice,
                damageType: damageType,
                masteryProperty: masteryProperty,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CharacterAttacksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({characterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (characterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.characterId,
                                referencedTable:
                                    $$CharacterAttacksTableReferences
                                        ._characterIdTable(db),
                                referencedColumn:
                                    $$CharacterAttacksTableReferences
                                        ._characterIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CharacterAttacksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharacterAttacksTable,
      CharacterAttack,
      $$CharacterAttacksTableFilterComposer,
      $$CharacterAttacksTableOrderingComposer,
      $$CharacterAttacksTableAnnotationComposer,
      $$CharacterAttacksTableCreateCompanionBuilder,
      $$CharacterAttacksTableUpdateCompanionBuilder,
      (CharacterAttack, $$CharacterAttacksTableReferences),
      CharacterAttack,
      PrefetchHooks Function({bool characterId})
    >;
typedef $$CharacterEquipmentTableCreateCompanionBuilder =
    CharacterEquipmentCompanion Function({
      Value<int> id,
      required int characterId,
      required String itemName,
      Value<int> quantity,
      Value<double> weight,
      Value<bool> equipped,
      Value<bool> attuned,
      Value<String> notes,
    });
typedef $$CharacterEquipmentTableUpdateCompanionBuilder =
    CharacterEquipmentCompanion Function({
      Value<int> id,
      Value<int> characterId,
      Value<String> itemName,
      Value<int> quantity,
      Value<double> weight,
      Value<bool> equipped,
      Value<bool> attuned,
      Value<String> notes,
    });

final class $$CharacterEquipmentTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CharacterEquipmentTable,
          CharacterEquipmentData
        > {
  $$CharacterEquipmentTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CharactersTable _characterIdTable(_$AppDatabase db) =>
      db.characters.createAlias(
        $_aliasNameGenerator(
          db.characterEquipment.characterId,
          db.characters.id,
        ),
      );

  $$CharactersTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<int>('character_id')!;

    final manager = $$CharactersTableTableManager(
      $_db,
      $_db.characters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CharacterEquipmentTableFilterComposer
    extends Composer<_$AppDatabase, $CharacterEquipmentTable> {
  $$CharacterEquipmentTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get equipped => $composableBuilder(
    column: $table.equipped,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get attuned => $composableBuilder(
    column: $table.attuned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$CharactersTableFilterComposer get characterId {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterEquipmentTableOrderingComposer
    extends Composer<_$AppDatabase, $CharacterEquipmentTable> {
  $$CharacterEquipmentTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get equipped => $composableBuilder(
    column: $table.equipped,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get attuned => $composableBuilder(
    column: $table.attuned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$CharactersTableOrderingComposer get characterId {
    final $$CharactersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableOrderingComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterEquipmentTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharacterEquipmentTable> {
  $$CharacterEquipmentTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemName =>
      $composableBuilder(column: $table.itemName, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<bool> get equipped =>
      $composableBuilder(column: $table.equipped, builder: (column) => column);

  GeneratedColumn<bool> get attuned =>
      $composableBuilder(column: $table.attuned, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$CharactersTableAnnotationComposer get characterId {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterEquipmentTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharacterEquipmentTable,
          CharacterEquipmentData,
          $$CharacterEquipmentTableFilterComposer,
          $$CharacterEquipmentTableOrderingComposer,
          $$CharacterEquipmentTableAnnotationComposer,
          $$CharacterEquipmentTableCreateCompanionBuilder,
          $$CharacterEquipmentTableUpdateCompanionBuilder,
          (CharacterEquipmentData, $$CharacterEquipmentTableReferences),
          CharacterEquipmentData,
          PrefetchHooks Function({bool characterId})
        > {
  $$CharacterEquipmentTableTableManager(
    _$AppDatabase db,
    $CharacterEquipmentTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharacterEquipmentTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharacterEquipmentTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharacterEquipmentTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> characterId = const Value.absent(),
                Value<String> itemName = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<bool> equipped = const Value.absent(),
                Value<bool> attuned = const Value.absent(),
                Value<String> notes = const Value.absent(),
              }) => CharacterEquipmentCompanion(
                id: id,
                characterId: characterId,
                itemName: itemName,
                quantity: quantity,
                weight: weight,
                equipped: equipped,
                attuned: attuned,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int characterId,
                required String itemName,
                Value<int> quantity = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<bool> equipped = const Value.absent(),
                Value<bool> attuned = const Value.absent(),
                Value<String> notes = const Value.absent(),
              }) => CharacterEquipmentCompanion.insert(
                id: id,
                characterId: characterId,
                itemName: itemName,
                quantity: quantity,
                weight: weight,
                equipped: equipped,
                attuned: attuned,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CharacterEquipmentTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({characterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (characterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.characterId,
                                referencedTable:
                                    $$CharacterEquipmentTableReferences
                                        ._characterIdTable(db),
                                referencedColumn:
                                    $$CharacterEquipmentTableReferences
                                        ._characterIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CharacterEquipmentTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharacterEquipmentTable,
      CharacterEquipmentData,
      $$CharacterEquipmentTableFilterComposer,
      $$CharacterEquipmentTableOrderingComposer,
      $$CharacterEquipmentTableAnnotationComposer,
      $$CharacterEquipmentTableCreateCompanionBuilder,
      $$CharacterEquipmentTableUpdateCompanionBuilder,
      (CharacterEquipmentData, $$CharacterEquipmentTableReferences),
      CharacterEquipmentData,
      PrefetchHooks Function({bool characterId})
    >;
typedef $$BatmanCharactersTableCreateCompanionBuilder =
    BatmanCharactersCompanion Function({
      Value<int> id,
      required int characterId,
      required String profileId,
      Value<String> secretIdentity,
      Value<String> mode,
      Value<int> force,
      Value<int> constitution,
      Value<int> dexterite,
      Value<int> intelligence,
      Value<int> perception,
      Value<int> volonte,
      Value<int> atcTotal,
      Value<int> atdTotal,
      Value<int> defense,
      Value<int> initiative,
      Value<int> exploitPointsCurrent,
      Value<int> exploitPointsMax,
      Value<int> ethicsOrder,
      Value<int> ethicsJustice,
      Value<int> ethicsAnarchy,
      Value<int> ethicsCrime,
      Value<String> livingStandard,
    });
typedef $$BatmanCharactersTableUpdateCompanionBuilder =
    BatmanCharactersCompanion Function({
      Value<int> id,
      Value<int> characterId,
      Value<String> profileId,
      Value<String> secretIdentity,
      Value<String> mode,
      Value<int> force,
      Value<int> constitution,
      Value<int> dexterite,
      Value<int> intelligence,
      Value<int> perception,
      Value<int> volonte,
      Value<int> atcTotal,
      Value<int> atdTotal,
      Value<int> defense,
      Value<int> initiative,
      Value<int> exploitPointsCurrent,
      Value<int> exploitPointsMax,
      Value<int> ethicsOrder,
      Value<int> ethicsJustice,
      Value<int> ethicsAnarchy,
      Value<int> ethicsCrime,
      Value<String> livingStandard,
    });

final class $$BatmanCharactersTableReferences
    extends
        BaseReferences<_$AppDatabase, $BatmanCharactersTable, BatmanCharacter> {
  $$BatmanCharactersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CharactersTable _characterIdTable(_$AppDatabase db) =>
      db.characters.createAlias(
        $_aliasNameGenerator(db.batmanCharacters.characterId, db.characters.id),
      );

  $$CharactersTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<int>('character_id')!;

    final manager = $$CharactersTableTableManager(
      $_db,
      $_db.characters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BatmanCharactersTableFilterComposer
    extends Composer<_$AppDatabase, $BatmanCharactersTable> {
  $$BatmanCharactersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secretIdentity => $composableBuilder(
    column: $table.secretIdentity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get force => $composableBuilder(
    column: $table.force,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get constitution => $composableBuilder(
    column: $table.constitution,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dexterite => $composableBuilder(
    column: $table.dexterite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intelligence => $composableBuilder(
    column: $table.intelligence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get perception => $composableBuilder(
    column: $table.perception,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get volonte => $composableBuilder(
    column: $table.volonte,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get atcTotal => $composableBuilder(
    column: $table.atcTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get atdTotal => $composableBuilder(
    column: $table.atdTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defense => $composableBuilder(
    column: $table.defense,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get initiative => $composableBuilder(
    column: $table.initiative,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exploitPointsCurrent => $composableBuilder(
    column: $table.exploitPointsCurrent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exploitPointsMax => $composableBuilder(
    column: $table.exploitPointsMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ethicsOrder => $composableBuilder(
    column: $table.ethicsOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ethicsJustice => $composableBuilder(
    column: $table.ethicsJustice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ethicsAnarchy => $composableBuilder(
    column: $table.ethicsAnarchy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ethicsCrime => $composableBuilder(
    column: $table.ethicsCrime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get livingStandard => $composableBuilder(
    column: $table.livingStandard,
    builder: (column) => ColumnFilters(column),
  );

  $$CharactersTableFilterComposer get characterId {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BatmanCharactersTableOrderingComposer
    extends Composer<_$AppDatabase, $BatmanCharactersTable> {
  $$BatmanCharactersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secretIdentity => $composableBuilder(
    column: $table.secretIdentity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get force => $composableBuilder(
    column: $table.force,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get constitution => $composableBuilder(
    column: $table.constitution,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dexterite => $composableBuilder(
    column: $table.dexterite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intelligence => $composableBuilder(
    column: $table.intelligence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get perception => $composableBuilder(
    column: $table.perception,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get volonte => $composableBuilder(
    column: $table.volonte,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get atcTotal => $composableBuilder(
    column: $table.atcTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get atdTotal => $composableBuilder(
    column: $table.atdTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defense => $composableBuilder(
    column: $table.defense,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get initiative => $composableBuilder(
    column: $table.initiative,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exploitPointsCurrent => $composableBuilder(
    column: $table.exploitPointsCurrent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exploitPointsMax => $composableBuilder(
    column: $table.exploitPointsMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ethicsOrder => $composableBuilder(
    column: $table.ethicsOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ethicsJustice => $composableBuilder(
    column: $table.ethicsJustice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ethicsAnarchy => $composableBuilder(
    column: $table.ethicsAnarchy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ethicsCrime => $composableBuilder(
    column: $table.ethicsCrime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get livingStandard => $composableBuilder(
    column: $table.livingStandard,
    builder: (column) => ColumnOrderings(column),
  );

  $$CharactersTableOrderingComposer get characterId {
    final $$CharactersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableOrderingComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BatmanCharactersTableAnnotationComposer
    extends Composer<_$AppDatabase, $BatmanCharactersTable> {
  $$BatmanCharactersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get secretIdentity => $composableBuilder(
    column: $table.secretIdentity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<int> get force =>
      $composableBuilder(column: $table.force, builder: (column) => column);

  GeneratedColumn<int> get constitution => $composableBuilder(
    column: $table.constitution,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dexterite =>
      $composableBuilder(column: $table.dexterite, builder: (column) => column);

  GeneratedColumn<int> get intelligence => $composableBuilder(
    column: $table.intelligence,
    builder: (column) => column,
  );

  GeneratedColumn<int> get perception => $composableBuilder(
    column: $table.perception,
    builder: (column) => column,
  );

  GeneratedColumn<int> get volonte =>
      $composableBuilder(column: $table.volonte, builder: (column) => column);

  GeneratedColumn<int> get atcTotal =>
      $composableBuilder(column: $table.atcTotal, builder: (column) => column);

  GeneratedColumn<int> get atdTotal =>
      $composableBuilder(column: $table.atdTotal, builder: (column) => column);

  GeneratedColumn<int> get defense =>
      $composableBuilder(column: $table.defense, builder: (column) => column);

  GeneratedColumn<int> get initiative => $composableBuilder(
    column: $table.initiative,
    builder: (column) => column,
  );

  GeneratedColumn<int> get exploitPointsCurrent => $composableBuilder(
    column: $table.exploitPointsCurrent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get exploitPointsMax => $composableBuilder(
    column: $table.exploitPointsMax,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ethicsOrder => $composableBuilder(
    column: $table.ethicsOrder,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ethicsJustice => $composableBuilder(
    column: $table.ethicsJustice,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ethicsAnarchy => $composableBuilder(
    column: $table.ethicsAnarchy,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ethicsCrime => $composableBuilder(
    column: $table.ethicsCrime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get livingStandard => $composableBuilder(
    column: $table.livingStandard,
    builder: (column) => column,
  );

  $$CharactersTableAnnotationComposer get characterId {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BatmanCharactersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BatmanCharactersTable,
          BatmanCharacter,
          $$BatmanCharactersTableFilterComposer,
          $$BatmanCharactersTableOrderingComposer,
          $$BatmanCharactersTableAnnotationComposer,
          $$BatmanCharactersTableCreateCompanionBuilder,
          $$BatmanCharactersTableUpdateCompanionBuilder,
          (BatmanCharacter, $$BatmanCharactersTableReferences),
          BatmanCharacter,
          PrefetchHooks Function({bool characterId})
        > {
  $$BatmanCharactersTableTableManager(
    _$AppDatabase db,
    $BatmanCharactersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BatmanCharactersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BatmanCharactersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BatmanCharactersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> characterId = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> secretIdentity = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<int> force = const Value.absent(),
                Value<int> constitution = const Value.absent(),
                Value<int> dexterite = const Value.absent(),
                Value<int> intelligence = const Value.absent(),
                Value<int> perception = const Value.absent(),
                Value<int> volonte = const Value.absent(),
                Value<int> atcTotal = const Value.absent(),
                Value<int> atdTotal = const Value.absent(),
                Value<int> defense = const Value.absent(),
                Value<int> initiative = const Value.absent(),
                Value<int> exploitPointsCurrent = const Value.absent(),
                Value<int> exploitPointsMax = const Value.absent(),
                Value<int> ethicsOrder = const Value.absent(),
                Value<int> ethicsJustice = const Value.absent(),
                Value<int> ethicsAnarchy = const Value.absent(),
                Value<int> ethicsCrime = const Value.absent(),
                Value<String> livingStandard = const Value.absent(),
              }) => BatmanCharactersCompanion(
                id: id,
                characterId: characterId,
                profileId: profileId,
                secretIdentity: secretIdentity,
                mode: mode,
                force: force,
                constitution: constitution,
                dexterite: dexterite,
                intelligence: intelligence,
                perception: perception,
                volonte: volonte,
                atcTotal: atcTotal,
                atdTotal: atdTotal,
                defense: defense,
                initiative: initiative,
                exploitPointsCurrent: exploitPointsCurrent,
                exploitPointsMax: exploitPointsMax,
                ethicsOrder: ethicsOrder,
                ethicsJustice: ethicsJustice,
                ethicsAnarchy: ethicsAnarchy,
                ethicsCrime: ethicsCrime,
                livingStandard: livingStandard,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int characterId,
                required String profileId,
                Value<String> secretIdentity = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<int> force = const Value.absent(),
                Value<int> constitution = const Value.absent(),
                Value<int> dexterite = const Value.absent(),
                Value<int> intelligence = const Value.absent(),
                Value<int> perception = const Value.absent(),
                Value<int> volonte = const Value.absent(),
                Value<int> atcTotal = const Value.absent(),
                Value<int> atdTotal = const Value.absent(),
                Value<int> defense = const Value.absent(),
                Value<int> initiative = const Value.absent(),
                Value<int> exploitPointsCurrent = const Value.absent(),
                Value<int> exploitPointsMax = const Value.absent(),
                Value<int> ethicsOrder = const Value.absent(),
                Value<int> ethicsJustice = const Value.absent(),
                Value<int> ethicsAnarchy = const Value.absent(),
                Value<int> ethicsCrime = const Value.absent(),
                Value<String> livingStandard = const Value.absent(),
              }) => BatmanCharactersCompanion.insert(
                id: id,
                characterId: characterId,
                profileId: profileId,
                secretIdentity: secretIdentity,
                mode: mode,
                force: force,
                constitution: constitution,
                dexterite: dexterite,
                intelligence: intelligence,
                perception: perception,
                volonte: volonte,
                atcTotal: atcTotal,
                atdTotal: atdTotal,
                defense: defense,
                initiative: initiative,
                exploitPointsCurrent: exploitPointsCurrent,
                exploitPointsMax: exploitPointsMax,
                ethicsOrder: ethicsOrder,
                ethicsJustice: ethicsJustice,
                ethicsAnarchy: ethicsAnarchy,
                ethicsCrime: ethicsCrime,
                livingStandard: livingStandard,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BatmanCharactersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({characterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (characterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.characterId,
                                referencedTable:
                                    $$BatmanCharactersTableReferences
                                        ._characterIdTable(db),
                                referencedColumn:
                                    $$BatmanCharactersTableReferences
                                        ._characterIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BatmanCharactersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BatmanCharactersTable,
      BatmanCharacter,
      $$BatmanCharactersTableFilterComposer,
      $$BatmanCharactersTableOrderingComposer,
      $$BatmanCharactersTableAnnotationComposer,
      $$BatmanCharactersTableCreateCompanionBuilder,
      $$BatmanCharactersTableUpdateCompanionBuilder,
      (BatmanCharacter, $$BatmanCharactersTableReferences),
      BatmanCharacter,
      PrefetchHooks Function({bool characterId})
    >;
typedef $$BatmanCharacterWaysTableCreateCompanionBuilder =
    BatmanCharacterWaysCompanion Function({
      Value<int> id,
      required int characterId,
      required String wayId,
      Value<int> rankAcquired,
      Value<String> acquiredCapabilities,
    });
typedef $$BatmanCharacterWaysTableUpdateCompanionBuilder =
    BatmanCharacterWaysCompanion Function({
      Value<int> id,
      Value<int> characterId,
      Value<String> wayId,
      Value<int> rankAcquired,
      Value<String> acquiredCapabilities,
    });

final class $$BatmanCharacterWaysTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $BatmanCharacterWaysTable,
          BatmanCharacterWay
        > {
  $$BatmanCharacterWaysTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CharactersTable _characterIdTable(_$AppDatabase db) =>
      db.characters.createAlias(
        $_aliasNameGenerator(
          db.batmanCharacterWays.characterId,
          db.characters.id,
        ),
      );

  $$CharactersTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<int>('character_id')!;

    final manager = $$CharactersTableTableManager(
      $_db,
      $_db.characters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BatmanCharacterWaysTableFilterComposer
    extends Composer<_$AppDatabase, $BatmanCharacterWaysTable> {
  $$BatmanCharacterWaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wayId => $composableBuilder(
    column: $table.wayId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rankAcquired => $composableBuilder(
    column: $table.rankAcquired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get acquiredCapabilities => $composableBuilder(
    column: $table.acquiredCapabilities,
    builder: (column) => ColumnFilters(column),
  );

  $$CharactersTableFilterComposer get characterId {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BatmanCharacterWaysTableOrderingComposer
    extends Composer<_$AppDatabase, $BatmanCharacterWaysTable> {
  $$BatmanCharacterWaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wayId => $composableBuilder(
    column: $table.wayId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rankAcquired => $composableBuilder(
    column: $table.rankAcquired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get acquiredCapabilities => $composableBuilder(
    column: $table.acquiredCapabilities,
    builder: (column) => ColumnOrderings(column),
  );

  $$CharactersTableOrderingComposer get characterId {
    final $$CharactersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableOrderingComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BatmanCharacterWaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $BatmanCharacterWaysTable> {
  $$BatmanCharacterWaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get wayId =>
      $composableBuilder(column: $table.wayId, builder: (column) => column);

  GeneratedColumn<int> get rankAcquired => $composableBuilder(
    column: $table.rankAcquired,
    builder: (column) => column,
  );

  GeneratedColumn<String> get acquiredCapabilities => $composableBuilder(
    column: $table.acquiredCapabilities,
    builder: (column) => column,
  );

  $$CharactersTableAnnotationComposer get characterId {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BatmanCharacterWaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BatmanCharacterWaysTable,
          BatmanCharacterWay,
          $$BatmanCharacterWaysTableFilterComposer,
          $$BatmanCharacterWaysTableOrderingComposer,
          $$BatmanCharacterWaysTableAnnotationComposer,
          $$BatmanCharacterWaysTableCreateCompanionBuilder,
          $$BatmanCharacterWaysTableUpdateCompanionBuilder,
          (BatmanCharacterWay, $$BatmanCharacterWaysTableReferences),
          BatmanCharacterWay,
          PrefetchHooks Function({bool characterId})
        > {
  $$BatmanCharacterWaysTableTableManager(
    _$AppDatabase db,
    $BatmanCharacterWaysTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BatmanCharacterWaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BatmanCharacterWaysTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BatmanCharacterWaysTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> characterId = const Value.absent(),
                Value<String> wayId = const Value.absent(),
                Value<int> rankAcquired = const Value.absent(),
                Value<String> acquiredCapabilities = const Value.absent(),
              }) => BatmanCharacterWaysCompanion(
                id: id,
                characterId: characterId,
                wayId: wayId,
                rankAcquired: rankAcquired,
                acquiredCapabilities: acquiredCapabilities,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int characterId,
                required String wayId,
                Value<int> rankAcquired = const Value.absent(),
                Value<String> acquiredCapabilities = const Value.absent(),
              }) => BatmanCharacterWaysCompanion.insert(
                id: id,
                characterId: characterId,
                wayId: wayId,
                rankAcquired: rankAcquired,
                acquiredCapabilities: acquiredCapabilities,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BatmanCharacterWaysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({characterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (characterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.characterId,
                                referencedTable:
                                    $$BatmanCharacterWaysTableReferences
                                        ._characterIdTable(db),
                                referencedColumn:
                                    $$BatmanCharacterWaysTableReferences
                                        ._characterIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BatmanCharacterWaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BatmanCharacterWaysTable,
      BatmanCharacterWay,
      $$BatmanCharacterWaysTableFilterComposer,
      $$BatmanCharacterWaysTableOrderingComposer,
      $$BatmanCharacterWaysTableAnnotationComposer,
      $$BatmanCharacterWaysTableCreateCompanionBuilder,
      $$BatmanCharacterWaysTableUpdateCompanionBuilder,
      (BatmanCharacterWay, $$BatmanCharacterWaysTableReferences),
      BatmanCharacterWay,
      PrefetchHooks Function({bool characterId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SrdSpellsTableTableManager get srdSpells =>
      $$SrdSpellsTableTableManager(_db, _db.srdSpells);
  $$SrdClassesTableTableManager get srdClasses =>
      $$SrdClassesTableTableManager(_db, _db.srdClasses);
  $$SrdSubclassesTableTableManager get srdSubclasses =>
      $$SrdSubclassesTableTableManager(_db, _db.srdSubclasses);
  $$SrdRacesTableTableManager get srdRaces =>
      $$SrdRacesTableTableManager(_db, _db.srdRaces);
  $$SrdSubracesTableTableManager get srdSubraces =>
      $$SrdSubracesTableTableManager(_db, _db.srdSubraces);
  $$SrdBackgroundsTableTableManager get srdBackgrounds =>
      $$SrdBackgroundsTableTableManager(_db, _db.srdBackgrounds);
  $$SrdFeaturesTableTableManager get srdFeatures =>
      $$SrdFeaturesTableTableManager(_db, _db.srdFeatures);
  $$SrdFeatsTableTableManager get srdFeats =>
      $$SrdFeatsTableTableManager(_db, _db.srdFeats);
  $$SrdWeaponMasteriesTableTableManager get srdWeaponMasteries =>
      $$SrdWeaponMasteriesTableTableManager(_db, _db.srdWeaponMasteries);
  $$BatmanProfilesTableTableManager get batmanProfiles =>
      $$BatmanProfilesTableTableManager(_db, _db.batmanProfiles);
  $$BatmanWaysTableTableManager get batmanWays =>
      $$BatmanWaysTableTableManager(_db, _db.batmanWays);
  $$CharactersTableTableManager get characters =>
      $$CharactersTableTableManager(_db, _db.characters);
  $$CharacterClassesTableTableManager get characterClasses =>
      $$CharacterClassesTableTableManager(_db, _db.characterClasses);
  $$CharacterAbilityScoresTableTableManager get characterAbilityScores =>
      $$CharacterAbilityScoresTableTableManager(
        _db,
        _db.characterAbilityScores,
      );
  $$CharacterProficienciesTableTableManager get characterProficiencies =>
      $$CharacterProficienciesTableTableManager(
        _db,
        _db.characterProficiencies,
      );
  $$CharacterSpellsTableTableManager get characterSpells =>
      $$CharacterSpellsTableTableManager(_db, _db.characterSpells);
  $$CharacterFeatsTableTableManager get characterFeats =>
      $$CharacterFeatsTableTableManager(_db, _db.characterFeats);
  $$CharacterSpellSlotsTableTableManager get characterSpellSlots =>
      $$CharacterSpellSlotsTableTableManager(_db, _db.characterSpellSlots);
  $$CharacterResourcesTableTableManager get characterResources =>
      $$CharacterResourcesTableTableManager(_db, _db.characterResources);
  $$CharacterAttacksTableTableManager get characterAttacks =>
      $$CharacterAttacksTableTableManager(_db, _db.characterAttacks);
  $$CharacterEquipmentTableTableManager get characterEquipment =>
      $$CharacterEquipmentTableTableManager(_db, _db.characterEquipment);
  $$BatmanCharactersTableTableManager get batmanCharacters =>
      $$BatmanCharactersTableTableManager(_db, _db.batmanCharacters);
  $$BatmanCharacterWaysTableTableManager get batmanCharacterWays =>
      $$BatmanCharacterWaysTableTableManager(_db, _db.batmanCharacterWays);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
