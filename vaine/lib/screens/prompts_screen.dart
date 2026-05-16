import 'package:flutter/material.dart';

import '../services/creative_prompt_service.dart';

class PromptsScreen extends StatefulWidget {
  const PromptsScreen({super.key});

  @override
  State<PromptsScreen> createState() => _PromptsScreenState();
}

class _PromptsScreenState extends State<PromptsScreen> {
  final _service = CreativePromptService();
  late String _scene = _service.randomPrompt(CreativePromptService.scenePrompts);
  late String _character = _service.buildCharacterWorkshop();
  late String _conflict = _service.randomPrompt(CreativePromptService.conflictIdeas);
  late String _template = _service.randomPrompt(CreativePromptService.sceneTemplates);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prompts')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _PromptCard(
            title: 'Scene',
            icon: Icons.movie_filter_outlined,
            text: _scene,
            onRefresh: () => setState(() => _scene = _service.randomPrompt(CreativePromptService.scenePrompts)),
          ),
          _PromptCard(
            title: 'Personnage',
            icon: Icons.person_search_outlined,
            text: _character,
            onRefresh: () => setState(() => _character = _service.buildCharacterWorkshop()),
          ),
          _PromptCard(
            title: 'Conflit',
            icon: Icons.bolt_outlined,
            text: _conflict,
            onRefresh: () => setState(() => _conflict = _service.randomPrompt(CreativePromptService.conflictIdeas)),
          ),
          _PromptCard(
            title: 'Modele de scene',
            icon: Icons.account_tree_outlined,
            text: _template,
            onRefresh: () => setState(() => _template = _service.randomPrompt(CreativePromptService.sceneTemplates)),
          ),
        ],
      ),
    );
  }
}

class _PromptCard extends StatelessWidget {
  const _PromptCard({
    required this.title,
    required this.icon,
    required this.text,
    required this.onRefresh,
  });

  final String title;
  final IconData icon;
  final String text;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
                  IconButton(
                    tooltip: 'Nouveau prompt',
                    onPressed: onRefresh,
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}
