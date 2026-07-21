import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/database/app_database.dart';
import 'core/providers/database_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/seed/srd_seeder.dart';
import 'core/providers/forge_navigation_provider.dart';
import 'core/seed/batman_seeder.dart';
import 'features/auth/screens/auth_screen.dart';
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
import 'core/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty) {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

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
    final sessionAsync = ref.watch(authSessionProvider);

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
      theme: AppTheme.darkTheme,
      routes: {
        '/character/create': (ctx) => const CharacterCreationWizard(),
        '/character/sheet': (ctx) {
          final id = ModalRoute.of(ctx)?.settings.arguments;
          if (id is int) return CharacterSheetScreen(characterId: id);
          return const Scaffold(body: Center(child: Text('Navigation invalide. Veuillez retourner à l\'accueil.')));
        },
        '/character/levelup': (ctx) {
          final id = ModalRoute.of(ctx)?.settings.arguments;
          if (id is int) return LevelUpScreen(characterId: id);
          return const Scaffold(body: Center(child: Text('Navigation invalide. Veuillez retourner à l\'accueil.')));
        },
        '/spells': (ctx) {
          final id = ModalRoute.of(ctx)?.settings.arguments;
          if (id is int) return SpellManagementScreen(characterId: id);
          return const Scaffold(body: Center(child: Text('Navigation invalide. Veuillez retourner à l\'accueil.')));
        },
        '/batman/create': (ctx) => const BatmanCreationWizard(),
        '/batman/sheet': (ctx) {
          final id = ModalRoute.of(ctx)?.settings.arguments;
          if (id is int) return BatmanSheetScreen(characterId: id);
          return const Scaffold(body: Center(child: Text('Navigation invalide. Veuillez retourner à l\'accueil.')));
        },
        '/batman/levelup': (ctx) {
          final id = ModalRoute.of(ctx)?.settings.arguments;
          if (id is int) return BatmanLevelUpScreen(characterId: id);
          return const Scaffold(body: Center(child: Text('Navigation invalide. Veuillez retourner à l\'accueil.')));
        },
      },
      home: sessionAsync.when(
        loading: () {
          try {
            final currentSession = Supabase.instance.client.auth.currentSession;
            if (currentSession != null) return const MainScaffold();
          } catch (_) {}
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        },
        error: (err, _) => Scaffold(body: Center(child: Text('Erreur Auth: $err'))),
        data: (session) {
          if (session == null) {
            return const AuthScreen();
          }
          return const MainScaffold();
        },
      ),
    );
  }
}

class MainScaffold extends ConsumerWidget {
  const MainScaffold({super.key});

  static const List<Widget> _screens = [
    CharacterListScreen(),
    ForgeScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(mainTabNavigationProvider);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: _screens[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (i) => ref.read(mainTabNavigationProvider.notifier).state = i,
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
