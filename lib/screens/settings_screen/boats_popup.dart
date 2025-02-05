import 'package:dragonator/data/boat/boat.dart';
import 'package:dragonator/data/team/team.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/utils/dependence_mixins/team_dependent_modal_state_mixin.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:dragonator/utils/validators.dart';
import 'package:dragonator/widgets/buttons/expanding_buttons.dart';
import 'package:dragonator/widgets/custom_input_decoration.dart';
import 'package:dragonator/widgets/modal_navigator.dart';
import 'package:dragonator/widgets/pages.dart';
import 'package:dragonator/widgets/popups/popup_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class BoatsPopup extends StatefulWidget {
  final String teamID;

  const BoatsPopup(this.teamID, {super.key});

  @override
  State<BoatsPopup> createState() => _BoatsPopupState();
}

class _BoatsPopupState extends State<BoatsPopup>
    with TeamDependentModalStateMixin {
  @override
  Widget build(BuildContext context) {
    return PopupDialog(
      child: ModalNavigator(
        onGenerateRoute: (settings) {
          final path = settings.name;

          if (path!.startsWith('/set')) {
            final boatID = Uri.parse(path).queryParameters['id'];
            final boat = context
                .read<RosterModel>()
                .getTeam(widget.teamID)!
                .boats[boatID];

            //TODO: manually padding everything is not optimal. maybe do this is popup transition page.
            return PopupTransitionPage(
              child: Padding(
                padding: EdgeInsets.all(Insets.lg),
                child: _EditBoatView(boat, widget.teamID),
              ),
            ).createRoute(context);
          } else if (path.startsWith('/boat-in-use')) {
            final boatName = Uri.parse(path).queryParameters['boatName']!;
            final teamName = Uri.parse(path).queryParameters['teamName']!;

            return PopupTransitionPage(
              child: Padding(
                padding: EdgeInsets.all(Insets.lg),
                child: _BoatDeletionBlockedView(
                  boatName: boatName,
                  teamName: teamName,
                  inUseLineupNames: settings.arguments as Iterable<String>,
                ),
              ),
            ).createRoute(context);
          }

          return MaterialPageRoute(
            builder: (context) => Padding(
              padding: EdgeInsets.all(Insets.lg),
              child: _BoatListView(widget.teamID),
            ),
          );
        },
      ),
    );
  }

  @override
  String get teamID => widget.teamID;
}

class _BoatListView extends StatelessWidget {
  final String teamID;

  const _BoatListView(this.teamID);

  @override
  Widget build(BuildContext context) {
    return Selector<RosterModel, Team?>(
      selector: (context, model) => model.getTeam(teamID),
      shouldRebuild: (previous, next) => next != null,
      builder: (context, team, child) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${team!.name} Boats',
            textAlign: TextAlign.center,
            style: TextStyles.title1,
          ),
          const SizedBox(height: Insets.med),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (team.boats.isEmpty)
                    Text('This team doesn\'t have any boats yet.')
                  else
                    for (var boat in team.boats.values) _BoatTile(boat),
                ].separate(Divider(height: Insets.xl)).toList(),
              ),
            ),
          ),
          const SizedBox(height: Insets.xl),
          Hero(
            tag: 'action button',
            flightShuttleBuilder: _heroFlightShuttleBuilder,
            child: ExpandingStadiumButton(
              onTap: () => Navigator.of(context).pushNamed('/set'),
              color: AppColors.of(context).primary,
              label: 'Add Boat',
            ),
          ),
          const SizedBox(height: Insets.sm),
          Hero(
            tag: 'pop button',
            flightShuttleBuilder: _heroFlightShuttleBuilder,
            child: ExpandingTextButton(onTap: context.pop, text: 'Done'),
          ),
        ],
      ),
    );
  }
}

class _BoatTile extends StatelessWidget {
  final Boat boat;

  const _BoatTile(this.boat);

  @override
  Widget build(BuildContext context) {
    final boatDetails = Row(
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
                    text: boat.formattedWeight,
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
    );

    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        appendQueryParams('/set', {'id': boat.id}),
      ),
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
                boatDetails,
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class _EditBoatView extends StatelessWidget {
  /// If null, creates a new boat.
  final Boat? boat;
  final String teamID;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey();

  _EditBoatView(this.boat, this.teamID);

  Future<void> _saveBoat(BuildContext context) async {
    if (!_formKey.currentState!.saveAndValidate()) {
      return;
    }

    final formData = _formKey.currentState!.value;
    final Boat savedBoat;
    if (boat == null) {
      savedBoat = Boat(
        id: Uuid().v4(),
        name: formData['name'],
        capacity: int.parse(formData['capacity']),
        weight: double.parse(formData['weight']),
      );
    } else {
      savedBoat = boat!.copyWith(
        name: formData['name'],
        capacity: int.parse(formData['capacity']),
        weight: double.parse(formData['weight']),
      );
    }

    await context.read<RosterModel>().setBoat(savedBoat, teamID);
    if (context.mounted) Navigator.popUntil(context, (route) => route.isFirst);
  }

  Future<void> _deleteBoat(BuildContext context) async {
    await context.read<RosterModel>().deleteBoat(boat!.id, teamID);
    if (context.mounted) Navigator.popUntil(context, (route) => route.isFirst);
  }

  String? _capacityValidator(String? value) {
    final isIntValidation = Validators.isInt(
      errorText:
          'Enter the number of paddlers in the boat, including the drummer and steers person.',
    ).call(value);

    if (isIntValidation != null) {
      return isIntValidation;
    }

    final capacity = int.parse(value!);
    if (capacity < 10) {
      return 'Capacity must be at least 10.';
    }
    if (capacity.isOdd) {
      return 'Capacity must be even.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            boat != null ? 'Edit ${boat!.name}' : 'Add boat',
            textAlign: TextAlign.center,
            style: TextStyles.title1,
          ),
          const SizedBox(height: Insets.med),
          FormBuilderTextField(
            name: 'name',
            initialValue: boat?.name,
            textCapitalization: TextCapitalization.words,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: Validators.required(errorText: 'Enter a name.'),
            decoration: CustomInputDecoration(
              AppColors.of(context),
              hintText: 'Name',
            ),
          ),
          const SizedBox(height: Insets.med),
          //TODO: can't handle odd capacities.
          FormBuilderTextField(
            name: 'capacity',
            initialValue: boat?.capacity.toString(),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            //TODO: must be greater than 2 * length of boat end segment
            validator: _capacityValidator,
            decoration: CustomInputDecoration(
              AppColors.of(context),
              hintText: 'Capacity',
              suffix: const Text('paddlers', style: TextStyles.body2),
            ),
          ),
          const SizedBox(height: Insets.med),
          FormBuilderTextField(
            name: 'weight',
            initialValue: boat?.formattedWeight,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'\d+(\.\d*)?'),
              ),
            ],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: Validators.isDouble(
              errorText: 'Enter the boat\'s weight.',
            ),
            decoration: CustomInputDecoration(
              AppColors.of(context),
              hintText: 'Weight',
              suffix: const Text('lbs', style: TextStyles.body2),
            ),
          ),
          const SizedBox(height: Insets.xl),
          Row(
            children: [
              Expanded(
                child: Hero(
                  tag: 'action button',
                  flightShuttleBuilder: _heroFlightShuttleBuilder,
                  child: ExpandingStadiumButton(
                    onTap: () => _saveBoat(context),
                    color: AppColors.of(context).buttonContainer,
                    textColor: AppColors.of(context).onButtonContainer,
                    label: 'Save',
                  ),
                ),
              ),
              if (boat != null) ...[
                SizedBox(width: Insets.med),
                Expanded(
                  child: ExpandingStadiumButton(
                    onTap: () async {
                      final inUseLineupNames =
                          await RosterModel.getBoatUsage(teamID, boat!.id);

                      if (!context.mounted) return;

                      if (inUseLineupNames.isNotEmpty) {
                        final teamName =
                            context.read<RosterModel>().getTeam(teamID)!.name;

                        Navigator.of(context).pushNamed(
                          appendQueryParams('/boat-in-use', {
                            'boatName': boat!.name,
                            'teamName': teamName,
                          }),
                          arguments: inUseLineupNames,
                        );
                        return;
                      }

                      _deleteBoat(context);
                    },
                    color: AppColors.of(context).error,
                    textColor: Colors.white,
                    label: 'Delete',
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: Insets.sm),
          Hero(
            tag: 'pop button',
            flightShuttleBuilder: _heroFlightShuttleBuilder,
            child: ExpandingTextButton(
              onTap: () => Navigator.pop(context),
              text: 'Cancel',
            ),
          ),
        ],
      ),
    );
  }
}

class _BoatDeletionBlockedView extends StatelessWidget {
  final String boatName;
  final String teamName;
  final Iterable<String> inUseLineupNames;

  const _BoatDeletionBlockedView({
    required this.boatName,
    required this.teamName,
    required this.inUseLineupNames,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text('Can\'t Delete Boat', style: TextStyles.title1),
        ),
        const SizedBox(height: Insets.lg),
        Text.rich(TextSpan(children: [
          TextSpan(
            text: boatName,
            style: TextStyles.body1.copyWith(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
                ' can\'t be deleted because it is currently assigned to the following lineups on ',
            style: TextStyles.body1,
          ),
          TextSpan(
            text: teamName,
            style: TextStyles.body1.copyWith(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: ':',
            style: TextStyles.body1,
          ),
        ])),
        const SizedBox(height: Insets.med),
        Consumer<RosterModel>(
          builder: (context, rosterModel, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (String lineupName in inUseLineupNames)
                Text(
                  '    •  $lineupName',
                  style: TextStyles.body1,
                ),
            ].separate(SizedBox(height: Insets.xs)).toList(),
          ),
        ),
        SizedBox(height: Insets.xl),
        ExpandingStadiumButton(
          onTap: () => Navigator.pop(context),
          color: AppColors.of(context).primary,
          label: 'Confirm',
        ),
        SizedBox(height: Insets.sm),
      ],
    );
  }
}

/// Cross fades the children while interpolating between their sizes.
//TODO: should be put somewhere generalized
Widget _heroFlightShuttleBuilder(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  final Hero fromHero = fromHeroContext.widget as Hero;
  final Hero toHero = toHeroContext.widget as Hero;

  final MediaQueryData? toMediaQueryData = MediaQuery.maybeOf(toHeroContext);
  final MediaQueryData? fromMediaQueryData =
      MediaQuery.maybeOf(fromHeroContext);

  if (toMediaQueryData == null || fromMediaQueryData == null) {
    return toHero.child;
  }

  final EdgeInsets fromHeroPadding = fromMediaQueryData.padding;
  final EdgeInsets toHeroPadding = toMediaQueryData.padding;

  final firstAnimation = animation
      .drive(CurveTween(curve: Curves.easeIn))
      .drive(Tween<double>(begin: 1.0, end: 0.0));
  final secondAnimation = animation.drive(CurveTween(curve: Curves.easeOut));
  final isForward = animation.isForwardOrCompleted;

  //TODO: causes flicker if button moves down on push
  return AnimatedBuilder(
    animation: animation,
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: toMediaQueryData.copyWith(
          padding: (flightDirection == HeroFlightDirection.push)
              ? EdgeInsetsTween(
                  begin: fromHeroPadding,
                  end: toHeroPadding,
                ).evaluate(animation)
              : EdgeInsetsTween(
                  begin: toHeroPadding,
                  end: fromHeroPadding,
                ).evaluate(animation),
        ),
        child: AnimatedCrossFade.defaultLayoutBuilder(
          FadeTransition(
            opacity: isForward ? firstAnimation : secondAnimation,
            child: fromHero,
          ),
          UniqueKey(),
          FadeTransition(
            opacity: isForward ? secondAnimation : firstAnimation,
            child: toHero,
          ),
          UniqueKey(),
        ),
      );
    },
  );
}
