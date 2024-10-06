import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/workout_bloc.dart';
import '../bloc/workout_event.dart';
import '../bloc/workout_state.dart';
import 'workout_screen.dart';

class WorkoutList extends StatefulWidget {
  const WorkoutList({super.key});

  @override
  State<WorkoutList> createState() => _WorkoutListState();
}

class _WorkoutListState extends State<WorkoutList> {
  Map groupedItems = {};
  String? dayName;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<WorkoutBloc>(context).add(GetWorkoutsEvent());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout List'),
      ),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkoutLoaded) {
            final workouts = state.workouts;
            print('---------------worrr');
            print(workouts);

            return ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (BuildContext context, int index) {
                final workout = workouts[index];

                return Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 1,
                    child: Column(
                      children: [
                        Text('Workout ${index + 1}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: workout.sets.length,
                          itemBuilder: (BuildContext context, int index) {
                            final set = workout.sets[index];
                            // Return a widget representing the item
                            return ListTile(
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  BlocProvider.of<WorkoutBloc>(context)
                                      .add(DeleteWorkoutEvent(workout.id));
                                  setState(() {});
                                },
                              ),
                              // trailing: Row(
                              //   children: [
                              //     IconButton(
                              //       icon: Icon(Icons.edit),
                              //       onPressed: () {
                              //         Navigator.of(context)
                              //             .push(MaterialPageRoute(
                              //           builder: (context) =>
                              //               WorkoutScreen(workout: workout),
                              //         ));
                              //       },
                              //     ),
                              //     IconButton(
                              //       icon: Icon(Icons.delete),
                              //       onPressed: () {
                              //         BlocProvider.of<WorkoutBloc>(context)
                              //             .add(DeleteWorkoutEvent(workout.id));
                              //       },
                              //     ),
                              //   ],
                              // ),
                              title: Text(
                                  'Set ${index + 1}: ${set.exercise} - ${set.weight}kg, ${set.repetitions} repetitions'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is WorkoutError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No workouts recorded.'));
        },
      ),
    );
  }
}
