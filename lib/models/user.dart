class User {
  final String name;
  final int age;
  final double height;
  final double weight;
  final double goalWeight;
  final List<String> specialConditions;
  final String? otherObservations;

  User({
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
    required this.goalWeight,
    this.specialConditions = const [],
    this.otherObservations,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      age: json['age'],
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      goalWeight: (json['goalWeight'] as num).toDouble(),
      specialConditions: List<String>.from(json['specialConditions'] ?? []),
      otherObservations: json['otherObservations'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'height': height,
      'weight': weight,
      'goalWeight': goalWeight,
      'specialConditions': specialConditions,
      'otherObservations': otherObservations,
    };
  }
}
