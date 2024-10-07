import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../const.dart';
import '../../data/repositories/shared_preferences_workout_repository.dart';
import '../../domain/repositories/ workout_repository.dart';
import '../../domain/models/workout_set.dart';
import '../../domain/usecases/add_workout_usecase.dart';
import '../../domain/usecases/delete_workout_usecase.dart';
import '../../domain/usecases/get_workout_usecase.dart';
import '../../domain/usecases/update_workout_usecase.dart';
import '../bloc/workout_bloc.dart';

import '../bloc/workout_event.dart';
import 'workout_list.dart';

class WorkoutScreen extends StatefulWidget {
  final Workout? workout;
  const WorkoutScreen({super.key, this.workout});

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final List<String> _exercises = [
    'Barbell row',
    'Bench press',
    'Shoulder press',
    'Deadlift',
    'Squat',
  ];

  final _formKey = GlobalKey<FormState>();
  String? _selectedExercise;
  int? _selectedDay;

  double _weight = 0.0;
  int _repetitions = 0;
  Map groupedItems = {};
  String? dayName;

  void _addSet() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final workout = Workout(
        id: widget.workout?.id ?? DateTime.now().toString(),
        sets: [
          WorkoutSet(
            day: _selectedDay!,
            exercise: _selectedExercise!,
            weight: _weight,
            repetitions: _repetitions,
          )
        ],
      );
      if (widget.workout == null) {
        BlocProvider.of<WorkoutBloc>(context).add(AddWorkoutEvent(workout));
      } else {
        BlocProvider.of<WorkoutBloc>(context).add(UpdateWorkoutEvent(workout));
      }
      _weight = 0.0;
      _repetitions = 0;

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout == null ? 'Add Workout' : 'Edit Workout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add a Set:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                value: _selectedDay,
                hint: const Text('Select Day'),
                items: dayItems.map((dayItem) {
                  return DropdownMenuItem(
                    value: dayItem.id,
                    child: Text(dayItem.day),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDay = value!;
                    print(value);
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a day';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedExercise,
                hint: const Text('Select Exercise'),
                items: _exercises.map((exercise) {
                  return DropdownMenuItem(
                    value: exercise,
                    child: Text(exercise),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedExercise = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an exercise';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _weight = double.parse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter weight';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Repetitions',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _repetitions = int.parse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter repetitions';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addSet,
                child: const Text('Add Set'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final sharedPreferences =
                      await SharedPreferences.getInstance();
                  final workoutRepository =
                      SharedPreferencesWorkoutRepository(sharedPreferences);

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => WorkoutBloc(
                        AddWorkout(workoutRepository),
                        UpdateWorkout(workoutRepository),
                        DeleteWorkout(workoutRepository),
                        GetWorkouts(workoutRepository),
                      ),
                      child: WorkoutList(),
                    ),
                  ));
                },
                child: const Text('Go to workout list'),
              ),
              const SizedBox(height: 24),
              const Text(
                'Workout Summary:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
