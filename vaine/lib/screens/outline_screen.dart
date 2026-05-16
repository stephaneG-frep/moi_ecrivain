import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/project_provider.dart';

class OutlineScreen extends StatefulWidget {
  const OutlineScreen({super.key, required this.projectId});

  final String projectId;

  @override
  State<OutlineScreen> createState() => _OutlineScreenState();
}

class _OutlineScreenState extends State<OutlineScreen> {
  final _controllers = <String, TextEditingController>{};

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final project = context.watch<ProjectProvider>().findById(widget.projectId);
    if (project == null) return const Scaffold(body: Center(child: Text('Projet introuvable.')));

    _controllers.putIfAbsent('beginning', () => TextEditingController(text: project.outlineBeginning));
    _controllers.putIfAbsent('trigger', () => TextEditingController(text: project.outlineTrigger));
    _controllers.putIfAbsent('conflicts', () => TextEditingController(text: project.outlineConflicts));
    _controllers.putIfAbsent('climax', () => TextEditingController(text: project.outlineClimax));
    _controllers.putIfAbsent('ending', () => TextEditingController(text: project.outlineEnding));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan'),
        actions: [
          FilledButton(
            onPressed: () async {
              await context.read<ProjectProvider>().updateOutline(
                    project: project,
                    beginning: _controllers['beginning']!.text,
                    trigger: _controllers['trigger']!.text,
                    conflicts: _controllers['conflicts']!.text,
                    climax: _controllers['climax']!.text,
                    ending: _controllers['ending']!.text,
                  );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Plan enregistre')));
              }
            },
            child: const Text('Sauver'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _OutlineField(label: 'Debut', controller: _controllers['beginning']!),
          _OutlineField(label: 'Element declencheur', controller: _controllers['trigger']!),
          _OutlineField(label: 'Conflits', controller: _controllers['conflicts']!),
          _OutlineField(label: 'Climax', controller: _controllers['climax']!),
          _OutlineField(label: 'Fin', controller: _controllers['ending']!),
        ],
      ),
    );
  }
}

class _OutlineField extends StatelessWidget {
  const _OutlineField({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        minLines: 4,
        maxLines: 8,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: true,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
