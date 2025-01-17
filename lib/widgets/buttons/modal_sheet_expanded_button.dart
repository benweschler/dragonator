import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A button that should be a child of a [ModalSheet] and should be used in
/// place of a standard modal sheet tile.
///
/// This tile should be the bottom-most tile in a modal sheet.
//TODO: should probably be named action something? is the tile analogy correct?
class ModalSheetButtonTile extends StatelessWidget {
  final Color color;
  final GestureTapCallback onTap;
  final bool autoPop;
  //TODO: bad, probably. generalize?
  final bool enabled;
  final String label;

  const ModalSheetButtonTile({
    super.key,
    required this.color,
    required this.onTap,
    this.autoPop = true,
    this.enabled = true,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: Insets.xs,
        left: Insets.offset,
        right: Insets.offset,
        bottom: Insets.offset,
      ),
      child: IgnorePointer(
        ignoring: !enabled,
        child: Opacity(
          opacity: enabled ? 1 : 0.5,
          child: ResponsiveButton.large(
            onTap: () {
              onTap();
              if(autoPop) context.pop();
            },
            builder: (overlay) => Container(
              padding: const EdgeInsets.all(Insets.med),
              decoration: BoxDecoration(
                borderRadius: Corners.medBorderRadius,
                color: Color.alphaBlend(overlay, color),
              ),
              child: Center(
                child: Text(
                  label,
                  // A ModalSheet provides a DefaultTextStyle to correctly style all
                  // text in the sheet, so additional styling is not required.
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
