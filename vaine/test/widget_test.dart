import 'package:flutter_test/flutter_test.dart';
import 'package:vaine/models/chapter.dart';
import 'package:vaine/models/writing_project.dart';

void main() {
  test('WritingProject calcule les mots et la progression', () {
    final project = WritingProject(
      id: 'project-1',
      title: 'Test',
      type: 'roman',
      genre: 'fantastique',
      summary: 'Resume',
      wordGoal: 10,
      tone: 'mysterieux',
      chapters: [
        Chapter(id: 'chapter-1', title: 'Chapitre 1', content: 'Un deux trois'),
        Chapter(id: 'chapter-2', title: 'Chapitre 2', content: 'Quatre cinq'),
      ],
    );

    expect(project.wordCount, 5);
    expect(project.progress, 0.5);
  });
}
