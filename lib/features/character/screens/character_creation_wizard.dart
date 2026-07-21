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
        title: Text(
          l10n.characterCreate,
          style: const TextStyle(fontFamily: 'Cinzel', fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _confirmDiscard(context, l10n),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: _StepIndicator(
                titles: stepTitles,
                currentStep: _currentStep,
                onTap: (i) {
                  if (i <= _currentStep) _goTo(i);
                },
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: PageView(
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
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Center(
          heightFactor: 1.0,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        side: BorderSide(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _saving ? null : _previous,
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: Text(l10n.wizardPrevious, style: const TextStyle(fontWeight: FontWeight.bold)),
                    )
                  else
                    const SizedBox.shrink(),
                  const Spacer(),
                  if (isLastStep)
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _saving ? null : _finish,
                      icon: _saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.check, size: 18),
                      label: Text(l10n.wizardFinish, style: const TextStyle(fontFamily: 'Cinzel', fontWeight: FontWeight.bold)),
                    )
                  else
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: canNext ? _next : null,
                      icon: const Icon(Icons.arrow_forward, size: 18),
                      label: Text(l10n.wizardNext, style: const TextStyle(fontFamily: 'Cinzel', fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
            ),
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
        title: const Text('Abandonner la création ?', style: TextStyle(fontFamily: 'Cinzel')),
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

  IconData _getIconForStep(int step) {
    switch (step) {
      case 0:
        return Icons.menu_book_outlined; // Système
      case 1:
        return Icons.person_outline; // Identité
      case 2:
        return Icons.shield_outlined; // Classe
      case 3:
        return Icons.explore_outlined; // Origine
      case 4:
        return Icons.casino_outlined; // Caractéristiques
      case 5:
        return Icons.construction_outlined; // Maîtrises
      case 6:
        return Icons.history_edu_outlined; // Résumé
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 700;

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (isDesktop) {
            // Only show all texts if we have enough available width in this widget (e.g. > 950px)
            final showAllTexts = constraints.maxWidth > 950;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(titles.length, (i) {
                final isDone = i < currentStep;
                final isCurrent = i == currentStep;
                final activeColor = colorScheme.primary;
                final inactiveColor = colorScheme.onSurface.withValues(alpha: 0.4);
                final showText = isCurrent || showAllTexts;

                return Tooltip(
                  message: titles[i],
                  child: InkWell(
                    onTap: i <= currentStep ? () => onTap(i) : null,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCurrent
                                  ? activeColor
                                  : isDone
                                      ? activeColor.withValues(alpha: 0.2)
                                      : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                              border: Border.all(
                                color: isCurrent
                                    ? Colors.white
                                    : isDone
                                        ? activeColor.withValues(alpha: 0.6)
                                        : colorScheme.outline.withValues(alpha: 0.2),
                                width: isCurrent ? 2 : 1,
                              ),
                            ),
                            child: Icon(
                              isDone ? Icons.check : _getIconForStep(i),
                              size: 16,
                              color: isCurrent
                                  ? colorScheme.onPrimary
                                  : isDone
                                      ? activeColor
                                      : inactiveColor,
                            ),
                          ),
                          if (showText) ...[
                            const SizedBox(width: 8),
                            Text(
                              titles[i],
                              style: TextStyle(
                                fontFamily: 'Cinzel',
                                fontSize: 11,
                                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                                color: isCurrent
                                    ? activeColor
                                    : isDone
                                        ? colorScheme.onSurface
                                        : inactiveColor,
                              ),
                            ),
                          ],
                          if (i < titles.length - 1) ...[
                            const SizedBox(width: 12),
                            Icon(
                              Icons.chevron_right,
                              size: 14,
                              color: colorScheme.onSurface.withValues(alpha: 0.2),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(titles.length, (i) {
                  final isDone = i < currentStep;
                  final isCurrent = i == currentStep;
                  final activeColor = colorScheme.primary;
                  final inactiveColor = colorScheme.onSurface.withValues(alpha: 0.4);

                  return GestureDetector(
                    onTap: i <= currentStep ? () => onTap(i) : null,
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCurrent
                                ? activeColor
                                : isDone
                                    ? activeColor.withValues(alpha: 0.15)
                                    : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                            border: Border.all(
                              color: isCurrent
                                  ? Colors.white
                                  : isDone
                                      ? activeColor.withValues(alpha: 0.5)
                                      : colorScheme.outline.withValues(alpha: 0.2),
                              width: isCurrent ? 2 : 1,
                            ),
                          ),
                          child: Icon(
                            isDone ? Icons.check : _getIconForStep(i),
                            size: 18,
                            color: isCurrent
                                ? colorScheme.onPrimary
                                : isDone
                                    ? activeColor
                                    : inactiveColor,
                          ),
                        ),
                        if (i < titles.length - 1)
                          Container(
                            width: 28,
                            height: 2,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            color: isDone
                                ? activeColor.withValues(alpha: 0.5)
                                : colorScheme.surfaceContainerHighest,
                          ),
                      ],
                    ),
                  );
                }),
              ),
            );
          }
        },
      ),
    );
  }
}
