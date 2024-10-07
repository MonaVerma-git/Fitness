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

// ignore: depend_on_referenced_packages

import '../bloc/workout_state.dart';
import 'workout_list.dart';
import 'workout_screen.dart';

class WorkoutDetails extends StatefulWidget {
  final String? day;

  const WorkoutDetails({super.key, required this.day});

  @override
  State<WorkoutDetails> createState() => _WorkoutDetailsState();
}

class _WorkoutDetailsState extends State<WorkoutDetails> {
  List<Workout> workouts = [];
  int dayId = 0;

  goToWorkoutScreen(Workout? workout) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final workoutRepository =
        SharedPreferencesWorkoutRepository(sharedPreferences);
    // ignore: use_build_context_synchronously
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => WorkoutBloc(
          AddWorkout(workoutRepository),
          UpdateWorkout(workoutRepository),
          DeleteWorkout(workoutRepository),
          GetWorkouts(workoutRepository),
        ),
        child: workout != null
            ? WorkoutScreen(workout: workout)
            : const WorkoutScreen(),
      ),
    ));
    BlocProvider.of<WorkoutBloc>(context).add(GetWorkoutsEvent());
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<WorkoutBloc>(context).add(GetWorkoutsEvent());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
          onPressed: () async {
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
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white, size: 28),
            onPressed: () async {
              print('press me');
              var deleteWorkoutList = [];
              print(workouts);

              for (var workoutList in workouts) {
                for (var workoutSets in workoutList.sets) {
                  if (workoutSets.day == dayId) {
                    deleteWorkoutList.add(workoutList.id);
                  }
                }
              }

              if (deleteWorkoutList.isNotEmpty) {
                for (var deleteByID in deleteWorkoutList) {
                  BlocProvider.of<WorkoutBloc>(context)
                      .add(DeleteWorkoutEvent(deleteByID));
                }
              }
              setState(() {});
            },
          ),
        ],
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(4),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 45, 87, 121),
        elevation: 4,
        title: Text(
          widget.day != null ? '${widget.day} Workouts' : 'Workout Details',
          style: const TextStyle(
            color: Colors.white, // Title text color
            fontWeight: FontWeight.bold, // Bold text
            fontSize: 24.0, // Title font size
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 45, 87, 121),
        elevation: 6,
        child: const Icon(
          Icons.add,
          size: 32.0,
          color: Colors.white,
        ),
        onPressed: () {
          goToWorkoutScreen(null);
        },
      ),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutLoaded) {
            workouts = state.workouts;

            for (var item in dayItems) {
              if (item.day == widget.day) {
                dayId = item.id;
              }
            }

            var filteredWorkouts = workouts.where((workout) {
              return workout.sets.first.day == dayId;
            }).toList();

            return filteredWorkouts.isEmpty
                ? const Center(
                    child: Text(
                      'No workout recorded',
                      style: TextStyle(
                        color: Colors.black, // Title text color
                        fontWeight: FontWeight.bold, // Bold text
                        fontSize: 16.0, // Title font size
                      ),
                    ),
                  )
                : Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1, color: Colors.grey),
                        itemCount: filteredWorkouts.length,
                        itemBuilder: (BuildContext context, int setIndex) {
                          final workout = filteredWorkouts[setIndex];
                          final set = workout.sets[0];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      icon: const Icon(Icons.edit,
                                          size: 20, color: Colors.teal),
                                      onPressed: () =>
                                          goToWorkoutScreen(workout)),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        size: 20, color: Colors.red),
                                    onPressed: () {
                                      BlocProvider.of<WorkoutBloc>(context)
                                          .add(DeleteWorkoutEvent(workout.id));

                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                              title: Text(
                                  key: const Key('setDetails'),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                  'Set-${setIndex + 1} details:\nExercise: ${set.exercise}\nWeight: ${set.weight}kg\nRepetitions: ${set.repetitions} '),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, color: Colors.grey)
                    ],
                  );
          } else if (state is WorkoutError) {
            return Center(
                key: const Key('errorMessage'), child: Text(state.message));
          } else if (state is WorkoutLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text('No workouts recorded.'));
        },
      ),
    );
  }
}
