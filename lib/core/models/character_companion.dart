class CharacterCompanion {
  final int id;
  final int characterId;
  final String name;
  final String type;
  final int hpCurrent;
  final int hpMax;
  final int armorClass;
  final String speed;
  final String attacks;
  final String notes;
  final DateTime createdAt;

  const CharacterCompanion({
    required this.id,
    required this.characterId,
    required this.name,
    required this.type,
    required this.hpCurrent,
    required this.hpMax,
    required this.armorClass,
    required this.speed,
    required this.attacks,
    required this.notes,
    required this.createdAt,
  });

  factory CharacterCompanion.fromJson(Map<String, dynamic> json) {
    return CharacterCompanion(
      id: json['id'] as int? ?? 0,
      characterId: json['characterId'] as int? ?? json['character_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? 'Familier',
      hpCurrent: json['hpCurrent'] as int? ?? json['hp_current'] as int? ?? 1,
      hpMax: json['hpMax'] as int? ?? json['hp_max'] as int? ?? 1,
      armorClass: json['armorClass'] as int? ?? json['armor_class'] as int? ?? 10,
      speed: json['speed'] as String? ?? '9 m',
      attacks: json['attacks'] as String? ?? '[]',
      notes: json['notes'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : (json['created_at'] != null
              ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
              : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'character_id': characterId,
      'name': name,
      'type': type,
      'hp_current': hpCurrent,
      'hp_max': hpMax,
      'armor_class': armorClass,
      'speed': speed,
      'attacks': attacks,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  CharacterCompanion copyWith({
    int? id,
    int? characterId,
    String? name,
    String? type,
    int? hpCurrent,
    int? hpMax,
    int? armorClass,
    String? speed,
    String? attacks,
    String? notes,
    DateTime? createdAt,
  }) {
    return CharacterCompanion(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      name: name ?? this.name,
      type: type ?? this.type,
      hpCurrent: hpCurrent ?? this.hpCurrent,
      hpMax: hpMax ?? this.hpMax,
      armorClass: armorClass ?? this.armorClass,
      speed: speed ?? this.speed,
      attacks: attacks ?? this.attacks,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
