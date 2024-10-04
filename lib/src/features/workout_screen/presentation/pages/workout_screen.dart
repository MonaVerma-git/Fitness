import 'package:flutter/material.dart';
import '../../domain/usecases/add_workout_usecase.dart';
import '../bloc/workout_bloc.dart';


class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final WorkoutBloc _workoutBloc = WorkoutBloc(AddWorkoutSetUseCase());

  final List<String> _exercises = [
    'Barbell row',
    'Bench press',
    'Shoulder press',
    'Deadlift',
    'Squat',
  ];

  final _formKey = GlobalKey<FormState>();
  String? _selectedExercise;
  String _weight = '';
  String _repetitions = '';

  void _addSet() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _workoutBloc.addWorkoutSet(_selectedExercise!, double.parse(_weight), int.parse(_repetitions));
      _weight = '';
      _repetitions = '';
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Tracker'),
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
                  _weight = value!;
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
                  _repetitions = value!;
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
              const SizedBox(height: 24),
              const Text(
                'Workout Summary:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _workoutBloc.workoutSets.length,
                  itemBuilder: (context, index) {
                    final set = _workoutBloc.workoutSets[index];
                    return ListTile(
                      title: Text(
                          'Set ${index + 1}: ${set.exercise} - ${set.weight}kg, ${set.repetitions} repetitions'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
