import 'package:dragonator/data/lineup/lineup.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/screens/single_field_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NameLineupScreen extends StatelessWidget {
  final String? lineupID;

  const NameLineupScreen({super.key, this.lineupID});

  @override
  Widget build(BuildContext context) {
    final Lineup? lineup = lineupID != null
        ? context.read<RosterModel>().getLineup(lineupID!)
        : null;

    final lineupNum = context.read<RosterModel>().lineups.length + 1;
    final defaultName = 'Lineup #$lineupNum';

    return SingleFieldFormScreen(
      onSave: (lineupName) => context.read<RosterModel>().setLineup(
            lineup?.copyWith(name: lineupName) ??
                Lineup(
                  id: '$lineupNum',
                  name: lineupName,
                  //TODO: implement choosing a boat
                  boatID: '',
                  paddlerIDs: const Iterable<String?>.empty(),
                ),
          ),
      heading: 'Create Lineup',
      initialValue: lineup?.name ?? defaultName,
      hintText: lineup?.name ?? defaultName,
    );
  }
}
