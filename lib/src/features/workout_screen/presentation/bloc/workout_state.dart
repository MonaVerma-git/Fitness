import '../../domain/models/workout_set.dart';

abstract class WorkoutState {}

class WorkoutInitial extends WorkoutState {}

class WorkoutLoading extends WorkoutState {}

class WorkoutLoaded extends WorkoutState {
  final List<Workout> workouts;
  WorkoutLoaded({required this.workouts});
}

class WorkoutError extends WorkoutState {
  final String message;
  WorkoutError(this.message);
}
