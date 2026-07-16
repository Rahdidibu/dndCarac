import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import '../database/app_database.dart';

class BatmanSeeder {
  final AppDatabase db;
  BatmanSeeder(this.db);

  Future<void> seedIfNeeded() async {
    final alreadySeeded = await db.batmanDao.isSeeded();
    if (alreadySeeded) return;
    await _seedProfiles();
    await _seedWays();
  }

  Future<void> _seedProfiles() async {
    final raw = await rootBundle
        .loadString('assets/data/Batman/profiles.json');
    final List<dynamic> list = json.decode(raw);
    for (final item in list) {
      await db.batmanDao.upsertProfile(BatmanProfilesCompanion.insert(
        id: item['id'] as String,
        name: item['name'] as String,
        mode: item['mode'] as String,
        hitDie: item['hitDie'] as String,
        atcBonus: Value(item['atcBonus'] as int),
        atdBonus: Value(item['atdBonus'] as int),
        atsBonus: Value(item['atsBonus'] as int),
        exploitPoints: Value(item['exploitPoints'] as int),
        capabilityPoints: Value(item['capabilityPoints'] as int),
        primaryAbilityWithEdge:
            json.encode(item['primaryAbilityWithEdge']),
        initialWays: json.encode(item['initialWays']),
        extraWays: Value(item['extraWays'] as int),
        extraWaysPool: Value(item['extraWaysPool'] as String?),
        livingStandard: item['livingStandard'] as String,
        description: item['description'] as String,
      ));
    }
  }

  Future<void> _seedWays() async {
    final raw = await rootBundle
        .loadString('assets/data/Batman/ways.json');
    final List<dynamic> list = json.decode(raw);
    for (final item in list) {
      await db.batmanDao.upsertWay(BatmanWaysCompanion.insert(
        id: item['id'] as String,
        name: item['name'] as String,
        type: item['type'] as String,
        prerequisite: Value(item['prerequisite'] as String?),
        ranksJson: json.encode(item['ranks']),
      ));
    }
  }
}

