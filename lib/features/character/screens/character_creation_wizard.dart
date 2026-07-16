import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/character_service.dart';
import '../../../core/providers/database_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/wizard_provider.dart';
import 'wizard_steps/step1_system.dart';
import 'wizard_steps/step2_identity.dart';
import 'wizard_steps/step3_class.dart';
import 'wizard_steps/step4_origin.dart';
import 'wizard_steps/step5_abilities.dart';
import 'wizard_steps/step6_proficiencies.dart';
import 'wizard_steps/step7_summary.dart';

class CharacterCreationWizard extends ConsumerStatefulWidget {
  const CharacterCreationWizard({super.key});

  @override
  ConsumerState<CharacterCreationWizard> createState() =>
      _CharacterCreationWizardState();
}

class _CharacterCreationWizardState
    extends ConsumerState<CharacterCreationWizard> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _saving = false;

  static const int _totalSteps = 7;

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

  void _next() {
    if (_currentStep < _totalSteps - 1) _goTo(_currentStep + 1);
  }

  void _previous() {
    if (_currentStep > 0) _goTo(_currentStep - 1);
  }

  Future<void> _finish() async {
    final wizard = ref.read(wizardProvider);
    if (!wizard.isStep2Valid || !wizard.isStep3Valid) return;

    setState(() => _saving = true);
    try {
      final db = ref.read(databaseProvider);
      final service = CharacterService(db);
      await service.createFromWizard(wizard);

      // Reset wizard state
      ref.read(wizardProvider.notifier).reset();

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

  bool _canGoNext(WizardState wizard) {
    switch (_currentStep) {
      case 1:
        return wizard.isStep2Valid;
      case 2:
        return wizard.isStep3Valid;
      case 3:
        return wizard.isStep4Valid;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final wizard = ref.watch(wizardProvider);

    final stepTitles = [
      l10n.wizardStepSystem,
      l10n.wizardStepIdentity,
      l10n.wizardStepClass,
      l10n.wizardStepOrigin,
      l10n.wizardStepAbilities,
      l10n.wizardStepProficiencies,
      l10n.wizardStepSummary,
    ];

    final isLastStep = _currentStep == _totalSteps - 1;
    final canNext = _canGoNext(wizard);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.characterCreate),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _confirmDiscard(context, l10n),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: _StepIndicator(
            titles: stepTitles,
            currentStep: _currentStep,
            onTap: (i) {
              // Only allow going back to previous steps
              if (i <= _currentStep) _goTo(i);
            },
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          Step1System(),
          Step2Identity(),
          Step3Class(),
          Step4Origin(),
          Step5Abilities(),
          Step6Proficiencies(),
          Step7Summary(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              if (_currentStep > 0)
                OutlinedButton.icon(
                  onPressed: _saving ? null : _previous,
                  icon: const Icon(Icons.arrow_back),
                  label: Text(l10n.wizardPrevious),
                )
              else
                const SizedBox.shrink(),
              const Spacer(),
              if (isLastStep)
                FilledButton.icon(
                  onPressed: _saving ? null : _finish,
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: Text(l10n.wizardFinish),
                )
              else
                FilledButton.icon(
                  onPressed: canNext ? _next : null,
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(l10n.wizardNext),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDiscard(BuildContext context, AppLocalizations l10n) async {
    final navigator = Navigator.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Abandonner la création ?'),
        content: const Text('Toutes les modifications seront perdues.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.actionConfirm),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      ref.read(wizardProvider.notifier).reset();
      navigator.pop();
    }
  }
}

class _StepIndicator extends StatelessWidget {
  final List<String> titles;
  final int currentStep;
  final void Function(int) onTap;

  const _StepIndicator({
    required this.titles,
    required this.currentStep,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
                    color: isDone || isCurrent
                        ? colorScheme.primary
                        : colorScheme.surfaceContainerHighest,
                    border: isCurrent
                        ? Border.all(
                            color: colorScheme.onPrimary, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: isDone
                        ? Icon(Icons.check,
                            size: 16, color: colorScheme.onPrimary)
                        : Text(
                            '${i + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isCurrent
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                  ),
                ),
                if (i < titles.length - 1)
                  Container(
                    width: 24,
                    height: 2,
                    color: isDone
                        ? colorScheme.primary
                        : colorScheme.surfaceContainerHighest,
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
