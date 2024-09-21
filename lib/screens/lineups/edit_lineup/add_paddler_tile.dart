import 'package:dragonator/data/paddler.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:flutter/material.dart';

//TODO: implement adding paddler
class AddPaddlerTile extends StatelessWidget {
  final ValueChanged<Paddler?> addPaddler;

  const AddPaddlerTile({super.key, required this.addPaddler});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => addPaddler(null),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 0.4 * MediaQuery.of(context).size.width,
        ),
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: Color.alphaBlend(
            AppColors.of(context).errorSurface,
            Theme.of(context).scaffoldBackgroundColor,
          ),
          borderRadius: Corners.smBorderRadius,
          border: Border.all(color: AppColors.of(context).accent),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add',
              style: TextStyles.body1.copyWith(
                color: AppColors.of(context).accent,
              ),
              maxLines: 2,
            ),
            const SizedBox(width: Insets.xs),
            Icon(Icons.add_rounded, color: AppColors.of(context).accent),
          ],
        ),
      ),
    );
  }
}
