import 'package:flutter/material.dart';

import '../../../../core/utils/character_service.dart';
import '../../../../core/utils/level_up_plan.dart';
import '../../../../core/utils/musical_instruments.dart';
import '../../../../core/utils/skills_catalog.dart';
import '../../../../l10n/app_localizations.dart';

/// Où retrouver un changement sur la fiche.
enum LevelUpDestination { none, stats, combat, magic, profile, spells }

class LevelUpChange {
  final IconData icon;
  final String text;
  final LevelUpDestination destination;

  /// Ligne de détail rattachée à la précédente (affichée en retrait).
  final bool detail;

  const LevelUpChange(
    this.icon,
    this.text, {
    this.destination = LevelUpDestination.none,
    this.detail = false,
  });
}

/// Libellé d'une clé de maîtrise ajoutée par la montée de niveau.
String levelUpProficiencyLabel(String key, AppLocalizations l10n) {
  if (key.startsWith('skill_')) {
    final skill = key.substring(6);
    for (final s in Skill.values) {
      if (s.key == skill) return s.name(l10n);
    }
    return skill;
  }
  if (key.startsWith('tool_')) {
    final tool = key.substring(5);
    for (final i in musicalInstruments) {
      if (i.key == tool) return i.name;
    }
  }
  return switch (key) {
    'armor_light' => l10n.proficiencyKeyArmorLight,
    'armor_medium' => l10n.proficiencyKeyArmorMedium,
    'armor_shield' => l10n.proficiencyKeyArmorShield,
    'weapon_simple' => l10n.proficiencyKeyWeaponSimple,
    'weapon_martial' => l10n.proficiencyKeyWeaponMartial,
    'weapon_shortsword' => l10n.proficiencyKeyWeaponShortsword,
    'tool_thieves-tools' => l10n.proficiencyKeyToolThieves,
    _ => key,
  };
}

String _slotsText(Map<int, int> slots, AppLocalizations l10n) {
  final levels = slots.keys.toList()..sort();
  return levels
      .map((level) => l10n.levelUpSlotEntry(level, slots[level]!))
      .join(', ');
}

/// Liste des changements d'une montée de niveau, à partir du même
/// [LevelUpOutcome] que celui écrit en base : l'aperçu avant validation et le
/// résumé final restent identiques. [armorClassBefore]/[armorClassAfter] ne
/// sont connus qu'après l'application.
List<LevelUpChange> buildLevelUpChanges({
  required LevelUpOutcome outcome,
  required AppLocalizations l10n,
  required String className,
  String? subclassName,
  String? featName,
  List<String> featureNames = const [],
  int? armorClassBefore,
  int? armorClassAfter,
}) {
  final plan = outcome.plan;
  final changes = <LevelUpChange>[
    LevelUpChange(
      Icons.arrow_upward,
      plan.isNewClass
          ? l10n.levelUpChangeNewClass(className)
          : l10n.levelUpChangeClass(className, plan.newClassLevel),
    ),
  ];

  if (outcome.proficiencyBonusBefore != outcome.proficiencyBonusAfter) {
    changes.add(
      LevelUpChange(
        Icons.star_outline,
        l10n.levelUpChangeProficiencyBonus(
          outcome.proficiencyBonusBefore,
          outcome.proficiencyBonusAfter,
        ),
        destination: LevelUpDestination.stats,
      ),
    );
  }

  changes.add(
    LevelUpChange(
      Icons.favorite_outline,
      l10n.levelUpChangeHp(
        plan.state.hpMax,
        outcome.hpMaxAfter,
        outcome.hpMaxDelta,
      ),
      destination: LevelUpDestination.stats,
    ),
  );
  if (outcome.retroactiveHp != 0) {
    changes.add(
      LevelUpChange(
        Icons.subdirectory_arrow_right,
        l10n.levelUpChangeHpRetro(outcome.retroactiveHp),
        destination: LevelUpDestination.stats,
        detail: true,
      ),
    );
  }

  if (armorClassBefore != null &&
      armorClassAfter != null &&
      armorClassBefore != armorClassAfter) {
    changes.add(
      LevelUpChange(
        Icons.shield_outlined,
        l10n.levelUpChangeAc(armorClassBefore, armorClassAfter),
        destination: LevelUpDestination.stats,
      ),
    );
  }

  changes.add(
    LevelUpChange(
      Icons.casino_outlined,
      l10n.levelUpChangeHitDie(plan.hitDie),
      destination: LevelUpDestination.combat,
    ),
  );

  if (outcome.subclassId != null && subclassName != null) {
    changes.add(
      LevelUpChange(
        Icons.account_tree_outlined,
        l10n.levelUpChangeSubclass(subclassName),
        destination: LevelUpDestination.profile,
      ),
    );
  }

  outcome.abilityChanges.forEach((key, change) {
    changes.add(
      LevelUpChange(
        Icons.trending_up,
        l10n.levelUpChangeAbility(
          SkillsCatalog.abilityName(key, l10n),
          change.before,
          change.after,
        ),
        destination: LevelUpDestination.stats,
      ),
    );
  });

  if (outcome.featId != null && featName != null) {
    changes.add(
      LevelUpChange(
        Icons.military_tech_outlined,
        l10n.levelUpChangeFeat(featName),
        destination: LevelUpDestination.profile,
      ),
    );
  }

  if (outcome.proficiencyKeysAdded.isNotEmpty) {
    changes.add(
      LevelUpChange(
        Icons.school_outlined,
        l10n.levelUpChangeProficiencies(
          outcome.proficiencyKeysAdded
              .map((k) => levelUpProficiencyLabel(k, l10n))
              .join(', '),
        ),
        destination: LevelUpDestination.profile,
      ),
    );
  }

  for (final name in featureNames) {
    changes.add(
      LevelUpChange(
        Icons.auto_awesome_outlined,
        l10n.levelUpChangeFeature(name),
        destination: LevelUpDestination.profile,
      ),
    );
  }

  outcome.resourceTargets.forEach((key, maximum) {
    final before = outcome.resourceTargetsBefore[key];
    if (before == maximum) return;
    final name = CharacterService.resourceDisplayName(key, l10n);
    changes.add(
      LevelUpChange(
        Icons.bolt,
        before == null
            ? l10n.levelUpChangeResourceNew(name, maximum)
            : l10n.levelUpChangeResource(name, before, maximum),
        destination: LevelUpDestination.combat,
      ),
    );
  });

  if (outcome.spellSlotsChanged) {
    changes.add(
      LevelUpChange(
        Icons.menu_book_outlined,
        l10n.levelUpChangeSlots(_slotsText(outcome.spellSlotsAfter, l10n)),
        destination: LevelUpDestination.magic,
      ),
    );
  }
  if (outcome.spells.cantrips > 0) {
    changes.add(
      LevelUpChange(
        Icons.local_fire_department_outlined,
        l10n.levelUpSpellsCantrips(outcome.spells.cantrips),
        destination: LevelUpDestination.spells,
      ),
    );
  }
  if (outcome.spells.spells > 0) {
    changes.add(
      LevelUpChange(
        Icons.menu_book_outlined,
        l10n.levelUpSpellsToLearn(outcome.spells.spells),
        destination: LevelUpDestination.spells,
      ),
    );
  }
  if (outcome.spells.spellbook > 0) {
    changes.add(
      LevelUpChange(
        Icons.import_contacts_outlined,
        l10n.levelUpSpellsSpellbook(outcome.spells.spellbook),
        destination: LevelUpDestination.spells,
      ),
    );
  }
  return changes;
}

/// Liste affichable des changements ; [onOpen] reçoit la destination du
/// changement touché.
class LevelUpChangesList extends StatelessWidget {
  final List<LevelUpChange> changes;
  final ValueChanged<LevelUpDestination>? onOpen;

  const LevelUpChangesList({super.key, required this.changes, this.onOpen});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        for (final change in changes)
          Padding(
            padding: EdgeInsets.only(left: change.detail ? 32 : 0),
            child: ListTile(
              dense: true,
              leading: Icon(change.icon, color: colorScheme.primary),
              title: Text(change.text),
              trailing:
                  onOpen != null &&
                      change.destination != LevelUpDestination.none
                  ? const Icon(Icons.chevron_right)
                  : null,
              onTap:
                  onOpen != null &&
                      change.destination != LevelUpDestination.none
                  ? () => onOpen!(change.destination)
                  : null,
            ),
          ),
      ],
    );
  }
}
