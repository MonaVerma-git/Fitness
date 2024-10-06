// import '../models/workout_set.dart';

// class AddWorkoutSetUseCase {
//   final List<WorkoutSet> _workoutSets = [];

//   List<WorkoutSet> get workoutSets => _workoutSets;

//   void addWorkoutSet(WorkoutSet workoutSet) {
//     _workoutSets.add(workoutSet);
//   }
// }

import '../repositories/ workout_repository.dart';
import '../models/workout_set.dart';

class AddWorkout {
  final WorkoutRepository repository;

  AddWorkout(this.repository);

  void call(Workout workout) {
    repository.addWorkout(workout);
  }
}
