class CharacterNote {
  final int id;
  final int characterId;
  final String category;
  final String title;
  final String content;
  final bool isPinned;
  final String createdAt;
  final String updatedAt;

  const CharacterNote({
    required this.id,
    required this.characterId,
    required this.category,
    required this.title,
    required this.content,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CharacterNote.fromJson(Map<String, dynamic> json) {
    return CharacterNote(
      id: json['id'] as int,
      characterId: json['characterId'] as int? ?? json['character_id'] as int? ?? 0,
      category: json['category'] as String? ?? 'journal',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      isPinned: json['isPinned'] as bool? ?? json['is_pinned'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? json['created_at'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? json['updated_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'character_id': characterId,
      'category': category,
      'title': title,
      'content': content,
      'is_pinned': isPinned,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
