import '../repositories/ workout_repository.dart';

class DeleteWorkout {
  final WorkoutRepository repository;

  DeleteWorkout(this.repository);

  void call(String id) {
    repository.deleteWorkout(id);
  }
}
