import 'package:fitness/src/features/workout_screen/domain/models/workout_set.dart';
import 'package:fitness/src/features/workout_screen/domain/usecases/add_workout_usecase.dart';
import 'package:fitness/src/features/workout_screen/domain/usecases/delete_workout_usecase.dart';
import 'package:fitness/src/features/workout_screen/domain/usecases/get_workout_usecase.dart';
import 'package:fitness/src/features/workout_screen/domain/usecases/update_workout_usecase.dart';
import 'package:fitness/src/features/workout_screen/presentation/bloc/workout_bloc.dart';
import 'package:fitness/src/features/workout_screen/presentation/bloc/workout_event.dart';
import 'package:fitness/src/features/workout_screen/presentation/bloc/workout_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

// Mock classes
class MockAddWorkout extends Mock implements AddWorkout {}

class MockUpdateWorkout extends Mock implements UpdateWorkout {}

class MockDeleteWorkout extends Mock implements DeleteWorkout {}

class MockGetWorkouts extends Mock implements GetWorkouts {}

void main() {
  late WorkoutBloc workoutBloc;
  late MockAddWorkout mockAddWorkout;
  late MockUpdateWorkout mockUpdateWorkout;
  late MockDeleteWorkout mockDeleteWorkout;
  late MockGetWorkouts mockGetWorkouts;

  setUp(() {
    mockAddWorkout = MockAddWorkout();
    mockUpdateWorkout = MockUpdateWorkout();
    mockDeleteWorkout = MockDeleteWorkout();
    mockGetWorkouts = MockGetWorkouts();

    workoutBloc = WorkoutBloc(
      mockAddWorkout,
      mockUpdateWorkout,
      mockDeleteWorkout,
      mockGetWorkouts,
    );
  });

  tearDown(() {
    workoutBloc.close();
  });

  group('WorkoutBloc', () {
    final Workout workout;
    workout = Workout(id: '1', sets: []);

    test('initial state is WorkoutInitial', () {
      expect(workoutBloc.state, WorkoutInitial());
    });

    blocTest<WorkoutBloc, WorkoutState>(
      'emits [WorkoutLoading, WorkoutLoaded] when AddWorkoutEvent is added',
      build: () {
        when(mockAddWorkout(workout)).thenAnswer((_) async => {});
        return workoutBloc;
      },
      act: (bloc) => bloc.add(AddWorkoutEvent(Workout(id: '1', sets: []))),
      expect: () => [
        WorkoutLoading(),
        WorkoutLoaded(workouts: [Workout(id: '1', sets: [])]),
      ],
    );

    blocTest<WorkoutBloc, WorkoutState>(
      'emits [WorkoutLoading, WorkoutLoaded] when UpdateWorkoutEvent is added',
      build: () {
        when(mockUpdateWorkout(workout)).thenAnswer((_) async => {});
        return workoutBloc;
      },
      act: (bloc) => bloc.add(UpdateWorkoutEvent(Workout(id: '1', sets: []))),
      expect: () => [
        WorkoutLoading(),
        WorkoutLoaded(workouts: [Workout(id: '1', sets: [])]),
      ],
    );

    blocTest<WorkoutBloc, WorkoutState>(
      'emits [WorkoutLoading, WorkoutLoaded] when DeleteWorkoutEvent is added',
      build: () {
        when(mockDeleteWorkout('1')).thenAnswer((_) async => {});
        return workoutBloc;
      },
      act: (bloc) => bloc.add(DeleteWorkoutEvent('1')),
      expect: () => [
        WorkoutLoading(),
        WorkoutLoaded(workouts: []),
      ],
    );

    blocTest<WorkoutBloc, WorkoutState>(
      'emits [WorkoutLoading, WorkoutLoaded] when GetWorkoutsEvent is added',
      build: () {
        when(mockGetWorkouts()).thenReturn([Workout(id: '1', sets: [])]);
        return workoutBloc;
      },
      act: (bloc) => bloc.add(GetWorkoutsEvent()),
      expect: () => [
        WorkoutLoading(),
        WorkoutLoaded(workouts: [Workout(id: '1', sets: [])]),
      ],
    );

    blocTest<WorkoutBloc, WorkoutState>(
      'emits [WorkoutError] when adding a workout fails',
      build: () {
        when(mockAddWorkout(workout)).thenThrow(Exception('Add failed'));
        return workoutBloc;
      },
      act: (bloc) => bloc.add(AddWorkoutEvent(Workout(id: '1', sets: []))),
      expect: () => [
        WorkoutLoading(),
        WorkoutError('Failed to add workout: Exception: Add failed'),
      ],
    );
  });
}
