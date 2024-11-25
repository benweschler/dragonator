import 'package:dragonator/models/settings_model.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/widgets/modal_sheets/modal_sheet.dart';
import 'package:dragonator/widgets/platform_aware/platform_aware_switch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditLineupOptionsModalSheet extends StatelessWidget {
  final Offset com;

  const EditLineupOptionsModalSheet({
    super.key,
    required this.com,
  });

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
                              color: AppColors.of(context).neutralContent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: Insets.med),
                    Consumer<SettingsModel>(
                      builder: (_, model, __) {
                        return PlatformAwareSwitch(
                          onChanged: (value) => model.setShowComOverlay(value),
                          value: model.showComOverlay,
                        );
                      }
                    ),
                  ],
                ),
                const SizedBox(height: Insets.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Horizontal Position',
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
                      'Vertical Position',
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
          ].separate(const SizedBox(height: Insets.sm)).toList(),
        ),
      ),
    );
  }
}
