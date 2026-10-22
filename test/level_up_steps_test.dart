import 'package:dnd_character_manager/core/database/app_database.dart';
import 'package:dnd_character_manager/core/database/tables/tables.dart';
import 'package:dnd_character_manager/core/utils/feature_rules.dart';
import 'package:dnd_character_manager/core/utils/level_up_plan.dart';
import 'package:dnd_character_manager/features/character/providers/character_providers.dart';
import 'package:dnd_character_manager/features/character/providers/level_up_provider.dart';
import 'package:dnd_character_manager/features/character/widgets/level_up/level_up_improvement_step.dart';
import 'package:dnd_character_manager/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _ruleset = RulesetVersion.dnd2024;

LevelUpPlan _fighterPlan(Map<String, int> scores) => LevelUpPlan.build(
  state: LevelUpState(
    ruleset: _ruleset,
    classes: const [
      ClassProgress(classId: 'fighter', level: 3, subclassId: 'champion'),
    ],
    scores: scores,
    hpMax: 30,
    hpCurrent: 30,
  ),
  classId: 'fighter',
);

Future<ProviderContainer> _pump(WidgetTester tester, LevelUpPlan plan) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        srdFeatsProvider(_ruleset).overrideWith(
          (ref) async => const [
            SrdFeat(
              id: 'grappler',
              ruleset: _ruleset,
              name: 'Empoigneur',
              description: '**Prérequis** : niveau 4',
              type: 'general',
              repeatable: false,
            ),
          ],
        ),
      ],
      child: MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: LevelUpImprovementStep(characterId: 1, plan: plan),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return ProviderScope.containerOf(
    tester.element(find.byType(LevelUpImprovementStep)),
  );
}

void main() {
  testWidgets('Guerrier 3→4 : +2 maximum, plafonné à 20', (tester) async {
    final container = await _pump(
      tester,
      _fighterPlan(const {
        'str': 19,
        'dex': 14,
        'con': 14,
        'int': 10,
        'wis': 10,
        'cha': 10,
      }),
    );
    IconButton plus(int row) => tester.widgetList<IconButton>(
      find.widgetWithIcon(IconButton, Icons.add_circle_outline),
    ).elementAt(row);

    // Force 19 : un seul +1 possible.
    await tester.tap(find.byIcon(Icons.add_circle_outline).first);
    await tester.pump();
    expect(container.read(levelUpFlowProvider(1)).choices.abilityIncreases, {
      'str': 1,
    });
    expect(plus(0).onPressed, isNull);

    // Deuxième point sur une autre caractéristique, puis plus aucun.
    await tester.tap(find.byIcon(Icons.add_circle_outline).at(1));
    await tester.pump();
    expect(container.read(levelUpFlowProvider(1)).choices.abilityIncreases, {
      'str': 1,
      'dex': 1,
    });
    for (var row = 0; row < 6; row++) {
      expect(plus(row).onPressed, isNull, reason: 'ligne $row');
    }
  });

  testWidgets('choisir un don annule les points de caractéristiques', (
    tester,
  ) async {
    final container = await _pump(
      tester,
      _fighterPlan(const {
        'str': 15,
        'dex': 14,
        'con': 14,
        'int': 10,
        'wis': 10,
        'cha': 10,
      }),
    );
    await tester.tap(find.byIcon(Icons.add_circle_outline).first);
    await tester.pump();
    expect(
      container.read(levelUpFlowProvider(1)).choices.abilityIncreases,
      isNotEmpty,
    );

    await tester.tap(find.text('Don'));
    await tester.pumpAndSettle();
    expect(
      container.read(levelUpFlowProvider(1)).choices.abilityIncreases,
      isEmpty,
    );
    expect(find.text('Empoigneur'), findsOneWidget);

    await tester.tap(find.text('Empoigneur'));
    await tester.pump();
    final choices = container.read(levelUpFlowProvider(1)).choices;
    expect(choices.featId, 'grappler');
    expect(_fighterPlan(const {}).outcome(choices).featId, 'grappler');
  });
}
