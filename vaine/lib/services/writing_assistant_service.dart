class WritingAssistantService {
  Future<String> improveSentence(String text) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return 'Version amelioree : ${text.trim()} avec un rythme plus fluide et des images plus precises.';
  }

  Future<String> correctSpelling(String text) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return 'Correction simulee : ${text.trim()}';
  }

  Future<String> generateIdeas(String context) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return 'Idee : ajoute un choix moral qui oblige le personnage a sacrifier une certitude pour avancer.';
  }

  Future<String> continueStory(String text) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return 'Suite possible : le silence se fendit, et une voix venue du couloir prononca son nom comme si elle l attendait depuis des annees.';
  }

  Future<String> createCharacter(String description) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return 'Personnage : ancien archiviste, calme en apparence, obsede par une promesse impossible a tenir.';
  }

  Future<String> transform(String action, String text) async {
    switch (action) {
      case 'Rendre plus poetique':
        return 'Plus poetique : ${text.trim()} devient une phrase plus sensorielle, portee par la lumiere, les sons et le souffle.';
      case 'Rendre plus naturel':
        return 'Plus naturel : garde l intention, simplifie le vocabulaire et rapproche la phrase de la voix du personnage.';
      case 'Rendre plus mysterieux':
        return 'Plus mysterieux : ajoute un detail inquietant, mais ne revele pas encore sa cause.';
      case 'Simplifier le texte':
        return 'Texte simplifie : une version plus directe, claire et facile a lire.';
      case 'Developper l idee':
        return await generateIdeas(text);
      case 'Proposer une suite':
        return await continueStory(text);
      case 'Trouver un meilleur dialogue':
        return 'Dialogue possible : "Tu savais que cette porte reviendrait." "Non. J esperais seulement qu elle se souviendrait de moi."';
      case 'Decrire un lieu':
        return 'Lieu : murs tiedes, odeur de papier ancien, parquet qui soupire sous les pas, fenetres voilees de pluie.';
      case 'Creer un personnage':
        return await createCharacter(text);
      default:
        return await improveSentence(text);
    }
  }
}
