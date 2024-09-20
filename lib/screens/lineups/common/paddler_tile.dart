import 'package:dragonator/data/paddler.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:flutter/material.dart';

class PaddlerTile extends StatelessWidget {
  final Paddler paddler;

  const PaddlerTile(this.paddler, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 0.4 * MediaQuery.of(context).size.width,
      ),
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        borderRadius: Corners.smBorderRadius,
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(
          color: AppColors.of(context).primaryContainer,
        ),
      ),
      child: Text(
        '${paddler.firstName} ${paddler.lastName}',
        style: TextStyles.body1.copyWith(
          color: AppColors.of(context).primaryContainer,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
