class StoryLocation {
  StoryLocation({
    required this.id,
    required this.name,
    this.description = '',
    this.mood = '',
    this.importance = '',
    this.visualDetails = '',
    this.sounds = '',
    this.smells = '',
    this.notes = '',
  });

  final String id;
  String name;
  String description;
  String mood;
  String importance;
  String visualDetails;
  String sounds;
  String smells;
  String notes;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'mood': mood,
        'importance': importance,
        'visualDetails': visualDetails,
        'sounds': sounds,
        'smells': smells,
        'notes': notes,
      };

  factory StoryLocation.fromMap(Map<dynamic, dynamic> map) => StoryLocation(
        id: map['id'] as String,
        name: (map['name'] ?? '') as String,
        description: (map['description'] ?? '') as String,
        mood: (map['mood'] ?? '') as String,
        importance: (map['importance'] ?? '') as String,
        visualDetails: (map['visualDetails'] ?? '') as String,
        sounds: (map['sounds'] ?? '') as String,
        smells: (map['smells'] ?? '') as String,
        notes: (map['notes'] ?? '') as String,
      );
}
