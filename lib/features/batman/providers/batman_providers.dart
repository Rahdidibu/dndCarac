import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/database_provider.dart';

// ── Compendium providers ────────────────────────────────────

final batmanProfilesProvider = FutureProvider<List<BatmanProfile>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.batmanDao.getAllProfiles();
});

final batmanWaysProvider = FutureProvider<List<BatmanWay>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.batmanDao.getAllWays();
});

// ── Character providers ─────────────────────────────────────

final batmanCharacterProvider =
    StreamProvider.family<BatmanCharacter?, int>((ref, characterId) {
  final db = ref.watch(databaseProvider);
  return db.batmanDao.watchBatmanCharacter(characterId);
});

final batmanCharacterWaysProvider =
    StreamProvider.family<List<BatmanCharacterWay>, int>((ref, characterId) {
  final db = ref.watch(databaseProvider);
  return db.batmanDao.watchCharacterWays(characterId);
});

// ── Wizard state ─────────────────────────────────────────────

class BatmanWizardState {
  // Step 1 – identity
  final String name;
  final String playerName;
  final String secretIdentity;
  final String mode; // rues, ombres, prodiges

  // Step 2 – profile
  final String? profileId;

  // Step 3 – ability scores (FOR, CON, DEX, INT, PER, VOL)
  final Map<String, int> abilityScores;
  final int pointsRemaining; // computed

  // Step 4 – ways selection
  final List<String> selectedWayIds;

  // Step 5 – ethics
  final int ethicsOrder;
  final int ethicsJustice;
  final int ethicsAnarchy;
  final int ethicsCrime;

  const BatmanWizardState({
    this.name = '',
    this.playerName = '',
    this.secretIdentity = '',
    this.mode = 'rues',
    this.profileId,
    this.abilityScores = const {
      'for': 8,
      'con': 8,
      'dex': 8,
      'int': 8,
      'per': 8,
      'vol': 8,
    },
    this.pointsRemaining = 18,
    this.selectedWayIds = const [],
    this.ethicsOrder = 0,
    this.ethicsJustice = 0,
    this.ethicsAnarchy = 0,
    this.ethicsCrime = 0,
  });

  bool get isStep1Valid => name.trim().isNotEmpty;
  bool get isStep2Valid => profileId != null;

  int get totalAbilityPoints {
    // Cost table: 8=0, 9=1, 10=2, 11=3, 12=4, 13=5, 14=7, 15=9, 16=12, 17=15, 18=18
    const costs = {
      8: 0, 9: 1, 10: 2, 11: 3, 12: 4, 13: 5,
      14: 7, 15: 9, 16: 12, 17: 15, 18: 18,
    };
    int budget;
    if (mode == 'rues') {
      budget = 18; // 14-18 points
    } else {
      budget = 24; // 18-24 points
    }
    final spent = abilityScores.values.fold(0, (s, v) => s + (costs[v] ?? 0));
    return budget - spent;
  }

  BatmanWizardState copyWith({
    String? name,
    String? playerName,
    String? secretIdentity,
    String? mode,
    String? profileId,
    Map<String, int>? abilityScores,
    List<String>? selectedWayIds,
    int? ethicsOrder,
    int? ethicsJustice,
    int? ethicsAnarchy,
    int? ethicsCrime,
  }) {
    return BatmanWizardState(
      name: name ?? this.name,
      playerName: playerName ?? this.playerName,
      secretIdentity: secretIdentity ?? this.secretIdentity,
      mode: mode ?? this.mode,
      profileId: profileId ?? this.profileId,
      abilityScores: abilityScores ?? this.abilityScores,
      selectedWayIds: selectedWayIds ?? this.selectedWayIds,
      ethicsOrder: ethicsOrder ?? this.ethicsOrder,
      ethicsJustice: ethicsJustice ?? this.ethicsJustice,
      ethicsAnarchy: ethicsAnarchy ?? this.ethicsAnarchy,
      ethicsCrime: ethicsCrime ?? this.ethicsCrime,
    );
  }
}

class BatmanWizardNotifier extends StateNotifier<BatmanWizardState> {
  BatmanWizardNotifier() : super(const BatmanWizardState());

  void setName(String v) => state = state.copyWith(name: v);
  void setPlayerName(String v) => state = state.copyWith(playerName: v);
  void setSecretIdentity(String v) =>
      state = state.copyWith(secretIdentity: v);
  void setMode(String v) {
    state = state.copyWith(
      mode: v,
      abilityScores: {
        'for': 8, 'con': 8, 'dex': 8, 'int': 8, 'per': 8, 'vol': 8
      },
    );
  }

  void setProfile(String? id) => state = state.copyWith(profileId: id);

  void setAbilityScore(String ability, int value) {
    final updated = Map<String, int>.from(state.abilityScores);
    updated[ability] = value;
    state = state.copyWith(abilityScores: updated);
  }

  void toggleWay(String wayId) {
    final current = [...state.selectedWayIds];
    if (current.contains(wayId)) {
      current.remove(wayId);
    } else {
      current.add(wayId);
    }
    state = state.copyWith(selectedWayIds: current);
  }

  void setWays(List<String> ways) =>
      state = state.copyWith(selectedWayIds: ways);

  void setEthics({int? order, int? justice, int? anarchy, int? crime}) {
    state = state.copyWith(
      ethicsOrder: order ?? state.ethicsOrder,
      ethicsJustice: justice ?? state.ethicsJustice,
      ethicsAnarchy: anarchy ?? state.ethicsAnarchy,
      ethicsCrime: crime ?? state.ethicsCrime,
    );
  }

  void reset() => state = const BatmanWizardState();
}

final batmanWizardProvider =
    StateNotifierProvider.autoDispose<BatmanWizardNotifier, BatmanWizardState>(
  (ref) => BatmanWizardNotifier(),
);

// ── Helpers ──────────────────────────────────────────────────

/// Parse ways ranks from JSON
List<Map<String, dynamic>> parseWayRanks(String ranksJson) {
  final List<dynamic> list = json.decode(ranksJson);
  return list.cast<Map<String, dynamic>>();
}

/// Get ability modifier (Batman RPG same table as D&D)
int abilityModifier(int value) {
  return ((value - 10) / 2).floor();
}

/// Compute defense from DEX modifier
int computeDefense(int dexScore) => 10 + abilityModifier(dexScore);

/// Compute initiative from PER modifier
int computeInitiative(int perScore) => abilityModifier(perScore);

/// Map ability key to display name
String abilityDisplayName(String key) {
  const names = {
    'for': 'Force (FOR)',
    'con': 'Constitution (CON)',
    'dex': 'Dextérité (DEX)',
    'int': 'Intelligence (INT)',
    'per': 'Perception (PER)',
    'vol': 'Volonté (VOL)',
  };
  return names[key] ?? key.toUpperCase();
}

String abilityShortName(String key) {
  const names = {
    'for': 'FOR',
    'con': 'CON',
    'dex': 'DEX',
    'int': 'INT',
    'per': 'PER',
    'vol': 'VOL',
  };
  return names[key] ?? key.toUpperCase();
}

/// Compute HP from hit die and CON modifier
int computeBatmanHP(String hitDie, int conScore) {
  final dieMax = int.parse(hitDie.replaceAll('D', ''));
  final conMod = abilityModifier(conScore);
  return dieMax + conMod;
}




