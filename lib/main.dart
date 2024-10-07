import 'package:fitness/src/features/workout_screen/domain/usecases/delete_workout_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/features/workout_screen/data/repositories/shared_preferences_workout_repository.dart';
import 'src/features/workout_screen/domain/usecases/add_workout_usecase.dart';
import 'src/features/workout_screen/domain/usecases/get_workout_usecase.dart';
import 'src/features/workout_screen/domain/usecases/update_workout_usecase.dart';
import 'src/features/workout_screen/presentation/bloc/workout_bloc.dart';
import 'src/features/workout_screen/presentation/pages/workout_list.dart';
import 'src/features/workout_screen/presentation/pages/workout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize the repository with Shared Preferences
  final workoutRepository =
      SharedPreferencesWorkoutRepository(sharedPreferences);

  runApp(MyApp(workoutRepository: workoutRepository));
}

class MyApp extends StatelessWidget {
  final SharedPreferencesWorkoutRepository workoutRepository;
  const MyApp({super.key, required this.workoutRepository});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Primary color for the app
      ),
      home: BlocProvider(
        create: (context) => WorkoutBloc(
          AddWorkout(workoutRepository),
          UpdateWorkout(workoutRepository),
          DeleteWorkout(workoutRepository),
          GetWorkouts(workoutRepository),
        ),
        child: const WorkoutList(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
