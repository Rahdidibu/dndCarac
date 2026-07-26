import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_localizations.dart';

class HpModifierDialog extends StatefulWidget {
  final int hpCurrent;
  final int hpMax;
  final int hpTemp;
  final ValueChanged<int> onHPChanged;

  const HpModifierDialog({
    super.key,
    required this.hpCurrent,
    required this.hpMax,
    required this.hpTemp,
    required this.onHPChanged,
  });

  static Future<void> show(
    BuildContext context, {
    required int hpCurrent,
    required int hpMax,
    required int hpTemp,
    required ValueChanged<int> onHPChanged,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => HpModifierDialog(
        hpCurrent: hpCurrent,
        hpMax: hpMax,
        hpTemp: hpTemp,
        onHPChanged: onHPChanged,
      ),
    );
  }

  @override
  State<HpModifierDialog> createState() => _HpModifierDialogState();
}

class _HpModifierDialogState extends State<HpModifierDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _apply(int Function(int current, int input) operation) {
    if (!_formKey.currentState!.validate()) return;
    final inputVal = int.tryParse(_controller.text) ?? 0;
    final newVal = operation(widget.hpCurrent, inputVal);
    widget.onHPChanged(newVal);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.hpModifierTitle),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.hpModifierCurrent(widget.hpCurrent, widget.hpMax),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            if (widget.hpTemp > 0) ...[
              const SizedBox(height: 4),
              Text(
                l10n.hpModifierTemp(widget.hpTemp),
                textAlign: TextAlign.center,
                style: TextStyle(color: colorScheme.secondary, fontWeight: FontWeight.w500),
              ),
            ],
            const SizedBox(height: 20),
            TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: l10n.hpModifierLabel,
                border: const OutlineInputBorder(),
                hintText: '0',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.hpModifierError;
                }
                final parsed = int.tryParse(value);
                if (parsed == null || parsed < 0) {
                  return l10n.hpModifierError;
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.actionCancel),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Damage Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade900,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onPressed: () => _apply((current, input) => current - input),
              child: Text(l10n.hpModifierDamage),
            ),
            const SizedBox(width: 6),
            // Heal Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade900,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onPressed: () => _apply((current, input) => current + input),
              child: Text(l10n.hpModifierHeal),
            ),
            const SizedBox(width: 6),
            // Set Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onPressed: () => _apply((current, input) => input),
              child: Text(l10n.hpModifierSet),
            ),
          ],
        ),
      ],
    );
  }
}
