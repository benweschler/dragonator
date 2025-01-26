import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/data/team/team.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/buttons/expanding_buttons.dart';
import 'package:dragonator/widgets/labeled_table.dart';
import 'package:dragonator/widgets/modal_navigator.dart';
import 'package:dragonator/widgets/modal_sheets/context_menu.dart';
import 'package:dragonator/widgets/pages.dart';
import 'package:dragonator/widgets/popups/popup_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'copy_to_team.dart';

class PaddlerPopup extends StatelessWidget {
  final String paddlerID;

  const PaddlerPopup(this.paddlerID, {super.key});

  @override
  Widget build(BuildContext context) {
    return PopupDialog(
      child: ModalNavigator(
        routeBuilder: (path) {
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
          }

          return MaterialPageRoute(
            builder: (context) => Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Insets.lg,
                vertical: Insets.lg,
              ),
              child: _PaddlerInfoView(paddlerID),
            ),
          );
        },
      ),
    );
  }
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
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            '${paddler.firstName} ${paddler.lastName}',
                            style: TextStyles.h2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomIconButton(
                    onTap: () => context.showModal(_PaddlerContextMenu(
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
              _TestPreferenceIndicator(
                label: 'Drummer',
                hasPreference: paddler.drummerPreference,
              ),
              SizedBox(height: Insets.med),
              _TestPreferenceIndicator(
                label: 'Steers Person',
                hasPreference: paddler.steersPersonPreference,
              ),
              SizedBox(height: Insets.med),
              _TestPreferenceIndicator(
                label: 'Stroke',
                hasPreference: paddler.strokePreference,
              ),
              SizedBox(height: Insets.sm),
            ],
          ),
        );
      },
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

class _TestPreferenceIndicator extends StatelessWidget {
  final String label;
  final bool hasPreference;

  const _TestPreferenceIndicator({
    required this.label,
    required this.hasPreference,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Insets.sm,
        horizontal: Insets.lg,
      ),
      decoration: BoxDecoration(
        borderRadius: Corners.medBorderRadius,
        color: hasPreference ? AppColors.of(context).primarySurface : null,
        border: Border.all(
          color: hasPreference
              ? AppColors.of(context).primary
              : AppColors.of(context).outline,
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              hasPreference ? Icons.check_rounded : Icons.close_rounded,
              color: hasPreference
                  ? AppColors.of(context).primary
                  : AppColors.of(context).neutralContent,
            ),
          ),
          Center(
            child: Text(
              label,
              style: TextStyles.body1.copyWith(
                color: hasPreference
                    ? AppColors.of(context).primary
                    : AppColors.of(context).neutralContent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
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

class _PaddlerContextMenu extends StatelessWidget {
  final Paddler paddler;
  final BuildContext popupContext;

  const _PaddlerContextMenu({
    required this.paddler,
    required this.popupContext,
  });

  @override
  Widget build(BuildContext context) {
    return ContextMenu([
      ContextMenuAction(
        onTap: () async {
          await Future.delayed(Timings.long);

          if (!popupContext.mounted) return;
          popupContext.push(RoutePaths.editPaddler(paddlerID: paddler.id));
        },
        icon: Icons.edit_rounded,
        label: 'Edit',
      ),
      ContextMenuAction(
        onTap: () async {
          await Future.delayed(Timings.long);

          if (!popupContext.mounted) return;
          popupContext.showModal(CopyPaddlerToTeamMenu(
            paddler: paddler,
            popupContext: popupContext,
          ));
        },
        icon: Icons.add_rounded,
        label: 'Add to team',
      ),
      ContextMenuAction(
        onTap: () {},
        icon: Icons.library_books,
        label: 'View lineups',
      ),
      ContextMenuAction(
        onTap: () async {
          await context.read<RosterModel>().deletePaddler(paddler.id);
          if (context.mounted) context.pop();
        },
        isDestructiveAction: true,
        icon: Icons.delete_rounded,
        label: 'Delete',
      ),
    ]);
  }
}
