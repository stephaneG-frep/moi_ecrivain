import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/location.dart';
import '../providers/project_provider.dart';

class LocationsScreen extends StatelessWidget {
  const LocationsScreen({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectProvider>();
    final project = provider.findById(projectId);
    if (project == null) return const Scaffold(body: Center(child: Text('Projet introuvable.')));

    return Scaffold(
      appBar: AppBar(title: const Text('Lieux')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _edit(context, provider.newLocation()),
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(18),
        itemCount: project.locations.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final location = project.locations[index];
          return Card(
            child: ListTile(
              title: Text(location.name.isEmpty ? 'Lieu sans nom' : location.name),
              subtitle: Text(location.mood),
              onTap: () => _edit(context, location),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => provider.deleteLocation(project, location),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _edit(BuildContext context, StoryLocation original) async {
    final provider = context.read<ProjectProvider>();
    final project = provider.findById(projectId)!;
    final item = StoryLocation.fromMap(original.toMap());
    final fields = {
      'Nom du lieu': TextEditingController(text: item.name),
      'Description': TextEditingController(text: item.description),
      'Ambiance': TextEditingController(text: item.mood),
      'Importance': TextEditingController(text: item.importance),
      'Details visuels': TextEditingController(text: item.visualDetails),
      'Sons': TextEditingController(text: item.sounds),
      'Odeurs': TextEditingController(text: item.smells),
      'Notes': TextEditingController(text: item.notes),
    };
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Fiche lieu'),
        content: SingleChildScrollView(
          child: Column(
            children: fields.entries
                .map((entry) => TextField(
                      controller: entry.value,
                      decoration: InputDecoration(labelText: entry.key),
                      maxLines: ['Description', 'Details visuels', 'Notes'].contains(entry.key) ? 3 : 1,
                    ))
                .toList(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Annuler')),
          FilledButton(
            onPressed: () {
              item
                ..name = fields['Nom du lieu']!.text
                ..description = fields['Description']!.text
                ..mood = fields['Ambiance']!.text
                ..importance = fields['Importance']!.text
                ..visualDetails = fields['Details visuels']!.text
                ..sounds = fields['Sons']!.text
                ..smells = fields['Odeurs']!.text
                ..notes = fields['Notes']!.text;
              provider.upsertLocation(project, item);
              Navigator.pop(dialogContext);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}
