import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/chapter.dart';
import '../models/character.dart';
import '../models/location.dart';
import '../models/story_idea.dart';
import '../models/writing_project.dart';
import '../services/storage_service.dart';

class ProjectProvider extends ChangeNotifier {
  ProjectProvider(this._storageService);

  final StorageService _storageService;
  final _uuid = const Uuid();
  List<WritingProject> _projects = [];
  bool _isLoading = true;

  List<WritingProject> get projects => List.unmodifiable(_projects);
  bool get isLoading => _isLoading;

  Future<void> loadProjects() async {
    _isLoading = true;
    notifyListeners();
    _projects = await _storageService.loadProjects();
    _isLoading = false;
    notifyListeners();
  }

  WritingProject? findById(String id) {
    for (final project in _projects) {
      if (project.id == id) return project;
    }
    return null;
  }

  Future<void> addProject({
    required String title,
    required String type,
    required String genre,
    required String summary,
    required int wordGoal,
    required String tone,
  }) async {
    final project = WritingProject(
      id: _uuid.v4(),
      title: title,
      type: type,
      genre: genre,
      summary: summary,
      wordGoal: wordGoal,
      tone: tone,
      chapters: [Chapter(id: _uuid.v4(), title: 'Chapitre 1')],
    );
    _projects.insert(0, project);
    await _persist();
  }

  Future<void> touch(WritingProject project) async {
    project.updatedAt = DateTime.now();
    await _persist();
  }

  Future<void> addChapter(WritingProject project) async {
    project.chapters.add(Chapter(id: _uuid.v4(), title: 'Nouveau chapitre'));
    await touch(project);
  }

  Future<void> renameChapter(WritingProject project, Chapter chapter, String title) async {
    chapter.title = title;
    await touch(project);
  }

  Future<void> deleteChapter(WritingProject project, Chapter chapter) async {
    project.chapters.removeWhere((item) => item.id == chapter.id);
    await touch(project);
  }

  Future<void> reorderChapters(WritingProject project, int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;
    final chapter = project.chapters.removeAt(oldIndex);
    project.chapters.insert(newIndex, chapter);
    await touch(project);
  }

  Future<void> saveChapter(WritingProject project, Chapter chapter, String content) async {
    chapter.content = content;
    chapter.updatedAt = DateTime.now();
    await touch(project);
  }

  Future<void> upsertCharacter(WritingProject project, StoryCharacter character) async {
    final index = project.characters.indexWhere((item) => item.id == character.id);
    index == -1 ? project.characters.add(character) : project.characters[index] = character;
    await touch(project);
  }

  Future<void> deleteCharacter(WritingProject project, StoryCharacter character) async {
    project.characters.removeWhere((item) => item.id == character.id);
    await touch(project);
  }

  Future<void> upsertLocation(WritingProject project, StoryLocation location) async {
    final index = project.locations.indexWhere((item) => item.id == location.id);
    index == -1 ? project.locations.add(location) : project.locations[index] = location;
    await touch(project);
  }

  Future<void> deleteLocation(WritingProject project, StoryLocation location) async {
    project.locations.removeWhere((item) => item.id == location.id);
    await touch(project);
  }

  Future<void> upsertIdea(WritingProject project, StoryIdea idea) async {
    final index = project.ideas.indexWhere((item) => item.id == idea.id);
    index == -1 ? project.ideas.add(idea) : project.ideas[index] = idea;
    await touch(project);
  }

  Future<void> deleteIdea(WritingProject project, StoryIdea idea) async {
    project.ideas.removeWhere((item) => item.id == idea.id);
    await touch(project);
  }

  StoryCharacter newCharacter() => StoryCharacter(id: _uuid.v4(), name: '');
  StoryLocation newLocation() => StoryLocation(id: _uuid.v4(), name: '');
  StoryIdea newIdea() => StoryIdea(id: _uuid.v4(), type: 'idee de scene', text: '');

  Future<void> _persist() async {
    await _storageService.saveProjects(_projects);
    notifyListeners();
  }
}
