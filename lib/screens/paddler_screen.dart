import 'package:dragonator/data/lineup/lineup.dart';
import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/data/team/team.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:dragonator/widgets/buttons/action_button_card.dart';
import 'package:dragonator/widgets/buttons/custom_back_button.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/buttons/expanding_buttons.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:dragonator/widgets/labeled_table.dart';
import 'package:dragonator/widgets/modal_sheets/selection_menu.dart';
import 'package:dragonator/widgets/popups/popup_dialog.dart';
import 'package:dragonator/widgets/preview_tiles/lineup_preview_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
            onTap: () =>
                context.push(RoutePaths.editPaddler(paddlerID: paddlerID)),
            icon: Icons.edit_rounded,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: Insets.xl),
                _PaddlerStatTable(paddler),
                const SizedBox(height: Insets.xl * 1.5),
                Row(
                  children: [
                    _PositionPreferenceIndicator(
                      label: 'Drummer',
                      hasPreference: paddler.drummerPreference,
                    ),
                    _PositionPreferenceIndicator(
                      label: 'Stroke',
                      hasPreference: paddler.strokePreference,
                    ),
                    _PositionPreferenceIndicator(
                      label: 'Steers Person',
                      hasPreference: paddler.steersPersonPreference,
                    ),
                  ].map((e) => Expanded(child: Center(child: e))).toList(),
                ),
                const SizedBox(height: Insets.xl),
                Text('Active Lineups', style: TextStyles.h2),
                SizedBox(height: Insets.sm),
                _ActiveLineups(paddlerID),
                SizedBox(height: Insets.xl),
                //TODO: implement actions
                ActionButtonCard([
                  CardActionButton(
                    onTap: () => context.showModal(
                      _CopyPaddlerToTeamMenu(paddler!),
                    ),
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

class _PositionPreferenceIndicator extends StatelessWidget {
  final String label;
  final bool hasPreference;

  const _PositionPreferenceIndicator({
    required this.label,
    required this.hasPreference,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(Insets.sm),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hasPreference ? AppColors.of(context).primarySurface : null,
            border: Border.all(
              width: 1.5,
              color: hasPreference
                  ? AppColors.of(context).primary
                  : AppColors.of(context).outline,
            ),
          ),
          child: Icon(
            hasPreference ? Icons.check_rounded : Icons.close_rounded,
            size: TextStyles.h2.fontSize,
            color: hasPreference
                ? AppColors.of(context).primary
                : AppColors.of(context).neutralContent,
          ),
        ),
        SizedBox(height: Insets.med),
        Text(label, style: TextStyles.body1),
      ],
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
                style: TextStyles.title1.copyWith(
                  fontWeight: FontWeight.normal,
                ),
              ),
              const TextSpan(text: ' lbs', style: TextStyles.body2),
            ])),
            Text(
              '${paddler.gender}',
              style: TextStyles.title1.copyWith(fontWeight: FontWeight.normal),
            ),
          ],
        ),
        LabeledTableRow(
          labels: ['Side', 'Age Group'],
          stats: [
            Text(
              '${paddler.sidePreference}',
              style: TextStyles.title1.copyWith(fontWeight: FontWeight.normal),
            ),
            Text(
              paddler.ageGroup.toString(),
              style: TextStyles.title1.copyWith(fontWeight: FontWeight.normal),
            ),
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

class _CopyPaddlerToTeamMenu extends StatelessWidget {
  final Paddler paddler;

  const _CopyPaddlerToTeamMenu(this.paddler);

  @override
  Widget build(BuildContext context) {
    return Selector<RosterModel, Iterable<Team>>(
      selector: (context, model) => model.teams,
      builder: (context, teams, _) {
        final rosterModel = context.read<RosterModel>();

        return SelectionMenu.multi(
          options: teams.toSet()..remove(rosterModel.currentTeam),
          labelBuilder: (team) => team.name,
          onSelect: (Set<Team> teams) async {
            final confirmation =
                await context.showPopup<bool>(_CopyPaddlerConfirmationPopup(
                      multipleTeams: teams.length > 1,
                    )) ??
                    false;

            if (!confirmation) return;

            for (var team in teams) {
              await rosterModel.copyPaddlerToTeam(paddler, team.id);
            }
            if (context.mounted) context.pop();
          },
        );
      },
    );
  }
}

class _CopyPaddlerConfirmationPopup extends StatelessWidget {
  final bool multipleTeams;

  const _CopyPaddlerConfirmationPopup({required this.multipleTeams});

  @override
  Widget build(BuildContext context) {
    return PopupDialog(
      child: Padding(
        padding: EdgeInsets.all(Insets.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Confirm Adding Paddler', style: TextStyles.title1),
            SizedBox(height: Insets.lg),
            Text(
              'If this paddler already exists in ${multipleTeams ? 'these teams' : 'this team'}, this will create a duplicate.\n\nAre you sure you want to continue?',
            ),
            SizedBox(height: Insets.xl),
            ExpandingStadiumButton(
              onTap: () => Navigator.pop(context, true),
              color: AppColors.of(context).primary,
              label: 'Confirm',
            ),
            SizedBox(height: Insets.sm),
            ExpandingTextButton(
              onTap: () => Navigator.pop(context, false),
              text: 'Cancel',
            ),
          ],
        ),
      ),
    );
  }
}
