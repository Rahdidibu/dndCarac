import 'dart:convert';
import 'dart:math';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../database/tables/tables.dart';
import '../utils/dnd_rules.dart';
import '../utils/starting_equipment_helper.dart';
import '../../features/character/providers/wizard_provider.dart';
import '../../l10n/app_localizations.dart';

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

    // 3 — Insert final ability scores
    await db.characterDao.upsertAbilityScores(
      CharacterAbilityScoresCompanion.insert(
        characterId: characterId,
        strength: Value(finalScores['str'] ?? 10),
        dexterity: Value(finalScores['dex'] ?? 10),
        constitution: Value(con),
        intelligence: Value(finalScores['int'] ?? 10),
        wisdom: Value(finalScores['wis'] ?? 10),
        charisma: Value(finalScores['cha'] ?? 10),
      ),
    );

    // 4 — Insert class rows (multiclass)
    for (final entry in wizard.classes) {
      await db.characterDao.insertCharacterClass(
        CharacterClassesCompanion.insert(
          characterId: characterId,
          classId: entry.classId,
          subclassId: Value(entry.subclassId),
          level: entry.level,
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
    Map<int, int> slots;

    if (wizard.classes.length == 1) {
      final classId = wizard.classes.first.classId;
      final level = wizard.classes.first.level;
      if (classId == 'warlock') {
        slots = DndRules.warlockPactSlots(level);
      } else {
        slots = DndRules.singleClassSpellSlots(classId, level);
      }
    } else {
      final pairs = wizard.classes
          .map((c) => (classId: c.classId, level: c.level))
          .toList();
      slots = DndRules.multiclassSpellSlots(pairs);
    }

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

      switch (entry.classId) {
        case 'barbarian':
          final rages = level >= 20
              ? 999 // Unlimited at 20
              : level >= 17
                  ? 6
                  : level >= 12
                      ? 5
                      : level >= 6
                          ? 4
                          : level >= 3
                              ? 3
                              : 2;
          resources.add(CharacterResourcesCompanion.insert(
            characterId: characterId,
            resourceName: 'resourceRage',
            current: rages,
            maximum: rages,
          ));
        case 'monk':
          resources.add(CharacterResourcesCompanion.insert(
            characterId: characterId,
            resourceName: 'resourceKi',
            current: level,
            maximum: level,
          ));
        case 'sorcerer':
          final points = level * 2;
          resources.add(CharacterResourcesCompanion.insert(
            characterId: characterId,
            resourceName: 'resourceSorceryPoints',
            current: points,
            maximum: points,
          ));
        case 'cleric':
        case 'paladin':
          resources.add(CharacterResourcesCompanion.insert(
            characterId: characterId,
            resourceName: 'resourceChannelDivinity',
            current: 1,
            maximum: 1,
          ));
        case 'druid':
          if (level >= 2) {
            resources.add(CharacterResourcesCompanion.insert(
              characterId: characterId,
              resourceName: 'resourceWildShape',
              current: 2,
              maximum: 2,
            ));
          }
        case 'fighter':
          final surges = level >= 17 ? 2 : 1;
          resources.add(CharacterResourcesCompanion.insert(
            characterId: characterId,
            resourceName: 'resourceActionSurge',
            current: surges,
            maximum: surges,
          ));
        default:
          break;
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

  /// Apply a level-up to an existing character.
  /// [classId] is the class gaining the level (may be new for multiclass).
  /// [hpGained] is the HP rolled/chosen.
  Future<void> levelUp({
    required int characterId,
    required String classId,
    required int hpGained,
    String? subclassId,
    bool addNewClass = false,
  }) async {
    final character = await db.characterDao.getCharacterById(characterId);
    if (character == null) return;

    final existingClasses =
        await db.characterDao.getCharacterClasses(characterId);

    // Update or add class level
    if (addNewClass) {
      await db.characterDao.insertCharacterClass(
        CharacterClassesCompanion.insert(
          characterId: characterId,
          classId: classId,
          subclassId: Value(subclassId),
          level: 1,
        ),
      );
    } else {
      final existing =
          existingClasses.firstWhere((c) => c.classId == classId);
      await db.characterDao.updateCharacterClass(
        CharacterClassesCompanion(
          id: Value(existing.id),
          characterId: Value(characterId),
          classId: Value(classId),
          subclassId: Value(subclassId ?? existing.subclassId),
          level: Value(existing.level + 1),
        ),
      );
    }

    // Update HP
    final newHpMax = character.hpMax + hpGained;
    final now = DateTime.now().toIso8601String();
    await db.characterDao.updateCharacter(
      CharactersCompanion(
        id: Value(characterId),
        hpMax: Value(newHpMax),
        hpCurrent: Value(character.hpCurrent + hpGained),
        updatedAt: Value(now),
      ),
    );

    // Recompute spell slots
    final updatedClasses =
        await db.characterDao.getCharacterClasses(characterId);
    final pairs = updatedClasses
        .map((c) => (classId: c.classId, level: c.level))
        .toList();
    final slots = DndRules.multiclassSpellSlots(pairs);
    if (slots.isNotEmpty) {
      // Preserve current slot usage: only increase max, don't reset current
      final existingSlots = await db.characterDao
          .watchSpellSlots(characterId)
          .first;
      final newCompanions = slots.entries.map((e) {
        final existing = existingSlots
            .where((s) => s.slotLevel == e.key)
            .firstOrNull;
        return CharacterSpellSlotsCompanion.insert(
          characterId: characterId,
          slotLevel: e.key,
          slotMax: e.value,
          slotCurrent: existing?.slotCurrent ?? e.value,
        );
      }).toList();
      await db.characterDao
          .replaceAllSpellSlots(characterId, newCompanions);
    }

    // Update Hit Dice resource
    final hitDie = getHitDieForClass(classId);
    final resources = await db.characterDao.watchResources(characterId).first;
    final existingHitDice = resources
        .where((r) => r.resourceName == 'hitDice_d$hitDie')
        .firstOrNull;
    if (existingHitDice != null) {
      await db.characterDao.upsertResource(
        CharacterResourcesCompanion(
          id: Value(existingHitDice.id),
          characterId: Value(characterId),
          resourceName: Value(existingHitDice.resourceName),
          current: Value(existingHitDice.current + 1),
          maximum: Value(existingHitDice.maximum + 1),
        ),
      );
    } else {
      await db.characterDao.upsertResource(
        CharacterResourcesCompanion.insert(
          characterId: characterId,
          resourceName: 'hitDice_d$hitDie',
          current: 1,
          maximum: 1,
        ),
      );
    }
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
    };
    return names[resourceKey] ?? resourceKey;
  }

  /// Recalculates the character's AC based on their current stats, classes, and equipped items.
  /// Then updates the armorClass field in the database.
  Future<int> recalculateCharacterAc(int characterId) async {
    // 1. Get ability scores
    final scores = await db.characterDao.getAbilityScores(characterId);
    final dexScore = scores?.dexterity ?? 10;
    final conScore = scores?.constitution ?? 10;
    final wisScore = scores?.wisdom ?? 10;

    // 2. Get character classes
    final classes = await db.characterDao.getCharacterClasses(characterId);

    // 3. Get equipment
    final equipment = await (db.select(db.characterEquipment)
          ..where((e) => e.characterId.equals(characterId)))
        .get();

    // 4. Parse equipped items
    ArmorInfo? equippedArmor;
    final equippedShields = <ArmorInfo>[];

    for (final item in equipment) {
      if (!item.equipped) continue;
      final armor = parseEquipmentAsArmor(item);
      if (armor == null) continue;
      if (armor.type == 'shield') {
        equippedShields.add(armor);
      } else {
        equippedArmor = armor;
      }
    }

    final dexMod = DndRules.modifier(dexScore);
    final conMod = DndRules.modifier(conScore);
    final wisMod = DndRules.modifier(wisScore);

    int baseAc = 10;
    int? maxDex;

    if (equippedArmor != null) {
      baseAc = equippedArmor.baseAc;
      maxDex = equippedArmor.maxDex;
    } else {
      // Unarmored Defense checking
      final isBarbarian = classes.any((c) => c.classId == 'barbarian');
      final isMonk = classes.any((c) => c.classId == 'monk');
      
      if (isBarbarian) {
        baseAc = 10 + conMod;
      } else if (isMonk) {
        if (equippedShields.isEmpty) {
          baseAc = 10 + wisMod;
        }
      }
    }

    int dexBonus = dexMod;
    if (maxDex != null) {
      if (dexBonus > maxDex) dexBonus = maxDex;
    }

    int totalAc = baseAc + dexBonus;
    for (final shield in equippedShields) {
      totalAc += shield.baseAc;
    }

    // 5. Update character AC in DB
    await (db.update(db.characters)..where((c) => c.id.equals(characterId)))
        .write(CharactersCompanion(
          armorClass: Value(totalAc),
          updatedAt: Value(DateTime.now().toIso8601String()),
        ));

    return totalAc;
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
      final String currentCurrencyJson = character.currency;
      try {
        final Map<String, dynamic> currMap = jsonDecode(currentCurrencyJson);
        currMap['gp'] = (currMap['gp'] ?? 0) + gold;
        await (db.update(db.characters)..where((t) => t.id.equals(characterId))).write(
          CharactersCompanion(
            currency: Value(jsonEncode(currMap)),
          ),
        );
      } catch (_) {}
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
      await db.characterDao.updateCharacter(
        CharactersCompanion(
          id: Value(characterId),
          hpCurrent: Value(character.hpMax),
          hpTemp: const Value(0),
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
      int newCurrent = r.maximum;
      if (r.resourceName.startsWith('hitDice_d')) {
        final regain = max(1, (r.maximum / 2).ceil());
        newCurrent = (r.current + regain).clamp(0, r.maximum);
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
