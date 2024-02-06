import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dependency_injection.dart';
import '../bloc/training_log_bloc.dart';

class TrainingLogPage extends StatelessWidget {
  const TrainingLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => sl<TrainingLogBloc>(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Training Log'), // TODO: add translation
            centerTitle: true,
          ),
          body: Align(
            alignment: Alignment.topCenter,
            child : TrainingLogBlocBuilder(
              builder: (context, state) {
                if (state is Loading) {
                  return const CircularProgressIndicator();
                } else if (state is Loaded) {
                  if (state.blocks.isNotEmpty) {
                    return ListView.builder(
                      itemCount: state.blocks.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(state.blocks[index].name)
                        );
                      }
                    );
                  } else {
                    return const Column(
                        children: [
                          Text('No training blocks yet'), // TODO: add translation
                          Text('Tap the button down below to start one') // TODO: add translation
                        ]
                    );
                  }
                } else {
                  return const Text('Error'); // TODO: add translation
                }
              }
            )
          ),
          floatingActionButton: TrainingLogBlocBuilder(
            builder: (context, state) {
              if (state is Loaded) {
                return FloatingActionButton(
                  onPressed: () {
                    // TODO
                  },
                  child: const Icon(Icons.add),
                );
              } else {
                return Container();
              }
            }
          )
        ),
      )
    );
  }
}

typedef TrainingLogBlocBuilder = BlocBuilder<TrainingLogBloc, TrainingLogState>;