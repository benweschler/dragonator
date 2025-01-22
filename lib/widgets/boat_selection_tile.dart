import 'package:dragonator/data/boat/boat.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:flutter/material.dart';

class BoatSelectionTile extends StatelessWidget {
  final Boat boat;
  final bool selected;
  final GestureTapCallback onTap;

  const BoatSelectionTile({
    super.key,
    required this.boat,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: selected,
      child: ResponsiveButton.large(
        onTap: onTap,
        builder: (overlay) => Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: Insets.sm,
                horizontal: Insets.lg,
              ),
              decoration: BoxDecoration(
                borderRadius: Corners.medBorderRadius,
                color: selected ? AppColors.of(context).primarySurface : null,
                //: AppColors.of(context).largeSurface,
                //: null,
                border: Border.all(
                  color: selected
                      ? AppColors.of(context).primary
                      : Color.alphaBlend(
                          overlay,
                          AppColors.of(context).outline,
                        ),
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
                              fontWeight: FontWeight.w500,
                              color: selected
                                  ? AppColors.of(context).primary
                                  : Color.alphaBlend(
                                overlay,
                                AppColors.of(context).outline,
                              ),
                            ),
                          ),
                          Text(
                            '${boat.capacity} paddler${boat.capacity > 1 ? 's' : ''} • ${boat.formattedWeight} lbs',
                            style: TextStyles.body2.copyWith(
                              color: selected
                                  ? AppColors.of(context).primary
                                  : Color.alphaBlend(
                                overlay,
                                AppColors.of(context).outline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (selected)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.check_rounded,
                          color: AppColors.of(context).primary,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
