import 'chapter.dart';
import 'character.dart';
import 'location.dart';
import 'story_idea.dart';

class WritingProject {
  WritingProject({
    required this.id,
    required this.title,
    required this.type,
    required this.genre,
    required this.summary,
    required this.wordGoal,
    required this.tone,
    DateTime? updatedAt,
    List<Chapter>? chapters,
    List<StoryCharacter>? characters,
    List<StoryLocation>? locations,
    List<StoryIdea>? ideas,
  })  : updatedAt = updatedAt ?? DateTime.now(),
        chapters = chapters ?? [],
        characters = characters ?? [],
        locations = locations ?? [],
        ideas = ideas ?? [];

  final String id;
  String title;
  String type;
  String genre;
  String summary;
  int wordGoal;
  String tone;
  DateTime updatedAt;
  List<Chapter> chapters;
  List<StoryCharacter> characters;
  List<StoryLocation> locations;
  List<StoryIdea> ideas;

  int get wordCount => chapters.fold(0, (total, chapter) => total + chapter.wordCount);
  double get progress => wordGoal <= 0 ? 0 : (wordCount / wordGoal).clamp(0, 1);

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'type': type,
        'genre': genre,
        'summary': summary,
        'wordGoal': wordGoal,
        'tone': tone,
        'updatedAt': updatedAt.toIso8601String(),
        'chapters': chapters.map((chapter) => chapter.toMap()).toList(),
        'characters': characters.map((character) => character.toMap()).toList(),
        'locations': locations.map((location) => location.toMap()).toList(),
        'ideas': ideas.map((idea) => idea.toMap()).toList(),
      };

  factory WritingProject.fromMap(Map<dynamic, dynamic> map) => WritingProject(
        id: map['id'] as String,
        title: (map['title'] ?? '') as String,
        type: (map['type'] ?? 'roman') as String,
        genre: (map['genre'] ?? 'fantastique') as String,
        summary: (map['summary'] ?? '') as String,
        wordGoal: (map['wordGoal'] ?? 50000) as int,
        tone: (map['tone'] ?? 'mysterieux') as String,
        updatedAt: DateTime.tryParse(map['updatedAt'] ?? '') ?? DateTime.now(),
        chapters: ((map['chapters'] ?? []) as List)
            .map((item) => Chapter.fromMap(item as Map<dynamic, dynamic>))
            .toList(),
        characters: ((map['characters'] ?? []) as List)
            .map((item) => StoryCharacter.fromMap(item as Map<dynamic, dynamic>))
            .toList(),
        locations: ((map['locations'] ?? []) as List)
            .map((item) => StoryLocation.fromMap(item as Map<dynamic, dynamic>))
            .toList(),
        ideas: ((map['ideas'] ?? []) as List)
            .map((item) => StoryIdea.fromMap(item as Map<dynamic, dynamic>))
            .toList(),
      );
}
