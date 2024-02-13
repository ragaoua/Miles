import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/entities/block.dart';

class BlockList extends StatelessWidget {
  const BlockList({
    super.key,
    required this.blocks
  });

  final List<BlockWithSessions> blocks;

  @override
  Widget build(BuildContext context) {
    if (blocks.isNotEmpty) {
      return ListView.builder(
          itemCount: blocks.length,
          itemBuilder: (context, index) {
            return ListTile(
                title: Text(blocks[index].name)
            );
          }
      );
    } else {
      return Builder(
        builder: (context) {
          final appStrings = AppLocalizations.of(context)!;
          return Column(
              children: [
                Text(appStrings.no_training_blocks),
                Text(appStrings.start_new_block)
              ]
          );
        }
      );
    }
  }
}