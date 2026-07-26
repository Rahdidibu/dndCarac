import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/batman_providers.dart';

class Step2Identity extends ConsumerStatefulWidget {
  const Step2Identity({super.key});

  @override
  ConsumerState<Step2Identity> createState() => _Step2IdentityState();
}

class _Step2IdentityState extends ConsumerState<Step2Identity> {
  late TextEditingController _nameCtrl;
  late TextEditingController _playerCtrl;
  late TextEditingController _secretCtrl;

  @override
  void initState() {
    super.initState();
    final wizard = ref.read(batmanWizardProvider);
    _nameCtrl = TextEditingController(text: wizard.name);
    _playerCtrl = TextEditingController(text: wizard.playerName);
    _secretCtrl = TextEditingController(text: wizard.secretIdentity);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _playerCtrl.dispose();
    _secretCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(batmanWizardProvider.notifier);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Identité',
          style: TextStyle(
              color: Colors.amber, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        _field('Nom / Surnom du héros', _nameCtrl,
            onChanged: notifier.setName),
        const SizedBox(height: 16),
        _field('Nom du joueur', _playerCtrl,
            onChanged: notifier.setPlayerName),
        const SizedBox(height: 16),
        _field('Identité secrète (optionnel)', _secretCtrl,
            onChanged: notifier.setSecretIdentity),
        const SizedBox(height: 24),
        const Text(
          'Éthique',
          style: TextStyle(
              color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Distribuez 3 points entre les quatre axes éthiques (0-3 chacun). Ces valeurs influencent l\'accès à certaines voies.',
          style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        ),
        const SizedBox(height: 12),
        Consumer(builder: (context, ref, _) {
          final wizard = ref.watch(batmanWizardProvider);
          final notif = ref.read(batmanWizardProvider.notifier);
          return Column(
            children: [
              _ethicRow('Ordre', wizard.ethicsOrder,
                  (v) => notif.setEthics(order: v)),
              _ethicRow('Justice', wizard.ethicsJustice,
                  (v) => notif.setEthics(justice: v)),
              _ethicRow('Anarchie', wizard.ethicsAnarchy,
                  (v) => notif.setEthics(anarchy: v)),
              _ethicRow('Crime', wizard.ethicsCrime,
                  (v) => notif.setEthics(crime: v)),
            ],
          );
        }),
      ],
    );
  }

  Widget _field(String label, TextEditingController ctrl,
      {required void Function(String) onChanged}) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber.shade300),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade700)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber)),
      ),
      onChanged: onChanged,
    );
  }

  Widget _ethicRow(String name, int value, void Function(int) onChange) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(name,
                style: const TextStyle(color: Colors.white)),
          ),
          ...List.generate(
              4,
              (i) => GestureDetector(
                    onTap: () => onChange(i),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i <= value
                            ? Colors.amber
                            : Colors.grey.shade800,
                        border: Border.all(color: Colors.amber.shade700),
                      ),
                      child: Center(
                        child: Text('$i',
                            style: TextStyle(
                                color: i <= value
                                    ? Colors.black
                                    : Colors.grey.shade400,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ),
                    ),
                  )),
        ],
      ),
    );
  }
}
