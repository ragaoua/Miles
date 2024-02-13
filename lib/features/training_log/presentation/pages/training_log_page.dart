import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:miles/features/training_log/presentation/pages/widgets/block_list.dart';
import 'package:miles/features/training_log/presentation/pages/widgets/new_block_sheet.dart';

import '../../../../core/dependency_injection.dart';
import '../bloc/training_log_bloc.dart';

typedef TrainingLogBlocBuilder = BlocBuilder<TrainingLogBloc, TrainingLogState>;

class TrainingLogPage extends StatelessWidget {
  const TrainingLogPage({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider(
        create: (_) => sl<TrainingLogBloc>(),
        child: Builder(
          builder: (context) {
            final appStrings = AppLocalizations.of(context)!;
            return Scaffold(
                appBar: AppBar(
                  title: Text(appStrings.training_log),
                  centerTitle: true,
                ),
                body: Align(
                  alignment: Alignment.topCenter,
                  child : TrainingLogBlocBuilder(
                    builder: (_, state) {
                      switch (state) {
                        case Loading():
                          return const CircularProgressIndicator();
                        case Loaded():
                          return BlockList(blocks: state.blocks);
                        case Error():
                          return Text(state.message);
                        default:
                          return const Text('Unknown error');
                      }
                    }
                  )
                ),
                floatingActionButton: TrainingLogBlocBuilder(
                  builder: (context, _) {
                    final bloc = BlocProvider.of<TrainingLogBloc>(context);
                    return FloatingActionButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => NewBlockSheet(bloc: bloc)
                        );
                      },
                      child: const Icon(Icons.add),
                    );
                  }
                )
            );
          }
        )
      )
    );
}