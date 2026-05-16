import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/writing_project.dart';
import 'correction_service.dart';

class WritingAssistantService {
  WritingAssistantService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<String> improveSentence(String text, {WritingProject? project}) async {
    return _ask(project, 'Ameliore la phrase en gardant le sens et la voix.', text);
  }

  Future<String> correctSpelling(String text, {WritingProject? project}) async {
    if (project?.aiProvider == 'LanguageTool') {
      return CorrectionServiceFactory.fromProject(project!).correct(text);
    }
    return _ask(project, 'Corrige uniquement l orthographe, la grammaire et la ponctuation.', text);
  }

  Future<String> generateIdeas(String context, {WritingProject? project}) async {
    return _ask(project, 'Propose trois idees creatives, concretes et reutilisables.', context);
  }

  Future<String> continueStory(String text, {WritingProject? project}) async {
    return _ask(project, 'Propose une suite narrative de 120 mots maximum.', text);
  }

  Future<String> createCharacter(String description, {WritingProject? project}) async {
    return _ask(project, 'Cree une fiche personnage courte avec objectif, peur, secret et evolution.', description);
  }

  Future<String> transform(String action, String text, {WritingProject? project}) async {
    final instruction = switch (action) {
      'Rendre plus poetique' => 'Rends ce texte plus poetique, sensoriel et fluide.',
      'Rendre plus naturel' => 'Rends ce texte plus naturel, simple et oral sans l appauvrir.',
      'Rendre plus mysterieux' => 'Rends ce texte plus mysterieux avec une tension subtile.',
      'Simplifier le texte' => 'Simplifie ce texte en gardant l intention.',
      'Developper l idee' => 'Developpe cette idee avec enjeux, conflit et consequence.',
      'Proposer une suite' => 'Propose une suite narrative de 120 mots maximum.',
      'Trouver un meilleur dialogue' => 'Recris ou propose un dialogue plus vivant et tendu.',
      'Decrire un lieu' => 'Decris un lieu avec details visuels, sons, odeurs et ambiance.',
      'Creer un personnage' => 'Cree une fiche personnage courte avec objectif, peur, secret et evolution.',
      _ => 'Ameliore ce texte pour un projet d ecriture creative.',
    };
    return _ask(project, instruction, text);
  }

  Future<String> _ask(WritingProject? project, String instruction, String text) async {
    final provider = project?.aiProvider ?? 'Aucun';
    final prompt = _buildPrompt(project, instruction, text);

    try {
      switch (provider) {
        case 'OpenAI':
          return await _askOpenAi(project!, prompt);
        case 'Mistral':
          return await _askMistral(project!, prompt);
        case 'Ollama local':
          return await _askOllama(project!, prompt);
        case 'LanguageTool':
          return await _localFallback(instruction, text);
        default:
          return await _localFallback(instruction, text);
      }
    } on Object catch (error) {
      return 'Connexion impossible ($provider) : $error\n\n${await _localFallback(instruction, text)}';
    }
  }

  String _buildPrompt(WritingProject? project, String instruction, String text) {
    final context = project == null
        ? ''
        : '''
Projet: ${project.title}
Type: ${project.type}
Genre: ${project.genre}
Ton souhaite: ${project.tone}
Resume: ${project.summary}
''';
    return '''
Tu es un assistant d'ecriture creative francophone.
$context
Consigne: $instruction

Texte:
$text

Reponds directement avec le contenu utile, sans explication technique.
''';
  }

  Future<String> _askOpenAi(WritingProject project, String prompt) async {
    _requireKey(project);
    final model = project.aiModel.trim().isEmpty ? 'gpt-5' : project.aiModel.trim();
    final response = await _client.post(
      Uri.parse('https://api.openai.com/v1/responses'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${project.aiApiKey.trim()}',
      },
      body: jsonEncode({
        'model': model,
        'input': prompt,
      }),
    ).timeout(const Duration(seconds: 45));
    _ensureSuccess(response, 'OpenAI');
    return _extractOpenAiText(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<String> _askMistral(WritingProject project, String prompt) async {
    _requireKey(project);
    final model = project.aiModel.trim().isEmpty ? 'mistral-small-latest' : project.aiModel.trim();
    final response = await _client.post(
      Uri.parse('https://api.mistral.ai/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${project.aiApiKey.trim()}',
      },
      body: jsonEncode({
        'model': model,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      }),
    ).timeout(const Duration(seconds: 45));
    _ensureSuccess(response, 'Mistral');
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return body['choices']?[0]?['message']?['content'] as String? ?? 'Reponse Mistral vide.';
  }

  Future<String> _askOllama(WritingProject project, String prompt) async {
    final model = project.aiModel.trim().isEmpty ? 'llama3' : project.aiModel.trim();
    final baseUrl = project.ollamaUrl.trim().replaceAll(RegExp(r'/$'), '');
    final response = await _client.post(
      Uri.parse('$baseUrl/api/generate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'model': model,
        'prompt': prompt,
        'stream': false,
      }),
    ).timeout(const Duration(seconds: 60));
    _ensureSuccess(response, 'Ollama');
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return body['response'] as String? ?? 'Reponse Ollama vide.';
  }

  String _extractOpenAiText(Map<String, dynamic> body) {
    final direct = body['output_text'];
    if (direct is String && direct.trim().isNotEmpty) return direct.trim();

    final buffer = StringBuffer();
    final output = body['output'];
    if (output is List) {
      for (final item in output) {
        if (item is! Map<String, dynamic>) continue;
        final content = item['content'];
        if (content is! List) continue;
        for (final part in content) {
          if (part is Map<String, dynamic>) {
            final text = part['text'];
            if (text is String) buffer.writeln(text);
          }
        }
      }
    }
    final text = buffer.toString().trim();
    return text.isEmpty ? 'Reponse OpenAI vide.' : text;
  }

  void _requireKey(WritingProject project) {
    if (project.aiApiKey.trim().isEmpty) {
      throw const AssistantException('aucune cle API configuree');
    }
  }

  void _ensureSuccess(http.Response response, String provider) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    var message = response.body;
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      message = body['error']?['message'] as String? ?? response.body;
    } on Object {
      // Keep raw response body when the provider does not return JSON.
    }
    throw AssistantException('$provider a renvoye ${response.statusCode}: $message');
  }

  Future<String> _localFallback(String instruction, String text) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final trimmed = text.trim();
    if (instruction.contains('Corrige')) return 'Correction locale simulee : $trimmed';
    if (instruction.contains('suite')) {
      return 'Suite locale : le silence se fendit, et une voix venue du couloir prononca son nom comme si elle l attendait depuis des annees.';
    }
    if (instruction.contains('personnage')) {
      return 'Personnage local : ancien archiviste, calme en apparence, obsede par une promesse impossible a tenir.';
    }
    return 'Suggestion locale : $trimmed\n\nAjoute un detail sensoriel, un enjeu clair et une consequence pour renforcer la scene.';
  }
}

class AssistantException implements Exception {
  const AssistantException(this.message);

  final String message;

  @override
  String toString() => message;
}
