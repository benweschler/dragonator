import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/widgets/modal_sheets/modal_sheet.dart';
import 'package:dragonator/widgets/platform_aware/platform_aware_switch.dart';
import 'package:flutter/material.dart';

class EditLineupOptionsModalSheet extends StatelessWidget {
  final Offset com;
  final ValueNotifier<bool> overlayVisibilityNotifier;
  final ValueChanged<bool> toggleOverlay;

  const EditLineupOptionsModalSheet({
    super.key,
    required this.com,
    required this.overlayVisibilityNotifier,
    required this.toggleOverlay,
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
                    ValueListenableBuilder(
                      valueListenable: overlayVisibilityNotifier,
                      builder: (_, value, __) => PlatformAwareSwitch(
                        onChanged: (value) => toggleOverlay(value),
                        value: value,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Insets.med),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Horizontal Position',
                            style: TextStyles.body1,
                          ),
                          Text(
                            'Overlay a diagram of the boat\'s center of mass on the boat diagram.',
                            style: TextStyles.caption.copyWith(
                              color: AppColors.of(context).neutralContent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Aligns text with above switch.
                    Padding(
                      padding: const EdgeInsets.only(
                        left: Insets.lg,
                        right: Insets.xs,
                      ),
                      child: Text(
                        '${(com.dx * 100).round()}%',
                        style: TextStyles.body1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Insets.med),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Vertical Position',
                            style: TextStyles.body1,
                          ),
                          Text(
                            'Overlay a diagram of the boat\'s center of mass on the boat diagram.',
                            style: TextStyles.caption.copyWith(
                              color: AppColors.of(context).neutralContent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: Insets.lg,
                        right: Insets.xs,
                      ),
                      child: Text(
                        '${(com.dy * 100).round()}%',
                        style: TextStyles.body1,
                      ),
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
