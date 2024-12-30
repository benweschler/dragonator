import 'package:dragonator/data/boat/boat.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/selector_button.dart';
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
                          '${boat.capacity} paddler${boat.capacity > 1 ? 's' : ''} • ${boat.formattedWeight} lbs',
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
