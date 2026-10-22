import 'dart:convert';
import 'dart:math';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../database/tables/tables.dart';
import '../utils/app_errors.dart';
import '../utils/armor_class_helper.dart';
import '../utils/class_orders.dart';
import '../utils/character_edit_rules.dart';
import '../utils/class_progression.dart';
import '../utils/dnd_rules.dart';
import '../utils/feature_rules.dart';
import '../utils/level_up_plan.dart';
import '../utils/starting_equipment_helper.dart';
import '../../features/character/providers/wizard_provider.dart';
import '../../l10n/app_localizations.dart';

/// Choix incomplets ou invalides pour une montée de niveau.
class LevelUpException implements Exception {
  final List<LevelUpIssue> issues;

  const LevelUpException(this.issues);

  @override
  String toString() => 'LevelUpException($issues)';
}

/// Montée de niveau appliquée : ce qui a été écrit, plus la CA recalculée.
class LevelUpResult {
  final LevelUpOutcome outcome;
  final int armorClassBefore;
  final int armorClassAfter;

  const LevelUpResult({
    required this.outcome,
    required this.armorClassBefore,
    required this.armorClassAfter,
  });
}

/// Conséquences d'un changement d'historique sur les maîtrises et le don d'origine.
class OriginChangePreview {
  final List<String> removedProficiencies;
  final List<String> addedProficiencies;
  final String? removedFeatId;
  final String? addedFeatId;

  const OriginChangePreview({
    this.removedProficiencies = const [],
    this.addedProficiencies = const [],
    this.removedFeatId,
    this.addedFeatId,
  });

  bool get isEmpty =>
      removedProficiencies.isEmpty &&
      addedProficiencies.isEmpty &&
      removedFeatId == null &&
      addedFeatId == null;
}

/// Conséquences d'un changement de caractéristiques sur les PV max et la CA.
class AbilityChangePreview {
  final int hpMaxBefore;
  final int hpMaxAfter;
  final int acBefore;
  final int acAfter;

  const AbilityChangePreview({
    required this.hpMaxBefore,
    required this.hpMaxAfter,
    required this.acBefore,
    required this.acAfter,
  });

  bool get hasChanges => hpMaxBefore != hpMaxAfter || acBefore != acAfter;
}

class CharacterEditRequest {
  final String name;
  final String playerName;
  final String alignment;
  final Map<String, int> finalScores;
  final String? speciesId;
  final String? subspeciesId;
  final String? backgroundId;
  final Map<String, int> originBonus;

  const CharacterEditRequest({
    required this.name,
    required this.playerName,
    required this.alignment,
    required this.finalScores,
    required this.speciesId,
    required this.subspeciesId,
    required this.backgroundId,
    required this.originBonus,
  });
}

class CharacterEditPreview {
  final AbilityChangePreview abilities;
  final OriginChangePreview origin;
  final bool originChanged;

  const CharacterEditPreview({
    required this.abilities,
    required this.origin,
    required this.originChanged,
  });

  bool get hasConsequences => abilities.hasChanges || !origin.isEmpty;
}

class CharacterService {
  final AppDatabase db;

  CharacterService(this.db);

  /// Create a brand-new character from wizard state.
  /// Returns the new character's ID.
  Future<int> createFromWizard(WizardState wizard) async {
    final now = DateTime.now().toIso8601String();

    // 0 — Calculate final ability scores including background/race modifiers
    final finalScores = Map<String, int>.from(wizard.abilityScores);

    if (wizard.ruleset == RulesetVersion.dnd2014) {
      // Race modifiers
      if (wizard.speciesId != null) {
        final race = await db.compendiumDao.getRaceById(wizard.speciesId!, RulesetVersion.dnd2014);
        if (race != null && race.abilityBonuses.isNotEmpty) {
          final List<dynamic> list = json.decode(race.abilityBonuses);
          for (final item in list) {
            final ability = item['ability'] as String;
            final bonus = item['bonus'] as int;
            finalScores[ability] = (finalScores[ability] ?? 10) + bonus;
          }
        }
      }
      // Subrace modifiers
      if (wizard.subspeciesId != null) {
        final subraces = await db.compendiumDao.getSubraces(wizard.speciesId!, RulesetVersion.dnd2014);
        final subrace = subraces.where((s) => s.id == wizard.subspeciesId).firstOrNull;
        if (subrace != null && subrace.abilityBonuses.isNotEmpty) {
          final List<dynamic> list = json.decode(subrace.abilityBonuses);
          for (final item in list) {
            final ability = item['ability'] as String;
            final bonus = item['bonus'] as int;
            finalScores[ability] = (finalScores[ability] ?? 10) + bonus;
          }
        }
      }
    } else if (wizard.ruleset == RulesetVersion.dnd2024) {
      // Background ASI choices
      for (final entry in wizard.backgroundAsiChoices.entries) {
        finalScores[entry.key] = (finalScores[entry.key] ?? 10) + entry.value;
      }
    }

    // 1 — Resolve HP (handling multiclassing and starting levels > 1)
    final primaryClass = wizard.classes.first;
    final con = finalScores['con'] ?? 10;
    int hpMax = 0;
    bool isFirstLevelResolved = false;

    for (int i = 0; i < wizard.classes.length; i++) {
      final classEntry = wizard.classes[i];
      final cls = await db.compendiumDao.getClassById(classEntry.classId, wizard.ruleset);
      final hitDie = cls?.hitDie ?? 8;

      if (!isFirstLevelResolved) {
        // First level of primary class gives max hit die value
        hpMax += DndRules.hpAtLevel1(hitDie, con);
        isFirstLevelResolved = true;
        // Remaining levels of primary class (if any) give average value
        if (classEntry.level > 1) {
          hpMax += (classEntry.level - 1) * DndRules.hpAverageOnLevelUp(hitDie, con);
        }
      } else {
        // All levels of subsequent classes (multiclassing) give average value
        hpMax += classEntry.level * DndRules.hpAverageOnLevelUp(hitDie, con);
      }
    }

    // 2 — Insert character row
    final characterId = await db.characterDao.insertCharacter(
      CharactersCompanion.insert(
        name: wizard.name.trim(),
        playerName: Value(wizard.playerName.trim()),
        ruleset: wizard.ruleset,
        alignment: Value(wizard.alignment),
        speciesId: Value(wizard.speciesId),
        subspeciesId: Value(wizard.subspeciesId),
        backgroundId: Value(wizard.backgroundId),
        hpMax: Value(hpMax),
        hpCurrent: Value(hpMax),
        createdAt: now,
        updatedAt: now,
      ),
    );

    // 3 — Insert final ability scores, with their base/origin-bonus split
    final baseScores = wizard.abilityScores;
    int baseOf(String key) => baseScores[key] ?? 10;
    int bonusOf(String key) => (finalScores[key] ?? 10) - baseOf(key);
    await db.characterDao.upsertAbilityScores(
      CharacterAbilityScoresCompanion.insert(
        characterId: characterId,
        strength: Value(finalScores['str'] ?? 10),
        dexterity: Value(finalScores['dex'] ?? 10),
        constitution: Value(con),
        intelligence: Value(finalScores['int'] ?? 10),
        wisdom: Value(finalScores['wis'] ?? 10),
        charisma: Value(finalScores['cha'] ?? 10),
        baseStrength: Value(baseOf('str')),
        baseDexterity: Value(baseOf('dex')),
        baseConstitution: Value(baseOf('con')),
        baseIntelligence: Value(baseOf('int')),
        baseWisdom: Value(baseOf('wis')),
        baseCharisma: Value(baseOf('cha')),
        bonusStrength: Value(bonusOf('str')),
        bonusDexterity: Value(bonusOf('dex')),
        bonusConstitution: Value(bonusOf('con')),
        bonusIntelligence: Value(bonusOf('int')),
        bonusWisdom: Value(bonusOf('wis')),
        bonusCharisma: Value(bonusOf('cha')),
      ),
    );

    // 4 — Insert class rows (multiclass)
    final is2024 = wizard.ruleset == RulesetVersion.dnd2024;
    for (final entry in wizard.classes) {
      final order = is2024
          ? ClassOrders.chosenFor(
              entry.classId,
              divineOrder: wizard.chosenDivineOrder,
              primalOrder: wizard.chosenPrimalOrder,
            )
          : null;
      await db.characterDao.insertCharacterClass(
        CharacterClassesCompanion.insert(
          characterId: characterId,
          classId: entry.classId,
          subclassId: Value(entry.subclassId),
          level: entry.level,
          // Colonne absente de l'insert si pas d'ordre : reste compatible avec
          // une base distante où la migration class_order n'est pas appliquée.
          classOrder: order == null ? const Value.absent() : Value(order),
        ),
      );
    }

    // 5 — Insert proficiencies: skills chosen + class saves + armor/weapons + background tools + weapon masteries
    final profCompanions = <CharacterProficienciesCompanion>[];

    // 5a — Skills chosen in wizard
    for (final key in wizard.chosenSkillProficiencies) {
      profCompanions.add(CharacterProficienciesCompanion.insert(
        characterId: characterId,
        proficiencyKey: 'skill_$key',
      ));
    }

    // 5b — Class saving throws and armor/weapon proficiencies (from SrdClasses.proficiencies JSON)
    final primaryClassData = await db.compendiumDao.getClassById(primaryClass.classId, wizard.ruleset);
    if (primaryClassData != null && primaryClassData.proficiencies.isNotEmpty) {
      final List<dynamic> classProfsList = json.decode(primaryClassData.proficiencies);
      // Each item is either a String (index) or a Map with an 'index' key
      for (final profItem in classProfsList) {
        final profIndex = profItem is String
            ? profItem
            : (profItem as Map<String, dynamic>)['index'] as String? ?? '';
        if (profIndex.isEmpty) continue;

        String? profKey;
        if (profIndex.startsWith('saving-throw-')) {
          profKey = 'save_${profIndex.replaceFirst('saving-throw-', '')}';
        } else if (profIndex == 'all-armor') {
          profKey = 'armor_all';
        } else if (profIndex == 'light-armor') {
          profKey = 'armor_light';
        } else if (profIndex == 'medium-armor') {
          profKey = 'armor_medium';
        } else if (profIndex == 'heavy-armor') {
          profKey = 'armor_heavy';
        } else if (profIndex == 'shields') {
          profKey = 'armor_shield';
        } else if (profIndex == 'simple-weapons') {
          profKey = 'weapon_simple';
        } else if (profIndex == 'martial-weapons') {
          profKey = 'weapon_martial';
        } else if (profIndex.startsWith('tool-')) {
          profKey = 'tool_${profIndex.replaceFirst('tool-', '')}';
        }
        if (profKey != null && !profCompanions.any((p) => p.proficiencyKey.value == profKey)) {
          profCompanions.add(CharacterProficienciesCompanion.insert(
            characterId: characterId,
            proficiencyKey: profKey,
          ));
        }
      }
    }


    // 5c — Background tool proficiencies (DnD 2024)
    if (wizard.backgroundId != null) {
      final background = await db.compendiumDao.getBackgroundById(wizard.backgroundId!, wizard.ruleset);
      if (background != null && background.toolProficiencies.isNotEmpty) {
        final List<dynamic> toolList = json.decode(background.toolProficiencies);
        for (final tool in toolList.cast<String>()) {
          final profKey = 'tool_$tool';
          if (!profCompanions.any((p) => p.proficiencyKey.value == profKey)) {
            profCompanions.add(CharacterProficienciesCompanion.insert(
              characterId: characterId,
              proficiencyKey: profKey,
            ));
          }
        }
      }
    }

    // 5d — Weapon masteries (DnD 2024)
    if (wizard.ruleset == RulesetVersion.dnd2024) {
      for (final masteryId in wizard.chosenWeaponMasteries) {
        final profKey = 'mastery_$masteryId';
        if (!profCompanions.any((p) => p.proficiencyKey.value == profKey)) {
          profCompanions.add(CharacterProficienciesCompanion.insert(
            characterId: characterId,
            proficiencyKey: profKey,
          ));
        }
      }
    }

    // 5e — Extra proficiencies from origin feats (Skilled, Crafter, Musician)
    for (final profKey in wizard.chosenFeatExtraProficiencies) {
      if (!profCompanions.any((p) => p.proficiencyKey.value == profKey)) {
        profCompanions.add(CharacterProficienciesCompanion.insert(
          characterId: characterId,
          proficiencyKey: profKey,
        ));
      }
    }

    // 5f — Divine Order Protector proficiencies (heavy armor, martial weapons)
    if (wizard.ruleset == RulesetVersion.dnd2024 && wizard.chosenDivineOrder == 'protector') {
      for (final profKey in ['armor_heavy', 'weapon_martial']) {
        if (!profCompanions.any((p) => p.proficiencyKey.value == profKey)) {
          profCompanions.add(CharacterProficienciesCompanion.insert(
            characterId: characterId,
            proficiencyKey: profKey,
          ));
        }
      }
    }

    // 5g — Primal Order Warden proficiencies (medium armor, martial weapons)
    if (wizard.ruleset == RulesetVersion.dnd2024 && wizard.chosenPrimalOrder == 'warden') {
      for (final profKey in ['armor_medium', 'weapon_martial']) {
        if (!profCompanions.any((p) => p.proficiencyKey.value == profKey)) {
          profCompanions.add(CharacterProficienciesCompanion.insert(
            characterId: characterId,
            proficiencyKey: profKey,
          ));
        }
      }
    }

    if (profCompanions.isNotEmpty) {
      await db.characterDao.replaceAllProficiencies(characterId, profCompanions);
    }

    // 5.5 — Insert starting feat (D&D 2024 only)
    if (wizard.ruleset == RulesetVersion.dnd2024 && wizard.chosenFeatId != null) {
      await db.characterDao.insertCharacterFeat(
        CharacterFeatsCompanion.insert(
          characterId: characterId,
          featId: wizard.chosenFeatId!,
          ruleset: RulesetVersion.dnd2024,
        ),
      );
    }

    // 5.6 — Insert chosen Warlock Pact as a feat (D&D 2024 only)
    if (wizard.ruleset == RulesetVersion.dnd2024 && wizard.chosenWarlockPact != null) {
      await db.characterDao.insertCharacterFeat(
        CharacterFeatsCompanion.insert(
          characterId: characterId,
          featId: wizard.chosenWarlockPact!,
          ruleset: RulesetVersion.dnd2024,
        ),
      );
    }

    // 5.7 — Insert chosen Fighting Style as a feat (D&D 2024 only)
    if (wizard.ruleset == RulesetVersion.dnd2024 && wizard.chosenFightingStyle != null) {
      await db.characterDao.insertCharacterFeat(
        CharacterFeatsCompanion.insert(
          characterId: characterId,
          featId: wizard.chosenFightingStyle!,
          ruleset: RulesetVersion.dnd2024,
        ),
      );
    }

    // 6 — Compute and insert spell slots
    await _initSpellSlots(characterId, wizard);

    // 7 — Init class resources
    await _initClassResources(characterId, wizard);

    // 8 — Seed starting equipment and gold
    await _initStartingEquipment(characterId, wizard);

    return characterId;
  }

  Future<void> _initSpellSlots(int characterId, WizardState wizard) async {
    final slots = ClassProgression.spellSlots(
      wizard.classes
          .map(
            (c) => ClassProgress(
              classId: c.classId,
              level: c.level,
              subclassId: c.subclassId,
            ),
          )
          .toList(),
      wizard.ruleset,
    );

    if (slots.isEmpty) return;

    final companions = slots.entries
        .map((e) => CharacterSpellSlotsCompanion.insert(
              characterId: characterId,
              slotLevel: e.key,
              slotMax: e.value,
              slotCurrent: e.value,
            ))
        .toList();
    await db.characterDao.replaceAllSpellSlots(characterId, companions);
  }

  Future<void> _initClassResources(int characterId, WizardState wizard) async {
    final resources = <CharacterResourcesCompanion>[];

    for (final entry in wizard.classes) {
      final level = entry.level;
      final hitDie = getHitDieForClass(entry.classId);
      resources.add(CharacterResourcesCompanion.insert(
        characterId: characterId,
        resourceName: 'hitDice_d$hitDie',
        current: level,
        maximum: level,
      ));

      for (final spec in DndRules.classResourceByLevel(
          entry.classId, level, wizard.ruleset)) {
        // Deux classes peuvent partager une ressource (ex. Conduit divin) :
        // on garde le plus grand maximum.
        final index = resources.indexWhere((r) =>
            r.resourceName.value == spec.key);
        if (index >= 0 && resources[index].maximum.value >= spec.maximum) {
          continue;
        }
        final companion = CharacterResourcesCompanion.insert(
          characterId: characterId,
          resourceName: spec.key,
          current: spec.maximum,
          maximum: spec.maximum,
        );
        if (index >= 0) {
          resources[index] = companion;
        } else {
          resources.add(companion);
        }
      }
    }

    final feats = await db.characterDao.getCharacterFeats(characterId);
    if (wizard.chosenFeatId == 'lucky' || feats.any((f) => f.featId == 'lucky')) {
      final totalLevel = wizard.classes.fold(0, (s, c) => s + c.level);
      final profBonus = max(2, DndRules.proficiencyBonus(totalLevel));
      resources.add(CharacterResourcesCompanion.insert(
        characterId: characterId,
        resourceName: 'resourceLucky',
        current: profBonus,
        maximum: profBonus,
      ));
    }

    if (resources.isNotEmpty) {
      await db.characterDao.replaceAllResources(characterId, resources);
    }
  }

  /// Enregistre l'ordre divin/primordial d'une classe d'un personnage existant
  /// et ajoute les maîtrises associées si elles manquent.
  Future<void> setClassOrder({
    required int characterId,
    required int classRowId,
    required String order,
  }) async {
    await db.characterDao.updateCharacterClass(
      CharacterClassesCompanion(
        id: Value(classRowId),
        classOrder: Value(order),
      ),
    );
    final existing = await db.characterDao.getProficiencies(characterId);
    for (final key in ClassOrders.proficiencyKeys(order)) {
      if (existing.any((p) => p.proficiencyKey == key)) continue;
      await db.characterDao.insertProficiency(
        CharacterProficienciesCompanion.insert(
          characterId: characterId,
          proficiencyKey: key,
        ),
      );
    }
  }

  /// État du personnage utilisé par [LevelUpPlan], lu depuis la base. Null si
  /// le personnage est introuvable.
  Future<LevelUpState?> loadLevelUpState(int characterId) async {
    final character = await db.characterDao.getCharacterById(characterId);
    if (character == null) return null;
    final classes = await db.characterDao.getCharacterClasses(characterId);
    final scores = await db.characterDao.getAbilityScores(characterId);
    final proficiencies = await db.characterDao.getProficiencies(characterId);
    final feats = await db.characterDao.getCharacterFeats(characterId);
    return LevelUpState(
      ruleset: character.ruleset,
      classes: classes
          .map(
            (c) => ClassProgress(
              classId: c.classId,
              level: c.level,
              subclassId: c.subclassId,
            ),
          )
          .toList(),
      scores: {
        'str': scores?.strength ?? 10,
        'dex': scores?.dexterity ?? 10,
        'con': scores?.constitution ?? 10,
        'int': scores?.intelligence ?? 10,
        'wis': scores?.wisdom ?? 10,
        'cha': scores?.charisma ?? 10,
      },
      hpMax: character.hpMax,
      hpCurrent: character.hpCurrent,
      proficiencies: proficiencies.map((p) => p.proficiencyKey).toSet(),
      featIds: feats.map((f) => f.featId).toSet(),
    );
  }

  /// Applique une montée de niveau complète : classe, PV, caractéristiques ou
  /// don, maîtrises, ressources, emplacements, dés de vie et CA, en une seule
  /// transaction côté serveur (`apply_level_up`). Retourne ce qui a été
  /// appliqué, pour le résumé.
  ///
  /// Lève [LevelUpException] si les choix sont incomplets ou invalides ; une
  /// erreur réseau ou serveur n'écrit rien.
  Future<LevelUpResult> levelUp({
    required int characterId,
    required String classId,
    required LevelUpChoices choices,
    Iterable<SrdFeat> feats = const [],
    bool hasSubclassOptions = true,
  }) async {
    final state = await loadLevelUpState(characterId);
    if (state == null) throw StateError('Personnage introuvable');

    final plan = LevelUpPlan.build(
      state: state,
      classId: classId,
      hasSubclassOptions: hasSubclassOptions,
    );
    final issues = plan.validate(choices, feats: feats);
    if (issues.isNotEmpty) throw LevelUpException(issues);
    final outcome = plan.outcome(choices);

    final classRows = await db.characterDao.getCharacterClasses(characterId);
    final classRow = classRows.where((c) => c.classId == classId).firstOrNull;

    final payload = <String, dynamic>{
      'class': {
        'id': classRow?.id,
        'class_id': classId,
        'subclass_id': outcome.classesAfter
            .firstWhere((c) => c.classId == classId)
            .subclassId,
        'level': plan.newClassLevel,
      },
      'expected_level': classRow?.level,
      'proficiencies': outcome.proficiencyKeysAdded,
    };

    if (outcome.abilityChanges.isNotEmpty) {
      final bonus = await loadOriginAbilityBonuses(characterId);
      payload['ability_scores'] = _abilityScoresPayload(
        outcome.scoresAfter,
        bonus,
      );
    }

    if (outcome.featId != null) {
      payload['feat'] = {
        'feat_id': outcome.featId,
        'ruleset': state.ruleset.name,
      };
    }

    final storedResources = <String, ResourceValue>{};
    for (final r in await db.characterDao.watchResources(characterId).first) {
      storedResources.putIfAbsent(
        r.resourceName,
        () => ResourceValue(r.current, r.maximum),
      );
    }
    payload['resources'] = [
      for (final e in outcome.resourceChanges(storedResources).entries)
        {
          'resource_name': e.key,
          'current': e.value.current,
          'maximum': e.value.maximum,
        },
    ];

    final slots = await _spellSlotsPayload(characterId, outcome);
    if (slots != null) payload['spell_slots'] = slots;

    // La CA enregistrée peut contenir des bonus saisis à la main : on lui
    // applique seulement l'écart calculé par la montée de niveau.
    final storedAc = (await db.characterDao.getCharacterById(characterId))
        ?.armorClass;
    final computedBefore = await _computeAc(characterId);
    final computedAfter = await _computeAc(
      characterId,
      dex: outcome.scoresAfter['dex'],
      con: outcome.scoresAfter['con'],
      wis: outcome.scoresAfter['wis'],
      classIds: outcome.classesAfter.map((c) => c.classId),
    );
    final armorClassBefore = storedAc ?? computedBefore;
    final armorClassAfter = armorClassBefore + computedAfter - computedBefore;
    payload['character'] = {
      'hp_max': outcome.hpMaxAfter,
      'hp_current': outcome.hpCurrentAfter,
      'armor_class': armorClassAfter,
      'updated_at': DateTime.now().toIso8601String(),
    };

    await db.characterDao.applyLevelUp(characterId, payload);
    return LevelUpResult(
      outcome: outcome,
      armorClassBefore: armorClassBefore,
      armorClassAfter: armorClassAfter,
    );
  }

  Map<String, int> _abilityScoresPayload(
    Map<String, int> finalScores,
    Map<String, int> originBonus,
  ) {
    const columns = {
      'str': 'strength',
      'dex': 'dexterity',
      'con': 'constitution',
      'int': 'intelligence',
      'wis': 'wisdom',
      'cha': 'charisma',
    };
    final payload = <String, int>{};
    columns.forEach((key, column) {
      final score = (finalScores[key] ?? 10).clamp(
        CharacterEditRules.minScore,
        CharacterEditRules.maxScore,
      );
      final bonus = originBonus[key] ?? 0;
      payload[column] = score;
      payload['base_$column'] = score - bonus;
      payload['bonus_$column'] = bonus;
    });
    return payload;
  }

  /// Emplacements à écrire (ensemble complet) ou null s'ils sont déjà à jour.
  /// Les emplacements dépensés le restent ; un maximum qui augmente ajoute
  /// autant d'emplacements disponibles.
  Future<List<Map<String, int>>?> _spellSlotsPayload(
    int characterId,
    LevelUpOutcome outcome,
  ) async {
    final stored = await db.characterDao.watchSpellSlots(characterId).first;
    final storedMax = {for (final s in stored) s.slotLevel: s.slotMax};
    final target = outcome.spellSlotsAfter;
    if (storedMax.length == target.length &&
        target.entries.every((e) => storedMax[e.key] == e.value)) {
      return null;
    }
    return [
      for (final e in target.entries)
        {
          'slot_level': e.key,
          'slot_max': e.value,
          'slot_current': () {
            final old = stored.where((s) => s.slotLevel == e.key).firstOrNull;
            if (old == null) return e.value;
            final gained = e.value > old.slotMax ? e.value - old.slotMax : 0;
            return (old.slotCurrent + gained).clamp(0, e.value);
          }(),
        },
    ];
  }

  /// Convert a class index to a display-friendly name
  static String classDisplayName(String classId, AppLocalizations l10n) {
    final names = {
      'barbarian': l10n.classBarbarian,
      'bard': l10n.classBard,
      'cleric': l10n.classCleric,
      'druid': l10n.classDruid,
      'fighter': l10n.classFighter,
      'monk': l10n.classMonk,
      'paladin': l10n.classPaladin,
      'ranger': l10n.classRanger,
      'rogue': l10n.classRogue,
      'sorcerer': l10n.classSorcerer,
      'warlock': l10n.classWarlock,
      'wizard': l10n.classWizard,
    };
    return names[classId] ??
        (classId.isEmpty
            ? '?'
            : classId[0].toUpperCase() + classId.substring(1));
  }

  /// Get the icon for a class ID
  static IconData getClassIcon(String classId) {
    switch (classId.toLowerCase().trim()) {
      case 'barbarian':
        return Icons.gavel;
      case 'bard':
        return Icons.music_note;
      case 'cleric':
        return Icons.favorite;
      case 'druid':
        return Icons.nature;
      case 'fighter':
        return Icons.shield;
      case 'monk':
        return Icons.sports_martial_arts;
      case 'paladin':
        return Icons.workspace_premium;
      case 'ranger':
        return Icons.explore;
      case 'rogue':
        return Icons.vpn_key;
      case 'sorcerer':
        return Icons.bolt;
      case 'warlock':
        return Icons.auto_awesome;
      case 'wizard':
        return Icons.menu_book;
      default:
        return Icons.help_outline;
    }
  }

  /// Convert a resource key to a display-friendly name
  static String resourceDisplayName(String resourceKey, AppLocalizations l10n) {
    final names = {
      'resourceRage': l10n.resourceRage,
      'resourceKi': l10n.resourceKi,
      'resourceSorceryPoints': l10n.resourceSorceryPoints,
      'resourceChannelDivinity': l10n.resourceChannelDivinity,
      'resourceWildShape': l10n.resourceWildShape,
      'resourceActionSurge': l10n.resourceActionSurge,
      'resourceSecondWind': l10n.resourceSecondWind,
    };
    return names[resourceKey] ?? resourceKey;
  }

  /// Recalculates the character's AC based on their current stats, classes, and equipped items.
  /// Then updates the armorClass field in the database.
  Future<int> recalculateCharacterAc(int characterId) async {
    final totalAc = await _computeAc(characterId);

    // 5. Update character AC in DB
    await db.characterDao.updateCharacter(CharactersCompanion(
      id: Value(characterId),
      armorClass: Value(totalAc),
      updatedAt: Value(DateTime.now().toIso8601String()),
    ));

    return totalAc;
  }

  /// Computes the AC from equipment/classes; [dex]/[con]/[wis] override the
  /// stored scores (used to preview a pending edit).
  Future<int> _computeAc(
    int characterId, {
    int? dex,
    int? con,
    int? wis,
    Iterable<String>? classIds,
  }) async {
    final scores = await db.characterDao.getAbilityScores(characterId);
    final classes = await db.characterDao.getCharacterClasses(characterId);
    final equipment = await db.characterDao.getEquipment(characterId);

    return ArmorClassHelper.calculateAc(
      equippedItems: equipment.where((e) => e.equipped).toList(),
      dexMod: DndRules.modifier(dex ?? scores?.dexterity ?? 10),
      conMod: DndRules.modifier(con ?? scores?.constitution ?? 10),
      wisMod: DndRules.modifier(wis ?? scores?.wisdom ?? 10),
      className: (classIds ?? classes.map((c) => c.classId)).join(' '),
    ).totalAc;
  }

  // ── Édition d'un personnage existant ─────────────────────────────────────

  Future<void> updateIdentity({
    required int characterId,
    required String name,
    required String playerName,
    required String alignment,
  }) async {
    await db.characterDao.updateCharacter(CharactersCompanion(
      id: Value(characterId),
      name: Value(name.trim()),
      playerName: Value(playerName.trim()),
      alignment: Value(alignment),
      updatedAt: Value(DateTime.now().toIso8601String()),
    ));
  }

  Future<({Set<String> toolKeys, String? featId})> _originGrants(
    String? backgroundId,
    RulesetVersion ruleset,
  ) async {
    if (backgroundId == null) return (toolKeys: <String>{}, featId: null);
    final bg = await db.compendiumDao.getBackgroundById(backgroundId, ruleset);
    if (bg == null) return (toolKeys: <String>{}, featId: null);
    final keys = <String>{};
    if (bg.toolProficiencies.isNotEmpty) {
      for (final tool in (json.decode(bg.toolProficiencies) as List).cast<String>()) {
        keys.add('tool_$tool');
      }
    }
    return (
      toolKeys: keys,
      featId: ruleset == RulesetVersion.dnd2024 ? bg.originFeatId : null,
    );
  }

  /// Ce qui change si l'origine devient (species, subspecies, background).
  Future<OriginChangePreview> previewOriginChange({
    required int characterId,
    required String? backgroundId,
  }) async {
    final character = await db.characterDao.getCharacterById(characterId);
    if (character == null || character.backgroundId == backgroundId) {
      return const OriginChangePreview();
    }
    final old = await _originGrants(character.backgroundId, character.ruleset);
    final next = await _originGrants(backgroundId, character.ruleset);

    final currentProfs = (await db.characterDao.getProficiencies(characterId))
        .map((p) => p.proficiencyKey)
        .toSet();
    final feats = await db.characterDao.getCharacterFeats(characterId);

    final removedProfs = old.toolKeys
        .difference(next.toolKeys)
        .where(currentProfs.contains)
        .toList()
      ..sort();
    final addedProfs = next.toolKeys
        .difference(currentProfs)
        .toList()
      ..sort();

    final removeFeat = old.featId != null &&
        old.featId != next.featId &&
        feats.any((f) => f.featId == old.featId);
    final addFeat = next.featId != null &&
        next.featId != old.featId &&
        !feats.any((f) => f.featId == next.featId);

    return OriginChangePreview(
      removedProficiencies: removedProfs,
      addedProficiencies: addedProfs,
      removedFeatId: removeFeat ? old.featId : null,
      addedFeatId: addFeat ? next.featId : null,
    );
  }

  /// Change espèce / sous-espèce / historique. Seuls les éléments issus de
  /// l'ancienne origine sont retirés : les ajouts manuels sont conservés.
  /// Les caractéristiques ne sont pas touchées ici (voir [updateAbilityScores]).
  Future<void> changeOrigin({
    required int characterId,
    required String? speciesId,
    required String? subspeciesId,
    required String? backgroundId,
  }) async {
    final character = await db.characterDao.getCharacterById(characterId);
    if (character == null) return;

    if (character.backgroundId != backgroundId) {
      final old = await _originGrants(character.backgroundId, character.ruleset);
      final next = await _originGrants(backgroundId, character.ruleset);
      final preview = await previewOriginChange(
        characterId: characterId,
        backgroundId: backgroundId,
      );

      for (final key in preview.removedProficiencies) {
        await db.characterDao.deleteProficiency(characterId, key);
      }
      for (final key in preview.addedProficiencies) {
        await db.characterDao.insertProficiency(
          CharacterProficienciesCompanion.insert(
            characterId: characterId,
            proficiencyKey: key,
          ),
        );
      }

      if (preview.removedFeatId != null) {
        final feats = await db.characterDao.getCharacterFeats(characterId);
        final row = feats.where((f) => f.featId == old.featId).firstOrNull;
        if (row != null) await db.characterDao.deleteCharacterFeatById(row.id);
      }
      if (preview.addedFeatId != null) {
        await db.characterDao.insertCharacterFeat(
          CharacterFeatsCompanion.insert(
            characterId: characterId,
            featId: next.featId!,
            ruleset: character.ruleset,
          ),
        );
      }
    }

    await db.characterDao.updateCharacter(CharactersCompanion(
      id: Value(characterId),
      speciesId: Value(speciesId),
      subspeciesId: Value(subspeciesId),
      backgroundId: Value(backgroundId),
      updatedAt: Value(DateTime.now().toIso8601String()),
    ));
  }

  Future<int> _totalLevel(int characterId) async {
    final classes = await db.characterDao.getCharacterClasses(characterId);
    return classes.fold<int>(0, (sum, c) => sum + c.level);
  }

  /// Conséquences d'une modification des valeurs finales de caractéristiques.
  Future<AbilityChangePreview> previewAbilityScores({
    required int characterId,
    required Map<String, int> finalScores,
  }) async {
    final character = await db.characterDao.getCharacterById(characterId);
    final old = await db.characterDao.getAbilityScores(characterId);
    if (character == null || old == null) {
      return const AbilityChangePreview(
        hpMaxBefore: 0,
        hpMaxAfter: 0,
        acBefore: 0,
        acAfter: 0,
      );
    }
    final newCon = finalScores['con'] ?? old.constitution;
    final delta = CharacterEditRules.retroactiveHpDelta(
      oldCon: old.constitution,
      newCon: newCon,
      totalLevel: await _totalLevel(characterId),
    );
    final hp = CharacterEditRules.applyHpDelta(
      hpMax: character.hpMax,
      hpCurrent: character.hpCurrent,
      delta: delta,
    );
    final acBefore = await _computeAc(characterId);
    final acAfter = await _computeAc(
      characterId,
      dex: finalScores['dex'],
      con: newCon,
      wis: finalScores['wis'],
    );
    return AbilityChangePreview(
      hpMaxBefore: character.hpMax,
      hpMaxAfter: hp.hpMax,
      acBefore: acBefore,
      acAfter: acAfter,
    );
  }

  /// Écrit les valeurs finales avec leur décomposition base/bonus, sans toucher
  /// aux PV ni à la CA. Utilisé aussi par l'édition rapide de la fiche : le
  /// bonus d'origine est relu (ou déduit pour un personnage plus ancien).
  Future<void> saveFinalScores({
    required int characterId,
    required Map<String, int> finalScores,
  }) async {
    final bonus = await loadOriginAbilityBonuses(characterId);
    await _writeScores(characterId, finalScores, bonus);
  }

  Future<void> _writeScores(
    int characterId,
    Map<String, int> finalScores,
    Map<String, int> originBonus,
  ) async {
    final old = await db.characterDao.getAbilityScores(characterId);

    int score(String key, int fallback) => (finalScores[key] ?? fallback)
        .clamp(CharacterEditRules.minScore, CharacterEditRules.maxScore);
    int bonus(String key) => originBonus[key] ?? 0;

    final str = score('str', old?.strength ?? 10);
    final dex = score('dex', old?.dexterity ?? 10);
    final con = score('con', old?.constitution ?? 10);
    final intel = score('int', old?.intelligence ?? 10);
    final wis = score('wis', old?.wisdom ?? 10);
    final cha = score('cha', old?.charisma ?? 10);

    await db.characterDao.upsertAbilityScores(
      CharacterAbilityScoresCompanion(
        characterId: Value(characterId),
        strength: Value(str),
        dexterity: Value(dex),
        constitution: Value(con),
        intelligence: Value(intel),
        wisdom: Value(wis),
        charisma: Value(cha),
        baseStrength: Value(str - bonus('str')),
        baseDexterity: Value(dex - bonus('dex')),
        baseConstitution: Value(con - bonus('con')),
        baseIntelligence: Value(intel - bonus('int')),
        baseWisdom: Value(wis - bonus('wis')),
        baseCharisma: Value(cha - bonus('cha')),
        bonusStrength: Value(bonus('str')),
        bonusDexterity: Value(bonus('dex')),
        bonusConstitution: Value(bonus('con')),
        bonusIntelligence: Value(bonus('int')),
        bonusWisdom: Value(bonus('wis')),
        bonusCharisma: Value(bonus('cha')),
      ),
    );
  }

  /// Enregistre les valeurs finales (= base + [originBonus]), applique l'écart
  /// rétroactif de PV si la CON change et recalcule la CA. Les emplacements de
  /// sorts dépendent uniquement des classes/niveaux, pas des caractéristiques.
  Future<void> updateAbilityScores({
    required int characterId,
    required Map<String, int> finalScores,
    required Map<String, int> originBonus,
  }) async {
    final character = await db.characterDao.getCharacterById(characterId);
    final old = await db.characterDao.getAbilityScores(characterId);
    if (character == null) return;

    final newCon = (finalScores['con'] ?? old?.constitution ?? 10)
        .clamp(CharacterEditRules.minScore, CharacterEditRules.maxScore);
    await _writeScores(characterId, finalScores, originBonus);

    final delta = CharacterEditRules.retroactiveHpDelta(
      oldCon: old?.constitution ?? newCon,
      newCon: newCon,
      totalLevel: await _totalLevel(characterId),
    );
    if (delta != 0) {
      final hp = CharacterEditRules.applyHpDelta(
        hpMax: character.hpMax,
        hpCurrent: character.hpCurrent,
        delta: delta,
      );
      await db.characterDao.updateCharacter(CharactersCompanion(
        id: Value(characterId),
        hpMax: Value(hp.hpMax),
        hpCurrent: Value(hp.hpCurrent),
        updatedAt: Value(DateTime.now().toIso8601String()),
      ));
    }

    await recalculateCharacterAc(characterId);
  }

  /// Bonus d'origine par caractéristique. Lus dans les colonnes `bonus_*` ;
  /// pour un personnage créé avant leur ajout, déduits de la race/sous-race
  /// en 2014 (inconnus, donc 0, en 2024).
  Future<Map<String, int>> loadOriginAbilityBonuses(int characterId) async {
    final character = await db.characterDao.getCharacterById(characterId);
    if (character == null) return {};

    final scores = await db.characterDao.getAbilityScores(characterId);
    if (scores != null) {
      final stored = {
        'str': scores.bonusStrength,
        'dex': scores.bonusDexterity,
        'con': scores.bonusConstitution,
        'int': scores.bonusIntelligence,
        'wis': scores.bonusWisdom,
        'cha': scores.bonusCharisma,
      };
      if (stored.values.any((v) => v != null)) {
        return {for (final e in stored.entries) e.key: e.value ?? 0};
      }
    }

    if (character.ruleset == RulesetVersion.dnd2024) return {};
    final speciesId = character.speciesId;
    if (speciesId == null) return {};
    final race = await db.compendiumDao.getRaceById(speciesId, character.ruleset);
    final subraces = await db.compendiumDao.getSubraces(speciesId, character.ruleset);
    final subrace =
        subraces.where((s) => s.id == character.subspeciesId).firstOrNull;
    return CharacterEditRules.sumBonuses([
      CharacterEditRules.parseAbilityBonuses(race?.abilityBonuses),
      CharacterEditRules.parseAbilityBonuses(subrace?.abilityBonuses),
    ]);
  }

  /// Conséquences cumulées d'une édition, pour le dialogue de confirmation.
  Future<CharacterEditPreview> previewEdit(
    int characterId,
    CharacterEditRequest request,
  ) async {
    final character = await db.characterDao.getCharacterById(characterId);
    final abilities = await previewAbilityScores(
      characterId: characterId,
      finalScores: request.finalScores,
    );
    final origin = await previewOriginChange(
      characterId: characterId,
      backgroundId: request.backgroundId,
    );
    return CharacterEditPreview(
      abilities: abilities,
      origin: origin,
      originChanged: character != null &&
          (character.speciesId != request.speciesId ||
              character.subspeciesId != request.subspeciesId ||
              character.backgroundId != request.backgroundId),
    );
  }

  /// Applique une édition complète : identité, origine, puis caractéristiques
  /// (PV max rétroactifs et CA recalculés en dernier).
  Future<void> applyEdit(int characterId, CharacterEditRequest request) async {
    final character = await db.characterDao.getCharacterById(characterId);
    if (character == null) return;

    await updateIdentity(
      characterId: characterId,
      name: request.name,
      playerName: request.playerName,
      alignment: request.alignment,
    );

    final originChanged = character.speciesId != request.speciesId ||
        character.subspeciesId != request.subspeciesId ||
        character.backgroundId != request.backgroundId;
    if (originChanged) {
      await changeOrigin(
        characterId: characterId,
        speciesId: request.speciesId,
        subspeciesId: request.subspeciesId,
        backgroundId: request.backgroundId,
      );
    }

    await updateAbilityScores(
      characterId: characterId,
      finalScores: request.finalScores,
      originBonus: request.originBonus,
    );
  }

  // Helper parser
  static ArmorInfo? parseEquipmentAsArmor(CharacterEquipmentData item) {
    final name = item.itemName.toLowerCase();
    final notes = item.notes.toLowerCase();
    
    // Check if it's a shield
    if (name.contains('bouclier') || name.contains('shield') || name.contains('buckler') || name.contains('pavois')) {
      int acBonus = 2;
      if (name.contains('buckler') || name.contains('poing')) acBonus = 1;
      if (name.contains('pavois') || name.contains('tower')) acBonus = 3;
      return ArmorInfo(item.itemName, acBonus, 'shield', null);
    }
    
    // Check for heavy armor
    if (name.contains('harnois') || name.contains('plate') || name.contains('clavandier') || name.contains('splint') || name.contains('cotte de mailles') || name.contains('chain mail') || name.contains('chainmail')) {
      int baseAc = 18;
      if (name.contains('splint') || name.contains('clavandier')) baseAc = 17;
      if (name.contains('cotte de mailles') || name.contains('chain mail') || name.contains('chainmail')) baseAc = 16;
      return ArmorInfo(item.itemName, baseAc, 'heavy', 0);
    }
    
    // Check for medium armor
    if (name.contains('chemise de mailles') || name.contains('chainshirt') || name.contains('cuirasse') || name.contains('breastplate') || name.contains('écailles') || name.contains('scale mail') || name.contains('demi-harnois') || name.contains('half plate') || name.contains('hide') || name.contains('peau')) {
      int baseAc = 13;
      if (name.contains('cuirasse') || name.contains('breastplate') || name.contains('écailles') || name.contains('scale')) baseAc = 14;
      if (name.contains('demi-harnois') || name.contains('half plate')) baseAc = 15;
      if (name.contains('hide') || name.contains('peau')) baseAc = 12;
      return ArmorInfo(item.itemName, baseAc, 'medium', 2);
    }
    
    // Check for light armor
    if (name.contains('cuir') || name.contains('leather') || name.contains('matelassé') || name.contains('padded') || name.contains('studded')) {
      int baseAc = 11;
      if (name.contains('studded') || name.contains('clouté')) baseAc = 12;
      return ArmorInfo(item.itemName, baseAc, 'light', null);
    }

    // Check if notes contain "CA X"
    final caMatch = RegExp(r'ca\s*([0-9]+)').firstMatch(notes);
    if (caMatch != null) {
      int val = int.parse(caMatch.group(1)!);
      if (notes.contains('+')) {
        return ArmorInfo(item.itemName, val, 'shield', null);
      } else {
        if (val >= 16) return ArmorInfo(item.itemName, val, 'heavy', 0);
        if (val >= 13) return ArmorInfo(item.itemName, val, 'medium', 2);
        return ArmorInfo(item.itemName, val, 'light', null);
      }
    }

    return null;
  }
  Future<void> _initStartingEquipment(int characterId, WizardState wizard) async {
    // 1. Get class starting equipment
    final classItems = wizard.classes.isNotEmpty
        ? StartingEquipmentHelper.getClassEquipment(wizard.classes.first.classId)
        : <StartingItem>[];

    // 2. Get background starting equipment
    final bgItems = wizard.backgroundId != null
        ? StartingEquipmentHelper.getBackgroundEquipment(wizard.backgroundId!)
        : <StartingItem>[];

    // Merge/insert all into db
    final allItems = [...classItems, ...bgItems];
    for (final item in allItems) {
      await db.characterDao.insertEquipment(
        CharacterEquipmentCompanion.insert(
          characterId: characterId,
          itemName: item.name,
          quantity: Value(item.quantity),
          weight: Value(item.weight),
          equipped: Value(item.equipped),
          attuned: const Value(false),
          notes: const Value('Équipement de départ'),
        ),
      );
    }

    // Seed attacks for weapons
    final scores = await db.characterDao.getAbilityScores(characterId);
    final int strScore = scores?.strength ?? 10;
    final int dexScore = scores?.dexterity ?? 10;
    final int strMod = DndRules.modifier(strScore);
    final int dexMod = DndRules.modifier(dexScore);

    for (final item in allItems) {
      final weapon = StartingEquipmentHelper.getWeaponStats(item.name);
      if (weapon != null) {
        int abilityMod;
        if (weapon.scalingAbility == 'str') {
          abilityMod = strMod;
        } else if (weapon.scalingAbility == 'dex') {
          abilityMod = dexMod;
        } else { // finesse
          abilityMod = strMod > dexMod ? strMod : dexMod;
        }

        final int totalAttackBonus = abilityMod + 2; // Level 1 prof bonus is +2
        final String attackBonusStr = totalAttackBonus >= 0 ? '+$totalAttackBonus' : '$totalAttackBonus';
        final String damageDiceStr = abilityMod != 0
            ? '${weapon.baseDice}${abilityMod > 0 ? '+$abilityMod' : '$abilityMod'}'
            : weapon.baseDice;

        await db.characterDao.insertAttack(
          CharacterAttacksCompanion.insert(
            characterId: characterId,
            name: weapon.name,
            attackBonus: attackBonusStr,
            damageDice: damageDiceStr,
            damageType: weapon.damageType,
            masteryProperty: Value(wizard.ruleset == RulesetVersion.dnd2024 ? weapon.mastery : null),
            notes: const Value('Arme de départ'),
          ),
        );
      }
    }

    // 3. Gold / Currency
    final gold = wizard.backgroundId != null
        ? StartingEquipmentHelper.getBackgroundStartingGold(wizard.backgroundId!)
        : 10;

    // Fetch character to update currency field
    final character = await db.characterDao.getCharacterById(characterId);
    if (character != null) {
      try {
        final Map<String, dynamic> currMap = jsonDecode(character.currency);
        currMap['gp'] = (currMap['gp'] ?? 0) + gold;
        await db.characterDao.updateCharacter(
          CharactersCompanion(
            id: Value(characterId),
            currency: Value(jsonEncode(currMap)),
          ),
        );
      } on FormatException catch (e, st) {
        AppErrors.log(e, st, context: 'Initial currency JSON');
      }
    }
  }

  Future<void> shortRest(int characterId) async {
    final resources = await db.characterDao.watchResources(characterId).first;
    final shortRestResources = {
      'resourceKi',
      'resourceChannelDivinity',
      'resourceWildShape',
      'resourceActionSurge',
      'resourceSecondWind',
      'resourceBardicInspiration',
      'resourceLucky',
    };
    for (final r in resources) {
      if (shortRestResources.contains(r.resourceName)) {
        await db.characterDao.upsertResource(
          CharacterResourcesCompanion(
            id: Value(r.id),
            characterId: Value(characterId),
            resourceName: Value(r.resourceName),
            current: Value(r.maximum),
            maximum: Value(r.maximum),
          ),
        );
      }
    }

    // Warlock spell slots recharge on short rest
    final classes = await db.characterDao.getCharacterClasses(characterId);
    if (classes.any((c) => c.classId == 'warlock')) {
      final slots = await db.characterDao.watchSpellSlots(characterId).first;
      for (final s in slots) {
        await db.characterDao.updateSpellSlot(
          CharacterSpellSlotsCompanion(
            id: Value(s.id),
            characterId: Value(characterId),
            slotLevel: Value(s.slotLevel),
            slotMax: Value(s.slotMax),
            slotCurrent: Value(s.slotMax),
          ),
        );
      }
    }
  }

  Future<void> longRest(int characterId) async {
    final character = await db.characterDao.getCharacterById(characterId);
    if (character != null) {
      final newExhaustion = max(0, character.exhaustionLevel - 1);
      await db.characterDao.updateCharacter(
        CharactersCompanion(
          id: Value(characterId),
          hpCurrent: Value(character.hpMax),
          hpTemp: const Value(0),
          exhaustionLevel: Value(newExhaustion),
          updatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );
    }

    final slots = await db.characterDao.watchSpellSlots(characterId).first;
    for (final s in slots) {
      await db.characterDao.updateSpellSlot(
        CharacterSpellSlotsCompanion(
          id: Value(s.id),
          characterId: Value(characterId),
          slotLevel: Value(s.slotLevel),
          slotMax: Value(s.slotMax),
          slotCurrent: Value(s.slotMax),
        ),
      );
    }

    final resources = await db.characterDao.watchResources(characterId).first;
    for (final r in resources) {
      if (r.resourceName.startsWith('condition_')) {
        // Clear unconscious and prone on long rest, but preserve current status of other conditions
        int newCurrent = r.current;
        if (r.resourceName == 'condition_unconscious' || r.resourceName == 'condition_prone') {
          newCurrent = 0;
        }
        await db.characterDao.upsertResource(
          CharacterResourcesCompanion(
            id: Value(r.id),
            characterId: Value(characterId),
            resourceName: Value(r.resourceName),
            current: Value(newCurrent),
            maximum: Value(r.maximum),
          ),
        );
      } else if (r.resourceName.startsWith('hitDice_d')) {
        final regain = max(1, (r.maximum / 2).ceil());
        final newCurrent = (r.current + regain).clamp(0, r.maximum);
        await db.characterDao.upsertResource(
          CharacterResourcesCompanion(
            id: Value(r.id),
            characterId: Value(characterId),
            resourceName: Value(r.resourceName),
            current: Value(newCurrent),
            maximum: Value(r.maximum),
          ),
        );
      } else if (r.resourceName.startsWith('active_concentration_')) {
        continue;
      } else {
        await db.characterDao.upsertResource(
          CharacterResourcesCompanion(
            id: Value(r.id),
            characterId: Value(characterId),
            resourceName: Value(r.resourceName),
            current: Value(r.maximum),
            maximum: Value(r.maximum),
          ),
        );
      }
    }

    // Clear active concentration
    await db.characterDao.clearConcentration(characterId);
  }

  static int getHitDieForClass(String classId) {
    switch (classId.toLowerCase()) {
      case 'barbarian':
        return 12;
      case 'fighter':
      case 'paladin':
      case 'ranger':
        return 10;
      case 'sorcerer':
      case 'wizard':
        return 6;
      default: // bard, cleric, druid, monk, rogue, warlock
        return 8;
    }
  }

  Future<void> ensureHitDiceResourcesExist(int characterId) async {
    final resources = await db.characterDao.watchResources(characterId).first;
    final hasHitDice = resources.any((r) => r.resourceName.startsWith('hitDice_d'));
    if (!hasHitDice) {
      final classes = await db.characterDao.getCharacterClasses(characterId);
      for (final c in classes) {
        final hitDie = getHitDieForClass(c.classId);
        await db.characterDao.upsertResource(
          CharacterResourcesCompanion.insert(
            characterId: characterId,
            resourceName: 'hitDice_d$hitDie',
            current: c.level,
            maximum: c.level,
          ),
        );
      }
    }
  }
}

class ArmorInfo {
  final String name;
  final int baseAc;
  final String type; // 'light', 'medium', 'heavy', 'shield', 'unarmored'
  final int? maxDex;

  ArmorInfo(this.name, this.baseAc, this.type, this.maxDex);
}

/// Static helpers that can be used by widgets without instantiating CharacterService.
class CharacterServiceHelper {
  /// Returns the armor category ('shield', 'light', 'medium', 'heavy')
  /// for a given equipment item name, or null if the item is not armor.
  static String? parseEquipmentKind(String itemName) {
    final name = itemName.toLowerCase();

    // Shield
    if (name.contains('bouclier') || name.contains('shield') ||
        name.contains('buckler') || name.contains('pavois')) {
      return 'shield';
    }

    // Heavy armor
    if (name.contains('harnois') || name.contains('plate') ||
        name.contains('splint') || name.contains('clavandier') ||
        name.contains('cotte de mailles') || name.contains('chain mail') ||
        name.contains('chainmail')) {
      return 'heavy';
    }

    // Medium armor
    if (name.contains('chemise de mailles') || name.contains('chain shirt') ||
        name.contains('cuirasse') || name.contains('breastplate') ||
        name.contains('écailles') || name.contains('scale mail') ||
        name.contains('demi-harnois') || name.contains('half plate') ||
        name.contains('peau') || name.contains('hide')) {
      return 'medium';
    }

    // Light armor
    if (name.contains('cuir') || name.contains('leather') ||
        name.contains('matelassé') || name.contains('padded') ||
        name.contains('studded') || name.contains('clouté')) {
      return 'light';
    }

    return null;
  }
}
