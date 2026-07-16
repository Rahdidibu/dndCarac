import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/dnd_rules.dart';
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

    final alignmentLabels = {
      'alignmentLG': l10n.alignmentLG,
      'alignmentNG': l10n.alignmentNG,
      'alignmentCG': l10n.alignmentCG,
      'alignmentLN': l10n.alignmentLN,
      'alignmentTN': l10n.alignmentTN,
      'alignmentCN': l10n.alignmentCN,
      'alignmentLE': l10n.alignmentLE,
      'alignmentNE': l10n.alignmentNE,
      'alignmentCE': l10n.alignmentCE,
      'alignmentU': l10n.alignmentU,
    };

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
        DropdownButtonFormField<String>(
          key: ValueKey(alignment.isEmpty ? null : alignment),
          decoration: InputDecoration(
            labelText: l10n.fieldAlignment,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.balance),
          ),
          value: alignment.isEmpty ? null : alignment,
          items: DndRules.alignments(alignmentLabels)
              .map((a) => DropdownMenuItem(value: a, child: Text(a)))
              .toList(),
          onChanged: (v) => notifier.setAlignment(v ?? ''),
        ),
      ],
    );
  }
}
