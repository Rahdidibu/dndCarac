import 'dart:async';

import 'package:dnd_character_manager/core/utils/app_errors.dart';
import 'package:dnd_character_manager/core/utils/proficiency_utils.dart';
import 'package:dnd_character_manager/l10n/app_localizations_fr.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef _Prof = ({String key, bool expertise});

List<_Prof> _dedupe(List<_Prof> items) => dedupeProficiencies<_Prof>(
      items,
      keyOf: (p) => p.key,
      hasExpertise: (p) => p.expertise,
    );

void main() {
  group('dedupeProficiencies', () {
    test('garde une seule entrée par clé', () {
      final result = _dedupe([
        (key: 'armor_all', expertise: false),
        (key: 'armor_shield', expertise: false),
        (key: 'armor_all', expertise: false),
        (key: 'armor_all', expertise: false),
        (key: 'armor_shield', expertise: false),
      ]);
      expect(result.map((p) => p.key), ['armor_all', 'armor_shield']);
    });

    test("l'expertise l'emporte quel que soit l'ordre", () {
      final first = _dedupe([
        (key: 'skill_stealth', expertise: true),
        (key: 'skill_stealth', expertise: false),
      ]);
      final last = _dedupe([
        (key: 'skill_stealth', expertise: false),
        (key: 'skill_stealth', expertise: true),
      ]);
      expect(first.single.expertise, isTrue);
      expect(last.single.expertise, isTrue);
    });

    test('liste vide', () {
      expect(_dedupe([]), isEmpty);
    });
  });

  group('AppErrors.userMessage', () {
    final l10n = AppLocalizationsFr();

    test('erreur de permission', () {
      expect(
        AppErrors.userMessage(
            const PostgrestException(message: 'denied', code: '42501'), l10n),
        l10n.errorPermission,
      );
    });

    test('erreur réseau', () {
      expect(AppErrors.userMessage(TimeoutException('x'), l10n), l10n.errorNetwork);
      expect(
        AppErrors.userMessage(
            Exception('ClientException: Failed host lookup'), l10n),
        l10n.errorNetwork,
      );
    });

    test('erreur générique sans fuite de détail technique', () {
      final message = AppErrors.userMessage(StateError('secret table x'), l10n);
      expect(message, l10n.errorGeneric);
      expect(message.contains('secret'), isFalse);
    });
  });
}
