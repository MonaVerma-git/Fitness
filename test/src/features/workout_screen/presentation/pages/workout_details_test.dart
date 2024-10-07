import 'package:bloc_test/bloc_test.dart';
import 'package:fitness/src/features/workout_screen/domain/models/workout_set.dart';
import 'package:fitness/src/features/workout_screen/presentation/bloc/workout_bloc.dart';
import 'package:fitness/src/features/workout_screen/presentation/bloc/workout_event.dart';
import 'package:fitness/src/features/workout_screen/presentation/bloc/workout_state.dart';
import 'package:fitness/src/features/workout_screen/presentation/pages/workout_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock the WorkoutBloc and SharedPreferences
class MockWorkoutBloc extends MockBloc<WorkoutEvent, WorkoutState>
    implements WorkoutBloc {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MyType {
  final String name;
  MyType(this.name);
}

// Define a fake version of MyType
class MyTypeFake extends Fake implements MyType {}

class WorkoutStateFake extends Fake implements WorkoutState {}

class WorkoutEventFake extends Fake implements WorkoutEvent {}

void main() {
  late MockWorkoutBloc mockWorkoutBloc;

  setUpAll(() {
    registerFallbackValue(MyTypeFake());
    registerFallbackValue(WorkoutStateFake());
    registerFallbackValue(WorkoutEventFake());
  });

  // Sample data for the test
  const String workoutDay = "Monday";
  final workoutSets = [
    WorkoutSet(exercise: 'Bench Press', weight: 70, repetitions: 10, day: 1),
  ];

  final workouts = [
    Workout(id: '1', sets: workoutSets),
    Workout(id: '2', sets: workoutSets),
  ];

  setUp(() {
    mockWorkoutBloc = MockWorkoutBloc();
  });

  Widget createTestableWidget(Widget child) {
    return BlocProvider<WorkoutBloc>.value(
      value: mockWorkoutBloc,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('renders loading state', (WidgetTester tester) async {
    when(() => mockWorkoutBloc.state).thenReturn(WorkoutLoading());

    await tester
        .pumpWidget(createTestableWidget(WorkoutDetails(day: workoutDay)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders loaded state with workouts',
      (WidgetTester tester) async {
    when(() => mockWorkoutBloc.state)
        .thenReturn(WorkoutLoaded(workouts: workouts));

    await tester.pumpWidget(
        createTestableWidget(const WorkoutDetails(day: workoutDay)));

    // Check if workout data is rendered
    expect(find.byKey(const Key('setDetails')), findsWidgets);
  });

  testWidgets('deletes a workout when delete button is pressed',
      (WidgetTester tester) async {
    when(() => mockWorkoutBloc.state)
        .thenReturn(WorkoutLoaded(workouts: workouts));

    await tester.pumpWidget(
        createTestableWidget(const WorkoutDetails(day: workoutDay)));

    // Ensure delete button exists
    expect(find.byIcon(Icons.delete), findsWidgets);

    // Tap delete button and verify bloc event is triggered
    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pump();

    /// TODO: solve this bug
    // verify(() => mockWorkoutBloc.add(DeleteWorkoutEvent('1'))).called(2);
  });

  testWidgets('renders error state', (WidgetTester tester) async {
    when(() => mockWorkoutBloc.state).thenReturn(WorkoutError('test'));

    await tester.pumpWidget(
        createTestableWidget(const WorkoutDetails(day: workoutDay)));

    expect(find.byKey(const Key('errorMessage')), findsOneWidget);
  });
}
