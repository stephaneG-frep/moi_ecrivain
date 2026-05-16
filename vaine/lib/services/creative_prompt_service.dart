import 'dart:math';

class CreativePromptService {
  final _random = Random();

  static const scenePrompts = [
    'Ecris une scene ou le personnage obtient ce qu il voulait, mais au mauvais moment.',
    'Ajoute un objet banal qui devient soudain une preuve importante.',
    'Fais entrer un personnage qui connait une verite que personne ne veut entendre.',
    'Transforme un lieu familier en espace inquietant avec trois details sensoriels.',
  ];

  static const characterQuestions = [
    'Que refuse ce personnage d admettre sur lui-meme ?',
    'Quel souvenir explique sa plus grande peur ?',
    'Quelle promesse ancienne pourrait le mettre en danger ?',
    'Que perd-il s il atteint son objectif ?',
  ];

  static const conflictIdeas = [
    'Deux allies veulent le meme resultat, mais pour des raisons incompatibles.',
    'Un mensonge utile commence a proteger la mauvaise personne.',
    'Le meilleur choix moral detruit l objectif initial du heros.',
    'Le personnage gagne du temps, mais perd la confiance de quelqu un.',
  ];

  static const sceneTemplates = [
    'Objectif -> obstacle -> decision -> consequence.',
    'Desir visible -> peur cachee -> conflit -> revelation.',
    'Lieu -> tension -> dialogue -> detail qui change le sens de la scene.',
    'Question ouverte -> fausse piste -> choix irreparable.',
  ];

  String randomPrompt(List<String> source) => source[_random.nextInt(source.length)];

  String buildCharacterWorkshop() => [
        randomPrompt(characterQuestions),
        randomPrompt(characterQuestions),
        randomPrompt(characterQuestions),
      ].join('\n');
}
