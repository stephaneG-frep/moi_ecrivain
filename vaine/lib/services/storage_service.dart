import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../models/chapter.dart';
import '../models/character.dart';
import '../models/location.dart';
import '../models/story_idea.dart';
import '../models/writing_project.dart';

class StorageService {
  static const _boxName = 'storyforge_projects';
  static const _projectsKey = 'projects';

  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
    if (!_box.containsKey(_projectsKey)) {
      await saveProjects(_sampleProjects());
    }
  }

  Future<List<WritingProject>> loadProjects() async {
    final rawProjects = (_box.get(_projectsKey, defaultValue: []) as List).cast<dynamic>();
    return rawProjects
        .map((item) => WritingProject.fromMap(item as Map<dynamic, dynamic>))
        .toList();
  }

  Future<void> saveProjects(List<WritingProject> projects) async {
    await _box.put(_projectsKey, projects.map((project) => project.toMap()).toList());
  }

  List<WritingProject> _sampleProjects() {
    const uuid = Uuid();
    return [
      WritingProject(
        id: uuid.v4(),
        title: 'La ville sous la brume',
        type: 'roman',
        genre: 'fantastique',
        summary: 'Une cartographe decouvre une ville qui change de rues chaque nuit.',
        wordGoal: 60000,
        tone: 'mysterieux',
        chapters: [
          Chapter(
            id: uuid.v4(),
            title: 'Chapitre 1 - Les rues mouvantes',
            content:
                'La brume descendait comme une main lente sur les toits. Elia suivit la carte, puis comprit que la carte mentait.',
          ),
          Chapter(id: uuid.v4(), title: 'Chapitre 2 - La porte sans maison'),
        ],
        characters: [
          StoryCharacter(
            id: uuid.v4(),
            name: 'Elia Marcen',
            age: '29',
            role: 'Heroine',
            personality: 'Patiente, ironique, curieuse',
            goal: 'Retrouver son frere disparu',
            fear: 'Perdre le sens du reel',
            secret: 'Elle sait lire les cartes impossibles',
          ),
        ],
        locations: [
          StoryLocation(
            id: uuid.v4(),
            name: 'Le quartier des Lanternes',
            description: 'Un dedale de ruelles humides et de vitrines allumees.',
            mood: 'Onirique',
            importance: 'Point d entree vers la ville mouvante',
          ),
        ],
        ideas: [
          StoryIdea(
            id: uuid.v4(),
            type: 'idee de conflit',
            text: 'La carte exige un souvenir en echange de chaque nouvelle rue.',
          ),
        ],
      ),
      WritingProject(
        id: uuid.v4(),
        title: 'Dernier train pour Solstice',
        type: 'nouvelle',
        genre: 'science-fiction',
        summary: 'Dans un train spatial, chaque wagon contient une epoque differente.',
        wordGoal: 9000,
        tone: 'poetique',
        chapters: [Chapter(id: uuid.v4(), title: 'Depart')],
      ),
    ];
  }
}
