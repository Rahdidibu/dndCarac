import 'dart:math';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../character/providers/character_providers.dart';
import '../../core/utils/dnd_rules.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/database_provider.dart';


// --- DATA STRUCTURES ---

class ForgeItem {
  final String id;
  final String name;
  final String category; // 'weapon', 'armor', 'shield'
  final int baseGp;
  final int baseCp;
  final String baseWeight;
  final String diceSize; // e.g. "1d4", "1d8", "1d10"
  final String properties;

  const ForgeItem({
    required this.id,
    required this.name,
    required this.category,
    required this.baseGp,
    required this.baseCp,
    required this.baseWeight,
    this.diceSize = '',
    this.properties = '',
  });
}

class ForgeMaterial {
  final String id;
  final String name;
  final int dcMod;
  final double priceMod;
  final String stat; // 'str', 'dex', 'con'
  final String effect;

  const ForgeMaterial({
    required this.id,
    required this.name,
    required this.dcMod,
    required this.priceMod,
    required this.stat,
    required this.effect,
  });
}

class ForgeTrait {
  final String id;
  final String name;
  final int dcMod;
  final int cpCost;
  final String effect;
  final List<String> eligibleCategories;

  const ForgeTrait({
    required this.id,
    required this.name,
    required this.dcMod,
    required this.cpCost,
    required this.effect,
    required this.eligibleCategories,
  });
}

// --- DATA CONSTANTS ---

const List<ForgeItem> _forgeItems = [
  // Weapons
  ForgeItem(id: 'dagger', name: 'Dague', category: 'weapon', baseGp: 2, baseCp: 1, baseWeight: '1 lb', diceSize: '1d4', properties: 'Finesse, légère, lancée (15/40)'),
  ForgeItem(id: 'greatclub', name: 'Massue à deux mains', category: 'weapon', baseGp: 2, baseCp: 1, baseWeight: '10 lbs', diceSize: '1d8', properties: 'Deux mains'),
  ForgeItem(id: 'handaxe', name: 'Hachette', category: 'weapon', baseGp: 5, baseCp: 1, baseWeight: '2 lbs', diceSize: '1d6', properties: 'Légère, lancée (20/60)'),
  ForgeItem(id: 'javelin', name: 'Javelot', category: 'weapon', baseGp: 5, baseCp: 1, baseWeight: '2 lbs', diceSize: '1d6', properties: 'Lancé (30/120)'),
  ForgeItem(id: 'kukri', name: 'Kukri', category: 'weapon', baseGp: 25, baseCp: 2, baseWeight: '2 lbs', diceSize: '1d6', properties: 'Finesse, légère'),
  ForgeItem(id: 'lighthammer', name: 'Marteau léger', category: 'weapon', baseGp: 2, baseCp: 1, baseWeight: '2 lbs', diceSize: '1d4', properties: 'Légère, lancée (20/60)'),
  ForgeItem(id: 'mace', name: 'Masse', category: 'weapon', baseGp: 5, baseCp: 1, baseWeight: '4 lbs', diceSize: '1d6', properties: '-'),
  ForgeItem(id: 'sickle', name: 'Faucille', category: 'weapon', baseGp: 1, baseCp: 1, baseWeight: '2 lbs', diceSize: '1d4', properties: 'Légère'),
  ForgeItem(id: 'spear', name: 'Lance', category: 'weapon', baseGp: 1, baseCp: 1, baseWeight: '3 lbs', diceSize: '1d6', properties: 'Lancée (20/60), polyvalente (1d8)'),
  ForgeItem(id: 'battleaxe', name: 'Hache d\'armes', category: 'weapon', baseGp: 10, baseCp: 2, baseWeight: '4 lbs', diceSize: '1d8', properties: 'Polyvalente (1d10)'),
  ForgeItem(id: 'flail', name: 'Fléau', category: 'weapon', baseGp: 10, baseCp: 2, baseWeight: '2 lbs', diceSize: '1d8', properties: '-'),
  ForgeItem(id: 'falchion', name: 'Fauchon', category: 'weapon', baseGp: 25, baseCp: 2, baseWeight: '4 lbs', diceSize: '1d8', properties: 'Finesse'),
  ForgeItem(id: 'glaive', name: 'Glaive', category: 'weapon', baseGp: 20, baseCp: 2, baseWeight: '6 lbs', diceSize: '1d10', properties: 'Lourde, portée, deux mains'),
  ForgeItem(id: 'greataxe', name: 'Grande hache', category: 'weapon', baseGp: 30, baseCp: 3, baseWeight: '7 lbs', diceSize: '1d12', properties: 'Lourde, deux mains'),
  ForgeItem(id: 'greatsword', name: 'Espadon', category: 'weapon', baseGp: 50, baseCp: 3, baseWeight: '6 lbs', diceSize: '2d6', properties: 'Lourde, deux mains'),
  ForgeItem(id: 'halberd', name: 'Hallebarde', category: 'weapon', baseGp: 20, baseCp: 2, baseWeight: '6 lbs', diceSize: '1d10', properties: 'Lourde, portée, deux mains'),
  ForgeItem(id: 'longsword', name: 'Épée longue', category: 'weapon', baseGp: 15, baseCp: 2, baseWeight: '3 lbs', diceSize: '1d8', properties: 'Polyvalente (1d10)'),
  ForgeItem(id: 'rapier', name: 'Rapière', category: 'weapon', baseGp: 25, baseCp: 2, baseWeight: '2 lbs', diceSize: '1d8', properties: 'Finesse'),
  ForgeItem(id: 'scimitar', name: 'Cimeterre', category: 'weapon', baseGp: 25, baseCp: 2, baseWeight: '3 lbs', diceSize: '1d6', properties: 'Finesse, légère'),
  ForgeItem(id: 'shortsword', name: 'Épée courte', category: 'weapon', baseGp: 10, baseCp: 2, baseWeight: '2 lbs', diceSize: '1d6', properties: 'Finesse, légère'),
  ForgeItem(id: 'maul', name: 'Maul', category: 'weapon', baseGp: 10, baseCp: 2, baseWeight: '10 lbs', diceSize: '2d6', properties: 'Lourde, deux mains'),
  ForgeItem(id: 'warhammer', name: 'Marteau de guerre', category: 'weapon', baseGp: 15, baseCp: 2, baseWeight: '2 lbs', diceSize: '1d8', properties: 'Polyvalente (1d10)'),
  
  // Armor & Shields
  ForgeItem(id: 'buckler', name: 'Bouclier de poing (Buckler)', category: 'shield', baseGp: 5, baseCp: 1, baseWeight: '3 lbs', properties: 'CA +1. Réaction pour ajouter son bonus de maîtrise à la CA. Attaques avec le bouclier : -1 aux dégâts.'),
  ForgeItem(id: 'breastplate', name: 'Cuirasse', category: 'armor', baseGp: 400, baseCp: 17, baseWeight: '20 lbs', properties: 'CA 14 + mod Dex (max 2)'),
  ForgeItem(id: 'chainmail', name: 'Cotte de mailles', category: 'armor', baseGp: 75, baseCp: 4, baseWeight: '55 lbs', properties: 'CA 16. Force requise 13. Désavantage en discrétion.'),
  ForgeItem(id: 'chainshirt', name: 'Chemise de mailles', category: 'armor', baseGp: 50, baseCp: 3, baseWeight: '20 lbs', properties: 'CA 13 + mod Dex (max 2)'),
  ForgeItem(id: 'halfplate', name: 'Demi-harnois', category: 'armor', baseGp: 750, baseCp: 31, baseWeight: '40 lbs', properties: 'CA 15 + mod Dex (max 2). Désavantage en discrétion.'),
  ForgeItem(id: 'scalemail', name: 'Armure d\'écailles', category: 'armor', baseGp: 50, baseCp: 3, baseWeight: '45 lbs', properties: 'CA 14 + mod Dex (max 2). Désavantage en discrétion.'),
  ForgeItem(id: 'shield', name: 'Bouclier (Écu)', category: 'shield', baseGp: 10, baseCp: 2, baseWeight: '6 lbs', properties: 'CA +2'),
  ForgeItem(id: 'splint', name: 'Clavandier (Splint)', category: 'armor', baseGp: 200, baseCp: 9, baseWeight: '60 lbs', properties: 'CA 17. Force requise 15. Désavantage en discrétion.'),
  ForgeItem(id: 'towershield', name: 'Bouclier pavois (Tower)', category: 'shield', baseGp: 50, baseCp: 3, baseWeight: '10 lbs', properties: 'CA +3. Vitesse -5 ft. Force requise, désavantage en discrétion.'),
  ForgeItem(id: 'plate', name: 'Harnois (Plate)', category: 'armor', baseGp: 1500, baseCp: 61, baseWeight: '65 lbs', properties: 'CA 18. Force requise 15. Désavantage en discrétion.'),
];

const List<ForgeMaterial> _forgeMaterials = [
  ForgeMaterial(id: 'steel', name: 'Acier (Steel)', dcMod: 0, priceMod: 1.0, stat: 'str', effect: 'Matériau de base. Aucune règle additionnelle.'),
  ForgeMaterial(id: 'iron', name: 'Fer (Iron)', dcMod: -1, priceMod: 0.75, stat: 'str', effect: 'Armes : -1 aux jets de dégâts. Armures/Boucliers : -1 à la CA.'),
  ForgeMaterial(id: 'mithral', name: 'Mithral (D)', dcMod: 2, priceMod: 4.0, stat: 'dex', effect: 'Poids divisé par 2. Outils requis : Dextérité. Armes à deux mains perdent "Lourde", autres gagnent "Légère". Armures : aucun prérequis de Force, Dex max +3 pour intermédiaire. Boucliers : légers, bonus CA ajouté aux JS Dex vs sorts.'),
  ForgeMaterial(id: 'adamantium', name: 'Adamantium (C)', dcMod: 3, priceMod: 5.0, stat: 'con', effect: 'Poids multiplié par 2. Outils requis : Constitution. Doubles PV, +5 DC de cassage. Armes : perdent "Légère"/gagnent "Lourde", dé de dégâts augmenté d\'une taille. Armures : réduit les dégâts magiques subis de 2. Boucliers : réduit les dégâts critiques non-magiques.'),
  ForgeMaterial(id: 'deepiron', name: 'Fer des profondeurs (Deepiron)', dcMod: 5, priceMod: 3.0, stat: 'str', effect: 'Armes : relance des dégâts contre les Fées/Célestes. Armures/Boucliers : avantage/bonus de CA aux JS contre les Fées/Célestes.'),
  ForgeMaterial(id: 'finimagus', name: 'Finimagus (Voidstone)', dcMod: 5, priceMod: 4.0, stat: 'str', effect: 'Empêche de lancer ou maintenir des sorts. Armes : inflige désavantage aux JS de concentration. Armures/Boucliers : avantage aux JS vs sorts / dégâts de sort divisés par 2 -> aucun dégât.'),
  ForgeMaterial(id: 'argentium', name: 'Argentium (Puresteel)', dcMod: 5, priceMod: 3.0, stat: 'str', effect: 'Armes : magiques pour surmonter les résistances. Armures : octroie 1 dé de vie de PV temporaires à l\'enfilage. Boucliers : résistance aux dégâts de sort subis pendant 1 minute (1/jour).'),
  ForgeMaterial(id: 'skyrite', name: 'Skyrite (Blessed Gold)', dcMod: 6, priceMod: 5.0, stat: 'str', effect: 'Armes : les coups critiques sur les Fiélons/Aberrations/Morts-vivants les étourdissent. Armures : avantage vs frayeur. Boucliers : inflige 1 dégât radiant aux attaquants.'),
  ForgeMaterial(id: 'meteoric', name: 'Fer météorique (Meteoric Iron)', dcMod: 6, priceMod: 6.0, stat: 'str', effect: 'Résistance au feu. Armes : +1 plage de critique contre les cibles vulnérables au feu, 1/2 dégâts crit sont de feu. Armures : renvoie d6 dégâts de feu sur les jets d\'attaque de 1 ou 20. Boucliers : absorption de feu sur JS 20.'),
  ForgeMaterial(id: 'erudite', name: 'Érudite (Crystal)', dcMod: 6, priceMod: 5.0, stat: 'dex', effect: 'Outils requis : Dextérité. Armes : focaliseur arcanique, +1 aux attaques de sort. Armures : avantage aux JS de concentration. Boucliers : focaliseur arcanique, +1 au DD de sauvegarde des sorts.'),
];

const List<ForgeTrait> _forgeTraits = [
  ForgeTrait(id: 'none', name: 'Aucun trait', dcMod: 0, cpCost: 0, effect: '-', eligibleCategories: ['weapon', 'armor', 'shield']),
  
  // Weapon traits
  ForgeTrait(id: 'balanced_weight', name: 'Poids équilibré (Balanced)', dcMod: 4, cpCost: 2, effect: 'Ajoute la propriété "Lancée (15/40)"', eligibleCategories: ['weapon']),
  ForgeTrait(id: 'slim_design', name: 'Conception fine (Slim)', dcMod: 4, cpCost: 1, effect: 'Avantage pour dissimuler l\'arme', eligibleCategories: ['weapon']),
  ForgeTrait(id: 'deep_fuller', name: 'Gorge profonde (Deep Fuller)', dcMod: 4, cpCost: 1, effect: '+1 au DD de sauvegarde des poisons appliqués', eligibleCategories: ['weapon']),
  ForgeTrait(id: 'weighted_end', name: 'Extrémité lestée (Weighted End)', dcMod: 4, cpCost: 2, effect: 'Sur critique : met la cible à terre (JS Force)', eligibleCategories: ['weapon']),
  ForgeTrait(id: 'spiked_end', name: 'Extrémité pointue (Spiked End)', dcMod: 4, cpCost: 3, effect: 'Sur critique : réduit la CA de la cible de 1', eligibleCategories: ['weapon']),
  ForgeTrait(id: 'hooked_blade', name: 'Lame à crochet (Hooked Blade)', dcMod: 4, cpCost: 2, effect: 'Sur critique : agrippe la cible (JS Force)', eligibleCategories: ['weapon']),
  ForgeTrait(id: 'sleek_design', name: 'Finition lisse (Sleek)', dcMod: 5, cpCost: 3, effect: 'Sur coup critique massif : garde le meilleur dé doublé', eligibleCategories: ['weapon']),
  ForgeTrait(id: 'counterbalanced', name: 'Contrebalancée', dcMod: 5, cpCost: 4, effect: 'Sur coup critique massif : ajoute 1d12 aux dégâts', eligibleCategories: ['weapon']),
  ForgeTrait(id: 'wide_head', name: 'Tête large', dcMod: 5, cpCost: 4, effect: 'Sur coup critique massif : étourdit la cible (JS Force)', eligibleCategories: ['weapon']),
  ForgeTrait(id: 'thick_blade', name: 'Garde épaisse', dcMod: 5, cpCost: 2, effect: 'Avantage pour pousser la cible avec l\'arme', eligibleCategories: ['weapon']),
  ForgeTrait(id: 'extended_grip', name: 'Poignée allongée', dcMod: 5, cpCost: 3, effect: 'Perd la finesse, augmente le dé de polyvalence', eligibleCategories: ['weapon']),
  ForgeTrait(id: 'extended_haft', name: 'Manche rallongé', dcMod: 5, cpCost: 2, effect: 'Gagne "Portée" et "Peu maniable" (Unwieldy)', eligibleCategories: ['weapon']),
  ForgeTrait(id: 'serrated_edge', name: 'Fil dentelé (Serrated)', dcMod: 5, cpCost: 2, effect: 'Relancer les 1 sur les dégâts, garde le nouveau résultat', eligibleCategories: ['weapon']),
  ForgeTrait(id: 'keen_edge', name: 'Tranchant affûté (Keen)', dcMod: 6, cpCost: 3, effect: '+1 à la plage de coups critiques', eligibleCategories: ['weapon']),
  ForgeTrait(id: 'fitted_grip', name: 'Prise ajustée (Fitted)', dcMod: 6, cpCost: 3, effect: 'Peut infliger -3 à l\'attaque pour ajouter mod Dex aux dégâts', eligibleCategories: ['weapon']),
  
  // Armor / Shield traits
  ForgeTrait(id: 'sturdy_legs', name: 'Jambières rigides (Sturdy Legs)', dcMod: 3, cpCost: 1, effect: 'Avantage pour résister à la poussée, vitesse -5 ft.', eligibleCategories: ['armor']),
  ForgeTrait(id: 'padding', name: 'Rembourrage (Padding)', dcMod: 3, cpCost: 2, effect: 'Annule le désavantage en discrétion', eligibleCategories: ['armor']),
  ForgeTrait(id: 'spiked', name: 'Pointes (Spiked)', dcMod: 4, cpCost: 2, effect: 'D4 dégâts perforants lors d\'une lutte. Bouclier utilisable en arme (d4).', eligibleCategories: ['armor', 'shield']),
  ForgeTrait(id: 'reinforced', name: 'Renforcé (Reinforced)', dcMod: 5, cpCost: 2, effect: 'Avantage pour pousser si déplacé de 15ft. Bouclier : bonus de poussée.', eligibleCategories: ['armor', 'shield']),
  ForgeTrait(id: 'plating', name: 'Plaquage supplémentaire (Extra Plating)', dcMod: 5, cpCost: 3, effect: 'Réduit les dégâts physiques non-magiques de 1.', eligibleCategories: ['armor', 'shield']),
];

// --- DICE HELPER ---

String _incrementDiceSize(String dice) {
  const progression = ["1", "1d4", "1d6", "1d8", "2d4", "1d10", "1d12", "2d6", "2d8"];
  final idx = progression.indexOf(dice.trim());
  if (idx != -1 && idx < progression.length - 1) {
    return progression[idx + 1];
  }
  return dice;
}

// --- FORGE SCREEN WIDGET ---

class ForgeScreen extends ConsumerStatefulWidget {
  const ForgeScreen({super.key});

  @override
  ConsumerState<ForgeScreen> createState() => _ForgeScreenState();
}

class _ForgeScreenState extends ConsumerState<ForgeScreen> {
  // Config state
  String _selectedCategory = 'weapon';
  late ForgeItem _selectedItem;
  late ForgeMaterial _selectedMaterial;
  late ForgeTrait _selectedTrait;

  // Selected character link
  int? _selectedCharacterId;

  // Simulator stats (for manual entry)
  int _smithToolsMod = 5;
  int _conMod = 2;

  // Simulation run state
  int _currentCp = 0;
  int _totalRolls = 0;
  int _failedRolls = 0;
  int _ruinedRolls = 0;
  final List<String> _log = [];

  final _random = Random();

  @override
  void initState() {
    super.initState();
    _resetConfig();
  }

  void _resetConfig() {
    final categoryItems = _forgeItems.where((i) => i.category == _selectedCategory).toList();
    _selectedItem = categoryItems.first;
    _selectedMaterial = _forgeMaterials.first;
    _selectedTrait = _forgeTraits.firstWhere(
      (t) => t.eligibleCategories.contains(_selectedCategory) && t.id == 'none',
      orElse: () => _forgeTraits.first,
    );
    _resetSimulation();
  }

  void _resetSimulation() {
    setState(() {
      _currentCp = 0;
      _totalRolls = 0;
      _failedRolls = 0;
      _ruinedRolls = 0;
      _log.clear();
      _log.add(" Forge prête. Sélectionnez vos matériaux et commencez à forger !");
    });
  }

  // --- ACTIONS ---

  void _simulateSingleRoll(int activeSmithToolsMod) {
    final targetCp = _selectedItem.baseCp + _selectedTrait.cpCost;
    if (_currentCp >= targetCp) return;

    final dcOffset = _selectedMaterial.dcMod + _selectedTrait.dcMod;
    final ruinedThreshold = 0 + dcOffset;
    final steadyThreshold = 10 + dcOffset;
    final noteworthyThreshold = 20 + dcOffset;

    final d20 = _random.nextInt(20) + 1;
    final total = d20 + activeSmithToolsMod;

    String resultStr = "";

    if (total <= ruinedThreshold) {
      _ruinedRolls++;
      _currentCp = 0; // Ruined loses all progress
      resultStr = "💥 RUINÉ ! (Jet: $d20 + $activeSmithToolsMod = $total <= $ruinedThreshold). Tout le progrès est perdu !";
    } else if (total < steadyThreshold) {
      _failedRolls++;
      resultStr = "❌ Aucun progrès (Jet: $d20 + $activeSmithToolsMod = $total < $steadyThreshold).";
    } else if (total < noteworthyThreshold) {
      _currentCp = min(targetCp, _currentCp + 1);
      resultStr = "🔨 Progrès régulier (+1 PC) (Jet: $d20 + $activeSmithToolsMod = $total, requis >= $steadyThreshold).";
    } else {
      _currentCp = min(targetCp, _currentCp + 2);
      resultStr = "🔥 Progrès remarquable (+2 PC) (Jet: $d20 + $activeSmithToolsMod = $total, requis >= $noteworthyThreshold).";
    }

    setState(() {
      _totalRolls++;
      _log.insert(0, "[Jet #$_totalRolls] $resultStr");
      if (_currentCp >= targetCp) {
        _log.insert(0, "🎉 OBJET TERMINÉ en $_totalRolls tentatives !");
      }
    });
  }

  void _simulateEightHours(int activeSmithToolsMod, int activeConMod) {
    final targetCp = _selectedItem.baseCp + _selectedTrait.cpCost;
    if (_currentCp >= targetCp) return;

    // 8 hours yields Max(2, Con Mod - 1) attempts
    final attempts = max(2, activeConMod - 1);
    _log.insert(0, "⏱️ Début d'une journée de travail de 8 heures ($attempts tentatives de forge...)");
    
    for (int i = 0; i < attempts; i++) {
      if (_currentCp >= targetCp) break;
      _simulateSingleRoll(activeSmithToolsMod);
    }
  }

  // --- OUTPUT RENDER CALCULATIONS ---

  int get _calculatedMaterialCost {
    return ((_selectedItem.baseGp * _selectedMaterial.priceMod) * 0.8).round();
  }

  int get _calculatedTargetCp {
    return _selectedItem.baseCp + _selectedTrait.cpCost;
  }

  String get _calculatedItemName {
    String suffix = "";
    if (_selectedMaterial.id != 'steel') {
      suffix += " en ${_selectedMaterial.name.split(' (')[0]}";
    }
    if (_selectedTrait.id != 'none') {
      suffix += " (${_selectedTrait.name.split(' (')[0]})";
    }
    return "${_selectedItem.name}$suffix";
  }

  String get _calculatedDamageOrAc {
    if (_selectedItem.category == 'weapon') {
      String baseDie = _selectedItem.diceSize;
      if (_selectedMaterial.id == 'adamantium') {
        baseDie = _incrementDiceSize(baseDie);
      }
      String damageText = baseDie;
      if (_selectedMaterial.id == 'iron') {
        damageText += " - 1 (min 1)";
      }
      return "$damageText dégâts";
    } else {
      // Armor or Shield
      int baseAc = 0;
      bool isArmor = _selectedItem.category == 'armor';
      if (isArmor) {
        if (_selectedItem.id == 'breastplate') baseAc = 14;
        else if (_selectedItem.id == 'chainmail') baseAc = 16;
        else if (_selectedItem.id == 'chainshirt') baseAc = 13;
        else if (_selectedItem.id == 'halfplate') baseAc = 15;
        else if (_selectedItem.id == 'scalemail') baseAc = 14;
        else if (_selectedItem.id == 'splint') baseAc = 17;
        else if (_selectedItem.id == 'plate') baseAc = 18;
      } else {
        // Shield
        if (_selectedItem.id == 'buckler') baseAc = 1;
        else if (_selectedItem.id == 'shield') baseAc = 2;
        else if (_selectedItem.id == 'towershield') baseAc = 3;
      }
      int finalAc = baseAc;
      if (_selectedMaterial.id == 'iron') {
        finalAc -= 1;
      }
      return isArmor ? "CA $finalAc" : "CA +$finalAc";
    }
  }

  String get _calculatedWeight {
    final rawStr = _selectedItem.baseWeight.split(' ')[0];
    final double rawVal = double.tryParse(rawStr) ?? 1.0;
    double finalVal = rawVal;
    if (_selectedMaterial.id == 'mithral') {
      finalVal /= 2.0;
    } else if (_selectedMaterial.id == 'adamantium') {
      finalVal *= 2.0;
    }
    return "${finalVal.toStringAsFixed(finalVal == finalVal.roundToDouble() ? 0 : 1)} lbs";
  }

  // --- BUILD METHOD ---

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final targetCp = _calculatedTargetCp;
    final progressPct = targetCp > 0 ? (_currentCp / targetCp).clamp(0.0, 1.0) : 0.0;

    final dcOffset = _selectedMaterial.dcMod + _selectedTrait.dcMod;
    final ruinedThreshold = 0 + dcOffset;
    final steadyThreshold = 10 + dcOffset;
    final noteworthyThreshold = 20 + dcOffset;

    // --- Dynamic Character Loading Logic ---
    int finalConMod = _conMod;
    int finalSmithToolsMod = _smithToolsMod;
    int finalStrMod = 0;
    int finalDexMod = 0;
    bool isSmithToolsProficient = false;
    int profBonus = 2;

    final charactersAsync = ref.watch(charactersProvider);

    if (_selectedCharacterId != null) {
      final scoresAsync = ref.watch(characterAbilityScoresProvider(_selectedCharacterId!));
      final profsAsync = ref.watch(characterProficienciesProvider(_selectedCharacterId!));
      final totalLevelAsync = ref.watch(characterTotalLevelProvider(_selectedCharacterId!));

      if (scoresAsync.hasValue && totalLevelAsync.hasValue) {
        final scores = scoresAsync.value;
        final totalLevel = totalLevelAsync.value ?? 1;
        profBonus = DndRules.proficiencyBonus(totalLevel);

        if (scores != null) {
          finalStrMod = DndRules.modifier(scores.strength);
          finalDexMod = DndRules.modifier(scores.dexterity);
          finalConMod = DndRules.modifier(scores.constitution);
        }

        if (profsAsync.hasValue) {
          final profs = profsAsync.value ?? [];
          final profKeys = profs.map((p) => p.proficiencyKey.toLowerCase()).toSet();
          isSmithToolsProficient = profKeys.contains('smith_tools') || 
                                   profKeys.contains('smith\'s tools') ||
                                   profKeys.contains('smith') ||
                                   profKeys.contains('outils de forgeron') ||
                                   profKeys.any((k) => k.contains('smith') || k.contains('forgeron') || k.contains('artisan'));
        }

        // Compute tool mod based on the material's required stat
        final activeStatMod = (_selectedMaterial.stat == 'str') 
            ? finalStrMod 
            : ((_selectedMaterial.stat == 'dex') ? finalDexMod : finalConMod);
            
        finalSmithToolsMod = activeStatMod + (isSmithToolsProficient ? profBonus : 0);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.gavel, color: Colors.orange),
            SizedBox(width: 8),
            Text("La Forge d'Armes"),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetSimulation,
            tooltip: "Réinitialiser la simulation",
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 900;

          if (isMobile) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildConfigPanel(
                    colorScheme, 
                    charactersAsync, 
                    isSmithToolsProficient, 
                    profBonus, 
                    finalStrMod, 
                    finalDexMod, 
                    finalConMod, 
                    finalSmithToolsMod
                  ),
                  const SizedBox(height: 16),
                  _buildOutputCard(),
                  const SizedBox(height: 16),
                  _buildProgressCard(
                    colorScheme, 
                    progressPct, 
                    targetCp, 
                    ruinedThreshold, 
                    steadyThreshold, 
                    noteworthyThreshold, 
                    finalSmithToolsMod, 
                    finalConMod
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: _buildLogCard(),
                  ),
                ],
              ),
            );
          } else {
            // Desktop/Tablet Row layout
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 4,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _buildConfigPanel(
                      colorScheme, 
                      charactersAsync, 
                      isSmithToolsProficient, 
                      profBonus, 
                      finalStrMod, 
                      finalDexMod, 
                      finalConMod, 
                      finalSmithToolsMod
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                    child: Column(
                      children: [
                        _buildOutputCard(),
                        const SizedBox(height: 12),
                        _buildProgressCard(
                          colorScheme, 
                          progressPct, 
                          targetCp, 
                          ruinedThreshold, 
                          steadyThreshold, 
                          noteworthyThreshold, 
                          finalSmithToolsMod, 
                          finalConMod
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: _buildLogCard(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildConfigPanel(
    ColorScheme colorScheme,
    AsyncValue<List<Character>> charactersAsync,
    bool isSmithToolsProficient,
    int profBonus,
    int finalStrMod,
    int finalDexMod,
    int finalConMod,
    int finalSmithToolsMod,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("1. CONFIGURATEUR D'OBJET", style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary)),
            const SizedBox(height: 12),
            
            // Category Selector
            FittedBox(
              fit: BoxFit.scaleDown,
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'weapon', label: Text('Armes'), icon: Icon(Icons.colorize)),
                  ButtonSegment(value: 'armor', label: Text('Armures'), icon: Icon(Icons.shield_outlined)),
                  ButtonSegment(value: 'shield', label: Text('Boucliers'), icon: Icon(Icons.shield)),
                ],
                selected: {_selectedCategory},
                onSelectionChanged: (set) {
                  setState(() {
                    _selectedCategory = set.first;
                    _resetConfig();
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            // Item Dropdown
            DropdownButtonFormField<ForgeItem>(
              decoration: const InputDecoration(labelText: "Objet à forger", border: OutlineInputBorder()),
              value: _selectedItem,
              items: _forgeItems
                  .where((i) => i.category == _selectedCategory)
                  .map((i) => DropdownMenuItem(value: i, child: Text("${i.name} (${i.baseGp} po, ${i.baseCp} PC)")))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedItem = val;
                    _resetSimulation();
                  });
                }
              },
            ),
            const SizedBox(height: 12),

            // Material Dropdown
            DropdownButtonFormField<ForgeMaterial>(
              decoration: const InputDecoration(labelText: "Matériau employé", border: OutlineInputBorder()),
              value: _selectedMaterial,
              items: _forgeMaterials
                  .map((m) => DropdownMenuItem(value: m, child: Text("${m.name} (DC: ${m.dcMod >= 0 ? '+' : ''}${m.dcMod})")))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedMaterial = val;
                    _resetSimulation();
                  });
                }
              },
            ),
            const SizedBox(height: 12),

            // Trait Dropdown
            DropdownButtonFormField<ForgeTrait>(
              decoration: const InputDecoration(labelText: "Trait forgé de départ", border: OutlineInputBorder()),
              value: _selectedTrait,
              items: _forgeTraits
                  .where((t) => t.eligibleCategories.contains(_selectedCategory))
                  .map((t) => DropdownMenuItem(value: t, child: Text("${t.name} (DC: +${t.dcMod}, +${t.cpCost} PC)")))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedTrait = val;
                    _resetSimulation();
                  });
                }
              },
            ),
            
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            Text("2. CONFIGURATION DU FORGERON", style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary)),
            const SizedBox(height: 12),

            // Associated Character Dropdown
            DropdownButtonFormField<int?>(
              decoration: const InputDecoration(
                labelText: "Personnage associé", 
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              value: _selectedCharacterId,
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text("Saisie manuelle (Manuel)"),
                ),
                if (charactersAsync.hasValue)
                  ...?charactersAsync.value?.map(
                    (c) => DropdownMenuItem<int?>(
                      value: c.id,
                      child: Text(c.name),
                    ),
                  ),
              ],
              onChanged: (val) {
                setState(() {
                  _selectedCharacterId = val;
                  _resetSimulation();
                });
              },
            ),
            const SizedBox(height: 16),

            // Conditional Inputs (Manual vs. Loaded Stats)
            if (_selectedCharacterId != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.cloud_download_outlined, size: 16, color: Colors.orangeAccent),
                        const SizedBox(width: 6),
                        Text("Données chargées :", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[400])),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Caractéristiques : FOR: ${finalStrMod >= 0 ? '+' : ''}$finalStrMod | DEX: ${finalDexMod >= 0 ? '+' : ''}$finalDexMod | CON: ${finalConMod >= 0 ? '+' : ''}$finalConMod",
                      style: const TextStyle(fontSize: 11),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Maîtrise Outils de Forgeron : ${isSmithToolsProficient ? 'Oui (+$profBonus)' : 'Non (+0)'}",
                      style: const TextStyle(fontSize: 11),
                    ),
                    const SizedBox(height: 6),
                    const Divider(),
                    const SizedBox(height: 4),
                    Text(
                      "Mod. Outils final : +$finalSmithToolsMod",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                    ),
                    Text(
                      "(Basé sur ${_selectedMaterial.stat.toUpperCase()} + Maîtrise)",
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      key: const Key('manual_smith_tools'),
                      initialValue: _smithToolsMod.toString(),
                      decoration: const InputDecoration(labelText: "Mod. Outils", border: OutlineInputBorder(), prefixIcon: Icon(Icons.handyman)),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _smithToolsMod = int.tryParse(v) ?? 5,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      key: const Key('manual_con'),
                      initialValue: _conMod.toString(),
                      decoration: const InputDecoration(labelText: "Mod. Con.", border: OutlineInputBorder(), prefixIcon: Icon(Icons.favorite)),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _conMod = int.tryParse(v) ?? 2,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOutputCard() {
    return Card(
      color: Colors.orange.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.orange.withValues(alpha: 0.3), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _calculatedItemName.toUpperCase(),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                  child: Text("${_calculatedTargetCp} PC requis", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                Chip(label: Text(_calculatedDamageOrAc, style: const TextStyle(fontSize: 10))),
                Chip(label: Text("Poids : $_calculatedWeight", style: const TextStyle(fontSize: 10))),
                Chip(label: Text("Coût : $_calculatedMaterialCost po", style: const TextStyle(fontSize: 10))),
                Chip(label: Text("Carac. : ${_selectedMaterial.stat.toUpperCase()}", style: const TextStyle(fontSize: 10))),
              ],
            ),
            const SizedBox(height: 8),
            if (_selectedMaterial.id != 'steel') ...[
              Text("Matériau (${_selectedMaterial.name}) :", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Text(_selectedMaterial.effect, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(height: 4),
            ],
            if (_selectedTrait.id != 'none') ...[
              Text("Trait forgé (${_selectedTrait.name}) :", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Text(_selectedTrait.effect, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(
    ColorScheme colorScheme,
    double progressPct,
    int targetCp,
    int ruinedThreshold,
    int steadyThreshold,
    int noteworthyThreshold,
    int finalSmithToolsMod,
    int finalConMod,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Progrès de forge : $_currentCp / $targetCp PC", style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("${(progressPct * 100).toStringAsFixed(0)}%"),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progressPct,
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
              color: Colors.orange,
              backgroundColor: colorScheme.surfaceContainerHighest,
            ),
            const SizedBox(height: 6),
            Text(
              "Tentatives : $_totalRolls | Échecs : $_failedRolls | Ruines : $_ruinedRolls",
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                children: [
                  Text("Seuils : ", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  Text("Ruine <= $ruinedThreshold | Régulier >= $steadyThreshold | Remarquable >= $noteworthyThreshold", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _currentCp >= targetCp ? null : () => _simulateSingleRoll(finalSmithToolsMod),
                    icon: const Icon(Icons.casino, size: 16),
                    label: const Text("1 jet d20", style: TextStyle(fontSize: 11)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange.withValues(alpha: 0.15),
                      foregroundColor: Colors.orangeAccent,
                    ),
                    onPressed: _currentCp >= targetCp ? null : () => _simulateEightHours(finalSmithToolsMod, finalConMod),
                    icon: const Icon(Icons.schedule, size: 16),
                    label: const Text("Journée 8h", style: TextStyle(fontSize: 11)),
                  ),
                ),
              ],
            ),
            // Export to character sheet button (shown when item is complete and character is selected)
            if (_currentCp >= targetCp && _selectedCharacterId != null) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.green.withValues(alpha: 0.2),
                  foregroundColor: Colors.greenAccent,
                ),
                onPressed: () => _addToCharacterSheet(
                  context,
                  _selectedCharacterId!,
                  finalSmithToolsMod,
                  ref,
                ),
                icon: const Icon(Icons.add_circle_outline, size: 16),
                label: Text(
                  'Ajouter à la fiche de personnage',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _addToCharacterSheet(
    BuildContext context,
    int characterId,
    int attackBonus,
    WidgetRef ref,
  ) async {
    // Pre-fill damage type based on category
    String suggestedType;
    if (_selectedItem.category == 'shield') {
      suggestedType = 'contondants';
    } else {
      // Guess based on item name/properties
      final props = _selectedItem.properties.toLowerCase();
      if (props.contains('perfor') || _selectedItem.id.contains('rapier') || _selectedItem.id.contains('spear') || _selectedItem.id.contains('arrow')) {
        suggestedType = 'perforants';
      } else if (props.contains('tranchant') || _selectedItem.id.contains('axe') || _selectedItem.id.contains('sword') || _selectedItem.id.contains('scimitar') || _selectedItem.id.contains('sickle') || _selectedItem.id.contains('glaive') || _selectedItem.id.contains('halberd') || _selectedItem.id.contains('dagger') || _selectedItem.id.contains('falchion')) {
        suggestedType = 'tranchants';
      } else {
        suggestedType = 'contondants';
      }
    }

    final damageTypeController = TextEditingController(text: suggestedType);
    bool addToInventory = true;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Ajouter à la fiche de personnage'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.gavel, color: Colors.orangeAccent),
                  title: Text(_calculatedItemName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('$_calculatedDamageOrAc • ${_calculatedTargetCp} PC'),
                  contentPadding: EdgeInsets.zero,
                ),
                const Divider(),
                const SizedBox(height: 8),
                TextField(
                  controller: damageTypeController,
                  decoration: InputDecoration(
                    labelText: 'Type de dégâts',
                    hintText: suggestedType,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.colorize),
                  ),
                ),
                const SizedBox(height: 12),
                CheckboxListTile(
                  title: const Text('Ajouter aussi à l\'inventaire'),
                  value: addToInventory,
                  onChanged: (v) => setState(() => addToInventory = v ?? true),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    try {
      final db = ref.read(databaseProvider);

      // Insert into CharacterAttacks
      if (_selectedItem.category == 'weapon') {
        final bonusStr = attackBonus >= 0 ? '+$attackBonus' : '$attackBonus';
        await db.characterDao.insertAttack(
          CharacterAttacksCompanion.insert(
            characterId: characterId,
            name: _calculatedItemName,
            attackBonus: bonusStr,
            damageDice: _calculatedDamageOrAc.replaceAll(' dégâts', ''),
            damageType: damageTypeController.text.trim().isEmpty
                ? suggestedType
                : damageTypeController.text.trim(),
            notes: Value('Forgé (${_selectedMaterial.name})${_selectedTrait.id != "none" ? " – ${_selectedTrait.name}" : ""}'),
          ),
        );
      }

      // Insert into CharacterEquipment if checkbox is checked
      if (addToInventory) {
        await db.characterDao.insertEquipment(
          CharacterEquipmentCompanion.insert(
            characterId: characterId,
            itemName: _calculatedItemName,
            weight: Value(double.tryParse(_calculatedWeight.replaceAll(' lbs', '')) ?? 0.0),
            equipped: const Value(false),
            notes: Value('${_selectedItem.properties}${_selectedMaterial.id != "steel" ? " | ${_selectedMaterial.effect}" : ""}'),
          ),
        );
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ "$_calculatedItemName" ajouté à la fiche !'),
            backgroundColor: Colors.green.shade700,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout : $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _buildLogCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("REGISTRE DU SOUFFLET (JOURNAL DE FORGE)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: _log.length,
                  itemBuilder: (ctx, i) {
                    final item = _log[i];
                    Color col = Colors.white;
                    if (item.contains("💥")) col = Colors.redAccent;
                    else if (item.contains("🔨")) col = Colors.orangeAccent;
                    else if (item.contains("🔥")) col = Colors.yellowAccent;
                    else if (item.contains("🎉")) col = Colors.greenAccent;
                    else if (item.contains("⏱️")) col = Colors.lightBlueAccent;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        item,
                        style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: col),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
