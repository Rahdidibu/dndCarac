import '../database/app_database.dart';
import '../database/tables/tables.dart';

/// Classe d'un personnage telle qu'utilisée pour filtrer les capacités.
class ClassProgress {
  final String classId;
  final String? subclassId;
  final int level;

  const ClassProgress({
    required this.classId,
    required this.level,
    this.subclassId,
  });
}

/// Règles de filtrage des capacités SRD affichées sur la fiche.
class FeatureRules {
  FeatureRules._();

  // 2014 : options d'un choix (style de combat, invocation…) listées comme
  // capacités. Le choix du joueur n'est pas enregistré : on ne les importe pas
  // (filtre sur le nom source anglais) et on garde la capacité parente.
  static final _optionPrefix = RegExp(
    r"^(Fighting Style|Eldritch Invocation|Metamagic|Hunter's Prey|"
    r"Defensive Tactics|Superior Hunter's Defense|Multiattack|"
    r'Dragon Ancestor|Circle of the Land): ',
  );
  static final _pactOption = RegExp(r'^Pact of the (Chain|Blade|Tome)$');
  static final _genericSubclassStub = RegExp(r' feature$');
  static final _variantSuffix = RegExp(r'\s*\([^)]*\)$');

  /// Vrai si une capacité 2014 (nom source anglais) est une option de choix
  /// ou un texte générique de sous-classe, à ne pas importer.
  static bool isHidden2014Source(String englishName, String? subclassId) =>
      _optionPrefix.hasMatch(englishName) ||
      _pactOption.hasMatch(englishName) ||
      (subclassId == null && _genericSubclassStub.hasMatch(englishName));

  /// Capacités de classe et de sous-classe pour [classes], limitées au niveau
  /// de chaque classe, triées par classe puis niveau puis nom.
  static List<SrdFeature> forClasses({
    required Iterable<SrdFeature> all,
    required RulesetVersion ruleset,
    required List<ClassProgress> classes,
  }) {
    final result = <SrdFeature>[];
    for (final c in classes) {
      var selected = all.where(
        (f) =>
            f.ruleset == ruleset &&
            f.classId == c.classId &&
            f.level <= c.level &&
            (f.subclassId == null || f.subclassId == c.subclassId),
      );

      // 2024 : l'entrée générique « Subclass » est redondante une fois la
      // sous-classe choisie.
      if (ruleset == RulesetVersion.dnd2024 && c.subclassId != null) {
        selected = selected.where((f) => !f.srdIndex.endsWith('-subclass'));
      }

      result.addAll(_keepHighestVariant(selected.toList()));
    }
    return result;
  }

  // « Action Surge (1 use) » puis « Action Surge (2 uses) » : seule la version
  // la plus récente est pertinente.
  static List<SrdFeature> _keepHighestVariant(List<SrdFeature> features) {
    final best = <String, SrdFeature>{};
    final passthrough = <SrdFeature>[];
    for (final f in features) {
      if (!_variantSuffix.hasMatch(f.name) &&
          !_hasVariantSibling(f, features)) {
        passthrough.add(f);
        continue;
      }
      final key =
          '${f.classId}|${f.subclassId}|${f.name.replaceFirst(_variantSuffix, '')}';
      final current = best[key];
      if (current == null || f.level > current.level) best[key] = f;
    }
    return [...passthrough, ...best.values];
  }

  static bool _hasVariantSibling(SrdFeature f, List<SrdFeature> all) => all.any(
    (o) =>
        o.id != f.id &&
        o.classId == f.classId &&
        o.subclassId == f.subclassId &&
        _variantSuffix.hasMatch(o.name) &&
        o.name.replaceFirst(_variantSuffix, '') == f.name,
  );

  static int compare(SrdFeature a, SrdFeature b) {
    final l = a.level.compareTo(b.level);
    return l != 0 ? l : a.name.compareTo(b.name);
  }

  /// Clé de `character_resources` suivie par une capacité (compteur
  /// d'utilisations), ou null si la capacité n'a pas de compteur.
  static String? resourceKeyFor(String srdIndex) {
    if (srdIndex == 'rage' || srdIndex == 'barbarian-rage')
      return 'resourceRage';
    if (srdIndex == 'ki' || srdIndex == 'monk-monks-focus') return 'resourceKi';
    if (srdIndex == 'font-of-magic' || srdIndex == 'sorcerer-font-of-magic') {
      return 'resourceSorceryPoints';
    }
    if (srdIndex == 'cleric-channel-divinity' ||
        srdIndex == 'paladin-channel-divinity' ||
        srdIndex == 'channel-divinity' ||
        RegExp(r'^channel-divinity-\d-rest$').hasMatch(srdIndex)) {
      return 'resourceChannelDivinity';
    }
    if (srdIndex == 'druid-wild-shape' || srdIndex.startsWith('wild-shape')) {
      return 'resourceWildShape';
    }
    if (srdIndex == 'fighter-action-surge' ||
        srdIndex.startsWith('action-surge')) {
      return 'resourceActionSurge';
    }
    if (srdIndex == 'fighter-second-wind' || srdIndex == 'second-wind') {
      return 'resourceSecondWind';
    }
    return null;
  }
}
