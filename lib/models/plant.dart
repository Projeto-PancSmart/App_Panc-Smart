class Plant {
  final String name;
  final String scientificName;
  final String description;
  final Map<String, dynamic> careInstructions;

  Plant({
    required this.name,
    required this.scientificName,
    required this.description,
    required this.careInstructions,
  });

  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      name: map['name'] ?? '',
      scientificName: map['scientificName'] ?? '',
      description: map['description'] ?? '',
      careInstructions: Map<String, dynamic>.from(map['careInstructions'] ?? {}),
    );
  }
}