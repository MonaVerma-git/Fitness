
import '../../domain/models/workout_set.dart';
import ' workout_repository.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final List<WorkoutSet> _workoutSets = [];

  @override
  List<WorkoutSet> getWorkoutSets() {
    return _workoutSets;
  }

  @override
  void addWorkoutSet(WorkoutSet workoutSet) {
    _workoutSets.add(workoutSet);
  }
}
