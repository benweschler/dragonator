import 'package:dragonator/data/boat/boat.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/models/settings_model.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/utils/dependence_mixins/team_dependent_modal_state_mixin.dart';
import 'package:dragonator/widgets/buttons/chip_button.dart';
import 'package:dragonator/widgets/buttons/expanding_buttons.dart';
import 'package:dragonator/widgets/buttons/selector_button.dart';
import 'package:dragonator/widgets/modal_navigator.dart';
import 'package:dragonator/widgets/modal_sheets/modal_sheet.dart';
import 'package:dragonator/widgets/platform_aware/platform_aware_switch.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EditLineupOptionsModalSheet extends StatelessWidget {
  final String lineupBoatID;
  final Offset com;
  final ValueChanged<Boat> onChangeBoat;

  const EditLineupOptionsModalSheet({
    super.key,
    required this.lineupBoatID,
    required this.com,
    required this.onChangeBoat,
  });

  @override
  Widget build(BuildContext context) {
    return ModalSheet(
      child: ChangeNotifierProvider(
        create: (_) => ValueNotifier<String>(lineupBoatID),
        child: Padding(
          padding: const EdgeInsets.all(Insets.lg),
          child: ModalNavigator(
            routeBuilder: (String? path) {
              if (path!.startsWith('/change-boat')) {
                return PopupTransitionPage(
                  child: _ChangeBoatView(onChangeBoat: onChangeBoat),
                ).createRoute(context);
              } else if (path.startsWith('/confirm-boat-change')) {
                final boatName = Uri.parse(path).queryParameters['name']!;

                return PopupTransitionPage<bool>(
                  child: _ConfirmDestructiveBoatChangeView(
                    newLineupBoatName: boatName,
                  ),
                ).createRoute(context);
              }

              return MaterialPageRoute(
                builder: (context) => _LineupOptionsView(com: com),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LineupOptionsView extends StatelessWidget {
  final Offset com;

  const _LineupOptionsView({required this.com});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LineupBoatOptions(),
        const SizedBox(height: Insets.lg),
        const Text('Center of Mass', style: TextStyles.title1),
        const SizedBox(height: Insets.sm),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Show overlay', style: TextStyles.body1),
                  Text(
                    'Overlay a diagram of the boat\'s center of mass on the boat diagram.',
                    style: TextStyles.caption.copyWith(
                      color: AppColors.of(context).neutralContent,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: Insets.med),
            Consumer<SettingsModel>(builder: (_, model, __) {
              return PlatformAwareSwitch(
                onChanged: (value) => model.setShowComOverlay(value),
                value: model.showComOverlay,
              );
            }),
          ],
        ),
        const SizedBox(height: Insets.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Horizontal Position:',
              style: TextStyles.body1,
            ),
            // Aligns text with above switch.
            Padding(
              padding: const EdgeInsets.only(right: Insets.xs),
              child: Text(
                '${(com.dx * 100).round()}%',
                style: TextStyles.body1,
              ),
            ),
          ],
        ),
        const SizedBox(height: Insets.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Vertical Position:',
              style: TextStyles.body1,
            ),
            // Aligns text with above switch.
            Padding(
              padding: const EdgeInsets.only(right: Insets.xs),
              child: Text(
                '${(com.dy * 100).round()}%',
                style: TextStyles.body1,
              ),
            ),
          ],
        ),
        const SizedBox(height: Insets.sm),
        Text(
          'Shown as a percentage of the total width and height of the boat, where 50% corresponds to the boat\'s center.',
          style: TextStyles.caption.copyWith(
            color: AppColors.of(context).neutralContent,
          ),
        ),
        SizedBox(height: Insets.med),
        ExpandingTextButton(
          onTap: context.pop,
          text: 'Done',
        ),
      ],
    );
  }
}

class _LineupBoatOptions extends StatelessWidget {
  const _LineupBoatOptions();

  @override
  Widget build(BuildContext context) {
    final selectedBoatID = context.watch<ValueNotifier<String>>().value;

    return Selector<RosterModel, Boat>(
      selector: (_, model) => model.currentTeam!.boats[selectedBoatID]!,
      builder: (context, boat, _) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(boat.name, style: TextStyles.title1),
          const SizedBox(height: Insets.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Capacity:', style: TextStyles.body1),
              Text.rich(TextSpan(children: [
                TextSpan(text: '${boat.capacity} ', style: TextStyles.body1),
                TextSpan(
                  text: 'paddlers',
                  style: TextStyles.body1
                      .copyWith(color: AppColors.of(context).neutralContent),
                ),
              ])),
            ],
          ),
          const SizedBox(height: Insets.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Weight:', style: TextStyles.body1),
              Text.rich(TextSpan(children: [
                TextSpan(
                  text: '${boat.formattedWeight} ',
                  style: TextStyles.body1,
                ),
                TextSpan(
                  text: 'lbs',
                  style: TextStyles.body1
                      .copyWith(color: AppColors.of(context).neutralContent),
                ),
              ])),
            ],
          ),
          SizedBox(height: Insets.med),
          Center(
            child: ChipButton(
              onTap: () => Navigator.of(context).pushNamed('/change-boat'),
              fillColor: AppColors.of(context).primary,
              contentColor: Colors.white,
              child: Text('Change Boat'),
            ),
          ),
        ],
      ),
    );
  }
}

//TODO: throws error when increasing boat capacity
class _ChangeBoatView extends StatefulWidget {
  final ValueChanged<Boat> onChangeBoat;

  const _ChangeBoatView({required this.onChangeBoat});

  @override
  State<_ChangeBoatView> createState() => _ChangeBoatViewState();
}

class _ChangeBoatViewState extends State<_ChangeBoatView> {
  late String _selectedBoatID = context.read<ValueNotifier<String>>().value;
  late final String _initialBoatID = _selectedBoatID;

  @override
  Widget build(BuildContext context) {
    final boats = context.select<RosterModel, Map<String, Boat>>(
      (model) => model.currentTeam!.boats,
    );

    print('Initial boat capacity: ${boats[_initialBoatID]?.capacity}');

    return Container(
      alignment: Alignment.center,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Change Boat', style: TextStyles.title1),
          const SizedBox(height: Insets.lg),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  for (Boat boat in boats.values)
                    _BoatSelectionTile(
                      boat: boat,
                      selected: _selectedBoatID == boat.id,
                      onTap: () => setState(() => _selectedBoatID = boat.id),
                    )
                ].separate(SizedBox(height: Insets.lg)).toList(),
              ),
            ),
          ),
          SizedBox(height: Insets.xl),
          ExpandingStadiumButton(
            onTap: () async {
              final boat = boats[_selectedBoatID];
              // True if the boat was deleted from the lineup before saving. No
              // boat will be selected if this is the case.
              if (boat == null) return;

              print('Initial boat capacity check: ${boats[_initialBoatID]?.capacity}');
              print('Selected boat capacity: ${boat.capacity}');

              final selectedBoatIDNotifier =
                  context.read<ValueNotifier<String>>();

              // Don't bother confirming if the initial boat is deleted.
              if (boats[_initialBoatID] != null &&
                  boat.capacity < boats[_initialBoatID]!.capacity) {
                final confirmChange = await Navigator.of(context)
                    .pushNamed<bool>('/confirm-boat-change?name=${boat.name}');

                if (confirmChange != true) return;
              }

              selectedBoatIDNotifier.value = boat.id;
              widget.onChangeBoat(boat);
              if (context.mounted) Navigator.of(context).pop();
            },
            color: AppColors.of(context).primary,
            label: 'Save',
          ),
          SizedBox(height: Insets.sm),
          ExpandingTextButton(
            onTap: Navigator.of(context).pop,
            text: 'Cancel',
          ),
        ],
      ),
    );
  }
}

class _BoatSelectionTile extends StatelessWidget {
  final Boat boat;
  final bool selected;
  final GestureTapCallback onTap;

  const _BoatSelectionTile({
    required this.boat,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(Insets.sm),
            decoration: BoxDecoration(
              borderRadius: Corners.medBorderRadius,
              color: selected
                  ? AppColors.of(context).primarySurface
                  : Colors.black.withOpacity(0.025),
              //: AppColors.of(context).largeSurface,
              //: null,
              border: Border.all(
                color: selected
                    ? AppColors.of(context).primary
                    : AppColors.of(context).outline,
              ),
            ),
            child: IntrinsicHeight(
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(
                          boat.name,
                          style: TextStyles.body1.copyWith(
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? AppColors.of(context).primary
                                : AppColors.of(context).neutralContent,
                          ),
                        ),
                        Text(
                          '${boat.capacity} paddler${boat.capacity > 1 ? 's' : ''}',
                          style: TextStyles.body2.copyWith(
                            color: selected
                                ? AppColors.of(context).primary
                                : AppColors.of(context).neutralContent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SelectorButton(selected: selected, onTap: null),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmDestructiveBoatChangeView extends StatelessWidget {
  final String newLineupBoatName;

  const _ConfirmDestructiveBoatChangeView({required this.newLineupBoatName});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Confirm Boat Change', style: TextStyles.title1),
          const SizedBox(height: Insets.lg),
          Text.rich(TextSpan(children: [
            TextSpan(
              text: newLineupBoatName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
                text:
                    ' has fewer paddlers than the currently selected boat. Changing boats will remove paddlers that are over capacity, starting from the back of the boat. Are you sure you want to continue?',
                style: TextStyle(fontWeight: FontWeight.normal)),
          ])),
          SizedBox(height: Insets.xl),
          ExpandingStadiumButton(
            onTap: () => Navigator.pop(context, true),
            color: AppColors.of(context).primary,
            label: 'Confirm Change',
          ),
          SizedBox(height: Insets.sm),
          ExpandingTextButton(
            onTap: () => Navigator.pop(context, false),
            text: 'Cancel',
          ),
        ],
      ),
    );
  }
}
