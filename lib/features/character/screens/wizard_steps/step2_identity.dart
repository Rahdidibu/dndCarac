import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../providers/wizard_provider.dart';

class Step2Identity extends ConsumerStatefulWidget {
  const Step2Identity({super.key});

  @override
  ConsumerState<Step2Identity> createState() => _Step2IdentityState();
}

class _Step2IdentityState extends ConsumerState<Step2Identity> {
  late TextEditingController _nameController;
  late TextEditingController _playerNameController;

  @override
  void initState() {
    super.initState();
    final wizard = ref.read(wizardProvider);
    _nameController = TextEditingController(text: wizard.name);
    _playerNameController = TextEditingController(text: wizard.playerName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _playerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final alignment =
        ref.watch(wizardProvider.select((s) => s.alignment));
    final notifier = ref.read(wizardProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          l10n.wizardStepIdentity,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: l10n.fieldName,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.person),
          ),
          textCapitalization: TextCapitalization.words,
          onChanged: notifier.setName,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _playerNameController,
          decoration: InputDecoration(
            labelText: l10n.fieldPlayerName,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.account_circle_outlined),
          ),
          textCapitalization: TextCapitalization.words,
          onChanged: notifier.setPlayerName,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.fieldAlignment,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.2,
          children: [
            (key: 'alignmentLG', label: l10n.alignmentLG),
            (key: 'alignmentNG', label: l10n.alignmentNG),
            (key: 'alignmentCG', label: l10n.alignmentCG),
            (key: 'alignmentLN', label: l10n.alignmentLN),
            (key: 'alignmentTN', label: l10n.alignmentTN),
            (key: 'alignmentCN', label: l10n.alignmentCN),
            (key: 'alignmentLE', label: l10n.alignmentLE),
            (key: 'alignmentNE', label: l10n.alignmentNE),
            (key: 'alignmentCE', label: l10n.alignmentCE),
          ].map((a) {
            final isSelected = alignment == a.label;
            return ChoiceChip(
              label: Container(
                alignment: Alignment.center,
                child: Text(
                  a.label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              selected: isSelected,
              showCheckmark: false,
              onSelected: (selected) {
                notifier.setAlignment(selected ? a.label : '');
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Center(
          child: ChoiceChip(
            label: Text(
              l10n.alignmentU,
              style: TextStyle(
                fontWeight: alignment == l10n.alignmentU ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            selected: alignment == l10n.alignmentU,
            onSelected: (selected) {
              notifier.setAlignment(selected ? l10n.alignmentU : '');
            },
          ),
        ),
      ],
    );
  }
}
