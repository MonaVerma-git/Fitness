import '../models/workout_set.dart';

class AddWorkoutSetUseCase {
  final List<WorkoutSet> _workoutSets = [];

  List<WorkoutSet> get workoutSets => _workoutSets;

  void addWorkoutSet(WorkoutSet workoutSet) {
    _workoutSets.add(workoutSet);
  }
}
