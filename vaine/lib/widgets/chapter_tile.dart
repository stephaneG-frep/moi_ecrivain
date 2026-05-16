import 'package:flutter/material.dart';

import '../models/chapter.dart';

class ChapterTile extends StatelessWidget {
  const ChapterTile({
    super.key,
    required this.chapter,
    required this.onOpen,
    required this.onRename,
    required this.onDelete,
  });

  final Chapter chapter;
  final VoidCallback onOpen;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.drag_handle),
        title: Text(chapter.title),
        subtitle: Text('${chapter.wordCount} mots'),
        onTap: onOpen,
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'rename') onRename();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'rename', child: Text('Renommer')),
            PopupMenuItem(value: 'delete', child: Text('Supprimer')),
          ],
        ),
      ),
    );
  }
}
