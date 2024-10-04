import '../../domain/models/workout_set.dart';

abstract class WorkoutRepository {
  List<WorkoutSet> getWorkoutSets();
  void addWorkoutSet(WorkoutSet workoutSet);
}
