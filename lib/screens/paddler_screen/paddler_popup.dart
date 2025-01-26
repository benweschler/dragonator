import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/data/team/team.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/labeled_table.dart';
import 'package:dragonator/widgets/modal_sheets/context_menu.dart';
import 'package:dragonator/widgets/popups/popup_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PaddlerPopup extends StatelessWidget {
  final String paddlerID;

  const PaddlerPopup(this.paddlerID, {super.key});

  @override
  Widget build(BuildContext context) {
    return PopupDialog(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Insets.lg,
          vertical: Insets.lg,
        ),
        child: Selector<RosterModel, Paddler?>(
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
                        onTap: () => context.showModal(ContextMenu([
                          ContextMenuAction(
                            icon: Icons.edit_rounded,
                            label: 'Edit',
                            onTap: () =>
                                RoutePaths.editPaddler(paddlerID: paddlerID),
                          ),
                          ContextMenuAction(
                            icon: Icons.add_rounded,
                            label: 'Add to team',
                            onTap: () =>
                                RoutePaths.editPaddler(paddlerID: paddlerID),
                          ),
                        ])),
                        icon: Icons.edit_rounded,
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
        ),
      ),
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
