import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables/tables.dart';
import '../../../core/providers/database_provider.dart';
import '../providers/batman_providers.dart';

class BatmanCreationWizard extends ConsumerStatefulWidget {
  const BatmanCreationWizard({super.key});

  @override
  ConsumerState<BatmanCreationWizard> createState() =>
      _BatmanCreationWizardState();
}

class _BatmanCreationWizardState extends ConsumerState<BatmanCreationWizard> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _saving = false;

  static const int _totalSteps = 5;
  static const _stepTitles = [
    'Mode & Profil',
    'Identité',
    'Caractéristiques',
    'Voies',
    'Récapitulatif',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goTo(int step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool _canGoNextWithRef(WidgetRef ref) {
    final wizard = ref.watch(batmanWizardProvider);
    switch (_currentStep) {
      case 0:
        return wizard.isStep2Valid; // profil sélectionné
      case 1:
        return wizard.isStep1Valid; // nom non vide
      default:
        return true;
    }
  }

  Future<void> _finish() async {
    final wizard = ref.read(batmanWizardProvider);
    if (!wizard.isStep1Valid || !wizard.isStep2Valid) return;

    setState(() => _saving = true);
    try {
      final db = ref.read(databaseProvider);
      await _createBatmanCharacter(db, wizard);
      ref.read(batmanWizardProvider.notifier).reset();
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _createBatmanCharacter(
      AppDatabase db, BatmanWizardState wizard) async {
    final now = DateTime.now().toIso8601String();
    final profile = await db.batmanDao.getProfileById(wizard.profileId!);
    final conScore = wizard.abilityScores['con'] ?? 8;
    final hp = profile != null
        ? computeBatmanHP(profile.hitDie, conScore)
        : 10;
    final dexScore = wizard.abilityScores['dex'] ?? 8;
    final perScore = wizard.abilityScores['per'] ?? 8;

    // Insert base character
    final characterId = await db.characterDao.insertCharacter(
      CharactersCompanion.insert(
        name: wizard.name.trim(),
        playerName: Value(wizard.playerName.trim()),
        ruleset: RulesetVersion.batman,
        hpMax: Value(hp),
        hpCurrent: Value(hp),
        createdAt: now,
        updatedAt: now,
      ),
    );

    // Insert Batman-specific data
    final atcBonus = profile?.atcBonus ?? 0;
    final atdBonus = profile?.atdBonus ?? 0;
    final forMod = abilityModifier(wizard.abilityScores['for'] ?? 8);
    await db.batmanDao.upsertBatmanCharacter(
      BatmanCharactersCompanion.insert(
        characterId: characterId,
        profileId: wizard.profileId!,
        secretIdentity: Value(wizard.secretIdentity),
        mode: Value(wizard.mode),
        force: Value(wizard.abilityScores['for'] ?? 8),
        constitution: Value(conScore),
        dexterite: Value(dexScore),
        intelligence: Value(wizard.abilityScores['int'] ?? 8),
        perception: Value(perScore),
        volonte: Value(wizard.abilityScores['vol'] ?? 8),
        atcTotal: Value(atcBonus + forMod),
        atdTotal: Value(atdBonus),
        defense: Value(computeDefense(dexScore)),
        initiative: Value(computeInitiative(perScore)),
        exploitPointsCurrent: Value(profile?.exploitPoints ?? 0),
        exploitPointsMax: Value(profile?.exploitPoints ?? 0),
        ethicsOrder: Value(wizard.ethicsOrder),
        ethicsJustice: Value(wizard.ethicsJustice),
        ethicsAnarchy: Value(wizard.ethicsAnarchy),
        ethicsCrime: Value(wizard.ethicsCrime),
        livingStandard: Value(profile?.livingStandard ?? 'modeste'),
      ),
    );

    // Insert ways
    for (final wayId in wizard.selectedWayIds) {
      await db.batmanDao.insertCharacterWay(
        BatmanCharacterWaysCompanion.insert(
          characterId: characterId,
          wayId: wayId,
          rankAcquired: const Value(1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentStep == _totalSteps - 1;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.amber,
        title: const Text(
          'Nouveau personnage — Batman RPG',
          style: TextStyle(fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _confirmDiscard(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: _BatmanStepIndicator(
            titles: _stepTitles,
            currentStep: _currentStep,
            onTap: (i) {
              if (i <= _currentStep) _goTo(i);
            },
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          _StepProfileMode(),
          _StepIdentity(),
          _StepAbilities(),
          _StepWays(),
          _StepSummary(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Consumer(
            builder: (context, ref, _) {
              final canNext = _canGoNextWithRef(ref);
              return Row(
                children: [
                  if (_currentStep > 0)
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.amber,
                        side: const BorderSide(color: Colors.amber),
                      ),
                      onPressed: _saving ? null : () => _goTo(_currentStep - 1),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Précédent'),
                    )
                  else
                    const SizedBox.shrink(),
                  const Spacer(),
                  if (isLast)
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black),
                      onPressed: _saving ? null : _finish,
                      icon: _saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.black),
                            )
                          : const Icon(Icons.check),
                      label: const Text('Créer'),
                    )
                  else
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black),
                      onPressed: canNext ? () => _goTo(_currentStep + 1) : null,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Suivant'),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDiscard(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Abandonner la création ?'),
        content: const Text('Toutes les modifications seront perdues.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      ref.read(batmanWizardProvider.notifier).reset();
      Navigator.of(context).pop();
    }
  }
}

// ─────────────────────────────────────────────────────────────
// STEP 1 — Mode & Profil
// ─────────────────────────────────────────────────────────────

class _StepProfileMode extends ConsumerWidget {
  const _StepProfileMode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizard = ref.watch(batmanWizardProvider);
    final profilesAsync = ref.watch(batmanProfilesProvider);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _sectionTitle(context, 'Mode de jeu'),
        const SizedBox(height: 8),
        _modeCard(context, ref, wizard, 'rues', 'Rues de Gotham City',
            'Aventures urbaines réalistes. Accès aux voies communes.'),
        const SizedBox(height: 8),
        _modeCard(context, ref, wizard, 'ombres', 'Ombres de Gotham City',
            'Justiciers et criminels d\'exception. Voies communes + voies des ombres.'),
        const SizedBox(height: 8),
        _modeCard(context, ref, wizard, 'prodiges', 'Prodiges de Gotham City',
            'Super-pouvoirs et menaces majeures. Toutes les voies disponibles.'),
        const SizedBox(height: 24),
        _sectionTitle(context, 'Profil'),
        const SizedBox(height: 8),
        profilesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Erreur: $e'),
          data: (profiles) {
            final filtered =
                profiles.where((p) => _profileFitsMode(p.mode, wizard.mode)).toList();
            return Column(
              children: filtered
                  .map((p) => _profileCard(context, ref, wizard, p))
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  bool _profileFitsMode(String profileMode, String selectedMode) {
    if (selectedMode == 'prodiges') return true;
    if (selectedMode == 'ombres') {
      return profileMode == 'rues' || profileMode == 'ombres';
    }
    return profileMode == 'rues';
  }

  Widget _modeCard(BuildContext context, WidgetRef ref, BatmanWizardState wizard,
      String modeId, String title, String subtitle) {
    final selected = wizard.mode == modeId;
    return Card(
      color: selected ? Colors.amber.shade900 : Colors.grey.shade900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: selected
            ? const BorderSide(color: Colors.amber, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => ref.read(batmanWizardProvider.notifier).setMode(modeId),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: Colors.amber,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: Colors.amber, fontWeight: FontWeight.bold)),
                    Text(subtitle,
                        style: TextStyle(
                            color: Colors.amber.shade200, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileCard(BuildContext context, WidgetRef ref,
      BatmanWizardState wizard, BatmanProfile profile) {
    final selected = wizard.profileId == profile.id;
    return Card(
      color: selected ? Colors.amber.shade900 : Colors.grey.shade900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: selected
            ? const BorderSide(color: Colors.amber, width: 2)
            : BorderSide.none,
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () =>
            ref.read(batmanWizardProvider.notifier).setProfile(profile.id),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: Colors.amber,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.name,
                        style: const TextStyle(
                            color: Colors.amber, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(profile.description,
                        style: TextStyle(
                            color: Colors.grey.shade400, fontSize: 12)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      children: [
                        _chip('${profile.hitDie}'),
                        if (profile.atcBonus > 0) _chip('ATC +${profile.atcBonus}'),
                        if (profile.atdBonus > 0) _chip('ATD +${profile.atdBonus}'),
                        _chip('PC: ${profile.capabilityPoints}'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(label,
            style:
                TextStyle(color: Colors.amber.shade300, fontSize: 11)),
      );

  Widget _sectionTitle(BuildContext context, String title) => Text(
        title,
        style: const TextStyle(
            color: Colors.amber,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      );
}

// ─────────────────────────────────────────────────────────────
// STEP 2 — Identité
// ─────────────────────────────────────────────────────────────

class _StepIdentity extends ConsumerStatefulWidget {
  const _StepIdentity();

  @override
  ConsumerState<_StepIdentity> createState() => _StepIdentityState();
}

class _StepIdentityState extends ConsumerState<_StepIdentity> {
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

// ─────────────────────────────────────────────────────────────
// STEP 3 — Caractéristiques
// ─────────────────────────────────────────────────────────────

class _StepAbilities extends ConsumerWidget {
  const _StepAbilities();

  static const _abilities = ['for', 'con', 'dex', 'int', 'per', 'vol'];
  static const _costs = {
    8: 0, 9: 1, 10: 2, 11: 3, 12: 4, 13: 5, 14: 7, 15: 9, 16: 12, 17: 15, 18: 18,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizard = ref.watch(batmanWizardProvider);
    final notifier = ref.read(batmanWizardProvider.notifier);
    final budget = wizard.mode == 'rues' ? 18 : 24;
    final spent = wizard.abilityScores.values
        .fold(0, (s, v) => s + (_costs[v] ?? 0));
    final remaining = budget - spent;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Caractéristiques primaires',
          style: TextStyle(
              color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: remaining >= 0 ? Colors.grey.shade900 : Colors.red.shade900,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.stars, color: Colors.amber),
              const SizedBox(width: 8),
              Text(
                'Points restants : $remaining / $budget',
                style: TextStyle(
                  color: remaining >= 0 ? Colors.amber : Colors.red.shade300,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ..._abilities.map((ability) {
          final value = wizard.abilityScores[ability] ?? 8;
          final mod = abilityModifier(value);
          final modStr = mod >= 0 ? '+$mod' : '$mod';
          return _AbilityRow(
            ability: ability,
            value: value,
            mod: modStr,
            onDecrement: value > 8
                ? () => notifier.setAbilityScore(ability, value - 1)
                : null,
            onIncrement: value < 18 && remaining > 0
                ? () {
                    final nextCost = (_costs[value + 1] ?? 0) - (_costs[value] ?? 0);
                    if (nextCost <= remaining) {
                      notifier.setAbilityScore(ability, value + 1);
                    }
                  }
                : null,
          );
        }),
        const SizedBox(height: 16),
        _derivedStats(wizard),
      ],
    );
  }

  Widget _derivedStats(BatmanWizardState wizard) {
    final dex = wizard.abilityScores['dex'] ?? 8;
    final per = wizard.abilityScores['per'] ?? 8;
    final def = computeDefense(dex);
    final ini = computeInitiative(per);
    final iniStr = ini >= 0 ? '+$ini' : '$ini';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Statistiques dérivées',
              style: TextStyle(
                  color: Colors.amber, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _statBox('Défense', '$def'),
            _statBox('Initiative', iniStr),
          ]),
        ],
      ),
    );
  }

  Widget _statBox(String label, String value) => Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
        ],
      );
}

class _AbilityRow extends StatelessWidget {
  final String ability;
  final int value;
  final String mod;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  const _AbilityRow({
    required this.ability,
    required this.value,
    required this.mod,
    this.onDecrement,
    this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              abilityShortName(ability),
              style: const TextStyle(
                  color: Colors.amber, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.amber),
            onPressed: onDecrement,
          ),
          Container(
            width: 40,
            alignment: Alignment.center,
            child: Text(
              '$value',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.amber),
            onPressed: onIncrement,
          ),
          const Spacer(),
          Container(
            width: 40,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.amber.shade900,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(mod,
                style: const TextStyle(
                    color: Colors.amber, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// STEP 4 — Voies
// ─────────────────────────────────────────────────────────────

class _StepWays extends ConsumerWidget {
  const _StepWays();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizard = ref.watch(batmanWizardProvider);
    final waysAsync = ref.watch(batmanWaysProvider);
    final profilesAsync = ref.watch(batmanProfilesProvider);

    return waysAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erreur: $e')),
      data: (ways) => profilesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
        data: (profiles) {
          final profile =
              profiles.where((p) => p.id == wizard.profileId).firstOrNull;
          final allowedType = wizard.mode == 'rues'
              ? ['commune']
              : wizard.mode == 'ombres'
                  ? ['commune', 'ombre']
                  : ['commune', 'ombre', 'prodige'];

          final filteredWays =
              ways.where((w) => allowedType.contains(w.type)).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Choisissez vos voies',
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              if (profile != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Voies initiales de votre profil : ${profile.capabilityPoints} points de capacité',
                  style:
                      TextStyle(color: Colors.grey.shade400, fontSize: 13),
                ),
              ],
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  'Voies sélectionnées : ${wizard.selectedWayIds.length}',
                  style: const TextStyle(color: Colors.amber),
                ),
              ),
              const SizedBox(height: 12),
              ...filteredWays.map((way) {
                final selected = wizard.selectedWayIds.contains(way.id);
                return Card(
                  color: selected ? Colors.amber.shade900 : Colors.grey.shade900,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: selected
                        ? const BorderSide(color: Colors.amber, width: 1.5)
                        : BorderSide.none,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () =>
                        ref.read(batmanWizardProvider.notifier).toggleWay(way.id),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(
                            selected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(way.name,
                                    style: const TextStyle(
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  _typeLabel(way.type),
                                  style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'commune':
        return 'Voie commune';
      case 'ombre':
        return 'Voie des ombres';
      case 'prodige':
        return 'Voie des prodiges';
      default:
        return type;
    }
  }
}

// ─────────────────────────────────────────────────────────────
// STEP 5 — Récapitulatif
// ─────────────────────────────────────────────────────────────

class _StepSummary extends ConsumerWidget {
  const _StepSummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizard = ref.watch(batmanWizardProvider);
    final profilesAsync = ref.watch(batmanProfilesProvider);
    final waysAsync = ref.watch(batmanWaysProvider);

    return profilesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (profiles) => waysAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (ways) {
          final profile =
              profiles.where((p) => p.id == wizard.profileId).firstOrNull;
          final selectedWays = ways
              .where((w) => wizard.selectedWayIds.contains(w.id))
              .toList();
          final con = wizard.abilityScores['con'] ?? 8;
          final hp = profile != null ? computeBatmanHP(profile.hitDie, con) : 0;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Récapitulatif',
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _row('Nom', wizard.name.isEmpty ? '—' : wizard.name),
              if (wizard.secretIdentity.isNotEmpty)
                _row('Identité secrète', wizard.secretIdentity),
              _row('Mode', _modeLabel(wizard.mode)),
              if (profile != null) _row('Profil', profile.name),
              _row('PV initiaux', '$hp'),
              const Divider(color: Colors.amber),
              const SizedBox(height: 8),
              const Text('Caractéristiques',
                  style: TextStyle(
                      color: Colors.amber, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['for', 'con', 'dex', 'int', 'per', 'vol']
                    .map((a) {
                  final v = wizard.abilityScores[a] ?? 8;
                  final m = abilityModifier(v);
                  return _abilityBox(
                      abilityShortName(a), v, m >= 0 ? '+$m' : '$m');
                }).toList(),
              ),
              const Divider(color: Colors.amber),
              const SizedBox(height: 8),
              const Text('Voies choisies',
                  style: TextStyle(
                      color: Colors.amber, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (selectedWays.isEmpty)
                const Text('Aucune voie sélectionnée.',
                    style: TextStyle(color: Colors.grey)),
              ...selectedWays.map((w) => Row(
                    children: [
                      const Icon(Icons.shield, color: Colors.amber, size: 16),
                      const SizedBox(width: 8),
                      Text(w.name,
                          style: const TextStyle(color: Colors.white)),
                    ],
                  )),
              const Divider(color: Colors.amber),
              const SizedBox(height: 8),
              const Text('Éthique',
                  style: TextStyle(
                      color: Colors.amber, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _ethicBox('Ordre', wizard.ethicsOrder),
                _ethicBox('Justice', wizard.ethicsJustice),
                _ethicBox('Anarchie', wizard.ethicsAnarchy),
                _ethicBox('Crime', wizard.ethicsCrime),
              ]),
            ],
          );
        },
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
                width: 130,
                child: Text(label,
                    style: TextStyle(color: Colors.grey.shade400))),
            Expanded(
                child:
                    Text(value, style: const TextStyle(color: Colors.white))),
          ],
        ),
      );

  Widget _abilityBox(String name, int value, String mod) => Container(
        width: 72,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.amber.shade800),
        ),
        child: Column(
          children: [
            Text(mod,
                style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            Text('$value',
                style: TextStyle(color: Colors.grey.shade300, fontSize: 13)),
            Text(name,
                style:
                    TextStyle(color: Colors.grey.shade400, fontSize: 11)),
          ],
        ),
      );

  Widget _ethicBox(String name, int value) => Column(
        children: [
          Text('$value',
              style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          Text(name,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
        ],
      );

  String _modeLabel(String mode) {
    switch (mode) {
      case 'rues':
        return 'Rues de Gotham City';
      case 'ombres':
        return 'Ombres de Gotham City';
      case 'prodiges':
        return 'Prodiges de Gotham City';
      default:
        return mode;
    }
  }
}

// Helper widget for step indicator
class _BatmanStepIndicator extends StatelessWidget {
  final List<String> titles;
  final int currentStep;
  final void Function(int) onTap;

  const _BatmanStepIndicator({
    required this.titles,
    required this.currentStep,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: List.generate(titles.length, (i) {
          final isDone = i < currentStep;
          final isCurrent = i == currentStep;
          return GestureDetector(
            onTap: () => onTap(i),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone || isCurrent ? Colors.amber : Colors.grey.shade800,
                  ),
                  child: Center(
                    child: isDone
                        ? const Icon(Icons.check, size: 16, color: Colors.black)
                        : Text(
                            '${i + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isCurrent ? Colors.black : Colors.grey,
                            ),
                          ),
                  ),
                ),
                if (i < titles.length - 1)
                  Container(
                    width: 20,
                    height: 2,
                    color: isDone ? Colors.amber : Colors.grey.shade700,
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}


