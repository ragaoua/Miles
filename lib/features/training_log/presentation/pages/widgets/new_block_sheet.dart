import 'package:flutter/material.dart';

import '../../bloc/training_log_bloc.dart';

class NewBlockSheet extends StatelessWidget {
  const NewBlockSheet({
    super.key,
    required this.bloc,
  });

  final TrainingLogBloc bloc;

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: const Text('TODO') // TODO: add form
    );
  }
}