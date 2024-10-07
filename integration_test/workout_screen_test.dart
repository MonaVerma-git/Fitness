import 'package:fitness/src/features/workout_screen/presentation/bloc/workout_bloc.dart';
import 'package:fitness/src/features/workout_screen/presentation/bloc/workout_event.dart';
import 'package:fitness/src/features/workout_screen/presentation/bloc/workout_state.dart';
import 'package:fitness/src/features/workout_screen/presentation/pages/workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

class MockWorkoutBloc extends Mock implements WorkoutBloc {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Workout Screen Integration Test', () {
    testWidgets('Add workout set', (WidgetTester tester) async {
      // Create a mock bloc and provide initial state
      final mockBloc = MockWorkoutBloc();
      when(mockBloc.state).thenReturn(WorkoutInitial());

      // Provide the mock bloc to the app
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: mockBloc,
            child: const WorkoutScreen(),
          ),
        ),
      );

      // Verify that the title is correct
      expect(find.text('Add Workout Set'), findsOneWidget);

      // Simulate selecting a day
      await tester.tap(find.byType(DropdownButtonFormField).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Monday').last); // Select Monday
      await tester.pumpAndSettle();

      // Simulate selecting an exercise
      await tester.tap(find.byType(DropdownButtonFormField).at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bench press').last); // Select Bench Press
      await tester.pumpAndSettle();

      // Enter weight and repetitions
      await tester.enterText(find.byType(TextFormField).first, '70'); // Weight
      await tester.enterText(
          find.byType(TextFormField).at(1), '10'); // Repetitions

      // Simulate tapping the save button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify that the appropriate methods were called on the bloc
      // verify(mockBloc.add(isA<AddWorkoutEvent>())).called(1);

      // Verify that a SnackBar appears
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Workout added successfully!'), findsOneWidget);
    });
  });
}
