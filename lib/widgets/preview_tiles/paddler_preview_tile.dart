import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/screens/paddler_popup/paddler_popup.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:flutter/material.dart';

class PaddlerPreviewTile extends StatelessWidget {
  //TODO: not listening to paddler changes
  final Paddler paddler;

  const PaddlerPreviewTile(this.paddler, {super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveStrokeButton(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    'Gender',
                    style: TextStyles.caption.copyWith(
                      color: appColors.neutralContent,
                    ),
                  ),
                  Text(
                    'Side',
                    style: TextStyles.caption.copyWith(
                      color: appColors.neutralContent,
                    ),
                  ),
                ].map((e) => Expanded(child: Center(child: e))).toList(),
              ),
              Row(
                children: [
                  Text(
                    '${paddler.gender}',
                    textAlign: TextAlign.center,
                    style: TextStyles.title1,
                  ),
                  Text(
                    '${paddler.sidePreference}',
                    textAlign: TextAlign.center,
                    style: TextStyles.title1,
                  ),
                ].map((e) => Expanded(child: Center(child: e))).toList(),
              ),
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
