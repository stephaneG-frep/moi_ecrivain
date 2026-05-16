import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chapter.dart';
import '../providers/project_provider.dart';
import '../services/export_service.dart';
import '../widgets/chapter_tile.dart';
import '../widgets/stat_card.dart';
import 'characters_screen.dart';
import 'editor_screen.dart';
import 'ideas_screen.dart';
import 'locations_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectProvider>();
    final project = provider.findById(projectId);
    if (project == null) {
      return const Scaffold(body: Center(child: Text('Projet introuvable.')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(project.title),
        actions: [
          PopupMenuButton<ExportFormat>(
            icon: const Icon(Icons.ios_share),
            onSelected: (format) async {
              final text = await ExportService().export(project, format);
              if (!context.mounted) return;
              showDialog<void>(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Export ${format.name.toUpperCase()}'),
                  content: SingleChildScrollView(child: SelectableText(text)),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer')),
                  ],
                ),
              );
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: ExportFormat.txt, child: Text('TXT')),
              PopupMenuItem(value: ExportFormat.markdown, child: Text('Markdown')),
              PopupMenuItem(value: ExportFormat.pdf, child: Text('PDF plus tard')),
              PopupMenuItem(value: ExportFormat.epub, child: Text('EPUB plus tard')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(project.summary, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: StatCard(label: 'Mots', value: '${project.wordCount}', icon: Icons.edit_note)),
              const SizedBox(width: 10),
              Expanded(child: StatCard(label: 'Objectif', value: '${project.wordGoal}', icon: Icons.flag)),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CharactersScreen(projectId: project.id)),
                ),
                icon: const Icon(Icons.person_outline),
                label: const Text('Personnages'),
              ),
              FilledButton.tonalIcon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LocationsScreen(projectId: project.id)),
                ),
                icon: const Icon(Icons.place_outlined),
                label: const Text('Lieux'),
              ),
              FilledButton.tonalIcon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => IdeasScreen(projectId: project.id)),
                ),
                icon: const Icon(Icons.lightbulb_outline),
                label: const Text('Idees'),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(child: Text('Chapitres', style: Theme.of(context).textTheme.titleLarge)),
              IconButton.filledTonal(
                tooltip: 'Ajouter un chapitre',
                onPressed: () => context.read<ProjectProvider>().addChapter(project),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: project.chapters.length,
            onReorder: (oldIndex, newIndex) =>
                context.read<ProjectProvider>().reorderChapters(project, oldIndex, newIndex),
            itemBuilder: (context, index) {
              final chapter = project.chapters[index];
              return Padding(
                key: ValueKey(chapter.id),
                padding: const EdgeInsets.only(bottom: 8),
                child: ChapterTile(
                  chapter: chapter,
                  onOpen: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditorScreen(projectId: project.id, chapterId: chapter.id),
                    ),
                  ),
                  onRename: () => _renameChapter(context, project, chapter),
                  onDelete: () => context.read<ProjectProvider>().deleteChapter(project, chapter),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _renameChapter(BuildContext context, dynamic project, Chapter chapter) async {
    final controller = TextEditingController(text: chapter.title);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Renommer le chapitre'),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Annuler')),
          FilledButton(
            onPressed: () {
              context.read<ProjectProvider>().renameChapter(project, chapter, controller.text.trim());
              Navigator.pop(dialogContext);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
