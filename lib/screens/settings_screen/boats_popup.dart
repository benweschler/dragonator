import 'package:dragonator/data/boat/boat.dart';
import 'package:dragonator/data/team/team.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/utils/notifier.dart';
import 'package:dragonator/utils/validators.dart';
import 'package:dragonator/widgets/buttons/expanding_buttons.dart';
import 'package:dragonator/widgets/custom_input_decoration.dart';
import 'package:dragonator/widgets/popup_dialog.dart';
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

class _BoatsPopupState extends State<BoatsPopup> {
  late Team _cachedTeam;

  @override
  void initState() {
    super.initState();
    _cachedTeam = context.read<RosterModel>().getTeam(widget.teamID)!;
  }

  @override
  Widget build(BuildContext context) {
    return PopupDialog(
      child: AnimatedSize(
        duration: Timings.long,
        curve: Curves.fastEaseInToSlowEaseOut,
        child: IntrinsicHeight(
          child: ChangeNotifierProvider(
            create: (_) => _PopupNavigator(),
            child: Selector<RosterModel, Team?>(
              selector: (context, model) => model.getTeam(widget.teamID),
              builder: (context, team, child) {
                // True if this team is deleted during editing.
                if (team == null) {
                  context.pop();
                  team = _cachedTeam;
                } else {
                  _cachedTeam = team;
                }

                final path = context.watch<_PopupNavigator>().path;
                var pages = <Page>[MaterialPage(child: _BoatList(team))];
                if (path.startsWith('/set')) {
                  final boatID = Uri.parse(path).queryParameters['id'];
                  pages.add(FadeTransitionPage(
                    child: _EditBoat(team.boats[boatID], team.id),
                  ));
                }

                return Navigator(
                  observers: [HeroController()],
                  pages: pages,
                  onDidRemovePage: (_) {},
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _PopupNavigator extends Notifier {
  String _path = '/';

  String get path => _path;

  static _PopupNavigator of(BuildContext context) =>
      context.read<_PopupNavigator>();

  void pushNamed(String path) => notify(() => _path = path);

  void home() => notify(() => _path = '/');
}

class _BoatList extends StatelessWidget {
  final Team team;

  const _BoatList(this.team);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${team.name} Boats',
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
          flightShuttleBuilder: _shuttleBuilder,
          child: ExpandingStadiumButton(
            onTap: () => _PopupNavigator.of(context).pushNamed('/set'),
            color: AppColors.of(context).primary,
            label: 'Add Boat',
          ),
        ),
        const SizedBox(height: Insets.sm),
        Hero(
          tag: 'pop button',
          flightShuttleBuilder: _shuttleBuilder,
          child: ExpandingTextButton(onTap: context.pop, text: 'Done'),
        ),
      ],
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
                    text: _formatDouble(boat.weight),
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
      onTap: () => _PopupNavigator.of(context).pushNamed('/set?id=${boat.id}'),
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

class _EditBoat extends StatelessWidget {
  /// If null, creates a new boat.
  final Boat? boat;
  final String teamID;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey();

  _EditBoat(this.boat, this.teamID);

  Future<void> _saveBoat(BuildContext context) async {
    if (!_formKey.currentState!.saveAndValidate()) {
      return;
    }

    final formData = _formKey.currentState!.value;
    final Boat boat;
    if (this.boat == null) {
      boat = Boat(
        id: Uuid().v4(),
        name: formData['name'],
        capacity: int.parse(formData['capacity']),
        weight: double.parse(formData['weight']),
      );
    } else {
      boat = this.boat!.copyWith(
            name: formData['name'],
            capacity: int.parse(formData['capacity']),
            weight: double.parse(formData['weight']),
          );
    }

    await context.read<RosterModel>().setBoat(boat, teamID);
    if (context.mounted) Navigator.pop(context);
  }

  Future<void> _deleteBoat(BuildContext context) async {
    await context.read<RosterModel>().deleteBoat(boat!.id, teamID);
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
              boat != null ? 'Edit ${boat!.name}' : 'Add boat',
              textAlign: TextAlign.center,
              style: TextStyles.title1,
            ),
            const SizedBox(height: Insets.med),
            FormBuilderTextField(
              name: 'name',
              initialValue: boat?.name,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: Validators.required(errorText: 'Enter a name.'),
              decoration: CustomInputDecoration(
                AppColors.of(context),
                hintText: 'Name',
              ),
            ),
            const SizedBox(height: Insets.med),
            FormBuilderTextField(
              name: 'capacity',
              initialValue: boat?.capacity.toString(),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: Validators.isInt(
                errorText:
                    'Enter the number of paddlers in the boat, including the drummer and steers person.',
              ),
              decoration: CustomInputDecoration(
                AppColors.of(context),
                hintText: 'Capacity',
                suffix: const Text('paddlers', style: TextStyles.body2),
              ),
            ),
            const SizedBox(height: Insets.med),
            FormBuilderTextField(
              name: 'weight',
              initialValue: _formatDouble(boat?.weight),
              keyboardType:
                  TextInputType.numberWithOptions(decimal: true),
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
                    tag: boat == null ? 'action button' : '',
                    flightShuttleBuilder: _shuttleBuilder,
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
                      onTap: () => _deleteBoat(context),
                      color: AppColors.of(context).error,
                      textColor: Colors.white,
                      label: 'Delete',
                    ),
                  ),
                ]
              ],
            ),
            const SizedBox(height: Insets.sm),
            Hero(
              tag: 'pop button',
              flightShuttleBuilder: _shuttleBuilder,
              child: ExpandingTextButton(
                onTap: _PopupNavigator.of(context).home,
                text: 'Cancel',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Cross fades the children while interpolated between their sizes.
Widget _shuttleBuilder(
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

String? _formatDouble(double? n) {
  if(n == null) return null;

  return n.toInt() == n ? n.toStringAsFixed(0) : '$n';
}
