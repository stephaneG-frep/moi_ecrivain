import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chapter.dart';
import '../providers/project_provider.dart';
import '../services/export_service.dart';
import '../widgets/chapter_tile.dart';
import '../widgets/stat_card.dart';
import 'ai_settings_screen.dart';
import 'characters_screen.dart';
import 'editor_screen.dart';
import 'goals_screen.dart';
import 'ideas_screen.dart';
import 'locations_screen.dart';
import 'outline_screen.dart';
import 'prompts_screen.dart';

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
          IconButton(
            tooltip: 'Modifier le projet',
            onPressed: () => _editProject(context, project),
            icon: const Icon(Icons.edit_outlined),
          ),
          PopupMenuButton<ExportFormat>(
            icon: const Icon(Icons.ios_share),
            onSelected: (format) async {
              final file = await ExportService().exportToFile(project, format);
              if (!context.mounted) return;
              showDialog<void>(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Export ${format.name.toUpperCase()}'),
                  content: SelectableText('Fichier cree :\n${file.path}'),
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
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: StatCard(label: 'Aujourd hui', value: '${project.wordsToday}', icon: Icons.today)),
              const SizedBox(width: 10),
              Expanded(child: StatCard(label: 'Serie', value: '${project.writingStreak} j', icon: Icons.local_fire_department)),
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
                  MaterialPageRoute(builder: (_) => OutlineScreen(projectId: project.id)),
                ),
                icon: const Icon(Icons.account_tree_outlined),
                label: const Text('Plan'),
              ),
              FilledButton.tonalIcon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => GoalsScreen(projectId: project.id)),
                ),
                icon: const Icon(Icons.flag_outlined),
                label: const Text('Objectifs'),
              ),
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
              FilledButton.tonalIcon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PromptsScreen()),
                ),
                icon: const Icon(Icons.auto_fix_high),
                label: const Text('Prompts'),
              ),
              FilledButton.tonalIcon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AiSettingsScreen(projectId: project.id)),
                ),
                icon: const Icon(Icons.psychology_alt_outlined),
                label: const Text('IA'),
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

  Future<void> _editProject(BuildContext context, dynamic project) async {
    const types = ['nouvelle', 'roman', 'conte', 'scenario'];
    const genres = [
      'fantastique',
      'policier',
      'science-fiction',
      'romance',
      'historique',
      'horreur',
      'aventure',
    ];
    const tones = ['poetique', 'sombre', 'drole', 'realiste', 'epique', 'mysterieux'];

    final title = TextEditingController(text: project.title);
    final summary = TextEditingController(text: project.summary);
    final wordGoal = TextEditingController(text: '${project.wordGoal}');
    var type = types.contains(project.type) ? project.type : types.first;
    var genre = genres.contains(project.genre) ? project.genre : genres.first;
    var tone = tones.contains(project.tone) ? project.tone : tones.first;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Modifier le projet'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: title, decoration: const InputDecoration(labelText: 'Titre')),
                DropdownButtonFormField(
                  initialValue: type,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: types.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                  onChanged: (value) => setDialogState(() => type = value!),
                ),
                DropdownButtonFormField(
                  initialValue: genre,
                  decoration: const InputDecoration(labelText: 'Genre'),
                  items: genres.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                  onChanged: (value) => setDialogState(() => genre = value!),
                ),
                TextField(
                  controller: summary,
                  decoration: const InputDecoration(labelText: 'Resume court'),
                  maxLines: 3,
                ),
                TextField(
                  controller: wordGoal,
                  decoration: const InputDecoration(labelText: 'Objectif de mots'),
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField(
                  initialValue: tone,
                  decoration: const InputDecoration(labelText: 'Ton souhaite'),
                  items: tones.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                  onChanged: (value) => setDialogState(() => tone = value!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Annuler')),
            FilledButton(
              onPressed: () async {
                await context.read<ProjectProvider>().updateProject(
                      project: project,
                      title: title.text.trim(),
                      type: type,
                      genre: genre,
                      summary: summary.text.trim(),
                      wordGoal: int.tryParse(wordGoal.text) ?? project.wordGoal,
                      tone: tone,
                    );
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
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
