import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chapter.dart';
import '../providers/editor_provider.dart';
import '../providers/project_provider.dart';
import '../widgets/assistant_panel.dart';
import '../widgets/editor_toolbar.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({
    super.key,
    required this.projectId,
    required this.chapterId,
  });

  final String projectId;
  final String chapterId;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late final TextEditingController _controller;
  Chapter? _chapter;
  String _selectedText = '';

  @override
  void initState() {
    super.initState();
    final project = context.read<ProjectProvider>().findById(widget.projectId);
    _chapter = project?.chapters.firstWhere((chapter) => chapter.id == widget.chapterId);
    _controller = TextEditingController(text: _chapter?.content ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = context.watch<ProjectProvider>();
    final editor = context.watch<EditorProvider>();
    final project = projectProvider.findById(widget.projectId);
    final chapter = project?.chapters.where((item) => item.id == widget.chapterId).firstOrNull;

    if (project == null || chapter == null) {
      return const Scaffold(body: Center(child: Text('Chapitre introuvable.')));
    }

    final hidePanels = editor.focusMode || editor.fullscreen;
    return Scaffold(
      appBar: editor.fullscreen
          ? null
          : AppBar(
              title: Text(chapter.title),
              actions: [
                IconButton(
                  tooltip: 'Mode sombre selon le systeme',
                  onPressed: () {},
                  icon: const Icon(Icons.dark_mode_outlined),
                ),
              ],
            ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 900;
            final editorPane = _EditorPane(
              controller: _controller,
              onChanged: (value) => editor.scheduleAutosave(
                () => context.read<ProjectProvider>().saveChapter(project, chapter, value),
              ),
              onSelectionChanged: () {
                final selection = _controller.selection;
                if (selection.isValid && !selection.isCollapsed) {
                  setState(() => _selectedText = selection.textInside(_controller.text));
                }
              },
            );

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (!hidePanels)
                  EditorToolbar(
                    onInsert: _insertText,
                    onNotes: _showNotes,
                    onFocus: editor.toggleFocusMode,
                    onFullscreen: editor.toggleFullscreen,
                  ),
                if (editor.fullscreen)
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton.filled(
                      tooltip: 'Quitter le plein ecran',
                      onPressed: editor.toggleFullscreen,
                      icon: const Icon(Icons.fullscreen_exit),
                    ),
                  ),
                const SizedBox(height: 12),
                if (wide && !hidePanels)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: editorPane),
                      const SizedBox(width: 14),
                      Expanded(
                        flex: 2,
                        child: AssistantPanel(
                          selectedText: _selectedText,
                          project: project,
                          onResult: (value) => _showSnack('Suggestion prete'),
                        ),
                      ),
                    ],
                  )
                else ...[
                  editorPane,
                  if (!hidePanels) ...[
                    const SizedBox(height: 14),
                    AssistantPanel(
                      selectedText: _selectedText,
                      project: project,
                      onResult: (value) => _showSnack('Suggestion prete'),
                    ),
                  ],
                ],
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  children: [
                    Chip(label: Text('${editor.wordCount(_controller.text)} mots')),
                    Chip(label: Text('${editor.characterCount(_controller.text)} caracteres')),
                    const Chip(label: Text('Sauvegarde auto locale')),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _insertText(String text) {
    final selection = _controller.selection;
    final start = selection.start < 0 ? _controller.text.length : selection.start;
    final end = selection.end < 0 ? _controller.text.length : selection.end;
    _controller.text = _controller.text.replaceRange(start, end, text);
    _controller.selection = TextSelection.collapsed(offset: start + text.length);
  }

  Future<void> _showNotes() async {
    final editor = context.read<EditorProvider>();
    final controller = TextEditingController(text: editor.quickNotes);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Text('Notes rapides', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                editor.updateNotes(controller.text);
                Navigator.pop(context);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _EditorPane extends StatelessWidget {
  const _EditorPane({
    required this.controller,
    required this.onChanged,
    required this.onSelectionChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          onTap: onSelectionChanged,
          keyboardType: TextInputType.multiline,
          minLines: 18,
          maxLines: null,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.55),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Commencez a ecrire...',
          ),
        ),
      ),
    );
  }
}
