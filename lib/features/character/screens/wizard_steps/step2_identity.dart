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
    final alignment = ref.watch(wizardProvider.select((s) => s.alignment));
    final notifier = ref.read(wizardProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          l10n.wizardStepIdentity,
          style: const TextStyle(fontFamily: 'Cinzel', fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Donnez un nom et définissez l\'alignement moral de votre héros.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontFamily: 'Lora'),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _nameController,
          style: const TextStyle(fontFamily: 'Lora'),
          decoration: InputDecoration(
            labelText: l10n.fieldName,
            labelStyle: const TextStyle(fontFamily: 'Cinzel', fontSize: 13),
            border: const OutlineInputBorder(),
            prefixIcon: Icon(Icons.person, color: colorScheme.primary.withValues(alpha: 0.7)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
          ),
          textCapitalization: TextCapitalization.words,
          onChanged: notifier.setName,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _playerNameController,
          style: const TextStyle(fontFamily: 'Lora'),
          decoration: InputDecoration(
            labelText: l10n.fieldPlayerName,
            labelStyle: const TextStyle(fontFamily: 'Cinzel', fontSize: 13),
            border: const OutlineInputBorder(),
            prefixIcon: Icon(Icons.account_circle_outlined, color: colorScheme.primary.withValues(alpha: 0.7)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
          ),
          textCapitalization: TextCapitalization.words,
          onChanged: notifier.setPlayerName,
        ),
        const SizedBox(height: 24),
        Text(
          l10n.fieldAlignment,
          style: const TextStyle(fontFamily: 'Cinzel', fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
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
            return _AlignmentCard(
              label: a.label,
              selected: isSelected,
              onTap: () => notifier.setAlignment(isSelected ? '' : a.label),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Center(
          child: SizedBox(
            width: 180,
            child: _AlignmentCard(
              label: l10n.alignmentU,
              selected: alignment == l10n.alignmentU,
              onTap: () => notifier.setAlignment(alignment == l10n.alignmentU ? '' : l10n.alignmentU),
            ),
          ),
        ),
      ],
    );
  }
}

class _AlignmentCard extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AlignmentCard({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_AlignmentCard> createState() => _AlignmentCardState();
}

class _AlignmentCardState extends State<_AlignmentCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            if (widget.selected || _isHovered)
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.1),
                blurRadius: 6,
                spreadRadius: 0.5,
              ),
          ],
        ),
        child: Card(
          margin: EdgeInsets.zero,
          color: widget.selected
              ? primaryColor.withValues(alpha: 0.2)
              : _isHovered
                  ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
                  : colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: widget.selected
                  ? primaryColor
                  : _isHovered
                      ? primaryColor.withValues(alpha: 0.5)
                      : colorScheme.outline.withValues(alpha: 0.15),
              width: widget.selected ? 1.5 : 1,
            ),
          ),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'Lora',
                  fontSize: 11,
                  fontWeight: widget.selected ? FontWeight.bold : FontWeight.normal,
                  color: widget.selected ? primaryColor : colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
