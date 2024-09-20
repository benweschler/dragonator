import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:flutter/material.dart';

final double _kTileHeight = Insets.sm * 2 +
    TextStyles.title1.fontSize! +
    Insets.xs +
    TextStyles.body1.fontSize! +
    5;

class PositionLabelTile extends StatelessWidget {
  final int position;

  const PositionLabelTile({super.key, required this.position})
      : assert(0 <= position && position < 22);

  @override
  Widget build(BuildContext context) {
    //TODO: hardcoded positions
    final List<String> positionLabels = [
      'D',
      for (int i = 1; i <= 10; i++) ...[
        '${i}R',
        '${i}L',
      ],
      'S',
    ];

    return SizedBox(
      height: _kTileHeight,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(Insets.sm + 1.5),
          child: Text(
            positionLabels[position],
            style: TextStyles.title1,
            softWrap: false,
          ),
        ),
      ),
    );
  }
}

class OldAddPaddlerTile extends StatelessWidget {
  const OldAddPaddlerTile({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kTileHeight,
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(Insets.sm),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: Corners.smBorderRadius,
              color: AppColors.of(context).accent.withOpacity(0.2),
              border: Border.all(color: AppColors.of(context).accent),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add',
                  style: TextStyles.body1
                      .copyWith(color: AppColors.of(context).accent),
                ),
                const SizedBox(
                  width: Insets.med,
                ),
                Icon(Icons.add_rounded, color: AppColors.of(context).accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyPaddlerTile extends StatelessWidget {
  const EmptyPaddlerTile({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kTileHeight,
      child: Padding(
        padding: const EdgeInsets.all(Insets.sm),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.of(context).largeSurface,
            borderRadius: Corners.smBorderRadius,
          ),
          child: Center(
            child: Text(
              'Empty',
              style: TextStyles.body2.copyWith(
                color: AppColors.of(context).neutralContent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
