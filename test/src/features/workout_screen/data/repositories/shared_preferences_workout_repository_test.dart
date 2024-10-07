import 'dart:convert';
import 'package:fitness/src/features/workout_screen/data/repositories/shared_preferences_workout_repository.dart';
import 'package:fitness/src/features/workout_screen/domain/models/workout_set.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

Future<void> main() async {
  late SharedPreferencesWorkoutRepository workoutRepository;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    workoutRepository =
        SharedPreferencesWorkoutRepository(mockSharedPreferences);
  });

  group('SharedPreferencesWorkoutRepository', () {
    test('getWorkouts returns an empty list when no workouts are saved',
        () async {
      when(mockSharedPreferences.getString('workouts')).thenReturn(null);

      final workouts = workoutRepository.getWorkouts();

      expect(workouts, isA<List<Workout>>());
      expect(workouts, isEmpty);
    });

    test('getWorkouts returns a list of workouts when workouts are saved',
        () async {
      final workoutJson = jsonEncode([
        {
          "id": "1",
          "sets": [
            {
              "day": 1,
              "exercise": "Bench Press",
              "weight": 40.0,
              "repetitions": 10
            }
          ]
        }
      ]);

      when(mockSharedPreferences.getString('workouts')).thenReturn(workoutJson);

      final workouts = workoutRepository.getWorkouts();

      expect(workouts.length, 1);
      expect(workouts.first.id, "1");
      expect(workouts.first.sets.length, 1);
      expect(workouts.first.sets.first.exercise, "Bench Press");
    });
  });
}
