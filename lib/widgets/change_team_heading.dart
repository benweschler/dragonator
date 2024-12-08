import 'dart:math';

import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'buttons/responsive_buttons.dart';
import 'modal_sheets/selection_menu.dart';

class ChangeTeamHeading extends StatelessWidget {
  const ChangeTeamHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RosterModel>(builder: (context, rosterModel, child) {
      final teams = rosterModel.teams.toList();
      if (teams.isEmpty) return SizedBox();

      return ResponsiveStrokeButton(
        onTap: () => context.showModal(_TeamSelectionMenu()),
        child: LayoutBuilder(
          builder: (context, constraints) => ConstrainedBox(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.75),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    rosterModel.currentTeam!.name,
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
          ),
        ),
      );
    });
  }
}

class _TeamSelectionMenu extends StatelessWidget {
  const _TeamSelectionMenu();

  @override
  Widget build(BuildContext context) {
    return Consumer<RosterModel>(
      builder: (context, rosterModel, child) {
        final teams = rosterModel.teams.toList();

        return SelectionMenu(
          items: teams.map((team) => team.name).toList(),
          initiallySelectedIndex: teams
              .indexWhere((team) => team.id == rosterModel.currentTeam!.id),
          onItemTap: (newTeamIndex) =>
              rosterModel.setCurrentTeam(teams[newTeamIndex].id),
        );
      },
    );
  }
}
