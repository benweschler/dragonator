import 'dart:math';

import 'package:dragonator/data/team.dart';
import 'package:dragonator/dummy_data.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/player_card.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({Key? key}) : super(key: key);

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  final ValueNotifier<Team> selectedTeamNotifier = ValueNotifier(teamOne);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: selectedTeamNotifier,
      child: CustomScaffold(
        center: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${selectedTeamNotifier.value.name} ",
                style: TextStyles.title1),
            Transform.rotate(
              angle: pi / 2,
              child: const Icon(Icons.chevron_right_sharp),
            ),
          ],
        ),
        child: ListView(
          children: [
            const Text("Roster", style: TextStyles.h1),
            ...selectedTeamNotifier.value.roster
                .map<Widget>((player) => PlayerCard(player))
                //TODO: don't hardcode, this sucks
                .separate(const Divider(height: 0.5, thickness: 0.5))
                .toList(),
          ],
        ),
      ),
    );
  }
}
