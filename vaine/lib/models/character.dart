class StoryCharacter {
  StoryCharacter({
    required this.id,
    required this.name,
    this.age = '',
    this.role = '',
    this.personality = '',
    this.goal = '',
    this.fear = '',
    this.secret = '',
    this.arc = '',
    this.notes = '',
  });

  final String id;
  String name;
  String age;
  String role;
  String personality;
  String goal;
  String fear;
  String secret;
  String arc;
  String notes;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'age': age,
        'role': role,
        'personality': personality,
        'goal': goal,
        'fear': fear,
        'secret': secret,
        'arc': arc,
        'notes': notes,
      };

  factory StoryCharacter.fromMap(Map<dynamic, dynamic> map) => StoryCharacter(
        id: map['id'] as String,
        name: (map['name'] ?? '') as String,
        age: (map['age'] ?? '') as String,
        role: (map['role'] ?? '') as String,
        personality: (map['personality'] ?? '') as String,
        goal: (map['goal'] ?? '') as String,
        fear: (map['fear'] ?? '') as String,
        secret: (map['secret'] ?? '') as String,
        arc: (map['arc'] ?? '') as String,
        notes: (map['notes'] ?? '') as String,
      );
}
