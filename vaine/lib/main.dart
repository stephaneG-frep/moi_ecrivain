import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'providers/editor_provider.dart';
import 'providers/project_provider.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final storageService = StorageService();
  await storageService.init();

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: storageService),
        ChangeNotifierProvider(
          create: (_) => ProjectProvider(storageService)..loadProjects(),
        ),
        ChangeNotifierProvider(create: (_) => EditorProvider()),
      ],
      child: const StoryForgeApp(),
    ),
  );
}
