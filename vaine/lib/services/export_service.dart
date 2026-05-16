import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/writing_project.dart';

enum ExportFormat { txt, markdown, pdf, epub }

class ExportService {
  Future<String> export(WritingProject project, ExportFormat format) async {
    switch (format) {
      case ExportFormat.txt:
        return _asPlainText(project);
      case ExportFormat.markdown:
        return _asMarkdown(project);
      case ExportFormat.pdf:
        return 'Export PDF pret a brancher. Contenu source :\n\n${_asMarkdown(project)}';
      case ExportFormat.epub:
        return 'Export EPUB pret a brancher. Contenu source :\n\n${_asMarkdown(project)}';
    }
  }

  Future<File> exportToFile(WritingProject project, ExportFormat format) async {
    final directory = await getApplicationDocumentsDirectory();
    final exportDirectory = Directory('${directory.path}/storyforge_exports');
    if (!await exportDirectory.exists()) {
      await exportDirectory.create(recursive: true);
    }
    final extension = switch (format) {
      ExportFormat.txt => 'txt',
      ExportFormat.markdown => 'md',
      ExportFormat.pdf => 'pdf.txt',
      ExportFormat.epub => 'epub.txt',
    };
    final slug = project.title
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    final file = File('${exportDirectory.path}/${slug.isEmpty ? 'projet' : slug}.$extension');
    return file.writeAsString(await export(project, format));
  }

  String _asPlainText(WritingProject project) => [
        project.title,
        project.summary,
        for (final chapter in project.chapters) ...[
          '',
          chapter.title,
          chapter.content,
        ],
      ].join('\n');

  String _asMarkdown(WritingProject project) => [
        '# ${project.title}',
        '',
        project.summary,
        for (final chapter in project.chapters) ...[
          '',
          '## ${chapter.title}',
          '',
          chapter.content,
        ],
      ].join('\n');
}
