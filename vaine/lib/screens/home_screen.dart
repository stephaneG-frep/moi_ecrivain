import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/project_provider.dart';
import '../widgets/project_card.dart';
import 'project_detail_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = '';

  static const types = ['nouvelle', 'roman', 'conte', 'scenario'];
  static const genres = [
    'fantastique',
    'policier',
    'science-fiction',
    'romance',
    'historique',
    'horreur',
    'aventure',
  ];
  static const tones = ['poetique', 'sombre', 'drole', 'realiste', 'epique', 'mysterieux'];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectProvider>();
    final projects = provider.projects.where((project) {
      final query = _query.toLowerCase();
      return project.title.toLowerCase().contains(query) ||
          project.genre.toLowerCase().contains(query) ||
          project.type.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('StoryForge'),
        actions: [
          IconButton(
            tooltip: 'Parametres',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showProjectDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Nouveau projet'),
      ),
      body: SafeArea(
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  Text('Ecris, corrige, imagine.', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  SearchBar(
                    hintText: 'Rechercher un projet',
                    leading: const Icon(Icons.search),
                    onChanged: (value) => setState(() => _query = value),
                  ),
                  const SizedBox(height: 18),
                  for (final project in projects) ...[
                    ProjectCard(
                      project: project,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ProjectDetailScreen(projectId: project.id),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (projects.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Center(child: Text('Aucun projet ne correspond a la recherche.')),
                    ),
                ],
              ),
      ),
    );
  }

  Future<void> _showProjectDialog(BuildContext context) async {
    final title = TextEditingController();
    final summary = TextEditingController();
    final wordGoal = TextEditingController(text: '50000');
    var type = types.first;
    var genre = genres.first;
    var tone = tones.first;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nouveau projet'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () async {
                if (title.text.trim().isEmpty) return;
                await context.read<ProjectProvider>().addProject(
                      title: title.text.trim(),
                      type: type,
                      genre: genre,
                      summary: summary.text.trim(),
                      wordGoal: int.tryParse(wordGoal.text) ?? 50000,
                      tone: tone,
                    );
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              child: const Text('Creer'),
            ),
          ],
        ),
      ),
    );
  }
}
