import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/screens/single_field_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NameTeamScreen extends StatelessWidget {
  final String? teamID;

  const NameTeamScreen({this.teamID, super.key});

  @override
  Widget build(BuildContext context) {
    final rosterModel = context.read<RosterModel>();
    final teamName = rosterModel.getTeam(teamID)?.name;

    return SingleFieldFormScreen(
      onSave: (name) async => teamID != null
          ? rosterModel.renameTeam(teamID!, name)
          : rosterModel.createTeam(name),
      actionLabel: teamID == null ? 'Create' : 'Rename',
      initialValue: teamName ?? 'Team #${rosterModel.teams.length + 1}',
      heading: teamID == null ? 'Create Team' : 'Rename Team',
    );
  }
}
