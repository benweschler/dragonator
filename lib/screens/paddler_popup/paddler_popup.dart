import 'package:dragonator/data/lineup/lineup.dart';
import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/data/team/team.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/dependence_mixins/team_detail_dependent_state_mixin.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/buttons/expanding_buttons.dart';
import 'package:dragonator/widgets/labeled/labeled_table.dart';
import 'package:dragonator/widgets/modal_navigator.dart';
import 'package:dragonator/widgets/pages.dart';
import 'package:dragonator/widgets/popups/popup_dialog.dart';
import 'package:dragonator/widgets/position_preference_indicator.dart';
import 'package:dragonator/widgets/preview_tiles/lineup_preview_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'paddler_context_menu.dart';

class PaddlerPopup extends StatefulWidget {
  final String paddlerID;

  const PaddlerPopup(this.paddlerID, {super.key});

  @override
  State<PaddlerPopup> createState() => _PaddlerPopupState();
}

class _PaddlerPopupState extends State<PaddlerPopup>
    with TeamDetailDependentStateMixin {
  @override
  Widget build(BuildContext context) {
    return PopupDialog(
      child: ModalNavigator(
        onGenerateRoute: (settings) {
          final path = settings.name;

          if (path!.startsWith('/copy-to-team')) {
            final bool multipleTeams =
                bool.parse(Uri.parse(path).queryParameters['multiple-teams']!);

            return PopupTransitionPage<bool>(
              child: Padding(
                padding: EdgeInsets.all(Insets.lg),
                child: _CopyPaddlerConfirmationView(
                  multipleTeams: multipleTeams,
                ),
              ),
            ).createRoute(context);
          } else if (path.startsWith('/lineups')) {
            return PopupTransitionPage(
              child: Padding(
                padding: EdgeInsets.all(Insets.lg),
                child: _ActiveLineupsView(widget.paddlerID),
              ),
            ).createRoute(context);
          }

          return MaterialPageRoute(
            builder: (context) => Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Insets.lg,
                vertical: Insets.lg,
              ),
              child: _PaddlerInfoView(widget.paddlerID),
            ),
          );
        },
      ),
    );
  }

  @override
  String get detailLabel => 'paddler';

  @override
  VoidCallback get dismissWidget => context.pop;

  @override
  Object? Function() get getDetail =>
      () => context.read<RosterModel>().getPaddler(widget.paddlerID);
}

class _PaddlerInfoView extends StatelessWidget {
  final String paddlerID;

  const _PaddlerInfoView(this.paddlerID);

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

        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CustomIconButton(
                    icon: Icons.close_rounded,
                    onTap: context.pop,
                  ),
                  SizedBox(width: Insets.med),
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            '${paddler.firstName} ${paddler.lastName}',
                            style: TextStyles.h2,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: Insets.med),
                  CustomIconButton(
                    onTap: () => context.showModal(PaddlerContextMenu(
                      paddler: paddler!,
                      popupContext: context,
                    )),
                    icon: Icons.more_horiz,
                  ),
                ],
              ),
              Selector<RosterModel, Team>(
                selector: (context, model) => model.currentTeam!,
                builder: (_, team, __) => Text(
                  team.name,
                  style: TextStyles.body1.copyWith(
                    color: AppColors.of(context).neutralContent,
                  ),
                ),
              ),
              SizedBox(height: Insets.lg),
              _PaddlerStatTable(paddler),
              const SizedBox(height: Insets.xl),
              PositionPreferenceIndicator(
                label: 'Drummer',
                hasPreference: paddler.drummerPreference,
              ),
              SizedBox(height: Insets.med),
              PositionPreferenceIndicator(
                label: 'Steers Person',
                hasPreference: paddler.steersPersonPreference,
              ),
              SizedBox(height: Insets.med),
              PositionPreferenceIndicator(
                label: 'Stroke',
                hasPreference: paddler.strokePreference,
              ),
              if (paddler.cancerSurvivor) ...[
                SizedBox(height: Insets.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Cancer Survivor',
                      style: TextStyles.body2.copyWith(
                          color: AppColors.of(context).neutralContent),
                    ),
                    SizedBox(width: Insets.lg),
                    SizedBox.square(
                      dimension: 25,
                      child: Image.network(
                        'https://static.thenounproject.com/png/126432-200.png',
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: Insets.sm),
            ],
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
            Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: '${paddler.weight}',
                  style: TextStyles.title1.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const TextSpan(text: ' lbs', style: TextStyles.body2),
              ]),
              textAlign: TextAlign.center,
            ),
            Text(
              '${paddler.gender}',
              textAlign: TextAlign.center,
              style: TextStyles.title1.copyWith(fontWeight: FontWeight.normal),
            ),
          ],
        ),
        LabeledTableRow(
          labels: ['Side', 'Age Group'],
          stats: [
            Text(
              '${paddler.sidePreference}',
              textAlign: TextAlign.center,
              style: TextStyles.title1.copyWith(fontWeight: FontWeight.normal),
            ),
            Text(
              paddler.ageGroup.toString(),
              textAlign: TextAlign.center,
              style: TextStyles.title1.copyWith(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ],
    );
  }
}

class _CopyPaddlerConfirmationView extends StatelessWidget {
  final bool multipleTeams;

  const _CopyPaddlerConfirmationView({required this.multipleTeams});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}

class _ActiveLineupsView extends StatelessWidget {
  final String paddlerID;

  const _ActiveLineupsView(this.paddlerID);

  @override
  Widget build(BuildContext context) {
    final activeLineups = context.select<RosterModel, Iterable<Lineup>>(
      (model) => model.lineups
          .where((lineup) => lineup.paddlerIDs.contains(paddlerID)),
    );

    final iterator = activeLineups.iterator..moveNext();

    final paddler = context
        .select<RosterModel, Paddler>((model) => model.getPaddler(paddlerID)!);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${paddler.firstName} ${paddler.lastName}',
          style: TextStyles.h2,
        ),
        if (activeLineups.isNotEmpty)
          Text(
            'Active Lineups',
            style: TextStyles.body1.copyWith(
              color: AppColors.of(context).neutralContent,
            ),
          ),
        SizedBox(height: Insets.med),
        if (activeLineups.isNotEmpty)
          ...List.generate(
            activeLineups.length,
            (index) {
              final tile = LineupPreviewTile(
                iterator.current,
                onTap: () async {
                  context.pop();
                  await Future.delayed(Timings.long);
                },
              );
              iterator.moveNext();
              return tile;
            },
          )
        else
          Text(
            'No Active Lineups',
            style: TextStyles.body2.copyWith(
              color: AppColors.of(context).neutralContent,
            ),
          ),
        SizedBox(height: Insets.xl),
        ExpandingTextButton(
          onTap: Navigator.of(context).pop,
          text: 'Back',
        ),
      ],
    );
  }
}
