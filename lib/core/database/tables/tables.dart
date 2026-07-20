import 'package:drift/drift.dart';

/// Enum for ruleset version stored as text
enum RulesetVersion { dnd2014, dnd2024, batman }

/// ─────────────────────────────────────────
/// COMPENDIUM TABLES (populated by SRD seed)
/// ─────────────────────────────────────────

class SrdSpells extends Table {
  TextColumn get id => text()();
  TextColumn get ruleset => textEnum<RulesetVersion>()();
  TextColumn get name => text()();
  IntColumn get level => integer()();
  TextColumn get school => text()();
  TextColumn get castingTime => text()();
  TextColumn get range => text()();
  TextColumn get components => text()(); // JSON array string
  TextColumn get duration => text()();
  BoolColumn get concentration => boolean().withDefault(const Constant(false))();
  BoolColumn get ritual => boolean().withDefault(const Constant(false))();
  TextColumn get description => text()();
  TextColumn get higherLevel => text().nullable()();
  TextColumn get classes => text()(); // JSON array of class index strings
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id, ruleset};
}

class SrdClasses extends Table {
  TextColumn get id => text()();
  TextColumn get ruleset => textEnum<RulesetVersion>()();
  TextColumn get name => text()();
  IntColumn get hitDie => integer()();
  TextColumn get proficiencies => text()(); // JSON
  TextColumn get savingThrows => text()(); // JSON array of ability names
  TextColumn get spellcastingAbility => text().nullable()();
  BoolColumn get isPreparedCaster => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id, ruleset};
}

class SrdSubclasses extends Table {
  TextColumn get id => text()();
  TextColumn get ruleset => textEnum<RulesetVersion>()();
  TextColumn get name => text()();
  TextColumn get classId => text()();
  TextColumn get description => text()();

  @override
  Set<Column> get primaryKey => {id, ruleset};
}

class SrdRaces extends Table {
  TextColumn get id => text()();
  TextColumn get ruleset => textEnum<RulesetVersion>()();
  TextColumn get name => text()();
  IntColumn get speed => integer()();
  TextColumn get abilityBonuses => text()(); // JSON [{ability, bonus}]
  TextColumn get languages => text()(); // JSON array
  TextColumn get traits => text()(); // JSON array

  @override
  Set<Column> get primaryKey => {id, ruleset};
}

class SrdSubraces extends Table {
  TextColumn get id => text()();
  TextColumn get ruleset => textEnum<RulesetVersion>()();
  TextColumn get name => text()();
  TextColumn get raceId => text()();
  TextColumn get abilityBonuses => text()(); // JSON

  @override
  Set<Column> get primaryKey => {id, ruleset};
}

class SrdBackgrounds extends Table {
  TextColumn get id => text()();
  TextColumn get ruleset => textEnum<RulesetVersion>()();
  TextColumn get name => text()();
  TextColumn get skillProficiencies => text()(); // JSON array
  TextColumn get toolProficiencies => text()(); // JSON array
  TextColumn get languages => text()(); // JSON array
  // 2024: background carries ASI and origin feat
  TextColumn get asiJson => text().nullable()(); // JSON {str:0,dex:2,...}
  TextColumn get originFeatId => text().nullable()(); // 2024 only

  @override
  Set<Column> get primaryKey => {id, ruleset};
}

class SrdFeatures extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get srdIndex => text()();
  TextColumn get ruleset => textEnum<RulesetVersion>()();
  TextColumn get name => text()();
  TextColumn get classId => text().nullable()();
  TextColumn get subclassId => text().nullable()();
  IntColumn get level => integer()();
  TextColumn get description => text()();
}

class SrdFeats extends Table {
  TextColumn get id => text()();
  TextColumn get ruleset => textEnum<RulesetVersion>()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get type => text()(); // e.g. "origin", "general", "fighting-style"
  BoolColumn get repeatable => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id, ruleset};
}

class SrdWeaponMasteries extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();

  @override
  Set<Column> get primaryKey => {id};
}


/// ─────────────────────────────────────────
/// USER TABLES
/// ─────────────────────────────────────────

class Characters extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get playerName => text().withDefault(const Constant(''))();
  TextColumn get ruleset => textEnum<RulesetVersion>()();
  TextColumn get alignment => text().withDefault(const Constant(''))();
  IntColumn get xp => integer().withDefault(const Constant(0))();

  // Origin
  TextColumn get speciesId => text().nullable()(); // race (2014) or species (2024)
  TextColumn get subspeciesId => text().nullable()();
  TextColumn get backgroundId => text().nullable()();

  // HP
  IntColumn get hpMax => integer().withDefault(const Constant(0))();
  IntColumn get hpCurrent => integer().withDefault(const Constant(0))();
  IntColumn get hpTemp => integer().withDefault(const Constant(0))();

  // Combat
  IntColumn get armorClass => integer().withDefault(const Constant(10))();
  IntColumn get speed => integer().withDefault(const Constant(30))();
  IntColumn get exhaustionLevel => integer().withDefault(const Constant(0))();
  BoolColumn get heroicInspiration => boolean().withDefault(const Constant(false))();

  // Death saves (0-3)
  IntColumn get deathSaveSuccesses => integer().withDefault(const Constant(0))();
  IntColumn get deathSaveFailures => integer().withDefault(const Constant(0))();

  // Profile
  TextColumn get personalityTraits => text().withDefault(const Constant(''))();
  TextColumn get ideals => text().withDefault(const Constant(''))();
  TextColumn get bonds => text().withDefault(const Constant(''))();
  TextColumn get flaws => text().withDefault(const Constant(''))();
  TextColumn get backstory => text().withDefault(const Constant(''))();
  TextColumn get appearance => text().withDefault(const Constant(''))();
  TextColumn get imageUrl => text().nullable()();

  // Currency (JSON)
  TextColumn get currency => text().withDefault(const Constant('{"cp":0,"sp":0,"ep":0,"gp":0,"pp":0}'))();

  TextColumn get createdAt => text()(); // ISO8601
  TextColumn get updatedAt => text()(); // ISO8601
}

/// One row per class the character has levels in (multiclass support)
class CharacterClasses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get characterId => integer().references(Characters, #id, onDelete: KeyAction.cascade)();
  TextColumn get classId => text()();
  TextColumn get subclassId => text().nullable()();
  IntColumn get level => integer()();
}

class CharacterAbilityScores extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get characterId => integer().references(Characters, #id, onDelete: KeyAction.cascade)();
  IntColumn get strength => integer().withDefault(const Constant(10))();
  IntColumn get dexterity => integer().withDefault(const Constant(10))();
  IntColumn get constitution => integer().withDefault(const Constant(10))();
  IntColumn get intelligence => integer().withDefault(const Constant(10))();
  IntColumn get wisdom => integer().withDefault(const Constant(10))();
  IntColumn get charisma => integer().withDefault(const Constant(10))();
}

/// Proficiencies and expertise for skills and saving throws
class CharacterProficiencies extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get characterId => integer().references(Characters, #id, onDelete: KeyAction.cascade)();
  TextColumn get proficiencyKey => text()(); // e.g., "skill_athletics", "save_str", "tool_thieves"
  BoolColumn get hasExpertise => boolean().withDefault(const Constant(false))();
}

class CharacterSpells extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get characterId => integer().references(Characters, #id, onDelete: KeyAction.cascade)();
  TextColumn get spellId => text()();
  TextColumn get ruleset => textEnum<RulesetVersion>()();
  BoolColumn get prepared => boolean().withDefault(const Constant(false))();
  BoolColumn get alwaysPrepared => boolean().withDefault(const Constant(false))();
}

class CharacterFeats extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get characterId => integer().references(Characters, #id, onDelete: KeyAction.cascade)();
  TextColumn get featId => text()();
  TextColumn get ruleset => textEnum<RulesetVersion>()();
  TextColumn get choicesJson => text().nullable()(); // JSON string for choices
}


/// Spell slots per level (1-9)
class CharacterSpellSlots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get characterId => integer().references(Characters, #id, onDelete: KeyAction.cascade)();
  IntColumn get slotLevel => integer()(); // 1-9
  IntColumn get slotMax => integer()();
  IntColumn get slotCurrent => integer()();
}

/// Class-specific resources (Rage, Ki points, Channel Divinity, etc.)
class CharacterResources extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get characterId => integer().references(Characters, #id, onDelete: KeyAction.cascade)();
  TextColumn get resourceName => text()();
  IntColumn get current => integer()();
  IntColumn get maximum => integer()();
}

/// Attacks (weapon attacks or spell attacks)
class CharacterAttacks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get characterId => integer().references(Characters, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get attackBonus => text()(); // e.g., "+5" or "STR+PROF"
  TextColumn get damageDice => text()(); // e.g., "1d8+3"
  TextColumn get damageType => text()();
  TextColumn get masteryProperty => text().nullable()(); // 2024 only
  TextColumn get notes => text().withDefault(const Constant(''))();
}

class CharacterEquipment extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get characterId => integer().references(Characters, #id, onDelete: KeyAction.cascade)();
  TextColumn get itemName => text()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  RealColumn get weight => real().withDefault(const Constant(0.0))();
  BoolColumn get equipped => boolean().withDefault(const Constant(false))();
  BoolColumn get attuned => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().withDefault(const Constant(''))();
}

/// App settings (one row, key-value)
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// ─────────────────────────────────────────
/// BATMAN RPG TABLES
/// ─────────────────────────────────────────

/// Batman RPG profiles (loaded from JSON)
class BatmanProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get mode => text()(); // rues, ombres, prodiges
  TextColumn get hitDie => text()(); // D6, D8, D10, D12
  IntColumn get atcBonus => integer().withDefault(const Constant(0))();
  IntColumn get atdBonus => integer().withDefault(const Constant(0))();
  IntColumn get atsBonus => integer().withDefault(const Constant(0))();
  IntColumn get exploitPoints => integer().withDefault(const Constant(0))();
  IntColumn get capabilityPoints => integer().withDefault(const Constant(0))();
  TextColumn get primaryAbilityWithEdge => text()(); // JSON array of ability keys
  TextColumn get initialWays => text()(); // JSON array of way IDs
  IntColumn get extraWays => integer().withDefault(const Constant(0))();
  TextColumn get extraWaysPool => text().nullable()();
  TextColumn get livingStandard => text()();
  TextColumn get description => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Batman RPG ways/voies (loaded from JSON)
class BatmanWays extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()(); // commune, ombre, prodige
  TextColumn get prerequisite => text().nullable()();
  TextColumn get ranksJson => text()(); // JSON array of {rank, name, type, description}

  @override
  Set<Column> get primaryKey => {id};
}

/// Batman RPG character-specific data
class BatmanCharacters extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get characterId => integer().references(Characters, #id, onDelete: KeyAction.cascade)();
  TextColumn get profileId => text()();
  TextColumn get secretIdentity => text().withDefault(const Constant(''))();
  TextColumn get mode => text().withDefault(const Constant(''))();
  // Ability scores (FOR, CON, DEX, INT, PER, VOL)
  IntColumn get force => integer().withDefault(const Constant(8))();
  IntColumn get constitution => integer().withDefault(const Constant(8))();
  IntColumn get dexterite => integer().withDefault(const Constant(8))();
  IntColumn get intelligence => integer().withDefault(const Constant(8))();
  IntColumn get perception => integer().withDefault(const Constant(8))();
  IntColumn get volonte => integer().withDefault(const Constant(8))();
  // Combat stats
  IntColumn get atcTotal => integer().withDefault(const Constant(0))();
  IntColumn get atdTotal => integer().withDefault(const Constant(0))();
  IntColumn get defense => integer().withDefault(const Constant(10))();
  IntColumn get initiative => integer().withDefault(const Constant(0))();
  IntColumn get exploitPointsCurrent => integer().withDefault(const Constant(0))();
  IntColumn get exploitPointsMax => integer().withDefault(const Constant(0))();
  // Ethics (0-5 each)
  IntColumn get ethicsOrder => integer().withDefault(const Constant(0))();
  IntColumn get ethicsJustice => integer().withDefault(const Constant(0))();
  IntColumn get ethicsAnarchy => integer().withDefault(const Constant(0))();
  IntColumn get ethicsCrime => integer().withDefault(const Constant(0))();
  // Living standard
  TextColumn get livingStandard => text().withDefault(const Constant('modeste'))();
}

/// Character's acquired ways and rank levels
class BatmanCharacterWays extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get characterId => integer().references(Characters, #id, onDelete: KeyAction.cascade)();
  TextColumn get wayId => text()();
  IntColumn get rankAcquired => integer().withDefault(const Constant(1))();
  TextColumn get acquiredCapabilities => text().withDefault(const Constant('[]'))(); // JSON array of rank numbers
}

