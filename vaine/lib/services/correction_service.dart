import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/writing_project.dart';

abstract class CorrectionService {
  Future<String> correct(String text);
}

class SimulatedCorrectionService implements CorrectionService {
  @override
  Future<String> correct(String text) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return 'Correction locale simulee : ${text.trim()}';
  }
}

class LanguageToolCorrectionService implements CorrectionService {
  LanguageToolCorrectionService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<String> correct(String text) async {
    final response = await _client.post(
      Uri.parse('https://api.languagetool.org/v2/check'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'text': text, 'language': 'fr'},
    ).timeout(const Duration(seconds: 20));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw CorrectionException('LanguageTool a renvoye ${response.statusCode}.');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final matches = (body['matches'] as List? ?? []).cast<Map<String, dynamic>>();
    var corrected = text;

    for (final match in matches.reversed) {
      final replacements = (match['replacements'] as List? ?? []).cast<Map<String, dynamic>>();
      if (replacements.isEmpty) continue;
      final offset = match['offset'] as int;
      final length = match['length'] as int;
      final replacement = replacements.first['value'] as String? ?? '';
      corrected = corrected.replaceRange(offset, offset + length, replacement);
    }

    return corrected;
  }
}

class CorrectionServiceFactory {
  static CorrectionService fromProject(WritingProject project) {
    if (project.aiProvider == 'LanguageTool') {
      return LanguageToolCorrectionService();
    }
    return SimulatedCorrectionService();
  }
}

class CorrectionException implements Exception {
  const CorrectionException(this.message);

  final String message;

  @override
  String toString() => message;
}

class CorrectionProviderConfig {
  const CorrectionProviderConfig(this.name, this.description);

  final String name;
  final String description;
}

const correctionProviders = [
  CorrectionProviderConfig('LanguageTool', 'Correction HTTP via api.languagetool.org.'),
  CorrectionProviderConfig('OpenAI', 'Assistance creative via Responses API.'),
  CorrectionProviderConfig('Mistral', 'Assistance creative via API chat completions.'),
  CorrectionProviderConfig('Ollama local', 'Assistance creative via /api/generate.'),
  CorrectionProviderConfig('Autre API IA', 'Emplacement pret pour un endpoint personnalise.'),
];
