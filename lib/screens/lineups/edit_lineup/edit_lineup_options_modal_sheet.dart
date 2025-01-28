import 'package:dragonator/data/boat/boat.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/models/settings_model.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/widgets/boat_selection_tile.dart';
import 'package:dragonator/widgets/buttons/chip_button.dart';
import 'package:dragonator/widgets/buttons/expanding_buttons.dart';
import 'package:dragonator/widgets/modal_navigator.dart';
import 'package:dragonator/widgets/modal_sheets/modal_sheet.dart';
import 'package:dragonator/widgets/pages.dart';
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
        child: ModalNavigator(
          onGenerateRoute: (settings) {
            final path = settings.name;

            if (path!.startsWith('/change-boat')) {
              return PopupTransitionPage(
                child: Padding(
                  padding: const EdgeInsets.all(Insets.lg),
                  child: _ChangeBoatView(onChangeBoat: onChangeBoat),
                ),
              ).createRoute(context);
            } else if (path.startsWith('/confirm-boat-change')) {
              final boatName = Uri.parse(path).queryParameters['name']!;

              return PopupTransitionPage<bool>(
                child: Padding(
                  padding: const EdgeInsets.all(Insets.lg),
                  child: _ConfirmDestructiveBoatChangeView(
                    newLineupBoatName: boatName,
                  ),
                ),
              ).createRoute(context);
            }

            return MaterialPageRoute(
              builder: (context) => Padding(
                padding: const EdgeInsets.all(Insets.lg),
                child: _LineupOptionsView(com: com),
              ),
            );
          },
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
  late final String _initialBoatID;

  @override
  void initState() {
    super.initState();
    _initialBoatID = _selectedBoatID;
  }

  void _saveBoatChange(Map<String, Boat> boats) async {
    final boat = boats[_selectedBoatID];
    // True if the boat was deleted from the lineup before saving. No
    // boat will be selected if this is the case.
    if (boat == null) return;

    final selectedBoatIDNotifier =
    context.read<ValueNotifier<String>>();

    if (boats[_initialBoatID] != null &&
        boat.capacity < boats[_initialBoatID]!.capacity) {
      final confirmChange = await Navigator.of(context)
          .pushNamed<bool>('/confirm-boat-change?name=${boat.name}');

      if (confirmChange != true) return;
    }

    selectedBoatIDNotifier.value = boat.id;
    widget.onChangeBoat(boat);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final boats = context.select<RosterModel, Map<String, Boat>>(
      (model) => model.currentTeam!.boats,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Change Boat', style: TextStyles.title1),
        const SizedBox(height: Insets.lg),
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                for (Boat boat in boats.values)
                  BoatSelectionTile(
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
          enabled: _selectedBoatID != _initialBoatID,
          onTap: () => _saveBoatChange(boats),
          color: AppColors.of(context).primary,
          label: 'Save',
        ),
        SizedBox(height: Insets.sm),
        ExpandingTextButton(
          onTap: Navigator.of(context).pop,
          text: 'Cancel',
        ),
      ],
    );
  }
}

class _ConfirmDestructiveBoatChangeView extends StatelessWidget {
  final String newLineupBoatName;

  const _ConfirmDestructiveBoatChangeView({required this.newLineupBoatName});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Confirm Boat Change', style: TextStyles.title1),
        const SizedBox(height: Insets.lg),
        Text.rich(TextSpan(children: [
          TextSpan(
            text: newLineupBoatName,
            style: TextStyles.body1.copyWith(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
                ' has fewer paddlers than the currently selected boat. Changing boats will remove paddlers that are over capacity, starting from the back of the boat. Are you sure you want to continue?',
            style: TextStyles.body1,
          ),
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
    );
  }
}
