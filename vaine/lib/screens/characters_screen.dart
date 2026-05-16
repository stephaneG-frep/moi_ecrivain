import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/character.dart';
import '../providers/project_provider.dart';

class CharactersScreen extends StatelessWidget {
  const CharactersScreen({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectProvider>();
    final project = provider.findById(projectId);
    if (project == null) return const Scaffold(body: Center(child: Text('Projet introuvable.')));

    return Scaffold(
      appBar: AppBar(title: const Text('Personnages')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _edit(context, provider.newCharacter()),
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(18),
        itemCount: project.characters.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final character = project.characters[index];
          return Card(
            child: ListTile(
              title: Text(character.name.isEmpty ? 'Personnage sans nom' : character.name),
              subtitle: Text([character.role, character.goal].where((item) => item.isNotEmpty).join(' - ')),
              onTap: () => _edit(context, character),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => provider.deleteCharacter(project, character),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _edit(BuildContext context, StoryCharacter original) async {
    final provider = context.read<ProjectProvider>();
    final project = provider.findById(projectId)!;
    final item = StoryCharacter.fromMap(original.toMap());
    final fields = {
      'Nom': TextEditingController(text: item.name),
      'Age': TextEditingController(text: item.age),
      'Role dans l histoire': TextEditingController(text: item.role),
      'Caractere': TextEditingController(text: item.personality),
      'Objectif': TextEditingController(text: item.goal),
      'Peur': TextEditingController(text: item.fear),
      'Secret': TextEditingController(text: item.secret),
      'Evolution': TextEditingController(text: item.arc),
      'Notes': TextEditingController(text: item.notes),
    };
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Fiche personnage'),
        content: SingleChildScrollView(
          child: Column(
            children: fields.entries
                .map((entry) => TextField(
                      controller: entry.value,
                      decoration: InputDecoration(labelText: entry.key),
                      maxLines: entry.key == 'Notes' ? 4 : 1,
                    ))
                .toList(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Annuler')),
          FilledButton(
            onPressed: () {
              item
                ..name = fields['Nom']!.text
                ..age = fields['Age']!.text
                ..role = fields['Role dans l histoire']!.text
                ..personality = fields['Caractere']!.text
                ..goal = fields['Objectif']!.text
                ..fear = fields['Peur']!.text
                ..secret = fields['Secret']!.text
                ..arc = fields['Evolution']!.text
                ..notes = fields['Notes']!.text;
              provider.upsertCharacter(project, item);
              Navigator.pop(dialogContext);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}
