import '../models/workout_set.dart';

abstract class WorkoutRepository {
  List<Workout> getWorkouts(); // Fetch all workouts
  void addWorkout(Workout workout); // Save a new workout
  void deleteWorkout(String workoutId); // Delete a workout by ID
  void updateWorkout(Workout workout); // Update an existing workout
}
