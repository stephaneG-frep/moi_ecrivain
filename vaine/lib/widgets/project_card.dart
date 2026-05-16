import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/writing_project.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
  });

  final WritingProject project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final percent = (project.progress * 100).round();

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(project.title, style: Theme.of(context).textTheme.titleLarge),
                  ),
                  Chip(label: Text(project.type)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                project.summary.isEmpty ? 'Aucun resume pour le moment.' : project.summary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 14),
              LinearProgressIndicator(value: project.progress),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _Info(icon: Icons.edit_note, text: '${project.wordCount} mots'),
                  _Info(icon: Icons.flag_outlined, text: '$percent %'),
                  _Info(
                    icon: Icons.schedule,
                    text: DateFormat('dd/MM/yyyy').format(project.updatedAt),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }
}
