import 'package:dnd_character_manager/core/utils/skills_catalog.dart';
import 'package:dnd_character_manager/features/character/providers/character_providers.dart';
import 'package:dnd_character_manager/features/character/providers/wizard_provider.dart';
import 'package:dnd_character_manager/features/character/screens/wizard_steps/step2_identity.dart';
import 'package:dnd_character_manager/features/character/screens/wizard_steps/step5_abilities.dart';
import 'package:dnd_character_manager/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final locale in ['fr', 'en']) {
    test('Skills ordered by ability and localized name ($locale)', () async {
      final l10n = await AppLocalizations.delegate.load(Locale(locale));
      final skills = SkillsCatalog.sorted(l10n);
      expect(skills.length, 18);
      expect(skills.map((s) => s.key).toSet().length, 18);
      expect(skills.first, Skill.athletics);
      expect(
        skills.where((s) => s.ability == 'dex'),
        locale == 'fr'
            ? [Skill.acrobatics, Skill.stealth, Skill.sleightOfHand]
            : [Skill.acrobatics, Skill.sleightOfHand, Skill.stealth],
      );
    });

    for (final width in [360.0, 1440.0]) {
      testWidgets('Point buy with bonuses and alignment at $width ($locale)', (
        tester,
      ) async {
        tester.view.physicalSize = Size(width, 1000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final container = ProviderContainer(
          overrides: [
            wizardAbilityModifiersProvider.overrideWith(
              (ref) async => {
                'str': 2,
                'dex': 1,
                'con': 0,
                'int': 0,
                'wis': 0,
                'cha': 0,
              },
            ),
          ],
        );
        addTearDown(container.dispose);
        Widget app(Widget child) => UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            locale: Locale(locale),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: child),
          ),
        );
        await tester.pumpWidget(app(const Step5Abilities()));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final increment = find
            .widgetWithIcon(IconButton, Icons.add_circle_outline)
            .first;
        expect(
          tester.getSize(increment).shortestSide,
          greaterThanOrEqualTo(44),
        );
        await tester.tap(increment);
        await tester.pumpAndSettle();
        expect(container.read(wizardProvider).abilityScores['str'], 9);
        expect(tester.takeException(), isNull);

        await tester.pumpWidget(app(const Step2Identity()));
        await tester.pumpAndSettle();
        final l10n = await AppLocalizations.delegate.load(Locale(locale));
        await tester.tap(find.text(l10n.alignmentCG));
        await tester.pumpAndSettle();
        expect(container.read(wizardProvider).alignment, l10n.alignmentCG);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
