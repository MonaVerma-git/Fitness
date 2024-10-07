import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../const.dart';

import '../../domain/models/workout_set.dart';
import '../bloc/workout_bloc.dart';
import '../bloc/workout_event.dart';
import '../bloc/workout_state.dart';
import 'package:collection/collection.dart';

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

            // Group workouts by day
            Map<int, List<Workout>> groupItemsByCategory(
                List<Workout> workouts) {
              workouts
                  .sort((a, b) => a.sets.first.day.compareTo(b.sets.first.day));

              return groupBy(workouts, (item) {
                // Assuming item.sets contains day
                return item.sets.first.day; // Group by day
              });
            }

            Map<int, List<Workout>> groupedItems =
                groupItemsByCategory(workouts);

            return ListView.builder(
              itemCount: groupedItems.length,
              itemBuilder: (BuildContext context, int index) {
                int category = groupedItems.keys.elementAt(index); // Day
                List itemsInCategory =
                    groupedItems[category]!; // Sets on that day

                String dayName = '';

                for (var day in dayItems) {
                  if (day.id == category) {
                    dayName = day.day;
                  }
                }

                return Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 1,
                    child: Column(
                      children: [
                        Text(dayName,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: itemsInCategory.length,
                          itemBuilder: (BuildContext context, int setIndex) {
                            final workout = itemsInCategory[setIndex];
                            final set = workout.sets[0];
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
                                  'Set ${setIndex + 1}: ${set.exercise} - ${set.weight}kg, ${set.repetitions} repetitions'),
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
