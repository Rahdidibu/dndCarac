import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables/tables.dart';
import '../../../core/providers/database_provider.dart';
import '../providers/batman_providers.dart';
import 'wizard_steps/batman_step_indicator.dart';
import 'wizard_steps/step1_profile_mode.dart';
import 'wizard_steps/step2_identity.dart';
import 'wizard_steps/step3_abilities.dart';
import 'wizard_steps/step4_ways.dart';
import 'wizard_steps/step5_summary.dart';

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
          child: BatmanStepIndicator(
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
          Step1ProfileMode(),
          Step2Identity(),
          Step3Abilities(),
          Step4Ways(),
          Step5Summary(),
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
