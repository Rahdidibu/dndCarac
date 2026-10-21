import '../../l10n/app_localizations.dart';
import 'dnd_rules.dart';
import 'string_utils.dart';

enum Skill {
  athletics('athletics', 'str'),
  acrobatics('acrobatics', 'dex'),
  sleightOfHand('sleight_of_hand', 'dex'),
  stealth('stealth', 'dex'),
  arcana('arcana', 'int'),
  history('history', 'int'),
  investigation('investigation', 'int'),
  nature('nature', 'int'),
  religion('religion', 'int'),
  animalHandling('animal_handling', 'wis'),
  insight('insight', 'wis'),
  medicine('medicine', 'wis'),
  perception('perception', 'wis'),
  survival('survival', 'wis'),
  deception('deception', 'cha'),
  intimidation('intimidation', 'cha'),
  performance('performance', 'cha'),
  persuasion('persuasion', 'cha');

  const Skill(this.key, this.ability);

  final String key;
  final String ability;

  String name(AppLocalizations l10n) => switch (this) {
    athletics => l10n.skillAthletics,
    acrobatics => l10n.skillAcrobatics,
    sleightOfHand => l10n.skillSleightOfHand,
    stealth => l10n.skillStealth,
    arcana => l10n.skillArcana,
    history => l10n.skillHistory,
    investigation => l10n.skillInvestigation,
    nature => l10n.skillNature,
    religion => l10n.skillReligion,
    animalHandling => l10n.skillAnimalHandling,
    insight => l10n.skillInsight,
    medicine => l10n.skillMedicine,
    perception => l10n.skillPerception,
    survival => l10n.skillSurvival,
    deception => l10n.skillDeception,
    intimidation => l10n.skillIntimidation,
    performance => l10n.skillPerformance,
    persuasion => l10n.skillPersuasion,
  };
}

class SkillsCatalog {
  static List<Skill> sorted(AppLocalizations l10n) =>
      [...Skill.values]..sort((a, b) {
        final abilityOrder = DndRules.abilityKeys
            .indexOf(a.ability)
            .compareTo(DndRules.abilityKeys.indexOf(b.ability));
        return abilityOrder != 0
            ? abilityOrder
            : StringUtils.compareAlphabetically(a.name(l10n), b.name(l10n));
      });

  static String abilityName(String key, AppLocalizations l10n) => switch (key) {
    'str' => l10n.abilityStr,
    'dex' => l10n.abilityDex,
    'con' => l10n.abilityCon,
    'int' => l10n.abilityInt,
    'wis' => l10n.abilityWis,
    'cha' => l10n.abilityCha,
    _ => throw ArgumentError.value(key, 'key', 'Unknown ability'),
  };
}
