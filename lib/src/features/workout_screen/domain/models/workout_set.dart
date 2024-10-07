class Workout {
  final String id;
  final List<WorkoutSet> sets;

  Workout({required this.id, required this.sets});

  // Serialize Workout object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sets': sets.map((set) => set.toJson()).toList(),
    };
  }

  // Deserialize Workout object from JSON
  static Workout fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      sets: (json['sets'] as List)
          .map((set) => WorkoutSet.fromJson(set))
          .toList(),
    );
  }
}

class WorkoutSet {
  final int day;
  final String exercise;
  final double weight;
  final int repetitions;

  WorkoutSet({
    required this.day,
    required this.exercise,
    required this.weight,
    required this.repetitions,
  });

  // Serialize WorkoutSet to JSON
  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'exercise': exercise,
      'weight': weight,
      'repetitions': repetitions,
    };
  }

  // Deserialize WorkoutSet from JSON
  static WorkoutSet fromJson(Map<String, dynamic> json) {
    return WorkoutSet(
      day: json['day'],
      exercise: json['exercise'],
      weight: json['weight'],
      repetitions: json['repetitions'],
    );
  }
}

class DayItems {
  final int id;
  final String day;

  DayItems({
    required this.id,
    required this.day,
  });
}
