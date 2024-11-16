import 'dart:math';

import 'package:dragonator/data/team.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/utils/navigator_utils.dart';
import 'package:flutter/material.dart';

import 'buttons/responsive_buttons.dart';
import 'modal_sheets/selection_menu.dart';

class ChangeTeamHeading extends StatelessWidget {
  final List<Team> teams;
  final int selectedTeamIndex;
  final ValueChanged<int> updateSelectedTeamIndex;

  const ChangeTeamHeading({
    super.key,
    required this.teams,
    required this.selectedTeamIndex,
    required this.updateSelectedTeamIndex,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveStrokeButton(
      onTap: () => context.showModal(SelectionMenu(
        items: teams.map((team) => team.name).toList(),
        initiallySelectedIndex: selectedTeamIndex,
        onItemTap: (newTeamIndex) {
          if (selectedTeamIndex != newTeamIndex) {
            updateSelectedTeamIndex(newTeamIndex);
          }
        },
      )),
      child: LayoutBuilder(
        builder: (context, constraints) => ConstrainedBox(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.75),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    'Team One',//'${teams[selectedTeamIndex].name} ',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.title1,
                  ),
                ),
                Transform.rotate(
                  angle: pi / 2,
                  child: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
          )
      ),
    );
  }
}