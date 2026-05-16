import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/project_provider.dart';
import '../widgets/stat_card.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectProvider>();
    final project = provider.findById(projectId);
    if (project == null) return const Scaffold(body: Center(child: Text('Projet introuvable.')));

    final sortedDays = project.dailyWordCounts.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    return Scaffold(
      appBar: AppBar(title: const Text('Objectifs')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Row(
            children: [
              Expanded(child: StatCard(label: 'Aujourd hui', value: '${project.wordsToday}', icon: Icons.today)),
              const SizedBox(width: 10),
              Expanded(child: StatCard(label: 'Serie', value: '${project.writingStreak} j', icon: Icons.local_fire_department)),
            ],
          ),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Objectif journalier', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(value: project.dailyProgress),
                  const SizedBox(height: 10),
                  Text('${project.wordsToday} / ${project.dailyWordGoal} mots'),
                  const SizedBox(height: 12),
                  FilledButton.tonalIcon(
                    onPressed: () => _editGoal(context, provider, project),
                    icon: const Icon(Icons.flag_outlined),
                    label: const Text('Modifier l objectif'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text('Historique', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          for (final entry in sortedDays.take(30))
            Card(
              child: ListTile(
                leading: const Icon(Icons.edit_calendar_outlined),
                title: Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(entry.key))),
                trailing: Text('${entry.value} mots'),
              ),
            ),
          if (sortedDays.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(child: Text('L historique se remplira pendant l ecriture.')),
            ),
        ],
      ),
    );
  }

  Future<void> _editGoal(BuildContext context, ProjectProvider provider, dynamic project) async {
    final controller = TextEditingController(text: '${project.dailyWordGoal}');
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Objectif journalier'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Mots par jour'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Annuler')),
          FilledButton(
            onPressed: () {
              provider.updateDailyGoal(project, int.tryParse(controller.text) ?? 500);
              Navigator.pop(dialogContext);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}
