import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:dragonator/widgets/single_field_form.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NameTeamScreen extends StatelessWidget {
  final String? teamID;

  const NameTeamScreen({this.teamID, super.key});

  @override
  Widget build(BuildContext context) {
    final rosterModel = context.read<RosterModel>();
    final teamName = rosterModel.getTeam(teamID)?.name;

    return CustomScaffold(
      addScreenInset: false,
      leading: CustomIconButton(
        onTap: context.pop,
        icon: Icons.close_rounded,
      ),
      center: Text(
        teamID == null ? 'Create Team' : 'Rename Team',
        style: TextStyles.title1,
      ),
      child: SingleFieldForm(
        onSave: (name) async => teamID != null
            ? rosterModel.renameTeam(teamID!, name)
            : rosterModel.createTeam(name),
        actionLabel: teamID == null ? 'Create' : 'Rename',
        initialValue: teamName ?? 'Team #${rosterModel.teams.length + 1}',
      ),
    );
  }
}
