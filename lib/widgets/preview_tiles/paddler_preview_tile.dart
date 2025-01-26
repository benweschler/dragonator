import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/screens/paddler_popup/paddler_popup.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:flutter/material.dart';

class PaddlerPreviewTile extends StatelessWidget {
  //TODO: not listening to paddler changes
  final Paddler paddler;

  const PaddlerPreviewTile(this.paddler, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //TODO: choose popup or screen
      //onTap: () => context.push(RoutePaths.paddler(paddler.id)),
      onTap: () => context.showPopup(PaddlerPopup(paddler.id)),
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.sm,
          vertical: Insets.med,
        ),
        child: _buildContent(AppColors.of(context)),
      ),
    );
  }

  Widget? _buildContent(AppColors appColors) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${paddler.firstName} ${paddler.lastName}',
                style: TextStyles.title1.copyWith(color: appColors.primary),
              ),
              const SizedBox(height: Insets.xs),
              Text.rich(TextSpan(children: [
                TextSpan(
                  text: '${paddler.weight}',
                  style: TextStyles.body1.copyWith(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: ' lbs', style: TextStyles.body2),
              ])),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                'Gender',
                style: TextStyles.caption.copyWith(
                  color: appColors.neutralContent,
                ),
              ),
              Text('${paddler.gender}', style: TextStyles.title1),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                'Side',
                style: TextStyles.caption.copyWith(
                  color: appColors.neutralContent,
                ),
              ),
              Text('${paddler.sidePreference}', style: TextStyles.title1),
            ],
          ),
        ),
        Icon(
          Icons.chevron_right_rounded,
          color: appColors.neutralContent,
        ),
      ],
    );
  }
}
