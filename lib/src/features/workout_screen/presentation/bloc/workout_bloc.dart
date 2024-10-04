import '../../domain/usecases/add_workout_usecase.dart';
import '../../domain/models/workout_set.dart';

class WorkoutBloc {
  final AddWorkoutSetUseCase _addWorkoutSetUseCase;

  WorkoutBloc(this._addWorkoutSetUseCase);

  List<WorkoutSet> get workoutSets => _addWorkoutSetUseCase.workoutSets;

  void addWorkoutSet(String exercise, double weight, int repetitions) {
    final workoutSet = WorkoutSet(
      exercise: exercise,
      weight: weight,
      repetitions: repetitions,
    );
    _addWorkoutSetUseCase.addWorkoutSet(workoutSet);
  }
}
