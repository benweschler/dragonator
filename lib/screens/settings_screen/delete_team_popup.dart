import 'package:dragonator/data/team/team.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/team_dependent_modal_state_mixin.dart';
import 'package:dragonator/widgets/buttons/expanding_buttons.dart';
import 'package:dragonator/widgets/custom_input_decoration.dart';
import 'package:dragonator/widgets/popups/popup_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DeleteTeamPopup extends StatefulWidget {
  final String teamID;

  const DeleteTeamPopup(this.teamID, {super.key});

  @override
  State<DeleteTeamPopup> createState() => _DeleteTeamPopupState();
}

class _DeleteTeamPopupState extends State<DeleteTeamPopup>
    with TeamDependentModalStateMixin {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<RosterModel, Team?>(
        shouldRebuild: (previous, next) => next != null,
        selector: (context, model) => model.getTeam(widget.teamID),
        builder: (context, team, _) {
          return PopupDialog(
            child: Padding(
              padding: EdgeInsets.all(Insets.med),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Confirm Team Deletion', style: TextStyles.title1),
                  SizedBox(height: Insets.lg),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                      text: 'Type ',
                      style: TextStyle(fontWeight: FontWeight.normal),

                    ),
                    TextSpan(
                      text: team!.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          ' to confirm you want to delete this team.',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ])),
                  SizedBox(height: Insets.med),
                  Container(
                    padding: const EdgeInsets.all(Insets.sm),
                    decoration: BoxDecoration(
                      borderRadius: Corners.medBorderRadius,
                      color: AppColors.of(context).error.withOpacity(0.08),
                      border: Border.all(color: AppColors.of(context).error),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_rounded,
                          color: AppColors.of(context).error,
                          //size: 28,
                          //weight: 2,
                        ),
                        //SizedBox(width: Insets.sm),
                        Expanded(
                          child: Text(
                            'Warning: this can not be undone',
                            textAlign: TextAlign.center,
                            style: TextStyles.body2.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.of(context).error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(),
                  SizedBox(height: Insets.med),
                  TextField(
                    controller: _controller,
                    decoration: CustomInputDecoration(
                      AppColors.of(context),
                      hintText: team.name,
                    ),
                  ),
                  SizedBox(height: Insets.xl),
                  ListenableBuilder(
                    listenable: _controller,
                    builder: (_, __) => ExpandingStadiumButton(
                      enabled: _controller.text == team.name,
                      onTap: () {
                        if (_controller.text == team.name) {
                          cancelTeamDependence();
                          context.pop();
                          context.read<RosterModel>().deleteTeam(widget.teamID);
                        }
                      },
                      color: AppColors.of(context).error,
                      label: 'Delete Team',
                    ),
                  ),
                  SizedBox(height: Insets.sm),
                  ExpandingTextButton(
                    onTap: context.pop,
                    text: 'Cancel',
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  String get teamID => widget.teamID;
}
