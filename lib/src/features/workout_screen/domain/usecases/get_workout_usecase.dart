import '../repositories/ workout_repository.dart';
import '../models/workout_set.dart';

class GetWorkouts {
  final WorkoutRepository repository;

  GetWorkouts(this.repository);

  List<Workout> call() {
    return repository.getWorkouts();
  }
}
