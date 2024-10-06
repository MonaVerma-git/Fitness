import '../../domain/models/workout_set.dart';

abstract class WorkoutEvent {}

class AddWorkoutEvent extends WorkoutEvent {
  final Workout workout;
  AddWorkoutEvent(this.workout);
}

class UpdateWorkoutEvent extends WorkoutEvent {
  final Workout workout;
  UpdateWorkoutEvent(this.workout);
}

class DeleteWorkoutEvent extends WorkoutEvent {
  final String id;
  DeleteWorkoutEvent(this.id);
}

class GetWorkoutsEvent extends WorkoutEvent {} // Event for fetching workouts

