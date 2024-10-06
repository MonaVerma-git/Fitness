import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/workout_set.dart';
import '../../domain/repositories/ workout_repository.dart';

class SharedPreferencesWorkoutRepository implements WorkoutRepository {
  final SharedPreferences sharedPreferences;

  static const String workoutKey = 'workouts';

  SharedPreferencesWorkoutRepository(this.sharedPreferences);

  @override
  List<Workout> getWorkouts() {
    final jsonString = sharedPreferences.getString(workoutKey);
    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Workout.fromJson(json)).toList();
    }
    return [];
  }

  @override
  void addWorkout(Workout workout) {
    final workouts = getWorkouts();
    workouts.add(workout);
    final jsonList = workouts.map((workout) => workout.toJson()).toList();
    sharedPreferences.setString(workoutKey, jsonEncode(jsonList));
  }

  @override
  void deleteWorkout(String workoutId) {
    final workouts = getWorkouts();
    final updatedWorkouts =
        workouts.where((workout) => workout.id != workoutId).toList();
    final jsonList =
        updatedWorkouts.map((workout) => workout.toJson()).toList();
    sharedPreferences.setString(workoutKey, jsonEncode(jsonList));
  }

  @override
  void updateWorkout(Workout workout) {
    final workouts = getWorkouts();
    final updatedWorkouts = workouts.map((existingWorkout) {
      return existingWorkout.id == workout.id ? workout : existingWorkout;
    }).toList();
    final jsonList =
        updatedWorkouts.map((workout) => workout.toJson()).toList();
    sharedPreferences.setString(workoutKey, jsonEncode(jsonList));
  }
}
