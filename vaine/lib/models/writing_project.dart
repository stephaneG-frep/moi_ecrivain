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
    this.outlineBeginning = '',
    this.outlineTrigger = '',
    this.outlineConflicts = '',
    this.outlineClimax = '',
    this.outlineEnding = '',
    this.dailyWordGoal = 500,
    Map<String, int>? dailyWordCounts,
    this.aiProvider = 'Aucun',
    this.aiApiKey = '',
    this.aiModel = '',
    this.ollamaUrl = 'http://localhost:11434',
  })  : updatedAt = updatedAt ?? DateTime.now(),
        chapters = chapters ?? [],
        characters = characters ?? [],
        locations = locations ?? [],
        ideas = ideas ?? [],
        dailyWordCounts = dailyWordCounts ?? {};

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
  String outlineBeginning;
  String outlineTrigger;
  String outlineConflicts;
  String outlineClimax;
  String outlineEnding;
  int dailyWordGoal;
  Map<String, int> dailyWordCounts;
  String aiProvider;
  String aiApiKey;
  String aiModel;
  String ollamaUrl;

  int get wordCount => chapters.fold(0, (total, chapter) => total + chapter.wordCount);
  double get progress => wordGoal <= 0 ? 0 : (wordCount / wordGoal).clamp(0, 1);
  int wordsForDate(DateTime date) => dailyWordCounts[_dateKey(date)] ?? 0;
  int get wordsToday => wordsForDate(DateTime.now());
  double get dailyProgress => dailyWordGoal <= 0 ? 0 : (wordsToday / dailyWordGoal).clamp(0, 1);
  int get writingStreak {
    var streak = 0;
    var day = DateTime.now();
    while ((dailyWordCounts[_dateKey(day)] ?? 0) > 0) {
      streak += 1;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }

  static String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

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
        'outlineBeginning': outlineBeginning,
        'outlineTrigger': outlineTrigger,
        'outlineConflicts': outlineConflicts,
        'outlineClimax': outlineClimax,
        'outlineEnding': outlineEnding,
        'dailyWordGoal': dailyWordGoal,
        'dailyWordCounts': dailyWordCounts,
        'aiProvider': aiProvider,
        'aiApiKey': aiApiKey,
        'aiModel': aiModel,
        'ollamaUrl': ollamaUrl,
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
        outlineBeginning: (map['outlineBeginning'] ?? '') as String,
        outlineTrigger: (map['outlineTrigger'] ?? '') as String,
        outlineConflicts: (map['outlineConflicts'] ?? '') as String,
        outlineClimax: (map['outlineClimax'] ?? '') as String,
        outlineEnding: (map['outlineEnding'] ?? '') as String,
        dailyWordGoal: (map['dailyWordGoal'] ?? 500) as int,
        dailyWordCounts: Map<String, int>.from(map['dailyWordCounts'] ?? {}),
        aiProvider: (map['aiProvider'] ?? 'Aucun') as String,
        aiApiKey: (map['aiApiKey'] ?? '') as String,
        aiModel: (map['aiModel'] ?? '') as String,
        ollamaUrl: (map['ollamaUrl'] ?? 'http://localhost:11434') as String,
      );
}
