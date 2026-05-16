import 'package:flutter/material.dart';

import '../services/correction_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parametres')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text('Correction orthographique', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          for (final provider in correctionProviders)
            Card(
              child: ListTile(
                leading: const Icon(Icons.extension_outlined),
                title: Text(provider.name),
                subtitle: Text(provider.description),
                trailing: const Chip(label: Text('pret')),
              ),
            ),
          const SizedBox(height: 22),
          Text('Exports', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          const Card(
            child: ListTile(
              leading: Icon(Icons.description_outlined),
              title: Text('TXT et Markdown disponibles'),
              subtitle: Text('PDF et EPUB sont prepares dans ExportService pour une future integration.'),
            ),
          ),
        ],
      ),
    );
  }
}
