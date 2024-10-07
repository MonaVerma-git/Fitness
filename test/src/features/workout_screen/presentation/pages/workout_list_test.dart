import 'package:fitness/src/features/workout_screen/data/repositories/shared_preferences_workout_repository.dart';
import 'package:fitness/src/features/workout_screen/domain/models/workout_set.dart';
import 'package:fitness/src/features/workout_screen/domain/usecases/add_workout_usecase.dart';
import 'package:fitness/src/features/workout_screen/domain/usecases/delete_workout_usecase.dart';
import 'package:fitness/src/features/workout_screen/domain/usecases/get_workout_usecase.dart';
import 'package:fitness/src/features/workout_screen/domain/usecases/update_workout_usecase.dart';
import 'package:fitness/src/features/workout_screen/presentation/bloc/workout_bloc.dart';
import 'package:fitness/src/features/workout_screen/presentation/bloc/workout_state.dart';
import 'package:fitness/src/features/workout_screen/presentation/pages/workout_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:mocktail/mocktail.dart';

class MockWorkoutBloc extends Mock implements WorkoutBloc {}

class MockWorkoutRepository extends Mock
    implements SharedPreferencesWorkoutRepository {}

void main() {
  late WorkoutBloc workoutBloc;
  late MockWorkoutRepository workoutRepository;

  setUp(() {
    workoutRepository = MockWorkoutRepository();
    workoutBloc = WorkoutBloc(
      AddWorkout(workoutRepository),
      UpdateWorkout(workoutRepository),
      DeleteWorkout(workoutRepository),
      GetWorkouts(workoutRepository),
    );
  });

  testWidgets('renders loading indicator when state is WorkoutLoading',
      (WidgetTester tester) async {
    // Arrange
    workoutBloc.emit(WorkoutLoading());

    // Act
    await tester.pumpWidget(
      BlocProvider<WorkoutBloc>(
        create: (context) => workoutBloc,
        child: const MaterialApp(home: WorkoutList()),
      ),
    );

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders error message when state is WorkoutError',
      (WidgetTester tester) async {
    // Arrange
    workoutBloc.emit(WorkoutError('Error loading workouts'));

    // Act
    await tester.pumpWidget(
      BlocProvider<WorkoutBloc>(
        create: (context) => workoutBloc,
        child: const MaterialApp(home: WorkoutList()),
      ),
    );

    // Assert
    expect(find.byKey(const Key('errorMessage')), findsOneWidget);
    expect(find.text('Error loading workouts'), findsOneWidget);
  });

  testWidgets('renders workout list when state is WorkoutLoaded with workouts',
      (WidgetTester tester) async {
    // Arrange
    final workouts = [
      Workout(
        id: '1',
        sets: [
          WorkoutSet(
              day: 1, exercise: 'Bench Press', weight: 70, repetitions: 10)
        ],
      ),
      Workout(
        id: '2',
        sets: [
          WorkoutSet(day: 1, exercise: 'Squat', weight: 100, repetitions: 8)
        ],
      ),
    ];

    workoutBloc.emit(WorkoutLoaded(workouts: workouts));

    // Act
    await tester.pumpWidget(
      BlocProvider<WorkoutBloc>(
        create: (context) => workoutBloc,
        child: const MaterialApp(home: WorkoutList()),
      ),
    );

    // Assert
    expect(find.text('Workout Tracker'), findsOneWidget);

    expect(find.text('Set 1: Bench Press, 70.0kg, 10 repetitions '),
        findsOneWidget);
  });

  testWidgets(
      'navigates to WorkoutScreen when floating action button is pressed',
      (WidgetTester tester) async {
    // Arrange
    workoutBloc.emit(WorkoutLoaded(workouts: []));

    await tester.pumpWidget(
      BlocProvider<WorkoutBloc>(
        create: (context) => workoutBloc,
        child: const MaterialApp(home: WorkoutList()),
      ),
    );

    // Act
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
  });
}
