import '../repositories/ workout_repository.dart';
import '../models/workout_set.dart';

class UpdateWorkout {
  final WorkoutRepository repository;

  UpdateWorkout(this.repository);

  void call(Workout workout) {
    repository.updateWorkout(workout);
  }
}
