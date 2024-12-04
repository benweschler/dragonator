import 'package:dragonator/data/lineup/lineup.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/models/settings_model.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/chip_button.dart';
import 'package:dragonator/widgets/modal_sheets/modal_sheet.dart';
import 'package:dragonator/widgets/platform_aware/platform_aware_switch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditLineupOptionsModalSheet extends StatelessWidget {
  final Lineup lineup;
  final Offset com;

  const EditLineupOptionsModalSheet({
    super.key,
    required this.lineup,
    required this.com,
  });

  @override
  Widget build(BuildContext context) {
    final boat = context.read<RosterModel>().currentTeam!.boats[lineup.boatID]!;

    return ModalSheet(
      child: Padding(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                onTap: () {},
                fillColor: AppColors.of(context).primary,
                contentColor: Colors.white,
                child: Text('Change Boat'),
              ),
            ),
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
          ],
        ),
      ),
    );
  }
}
