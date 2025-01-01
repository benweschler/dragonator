import 'package:dragonator/data/lineup/lineup.dart';
import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/widgets/buttons/action_button_card.dart';
import 'package:dragonator/widgets/buttons/custom_back_button.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:dragonator/widgets/labeled_table.dart';
import 'package:dragonator/widgets/preview_tiles/lineup_preview_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'preference_row.dart';

class PaddlerScreen extends StatelessWidget {
  final String paddlerID;

  const PaddlerScreen(this.paddlerID, {super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<RosterModel, Paddler?>(
      selector: (_, model) => model.getPaddler(paddlerID),
      // If the paddler is deleted, this screen is popped and should
      // continue showing the same screen (i.e. the deleted paddler's
      // details) while animating out.
      shouldRebuild: (_, newPaddler) => newPaddler != null,
      builder: (_, paddler, __) {
        paddler = paddler as Paddler;

        return CustomScaffold(
          leading: const CustomBackButton(),
          center: Text(
            '${paddler.firstName} ${paddler.lastName}',
            style: TextStyles.title1,
          ),
          trailing: CustomIconButton(
            onTap: () => context.push(RoutePaths.editPaddler(paddlerID: paddlerID)),
            icon: Icons.edit_rounded,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: Insets.xl),
                _PaddlerStatTable(paddler),
                const SizedBox(height: Insets.xl),
                Row(
                  children: [
                    Expanded(
                      child: PreferenceRow(
                        label: 'Drummer',
                        hasPreference: paddler.drummerPreference,
                      ),
                    ),
                    Expanded(
                      child: PreferenceRow(
                        label: 'Steers Person',
                        hasPreference: paddler.steersPersonPreference,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Insets.med),
                PreferenceRow(
                  label: 'Stroke',
                  hasPreference: paddler.strokePreference,
                ),
                const SizedBox(height: Insets.xl),
                Text('Active Lineups', style: TextStyles.h2),
                SizedBox(height: Insets.sm),
                _ActiveLineups(paddlerID),
                SizedBox(height: Insets.xl),
                //TODO: implement actions
                ActionButtonCard([
                  CardActionButton(
                    onTap: () {},
                    label: 'Add to team',
                    icon: Icons.add_rounded,
                  ),
                  CardActionButton(
                    onTap: () async {
                      await context
                          .read<RosterModel>()
                          .deletePaddler(paddlerID);
                      if (context.mounted) context.pop();
                    },
                    label: 'Delete',
                    icon: Icons.delete_rounded,
                  ),
                ]),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PaddlerStatTable extends StatelessWidget {
  final Paddler paddler;

  const _PaddlerStatTable(this.paddler);

  @override
  Widget build(BuildContext context) {
    return LabeledTable(
      rows: [
        LabeledTableRow(
          labels: ['Weight', 'Gender'],
          stats: [
            Text.rich(TextSpan(children: [
              TextSpan(
                text: '${paddler.weight}',
                style: TextStyles.title1,
              ),
              const TextSpan(text: ' lbs', style: TextStyles.body2),
            ])),
            Text('${paddler.gender}', style: TextStyles.title1),
          ],
        ),
        LabeledTableRow(
          labels: ['Side', 'Age Group'],
          stats: [
            Text('${paddler.sidePreference}', style: TextStyles.title1),
            Text(paddler.ageGroup.toString(), style: TextStyles.title1),
          ],
        ),
      ],
    );
  }
}

class _ActiveLineups extends StatelessWidget {
  final String paddlerID;

  const _ActiveLineups(this.paddlerID);

  @override
  Widget build(BuildContext context) {
    final activeLineups = context.select<RosterModel, Iterable<Lineup>>(
      (model) => model.lineups
          .where((lineup) => lineup.paddlerIDs.contains(paddlerID)),
    );

    final iterator = activeLineups.iterator..moveNext();

    return Column(
      children: List.generate(
        activeLineups.length,
        (index) {
          final tile = LineupPreviewTile(iterator.current);
          iterator.moveNext();
          return tile;
        },
      ),
    );
  }
}
