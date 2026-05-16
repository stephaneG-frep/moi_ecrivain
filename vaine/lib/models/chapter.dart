class Chapter {
  Chapter({
    required this.id,
    required this.title,
    this.content = '',
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  final String id;
  String title;
  String content;
  DateTime updatedAt;

  int get wordCount => content.trim().isEmpty
      ? 0
      : content.trim().split(RegExp(r'\s+')).length;

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'content': content,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Chapter.fromMap(Map<dynamic, dynamic> map) => Chapter(
        id: map['id'] as String,
        title: map['title'] as String,
        content: (map['content'] ?? '') as String,
        updatedAt: DateTime.tryParse(map['updatedAt'] ?? '') ?? DateTime.now(),
      );
}
