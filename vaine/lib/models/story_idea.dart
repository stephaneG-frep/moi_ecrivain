class StoryIdea {
  StoryIdea({
    required this.id,
    required this.type,
    required this.text,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String id;
  String type;
  String text;
  DateTime createdAt;

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'text': text,
        'createdAt': createdAt.toIso8601String(),
      };

  factory StoryIdea.fromMap(Map<dynamic, dynamic> map) => StoryIdea(
        id: map['id'] as String,
        type: (map['type'] ?? 'idee de scene') as String,
        text: (map['text'] ?? '') as String,
        createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      );
}
