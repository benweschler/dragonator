import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/widgets/modal_sheets/modal_sheet.dart';
import 'package:dragonator/widgets/platform_aware/platform_aware_switch.dart';
import 'package:flutter/material.dart';

class EditLineupOptionsModalSheet extends StatefulWidget {
  const EditLineupOptionsModalSheet({super.key});

  @override
  State<EditLineupOptionsModalSheet> createState() =>
      _EditLineupOptionsModalSheetState();
}

class _EditLineupOptionsModalSheetState
    extends State<EditLineupOptionsModalSheet> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return ModalSheet(
      child: Padding(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Boat', style: TextStyles.title1),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                                color: AppColors.of(context).neutralContent),
                          ),
                        ],
                      ),
                    ),
                    PlatformAwareSwitch(
                      onChanged: (_) => setState(() => value = !value),
                      value: value,
                    ),
                  ],
                ),
                const SizedBox(height: Insets.sm),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Horizontal Position', style: TextStyles.body1),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Insets.xs),
                      child: Text('52%', style: TextStyles.body1),
                    ),
                  ],
                ),
                const SizedBox(height: Insets.sm),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Vertical Position', style: TextStyles.body1),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Insets.xs),
                      child: Text('25%', style: TextStyles.body1),
                    ),
                  ],
                ),
              ],
            ),
          ].separate(const SizedBox(height: Insets.sm)).toList(),
        ),
      ),
    );
  }
}
