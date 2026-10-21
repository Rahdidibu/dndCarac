import 'dart:convert';

import 'dnd_rules.dart';

/// Règles pures (sans I/O) utilisées par l'édition d'un personnage existant.
class CharacterEditRules {
  CharacterEditRules._();

  static const int minScore = 1;
  static const int maxScore = 30;

  /// Écart de PV max appliqué rétroactivement quand la CON change :
  /// (nouveau modificateur − ancien modificateur) × niveau total.
  static int retroactiveHpDelta({
    required int oldCon,
    required int newCon,
    required int totalLevel,
  }) {
    return (DndRules.modifier(newCon) - DndRules.modifier(oldCon)) * totalLevel;
  }

  /// Nouveaux PV (max, courants) après un écart rétroactif : le maximum reste
  /// >= 1, les PV courants suivent une hausse et sont plafonnés lors d'une baisse.
  static ({int hpMax, int hpCurrent}) applyHpDelta({
    required int hpMax,
    required int hpCurrent,
    required int delta,
  }) {
    final newMax = (hpMax + delta) < 1 ? 1 : hpMax + delta;
    final newCurrent = delta > 0
        ? hpCurrent + delta
        : (hpCurrent > newMax ? newMax : hpCurrent);
    return (hpMax: newMax, hpCurrent: newCurrent);
  }

  /// Décode `[{ability, bonus}]` (races/sous-races 2014).
  static Map<String, int> parseAbilityBonuses(String? rawJson) {
    final result = <String, int>{};
    if (rawJson == null || rawJson.isEmpty) return result;
    final decoded = json.decode(rawJson);
    if (decoded is! List) return result;
    for (final item in decoded) {
      if (item is! Map) continue;
      final ability = item['ability'];
      final bonus = item['bonus'];
      if (ability is String && bonus is int) {
        result[ability] = (result[ability] ?? 0) + bonus;
      }
    }
    return result;
  }

  static Map<String, int> sumBonuses(Iterable<Map<String, int>> bonuses) {
    final result = <String, int>{};
    for (final map in bonuses) {
      map.forEach((k, v) => result[k] = (result[k] ?? 0) + v);
    }
    return result;
  }

  /// Valeur de base = valeur finale stockée − bonus d'origine.
  static int baseFromFinal(int finalScore, int originBonus) =>
      finalScore - originBonus;

  /// Valeur finale stockée = base + bonus d'origine.
  static int finalFromBase(int base, int originBonus) => base + originBonus;

  static bool isValidBase(int base, int originBonus) {
    final total = finalFromBase(base, originBonus);
    return total >= minScore && total <= maxScore;
  }

  /// Caractéristiques éligibles d'un historique 2024 (`["str","dex",...]`).
  static List<String> parseEligibleAsi(String? asiJson) {
    if (asiJson == null || asiJson.isEmpty) return const [];
    try {
      final decoded = json.decode(asiJson);
      return decoded is List ? decoded.whereType<String>().toList() : const [];
    } catch (_) {
      return const [];
    }
  }

  /// Différence entre deux ensembles de clés : ce qui disparaît / apparaît.
  static ({List<String> removed, List<String> added}) diffKeys(
    Iterable<String> before,
    Iterable<String> after,
  ) {
    final b = before.toSet();
    final a = after.toSet();
    return (
      removed: b.difference(a).toList()..sort(),
      added: a.difference(b).toList()..sort(),
    );
  }
}
