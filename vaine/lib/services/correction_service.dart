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

class CorrectionProviderConfig {
  const CorrectionProviderConfig(this.name, this.description);

  final String name;
  final String description;
}

const correctionProviders = [
  CorrectionProviderConfig('LanguageTool', 'Correcteur grammatical open source.'),
  CorrectionProviderConfig('OpenAI', 'Correction et reformulation par API IA.'),
  CorrectionProviderConfig('Mistral', 'Assistant francophone connectable plus tard.'),
  CorrectionProviderConfig('Ollama local', 'Mode hors ligne avec modele local.'),
  CorrectionProviderConfig('Autre API IA', 'Point d extension pour un service personnalise.'),
];
