import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dnd_character_manager/features/character/screens/character_creation_wizard.dart';
import 'package:dnd_character_manager/core/providers/database_provider.dart';
import 'package:dnd_character_manager/core/database/app_database.dart';
import 'package:dnd_character_manager/l10n/app_localizations.dart';

void main() {
  testWidgets('Diagnose wizard render tree and layout size', (WidgetTester tester) async {
    final db = AppDatabase();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale("fr"),
            Locale("en"),
          ],
          locale: const Locale("fr"),
          home: const CharacterCreationWizard(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Print widget tree hierarchy for body PageView
    final pageViewFinder = find.byType(PageView);
    if (pageViewFinder.evaluate().isNotEmpty) {
      final RenderBox renderBox = tester.renderObject(pageViewFinder);
      print('PageView Size: ${renderBox.size}');
      print('PageView Constraints: ${renderBox.constraints}');
    } else {
      print('PageView NOT found!');
    }

    // Print the overall render tree text dump
    debugDumpRenderTree();
  });
}
