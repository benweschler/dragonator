import 'package:dragonator/data/boat/boat.dart';
import 'package:dragonator/data/team/team.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/utils/validators.dart';
import 'package:dragonator/widgets/buttons/expanding_buttons.dart';
import 'package:dragonator/widgets/custom_input_decoration.dart';
import 'package:dragonator/widgets/popup_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BoatsPopup extends StatelessWidget {
  final String teamID;

  const BoatsPopup(this.teamID, {super.key});

  @override
  Widget build(BuildContext context) {
    return PopupDialog(
      child: AnimatedSize(
        duration: Duration(milliseconds: 400),
        curve: Curves.fastEaseInToSlowEaseOut,
        child: IntrinsicHeight(
          //TODO: current: selector should be around routes because it doesn't update them since they're instantiated in a closure.
          child: Selector<RosterModel, Team?>(
              selector: (context, model) => model.getTeam(teamID),
              builder: (context, team, child) {
                // True if this team is deleted during editing.
                if (team == null) {
                  context.pop();
                  //TODO: this will cause a visual jump if the current team is deleted.
                  return Container();
                }

                return Navigator(
                  onGenerateRoute: (settings) {
                    Widget content;
                    if (settings.name == '/') {
                      content = _BoatList(team);
                    } else {
                      var id = Uri.parse(settings.name!).pathSegments.first;
                      content = _EditBoat(team.boats[id]!, team.id);
                    }
                    return FadeTransitionPage(child: content)
                        .createRoute(context);
                  },
                );
              }),
        ),
      ),
    );
  }
}

class _BoatList extends StatefulWidget {
  final Team team;

  const _BoatList(this.team);

  @override
  State<_BoatList> createState() => _BoatListState();
}

class _BoatListState extends State<_BoatList> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${widget.team.name} Boats',
          textAlign: TextAlign.center,
          style: TextStyles.title1,
        ),
        const SizedBox(height: Insets.med),
        Flexible(
          child: SingleChildScrollView(
            controller: _controller,
            child: Column(
              children: [
                if (widget.team.boats.isEmpty)
                  Text('This team doesn\'t have any boats yet.')
                else
                  for (var boat in widget.team.boats.values) _BoatTile(boat),
              ].separate(Divider(height: Insets.xl)).toList(),
            ),
          ),
        ),
        const SizedBox(height: Insets.xl),
        ExpandingStadiumButton(
          onTap: () => _controller.position.animateTo(
            _controller.position.maxScrollExtent,
            duration: Timings.med,
            curve: Curves.easeOutQuart,
          ),
          color: AppColors.of(context).primary,
          label: 'Add Boat',
        ),
        const SizedBox(height: Insets.sm),
        ExpandingTextButton(onTap: context.pop, text: 'Done'),
      ],
    );
  }
}

class _BoatTile extends StatelessWidget {
  final Boat boat;

  const _BoatTile(this.boat);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('/${boat.id}'),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  boat.name,
                  style: TextStyles.title1.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: Insets.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Capacity:', style: TextStyles.body1),
                        SizedBox(height: Insets.xs),
                        Text('Weight:', style: TextStyles.body1),
                      ],
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(TextSpan(children: [
                              TextSpan(
                                text: '${boat.capacity}',
                                style: TextStyles.body1,
                              ),
                              TextSpan(
                                text: '  paddlers',
                                style: TextStyles.body2.copyWith(
                                  color: AppColors.of(context).neutralContent,
                                ),
                              ),
                            ])),
                            Text.rich(TextSpan(children: [
                              TextSpan(
                                text: '${boat.weight}',
                                style: TextStyles.body1,
                              ),
                              TextSpan(
                                text: '  lbs',
                                style: TextStyles.body2.copyWith(
                                  color: AppColors.of(context).neutralContent,
                                ),
                              ),
                            ])),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class _EditBoat extends StatelessWidget {
  final Boat boat;
  final String teamID;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey();

  _EditBoat(this.boat, this.teamID);

  Future<void> _saveBoat(BuildContext context) async {
    if (!_formKey.currentState!.saveAndValidate()) {
      return;
    }

    final formData = _formKey.currentState!.value;
    await context.read<RosterModel>().setBoat(
          boat.copyWith(
            name: formData['name'],
            capacity: int.parse(formData['capacity']),
            weight: double.parse(formData['weight']),
          ),
          teamID,
        );
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      // Add a background color to obscure the previous route during a push
      // animation.
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit ${boat.name}',
              textAlign: TextAlign.center,
              style: TextStyles.title1,
            ),
            const SizedBox(height: Insets.med),
            FormBuilderTextField(
              name: 'name',
              initialValue: boat.name,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: Validators.required(errorText: 'Enter a name.'),
              decoration: CustomInputDecoration(
                AppColors.of(context),
              ),
            ),
            const SizedBox(height: Insets.med),
            FormBuilderTextField(
              name: 'capacity',
              initialValue: boat.capacity.toString(),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: Validators.isInt(
                errorText:
                    'Enter the number of paddlers in the boat, including the drummer and steers person.',
              ),
              decoration: CustomInputDecoration(
                AppColors.of(context),
                suffix: const Text('paddlers', style: TextStyles.body2),
              ),
            ),
            const SizedBox(height: Insets.med),
            FormBuilderTextField(
              name: 'weight',
              initialValue: boat.weight.toString(),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: Validators.required(
                errorText: 'Enter the boat\'s weight.',
              ),
              decoration: CustomInputDecoration(
                AppColors.of(context),
                suffix: const Text('lbs', style: TextStyles.body2),
              ),
            ),
            const SizedBox(height: Insets.xl),
            ExpandingStadiumButton(
              onTap: () => _saveBoat(context),
              color: AppColors.of(context).buttonContainer,
              textColor: AppColors.of(context).onButtonContainer,
              label: 'Save',
            ),
            const SizedBox(height: Insets.sm),
            ExpandingTextButton(
              onTap: Navigator.of(context).pop,
              text: 'Cancel',
            ),
          ],
        ),
      ),
    );
  }
}
