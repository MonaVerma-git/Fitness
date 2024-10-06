// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_workout_usecase.dart';
import '../../domain/usecases/delete_workout_usecase.dart';
import '../../domain/usecases/update_workout_usecase.dart';
import '../../domain/usecases/get_workout_usecase.dart';
import 'workout_event.dart';
import 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final AddWorkout addWorkoutUseCase;
  final UpdateWorkout updateWorkoutUseCase;
  final DeleteWorkout deleteWorkoutUseCase;
  final GetWorkouts getWorkoutsUseCase;

  WorkoutBloc(this.addWorkoutUseCase, this.updateWorkoutUseCase,
      this.deleteWorkoutUseCase, this.getWorkoutsUseCase)
      : super(WorkoutInitial());

  @override
  Stream<WorkoutState> mapEventToState(WorkoutEvent event) async* {
    if (event is AddWorkoutEvent) {
      yield WorkoutLoading();
      try {
        addWorkoutUseCase(event.workout);
        yield WorkoutLoaded(workouts: [event.workout]); // Emit loaded state
      } catch (e) {
        yield WorkoutError('Failed to add workout: $e');
      }
    } else if (event is UpdateWorkoutEvent) {
      yield WorkoutLoading();
      try {
        updateWorkoutUseCase(event.workout);
        yield WorkoutLoaded(workouts: [event.workout]); // Emit loaded state
      } catch (e) {
        yield WorkoutError('Failed to update workout: $e');
      }
    } else if (event is DeleteWorkoutEvent) {
      yield WorkoutLoading();
      try {
        deleteWorkoutUseCase.call(event.id);
        yield WorkoutLoaded(workouts: []); // Emit loaded state after deletion
      } catch (e) {
        yield WorkoutError('Failed to delete workout: $e');
      }
    } else if (event is GetWorkoutsEvent) {
      yield WorkoutLoading();
      try {
        final workouts = getWorkoutsUseCase();
        yield WorkoutLoaded(workouts: workouts);
      } catch (e) {
        yield WorkoutError('Failed to delete workout: $e');
      }
    }
  }
}
