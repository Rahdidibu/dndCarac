import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/character/screens/character_list_screen.dart';
import '../../features/forge/forge_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../l10n/app_localizations.dart';
import '../providers/forge_navigation_provider.dart';

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
        onDestinationSelected: (i) =>
            ref.read(mainTabNavigationProvider.notifier).state = i,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.people_outline),
            selectedIcon: const Icon(Icons.people),
            label: l10n.navCharacters,
          ),
          NavigationDestination(
            icon: const Icon(Icons.gavel_outlined),
            selectedIcon: const Icon(Icons.gavel),
            label: l10n.navForge,
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
