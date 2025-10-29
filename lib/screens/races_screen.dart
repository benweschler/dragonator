import 'package:dragonator/widgets/buttons/custom_fab.dart';
import 'package:dragonator/widgets/change_team_heading.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';

class RacesScreen extends StatelessWidget {
  const RacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      floatingActionButton: CustomFAB(
        child: const Icon(Icons.add_rounded),
        onTap: () {},
      ),
      center: ChangeTeamHeading(),
      child: Center(
        child: Text('Races Screen'),
      ),
    );
  }
}
