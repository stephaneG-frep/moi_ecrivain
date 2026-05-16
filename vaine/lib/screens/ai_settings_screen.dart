import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/project_provider.dart';
import '../services/correction_service.dart';

class AiSettingsScreen extends StatefulWidget {
  const AiSettingsScreen({super.key, required this.projectId});

  final String projectId;

  @override
  State<AiSettingsScreen> createState() => _AiSettingsScreenState();
}

class _AiSettingsScreenState extends State<AiSettingsScreen> {
  final _apiKey = TextEditingController();
  final _model = TextEditingController();
  final _ollamaUrl = TextEditingController();
  String _provider = 'Aucun';
  bool _loaded = false;

  @override
  void dispose() {
    _apiKey.dispose();
    _model.dispose();
    _ollamaUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final project = context.watch<ProjectProvider>().findById(widget.projectId);
    if (project == null) return const Scaffold(body: Center(child: Text('Projet introuvable.')));

    if (!_loaded) {
      _provider = project.aiProvider;
      _apiKey.text = project.aiApiKey;
      _model.text = project.aiModel;
      _ollamaUrl.text = project.ollamaUrl;
      _loaded = true;
    }

    final providers = ['Aucun', ...correctionProviders.map((item) => item.name)];

    return Scaffold(
      appBar: AppBar(title: const Text('IA et correction')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          DropdownButtonFormField(
            initialValue: providers.contains(_provider) ? _provider : 'Aucun',
            decoration: const InputDecoration(labelText: 'Fournisseur'),
            items: providers.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
            onChanged: (value) => setState(() => _provider = value!),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _model,
            decoration: const InputDecoration(
              labelText: 'Modele',
              hintText: 'gpt-4.1-mini, mistral-small, llama3...',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _apiKey,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Cle API'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _ollamaUrl,
            decoration: const InputDecoration(labelText: 'URL Ollama local'),
          ),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Ces reglages sont stockes localement pour preparer la connexion future. Les services actuels restent simules et hors ligne.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () async {
              await context.read<ProjectProvider>().updateAiSettings(
                    project: project,
                    provider: _provider,
                    apiKey: _apiKey.text,
                    model: _model.text,
                    ollamaUrl: _ollamaUrl.text,
                  );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reglages IA enregistres')));
              }
            },
            icon: const Icon(Icons.save_outlined),
            label: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}
