import 'package:dragonator/data/lineup.dart';
import 'package:dragonator/data/paddler.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/screens/single_field_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateLineupScreen extends StatelessWidget {
  const CreateLineupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lineupNum = context.read<RosterModel>().lineups.length + 1;
    final defaultName = 'Lineup #$lineupNum';

    return SingleFieldFormScreen(
      onSave: (lineupName) => context.read<RosterModel>().setLineup(Lineup(
            id: '$lineupNum',
            name: lineupName,
            paddlers: const Iterable<Paddler?>.empty(),
          )),
      heading: 'Create Lineup',
      initialValue: defaultName,
      hintText: defaultName,
    );
  }
}
