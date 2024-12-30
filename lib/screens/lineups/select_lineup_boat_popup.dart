import 'package:dragonator/data/boat/boat.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/widgets/boat_selection_tile.dart';
import 'package:dragonator/widgets/buttons/expanding_buttons.dart';
import 'package:dragonator/widgets/popups/popup_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SelectLineupBoatPopup extends StatefulWidget {
  final ValueChanged<Boat> onSelectBoat;

  const SelectLineupBoatPopup({super.key, required this.onSelectBoat});

  @override
  State<SelectLineupBoatPopup> createState() => _SelectLineupBoatPopupState();
}

class _SelectLineupBoatPopupState extends State<SelectLineupBoatPopup> {
  Boat? _selectedBoat;

  @override
  Widget build(BuildContext context) {
    return PopupDialog(
      child: Padding(
        padding: EdgeInsets.all(Insets.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select a Boat', style: TextStyles.title1),
            SizedBox(height: Insets.lg),
            ...context
                .select<RosterModel, Iterable<Boat>>(
                    (model) => model.currentTeam!.boats.values)
                .map<Widget>((boat) => BoatSelectionTile(
              boat: boat,
              selected: _selectedBoat == boat,
              onTap: () => setState(() => _selectedBoat = boat),
            ))
                .separate(SizedBox(height: Insets.lg)),
            SizedBox(height: Insets.lg),
            //TODO: standardize disabled button
            IgnorePointer(
              ignoring: _selectedBoat == null,
              child: Opacity(
                opacity: _selectedBoat == null ? 0.5 : 1,
                child: ExpandingStadiumButton(
                  onTap: () {
                    widget.onSelectBoat(_selectedBoat!);
                    context.pop();
                  },
                  color: AppColors.of(context).primary,
                  label: 'Create',
                ),
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
  }
}
