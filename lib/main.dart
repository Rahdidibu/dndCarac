import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/database/app_database.dart';
import 'core/providers/database_provider.dart';
import 'core/seed/srd_seeder.dart';
import 'core/seed/batman_seeder.dart';
import 'features/character/screens/character_list_screen.dart';
import 'features/character/screens/character_creation_wizard.dart';
import 'features/character/screens/character_sheet_screen.dart';
import 'features/character/screens/level_up_screen.dart';
import 'features/batman/screens/batman_creation_wizard.dart';
import 'features/batman/screens/batman_sheet_screen.dart';
import 'features/batman/screens/batman_level_up_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/spells/screens/spell_management_screen.dart';
import 'features/forge/forge_screen.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  await SrdSeeder(db).seedIfNeeded();
  await BatmanSeeder(db).seedIfNeeded();
  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
      ],
      child: const DndApp(),
    ),
  );
}

class DndApp extends ConsumerWidget {
  const DndApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp(
      title: "D&D Character Manager",
      debugShowCheckedModeBanner: false,
      locale: locale,
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B0000),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      routes: {
        '/character/create': (ctx) => const CharacterCreationWizard(),
        '/character/sheet': (ctx) {
          final id = ModalRoute.of(ctx)!.settings.arguments as int;
          return CharacterSheetScreen(characterId: id);
        },
        '/character/levelup': (ctx) {
          final id = ModalRoute.of(ctx)!.settings.arguments as int;
          return LevelUpScreen(characterId: id);
        },
        '/spells': (ctx) {
          final id = ModalRoute.of(ctx)!.settings.arguments as int;
          return SpellManagementScreen(characterId: id);
        },
        '/batman/create': (ctx) => const BatmanCreationWizard(),
        '/batman/sheet': (ctx) {
          final id = ModalRoute.of(ctx)!.settings.arguments as int;
          return BatmanSheetScreen(characterId: id);
        },
        '/batman/levelup': (ctx) {
          final id = ModalRoute.of(ctx)!.settings.arguments as int;
          return BatmanLevelUpScreen(characterId: id);
        },
      },
      home: const MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    CharacterListScreen(),
    ForgeScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.people_outline),
            selectedIcon: const Icon(Icons.people),
            label: l10n.navCharacters,
          ),
          const NavigationDestination(
            icon: Icon(Icons.gavel_outlined),
            selectedIcon: Icon(Icons.gavel),
            label: 'La Forge',
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
