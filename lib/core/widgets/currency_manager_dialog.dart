import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import '../database/app_database.dart';
import '../providers/database_provider.dart';
import '../../features/character/providers/character_providers.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

class CurrencyManagerDialog extends StatefulWidget {
  final int characterId;
  final Map<String, int> initialCurrency;

  const CurrencyManagerDialog({
    super.key,
    required this.characterId,
    required this.initialCurrency,
  });

  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    int characterId,
    Map<String, int> currency,
  ) {
    return showDialog<void>(
      context: context,
      builder: (context) => CurrencyManagerDialog(
        characterId: characterId,
        initialCurrency: currency,
      ),
    );
  }

  @override
  State<CurrencyManagerDialog> createState() => _CurrencyManagerDialogState();
}

class _CurrencyManagerDialogState extends State<CurrencyManagerDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Currencies
  late int _cp;
  late int _sp;
  late int _ep;
  late int _gp;
  late int _pp;

  // Controllers for manual mode
  late TextEditingController _cpCtrl;
  late TextEditingController _spCtrl;
  late TextEditingController _epCtrl;
  late TextEditingController _gpCtrl;
  late TextEditingController _ppCtrl;

  // Controllers for transaction mode
  final _transAmountCtrl = TextEditingController(text: '0');
  String _transType = 'gp'; // 'cp', 'sp', 'ep', 'gp', 'pp'
  bool _isAddTransaction = true; // true = Gain, false = Dépense

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _cp = widget.initialCurrency['cp'] ?? 0;
    _sp = widget.initialCurrency['sp'] ?? 0;
    _ep = widget.initialCurrency['ep'] ?? 0;
    _gp = widget.initialCurrency['gp'] ?? 0;
    _pp = widget.initialCurrency['pp'] ?? 0;

    _cpCtrl = TextEditingController(text: _cp.toString());
    _spCtrl = TextEditingController(text: _sp.toString());
    _epCtrl = TextEditingController(text: _ep.toString());
    _gpCtrl = TextEditingController(text: _gp.toString());
    _ppCtrl = TextEditingController(text: _pp.toString());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cpCtrl.dispose();
    _spCtrl.dispose();
    _epCtrl.dispose();
    _gpCtrl.dispose();
    _ppCtrl.dispose();
    _transAmountCtrl.dispose();
    super.dispose();
  }

  int get _totalCP =>
      _cp + (_sp * 10) + (_ep * 50) + (_gp * 100) + (_pp * 1000);
  double get _totalGP => _totalCP / 100.0;
  int get _totalCoins => _cp + _sp + _ep + _gp + _pp;
  double get _totalWeightLbs => _totalCoins / 50.0;

  void _updateFromControllers() {
    setState(() {
      _cp = int.tryParse(_cpCtrl.text) ?? 0;
      _sp = int.tryParse(_spCtrl.text) ?? 0;
      _ep = int.tryParse(_epCtrl.text) ?? 0;
      _gp = int.tryParse(_gpCtrl.text) ?? 0;
      _pp = int.tryParse(_ppCtrl.text) ?? 0;
    });
  }

  void _updateControllers() {
    _cpCtrl.text = _cp.toString();
    _spCtrl.text = _sp.toString();
    _epCtrl.text = _ep.toString();
    _gpCtrl.text = _gp.toString();
    _ppCtrl.text = _pp.toString();
  }

  void _optimizeCurrency() {
    final l10n = AppLocalizations.of(context)!;
    final total = _totalCP;
    int remaining = total;

    final newPP = remaining ~/ 1000;
    remaining %= 1000;

    final newGP = remaining ~/ 100;
    remaining %= 100;

    final newEP = 0; // Convert Ep to GP/SP
    final newSP = remaining ~/ 10;
    final newCP = remaining % 10;

    setState(() {
      _pp = newPP;
      _gp = newGP;
      _ep = newEP;
      _sp = newSP;
      _cp = newCP;
      _updateControllers();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.currencyOptimized),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _executeTransaction() {
    final l10n = AppLocalizations.of(context)!;
    final amount = int.tryParse(_transAmountCtrl.text) ?? 0;
    if (amount <= 0) return;

    int multiplier = 100; // default GP
    switch (_transType) {
      case 'cp':
        multiplier = 1;
        break;
      case 'sp':
        multiplier = 10;
        break;
      case 'ep':
        multiplier = 50;
        break;
      case 'gp':
        multiplier = 100;
        break;
      case 'pp':
        multiplier = 1000;
        break;
    }

    final transCP = amount * multiplier;

    if (!_isAddTransaction && transCP > _totalCP) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.currencyInsufficientFunds),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final newTotalCP = _isAddTransaction
        ? (_totalCP + transCP)
        : (_totalCP - transCP);

    // Re-distribute
    int remaining = newTotalCP;
    final newPP = remaining ~/ 1000;
    remaining %= 1000;

    final newGP = remaining ~/ 100;
    remaining %= 100;

    final newSP = remaining ~/ 10;
    final newCP = remaining % 10;

    setState(() {
      _pp = newPP;
      _gp = newGP;
      _ep = 0;
      _sp = newSP;
      _cp = newCP;
      _updateControllers();
      _transAmountCtrl.text = '0';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isAddTransaction
              ? l10n.currencyAdded(amount, _transType.toUpperCase())
              : l10n.currencySpent(amount, _transType.toUpperCase()),
        ),
      ),
    );
  }

  void _emptyPurse() {
    final l10n = AppLocalizations.of(context)!;
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent),
            SizedBox(width: 10),
            Text(
              l10n.currencyEmptyTitle,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Text(
          l10n.currencyEmptyConfirm,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.currencyEmptyButton),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        setState(() {
          _cp = 0;
          _sp = 0;
          _ep = 0;
          _gp = 0;
          _pp = 0;
          _updateControllers();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.currencyEmptied),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  Future<void> _save(WidgetRef ref) async {
    _updateFromControllers();

    final newMap = {'cp': _cp, 'sp': _sp, 'ep': _ep, 'gp': _gp, 'pp': _pp};

    final db = ref.read(databaseProvider);
    await db.characterDao.updateCharacter(
      CharactersCompanion(
        id: Value(widget.characterId),
        currency: Value(jsonEncode(newMap)),
      ),
    );

    ref.invalidate(characterByIdProvider(widget.characterId));
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer(
      builder: (context, ref, child) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: GlassContainer(
            borderRadius: 24,
            padding: const EdgeInsets.all(20),
            border: Border.all(
              color: AppTheme.neonCyan.withValues(alpha: 0.3),
              width: 1.5,
            ),
            child: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // En-tête de la bourse
                  Row(
                    children: [
                      const Icon(
                        Icons.account_balance_wallet,
                        color: Colors.amber,
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.currencyDialogTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        tooltip: l10n.currencyEmptyButton,
                        onPressed: _emptyPurse,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        tooltip: l10n.actionClose,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Carte récapitulative de la valeur et du poids
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.amber.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              l10n.currencyTotalValue.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white60,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${_totalGP.toStringAsFixed(2)} ${l10n.currencyGold}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                        Container(height: 30, width: 1, color: Colors.white24),
                        Column(
                          children: [
                            Text(
                              l10n.currencyPurseWeight.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white60,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.currencyWeightSummary(
                                _totalWeightLbs.toStringAsFixed(1),
                                _totalCoins,
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Onglets
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.center,
                    indicatorColor: AppTheme.neonCyan,
                    labelColor: AppTheme.neonCyan,
                    unselectedLabelColor: Colors.white60,
                    tabs: [
                      Tab(text: l10n.currencyDetailTab),
                      Tab(text: l10n.currencyTransactionTab),
                      Tab(text: l10n.currencyOptimizeTab),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Contenu des onglets
                  SizedBox(
                    height: 260,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Onglet 1 : Édition manuelle
                        _buildManualTab(),

                        // Onglet 2 : Transactions rapides (+/-)
                        _buildTransactionTab(),

                        // Onglet 3 : Optimisation / Conversion
                        _buildOptimizeTab(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white70,
                            side: const BorderSide(color: Colors.white24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(l10n.actionCancel),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => _save(ref),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            l10n.actionSave,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildManualTab() {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCoinInputRow(
            '${l10n.currencyCopper} (${l10n.currencyCopperName})',
            _cpCtrl,
            Colors.brown,
            (v) => setState(() => _cp = v),
          ),
          _buildCoinInputRow(
            '${l10n.currencySilver} (${l10n.currencySilverName})',
            _spCtrl,
            Colors.grey,
            (v) => setState(() => _sp = v),
          ),
          _buildCoinInputRow(
            '${l10n.currencyElectrum} (${l10n.currencyElectrumName})',
            _epCtrl,
            Colors.blueGrey,
            (v) => setState(() => _ep = v),
          ),
          _buildCoinInputRow(
            '${l10n.currencyGold} (${l10n.currencyGoldName})',
            _gpCtrl,
            Colors.amber,
            (v) => setState(() => _gp = v),
          ),
          _buildCoinInputRow(
            '${l10n.currencyPlatinum} (${l10n.currencyPlatinumName})',
            _ppCtrl,
            Colors.white70,
            (v) => setState(() => _pp = v),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinInputRow(
    String label,
    TextEditingController ctrl,
    Color color,
    Function(int) onChanged,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.monetization_on, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.remove_circle_outline,
              size: 20,
              color: Colors.white54,
            ),
            tooltip: l10n.currencyDecreaseTooltip(label),
            onPressed: () {
              final val = (int.tryParse(ctrl.text) ?? 0) - 1;
              if (val >= 0) {
                ctrl.text = val.toString();
                onChanged(val);
              }
            },
          ),
          SizedBox(
            width: 70,
            child: TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 8,
                ),
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                final val = int.tryParse(text) ?? 0;
                onChanged(val);
              },
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              size: 20,
              color: AppTheme.neonCyan,
            ),
            tooltip: l10n.currencyIncreaseTooltip(label),
            onPressed: () {
              final val = (int.tryParse(ctrl.text) ?? 0) + 1;
              ctrl.text = val.toString();
              onChanged(val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTab() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ChoiceChip(
                label: Text(l10n.currencyReceiveLoot),
                selected: _isAddTransaction,
                selectedColor: Colors.green.shade800,
                onSelected: (val) {
                  if (val) setState(() => _isAddTransaction = true);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ChoiceChip(
                label: Text(l10n.currencySpendPurchase),
                selected: !_isAddTransaction,
                selectedColor: Colors.red.shade800,
                onSelected: (val) {
                  if (val) setState(() => _isAddTransaction = false);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _transAmountCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.currencyAmount,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calculate),
                ),
              ),
            ),
            const SizedBox(width: 12),
            DropdownButton<String>(
              value: _transType,
              dropdownColor: Colors.grey.shade900,
              items: [
                DropdownMenuItem(
                  value: 'cp',
                  child: Text(
                    '${l10n.currencyCopper} (${l10n.currencyCopperName})',
                  ),
                ),
                DropdownMenuItem(
                  value: 'sp',
                  child: Text(
                    '${l10n.currencySilver} (${l10n.currencySilverName})',
                  ),
                ),
                DropdownMenuItem(
                  value: 'ep',
                  child: Text(
                    '${l10n.currencyElectrum} (${l10n.currencyElectrumName})',
                  ),
                ),
                DropdownMenuItem(
                  value: 'gp',
                  child: Text(
                    '${l10n.currencyGold} (${l10n.currencyGoldName})',
                  ),
                ),
                DropdownMenuItem(
                  value: 'pp',
                  child: Text(
                    '${l10n.currencyPlatinum} (${l10n.currencyPlatinumName})',
                  ),
                ),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _transType = val);
              },
            ),
          ],
        ),

        const Spacer(),

        SizedBox(
          width: double.infinity,
          height: 44,
          child: FilledButton.icon(
            onPressed: _executeTransaction,
            style: FilledButton.styleFrom(
              backgroundColor: _isAddTransaction
                  ? Colors.green.shade700
                  : Colors.orange.shade800,
            ),
            icon: Icon(_isAddTransaction ? Icons.add : Icons.remove),
            label: Text(
              _isAddTransaction
                  ? l10n.currencyAddToPurse
                  : l10n.currencyMakePayment,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptimizeTab() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.auto_awesome, size: 40, color: Colors.amber),
        const SizedBox(height: 12),
        Text(
          l10n.currencyOptimizerTitle,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.currencyOptimizerDescription,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.white70),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: _optimizeCurrency,
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.neonCyan,
            foregroundColor: Colors.black,
          ),
          icon: const Icon(Icons.swap_vert, size: 20),
          label: Text(l10n.currencyOptimizeButton),
        ),
      ],
    );
  }
}
