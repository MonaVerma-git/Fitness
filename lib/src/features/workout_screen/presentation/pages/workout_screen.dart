import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../const.dart';
import '../../data/repositories/shared_preferences_workout_repository.dart';
import '../../domain/models/workout_set.dart';
import '../../domain/usecases/add_workout_usecase.dart';
import '../../domain/usecases/delete_workout_usecase.dart';
import '../../domain/usecases/get_workout_usecase.dart';
import '../../domain/usecases/update_workout_usecase.dart';
import '../bloc/workout_bloc.dart';

import '../bloc/workout_event.dart';
import '../bloc/workout_state.dart';
import 'workout_list.dart';

class WorkoutScreen extends StatefulWidget {
  final Workout? workout;
  const WorkoutScreen({super.key, this.workout});

  @override
  // ignore: library_private_types_in_public_api
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  @override
  void initState() {
    super.initState();
    // Populate fields if workout is provided
    if (widget.workout != null) {
      // Assuming the workout has at least one set and the first set can be used to populate the fields
      final firstSet = widget.workout!.sets.first;
      _selectedExercise = firstSet.exercise;
      _selectedDay =
          firstSet.day; // Ensure day is included in the WorkoutSet model
      _weight = firstSet.weight;
      _repetitions = firstSet.repetitions;
    }
  }

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

  goToWorkoutListScreen() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final workoutRepository =
        SharedPreferencesWorkoutRepository(sharedPreferences);
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => WorkoutBloc(
          AddWorkout(workoutRepository),
          UpdateWorkout(workoutRepository),
          DeleteWorkout(workoutRepository),
          GetWorkouts(workoutRepository),
        ),
        child: const WorkoutList(),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(4),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 45, 87, 121),
        elevation: 4,
        title: Text(
          widget.workout == null ? 'Add Workout Set' : 'Edit Workout Set',
          style: const TextStyle(
            color: Colors.white, // Title text color
            fontWeight: FontWeight.bold, // Bold text
            fontSize: 24.0, // Title font size
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<WorkoutBloc, WorkoutState>(
          listener: (context, state) {
            if (state is WorkoutLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(widget.workout == null
                      ? 'Workout added successfully!'
                      : 'Workout updated successfully!'),
                  duration: const Duration(seconds: 2),
                ),
              );
              Navigator.pop(context);
              // Future.delayed(const Duration(milliseconds: 1000), () {
              //   goToWorkoutListScreen();
              // });
            }
          },
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Day Dropdown
                DropdownButtonFormField(
                  value: _selectedDay,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    labelText: 'Select Day',
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  items: dayItems.map((dayItem) {
                    return DropdownMenuItem(
                      value: dayItem.id,
                      child: Text(dayItem.day),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDay = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) return 'Please select a day';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Exercise Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedExercise,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 195, 188, 188)),
                    ),
                    labelText: 'Select Exercise',
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
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
                    if (value == null) return 'Please select an exercise';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Weight Input Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Weight (kg)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _weight = double.parse(value!);
                  },
                  validator: (value) {
                    // Check if the input is empty
                    if (value == null || value.isEmpty) {
                      return 'Please enter weight';
                    }

                    // Check if the input is a valid integer
                    final doubleValue = double.tryParse(value);
                    if (doubleValue == null || doubleValue <= 0) {
                      return 'Please enter a valid number';
                    }

                    return null; // Return null if validation passes
                  },
                  initialValue:
                      widget.workout != null ? _weight.toString() : '',
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Repetitions',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _repetitions = int.parse(value!);
                  },
                  validator: (value) {
                    // Check if the input is empty
                    if (value == null || value.isEmpty) {
                      return 'Please enter repetitions';
                    }

                    // Check if the input is a valid integer
                    final intValue = int.tryParse(value);
                    if (intValue == null || intValue <= 0) {
                      return 'Please enter a valid number';
                    }

                    return null; // Return null if validation passes
                  },
                  initialValue:
                      widget.workout != null ? _repetitions.toString() : '',
                ),
                const SizedBox(height: 42),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 45, 87, 121),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12), // Padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                      elevation: 5, // Elevation for shadow effect
                    ),
                    onPressed: _addSet,
                    child: Text(
                      widget.workout == null
                          ? 'Save Workout'
                          : 'Update Workout',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
