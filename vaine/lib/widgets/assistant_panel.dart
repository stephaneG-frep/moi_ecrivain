import 'package:flutter/material.dart';

import '../services/writing_assistant_service.dart';

class AssistantPanel extends StatefulWidget {
  const AssistantPanel({
    super.key,
    required this.selectedText,
    required this.onResult,
  });

  final String selectedText;
  final ValueChanged<String> onResult;

  @override
  State<AssistantPanel> createState() => _AssistantPanelState();
}

class _AssistantPanelState extends State<AssistantPanel> {
  final _service = WritingAssistantService();
  bool _isLoading = false;
  String _lastResult = '';

  static const actions = [
    'Ameliorer la phrase',
    'Corriger l orthographe',
    'Rendre plus poetique',
    'Rendre plus naturel',
    'Rendre plus mysterieux',
    'Simplifier le texte',
    'Developper l idee',
    'Proposer une suite',
    'Trouver un meilleur dialogue',
    'Decrire un lieu',
    'Creer un personnage',
  ];

  Future<void> _run(String action) async {
    setState(() => _isLoading = true);
    final text = widget.selectedText.trim().isEmpty
        ? 'Contexte general du chapitre'
        : widget.selectedText.trim();
    final result = action == 'Corriger l orthographe'
        ? await _service.correctSpelling(text)
        : await _service.transform(action, text);
    setState(() {
      _lastResult = result;
      _isLoading = false;
    });
    widget.onResult(result);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Assistant', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final action in actions)
                  FilledButton.tonal(
                    onPressed: _isLoading ? null : () => _run(action),
                    child: Text(action),
                  ),
              ],
            ),
            if (_isLoading) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
            ],
            if (_lastResult.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(_lastResult),
            ],
          ],
        ),
      ),
    );
  }
}
