import 'package:dragonator/data/lineup/lineup.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/screens/single_field_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

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
      onSave: (lineupName) {
        //TODO: dummy
        final boat =
            context.read<RosterModel>().currentTeam!.boats.values.first;
        context.read<RosterModel>().setLineup(
              lineup?.copyWith(name: lineupName) ??
                  Lineup(
                    id: Uuid().v4(),
                    name: lineupName,
                    //TODO: implement choosing a boat
                    boatID: boat.id,
                    //TODO: because this must be the capacity of the boat, abstract this away into a create lineup method in RosterModel.
                    paddlerIDs:
                        Iterable<String?>.generate(boat.capacity, (_) => null),
                  ),
            );
      },
      actionLabel: 'Create',
      heading: 'Create Lineup',
      initialValue: lineup?.name ?? defaultName,
      hintText: lineup?.name ?? defaultName,
    );
  }
}
