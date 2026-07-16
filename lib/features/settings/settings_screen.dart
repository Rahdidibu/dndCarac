import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/database_provider.dart';
import '../../l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);
    final currentCode = currentLocale?.languageCode ?? 'fr';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navSettings),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Language ─────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settingsLanguage,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(
                        value: 'fr',
                        label: Text('Français'),
                        icon: Icon(Icons.language),
                      ),
                      ButtonSegment(
                        value: 'en',
                        label: Text('English'),
                        icon: Icon(Icons.language),
                      ),
                    ],
                    selected: {currentCode},
                    onSelectionChanged: (selection) {
                      ref
                          .read(localeProvider.notifier)
                          .setLocale(selection.first);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // ── About ─────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settingsAbout,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.settingsAboutText,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => showLicensePage(
                      context: context,
                      applicationName: 'D&D Character Manager',
                      applicationVersion: '1.0.0',
                    ),
                    icon: const Icon(Icons.description_outlined),
                    label: Text(l10n.settingsLicenses),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
