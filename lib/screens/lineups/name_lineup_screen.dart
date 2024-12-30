import 'package:dragonator/data/lineup/lineup.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/screens/lineups/select_lineup_boat_popup.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:dragonator/widgets/single_field_form.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class NameLineupScreen extends StatelessWidget {
  final String? lineupID;

  const NameLineupScreen({super.key, this.lineupID});

  void _renameLineup(String lineupName, BuildContext context) {
    final lineup = context.read<RosterModel>().getLineup(lineupID!)!;
    context.read<RosterModel>().setLineup(lineup.copyWith(name: lineupName));
  }

  void _selectLineupBoat(String lineupName, BuildContext context) async {
    final rosterModel = context.read<RosterModel>();
    final navigatorContext = Navigator.of(context).context;

    await Future.delayed(Timings.long);

    if (!navigatorContext.mounted) return;
    navigatorContext.showPopup(SelectLineupBoatPopup(
      onSelectBoat: (boat) => rosterModel.setLineup(Lineup(
        id: Uuid().v4(),
        name: lineupName,
        boatID: boat.id,
        //TODO: because this must be the capacity of the boat, abstract this away into a create lineup method in RosterModel.
        paddlerIDs: Iterable<String?>.generate(boat.capacity, (_) => null),
      )),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final Lineup? lineup = lineupID != null
        ? context.read<RosterModel>().getLineup(lineupID!)
        : null;

    final lineupNum = context.read<RosterModel>().lineups.length + 1;
    final defaultName = 'Lineup #$lineupNum';

    return CustomScaffold(
      addScreenInset: false,
      leading: CustomIconButton(
        icon: Icons.close,
        onTap: context.pop,
      ),
      center: Text(
        '${lineupID == null ? 'Create' : 'Rename'} Lineup',
        style: TextStyles.title1,
      ),
      child: SingleFieldForm(
        onSave: (value) => lineupID == null
            ? _selectLineupBoat(value, context)
            : _renameLineup(value, context),
        actionLabel: lineupID == null ? 'Continue' : 'Rename',
        initialValue: lineup?.name ?? defaultName,
      ),
    );
  }
}
