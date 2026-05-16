import 'package:flutter/material.dart';

class EditorToolbar extends StatelessWidget {
  const EditorToolbar({
    super.key,
    required this.onInsert,
    required this.onNotes,
    required this.onFocus,
    required this.onFullscreen,
  });

  final ValueChanged<String> onInsert;
  final VoidCallback onNotes;
  final VoidCallback onFocus;
  final VoidCallback onFullscreen;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          IconButton.filledTonal(
            tooltip: 'Gras',
            onPressed: () => onInsert('**texte en gras**'),
            icon: const Icon(Icons.format_bold),
          ),
          IconButton(
            tooltip: 'Italique',
            onPressed: () => onInsert('_texte en italique_'),
            icon: const Icon(Icons.format_italic),
          ),
          IconButton(
            tooltip: 'Titre',
            onPressed: () => onInsert('\n# Titre\n'),
            icon: const Icon(Icons.title),
          ),
          IconButton(
            tooltip: 'Separation de scene',
            onPressed: () => onInsert('\n\n---\n\n'),
            icon: const Icon(Icons.horizontal_rule),
          ),
          IconButton(
            tooltip: 'Notes rapides',
            onPressed: onNotes,
            icon: const Icon(Icons.sticky_note_2_outlined),
          ),
          IconButton(
            tooltip: 'Mode concentration',
            onPressed: onFocus,
            icon: const Icon(Icons.center_focus_strong),
          ),
          IconButton(
            tooltip: 'Plein ecran',
            onPressed: onFullscreen,
            icon: const Icon(Icons.fullscreen),
          ),
        ],
      ),
    );
  }
}
