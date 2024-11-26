import 'package:dragonator/data/boat/boat.dart';
import 'package:dragonator/data/team/team.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/widgets/buttons/expanding_buttons.dart';
import 'package:dragonator/widgets/popup_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BoatsPopup extends StatefulWidget {
  final Team team;

  const BoatsPopup(this.team, {super.key});

  @override
  State<BoatsPopup> createState() => _BoatsPopupState();
}

class _BoatsPopupState extends State<BoatsPopup> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var team = widget.team.copyWith(boats: {
      '1': Boat(
        id: 'one',
        name: 'Boat One',
        capacity: 22,
        weight: 800.1,
      ),
      '2': Boat(
        id: 'one',
        name: 'Boat One',
        capacity: 22,
        weight: 800.1,
      ),
      '3': Boat(
        id: 'one',
        name: 'Boat One',
        capacity: 22,
        weight: 800.1,
      ),
    });

    return Builder(
      builder: (context) {
        return PopupDialog(
          title: '${team.name} Boats',
          body: SingleChildScrollView(
            controller: _controller,
            child: Column(
              children: [
                if (team.boats.isEmpty)
                  Text('This team doesn\'t have any boats yet.')
                else
                  for (var boat in team.boats.values) _BoatTile(boat),
              ].separate(Divider(height: Insets.xl)).toList(),
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: ExpandingStadiumButton(
                    onTap: () => _controller.position.animateTo(
                      _controller.position.maxScrollExtent,
                      duration: Timings.med,
                      curve: Curves.easeOutQuart,
                    ),
                    color: AppColors.of(context).primary,
                    label: 'Add Boat',
                  ),
                ),
                SizedBox(width: Insets.med),
                Expanded(
                  child: ExpandingStadiumButton(
                    onTap: () {},
                    color: AppColors.of(context).buttonContainer,
                    textColor: AppColors.of(context).onButtonContainer,
                    label: 'Edit',
                  ),
                ),
              ],
            ),
            ExpandingTextButton(onTap: context.pop, text: 'Done'),
          ],
        );
      }
    );
  }
}

class _BoatTile extends StatelessWidget {
  final Boat boat;

  const _BoatTile(this.boat);

  @override
  Widget build(BuildContext context) {
    return Column(
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Capacity:', style: TextStyles.body1),
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
          ],
        ),
        SizedBox(height: Insets.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Weight:', style: TextStyles.body1),
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
      ],
    );
  }
}
