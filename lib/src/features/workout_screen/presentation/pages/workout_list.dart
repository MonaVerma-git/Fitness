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
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

import 'workout_details.dart';
import 'workout_screen.dart';

class WorkoutList extends StatefulWidget {
  const WorkoutList({super.key});

  @override
  State<WorkoutList> createState() => _WorkoutListState();
}

class _WorkoutListState extends State<WorkoutList> {
  Map groupedItems = {};
  String? dayName;

  goToWorkoutScreen(BuildContext context, Workout? workout) async {
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
            ? WorkoutScreen(key: const Key('workoutScreen'), workout: workout)
            : const WorkoutScreen(
                key: Key('workoutScreen'),
              ),
      ),
    ));
    BlocProvider.of<WorkoutBloc>(context).add(GetWorkoutsEvent());
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<WorkoutBloc>(context).add(GetWorkoutsEvent());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(4),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 45, 87, 121),
        elevation: 4,
        title: const Text(
          'Workout Tracker',
          style: TextStyle(
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
          goToWorkoutScreen(context, null);
        },
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

            return groupedItems.isEmpty
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
                : ListView.builder(
                    itemCount: groupedItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      int category = groupedItems.keys.elementAt(index); // Day
                      List<Workout> itemsInCategory =
                          groupedItems[category]!; // Sets on that day

                      String dayName = '';

                      for (var day in dayItems) {
                        if (day.id == category) {
                          dayName = day.day;
                        }
                      }

                      return GestureDetector(
                        onTap: () async {
                          final sharedPreferences =
                              await SharedPreferences.getInstance();
                          final workoutRepository =
                              SharedPreferencesWorkoutRepository(
                                  sharedPreferences);
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BlocProvider(
                                create: (context) => WorkoutBloc(
                                      AddWorkout(workoutRepository),
                                      UpdateWorkout(workoutRepository),
                                      DeleteWorkout(workoutRepository),
                                      GetWorkouts(workoutRepository),
                                    ),
                                child: WorkoutDetails(
                                  day: dayName,
                                )),
                          ));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.grey, width: 0.3),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    dayName, // Day name (e.g. "Monday")
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                const Divider(),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: itemsInCategory.length,
                                  itemBuilder:
                                      (BuildContext context, int setIndex) {
                                    final workout = itemsInCategory[setIndex];
                                    final set = workout.sets[0];
                                    return ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      title: Text(
                                          key: const Key('setDetailsList'),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                          'Set ${setIndex + 1}: ${set.exercise}, ${set.weight}kg, ${set.repetitions} ${set.repetitions > 1 ? 'repetitions' : 'repetition'} '),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
          } else if (state is WorkoutError) {
            return Center(
                key: const Key('errorMessage'), child: Text(state.message));
          }
          return const Center(child: Text('No workouts recorded.'));
        },
      ),
    );
  }
}
