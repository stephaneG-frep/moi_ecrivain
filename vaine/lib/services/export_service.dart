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
