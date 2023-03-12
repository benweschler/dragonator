import 'dart:math';

import 'package:dragonator/data/team.dart';
import 'package:dragonator/dummy_data.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/utils/navigator_utils.dart';
import 'package:dragonator/widgets/buttons/option_button.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:dragonator/widgets/modal_sheets/context_menu.dart';
import 'package:flutter/material.dart';

import 'components/player_preview_card.dart';

class RosterScreen extends StatelessWidget {
  final ValueNotifier<Team> selectedTeamNotifier = ValueNotifier(teamOne);

  RosterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedTeamNotifier,
      builder: (_, team, __) {
        return CustomScaffold(
          center: ResponsiveStrokeButton(
            onTap: () => context.showModal(
              _ChangeTeamMenu(changeTeam: (newTeam) {
                if (selectedTeamNotifier.value != newTeam) {
                  selectedTeamNotifier.value = newTeam;
                }
              }),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${team.name} ",
                  style: TextStyles.title1,
                ),
                Transform.rotate(
                  angle: pi / 2,
                  child: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
          ),
          child: _RosterContent(team),
        );
      },
    );
  }
}

class _RosterContent extends StatelessWidget {
  final Team team;

  const _RosterContent(this.team, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (team.playerIDs.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Roster", style: TextStyles.h1),
          Expanded(
            child: Center(
              child: Text(
                "No players in ${team.name}",
              ),
            ),
          ),
        ],
      );
    }

    final Widget heading = Row(
      children: [
        const Text("Roster", style: TextStyles.h1),
        const Spacer(),
        OptionButton(onTap: () => {}, icon: Icons.sort_rounded),
        const SizedBox(width: Insets.sm),
        OptionButton(onTap: () {}, icon: Icons.filter_alt_rounded),
      ],
    );

    return ListView(
      children: [
        heading,
        ...team.playerIDs
            .map<Widget>((player) => PlayerPreviewCard(player))
            //TODO: don't hardcode, this sucks
            .separate(const Divider(height: 0.5, thickness: 0.5))
            .toList(),
      ],
    );
  }
}

class _ChangeTeamMenu extends StatelessWidget {
  final ValueChanged<Team> changeTeam;

  const _ChangeTeamMenu({Key? key, required this.changeTeam}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContextMenu(
      actions: [
        ContextMenuAction(
          icon: Icons.abc,
          label: "Team One",
          onTap: () => changeTeam(teamOne),
        ),
        ContextMenuAction(
          icon: Icons.abc,
          label: "Team Two",
          onTap: () => changeTeam(teamTwo),
        ),
      ],
    );
  }
}
