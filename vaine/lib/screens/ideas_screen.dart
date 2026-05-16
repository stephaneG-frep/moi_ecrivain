import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/story_idea.dart';
import '../providers/project_provider.dart';

class IdeasScreen extends StatelessWidget {
  const IdeasScreen({super.key, required this.projectId});

  final String projectId;
  static const ideaTypes = [
    'idee d intrigue',
    'idee de scene',
    'idee de dialogue',
    'idee de personnage',
    'idee de fin',
    'idee de conflit',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectProvider>();
    final project = provider.findById(projectId);
    if (project == null) return const Scaffold(body: Center(child: Text('Projet introuvable.')));

    return Scaffold(
      appBar: AppBar(title: const Text('Idees')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(context, provider.newIdea()),
        icon: const Icon(Icons.add),
        label: const Text('Idee'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(18),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 360,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.25,
        ),
        itemCount: project.ideas.length,
        itemBuilder: (context, index) {
          final idea = project.ideas[index];
          return Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => _edit(context, idea),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Chip(label: Text(idea.type)),
                    const SizedBox(height: 8),
                    Expanded(child: Text(idea.text, overflow: TextOverflow.fade)),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => provider.deleteIdea(project, idea),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _edit(BuildContext context, StoryIdea original) async {
    final provider = context.read<ProjectProvider>();
    final project = provider.findById(projectId)!;
    final item = StoryIdea.fromMap(original.toMap());
    final text = TextEditingController(text: item.text);
    var type = ideaTypes.contains(item.type) ? item.type : ideaTypes.first;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Idee'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField(
                initialValue: type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: ideaTypes.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                onChanged: (value) => setDialogState(() => type = value!),
              ),
              TextField(
                controller: text,
                decoration: const InputDecoration(labelText: 'Texte'),
                maxLines: 5,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Annuler')),
            FilledButton(
              onPressed: () {
                item
                  ..type = type
                  ..text = text.text;
                provider.upsertIdea(project, item);
                Navigator.pop(dialogContext);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
