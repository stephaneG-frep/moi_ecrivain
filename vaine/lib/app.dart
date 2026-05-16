import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

class StoryForgeApp extends StatelessWidget {
  const StoryForgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFFC46A35);

    return MaterialApp(
      title: 'StoryForge',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.light,
          surface: const Color(0xFFFFF8EF),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8EF),
        appBarTheme: const AppBarTheme(centerTitle: false),
        cardTheme: CardThemeData(
          elevation: 0,
          color: const Color(0xFFFFFCF7),
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFFEBD9C5)),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
          surface: const Color(0xFF1E1713),
        ),
        scaffoldBackgroundColor: const Color(0xFF17110E),
        cardTheme: CardThemeData(
          elevation: 0,
          color: const Color(0xFF241B17),
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFF3B2A23)),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
