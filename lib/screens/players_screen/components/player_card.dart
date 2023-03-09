import 'package:dragonator/data/player.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:flutter/material.dart';

class PlayerCard extends StatelessWidget {
  final Player player;

  const PlayerCard(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.sm,
          vertical: Insets.med,
        ),
        child: _buildCardContent(context),
      ),
    );
  }

  Widget? _buildCardContent(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${player.firstName} ${player.lastName}",
                style: TextStyles.title1.copyWith(
                  color: const Color.fromRGBO(229, 92, 69, 1),
                ),
              ),
              const SizedBox(height: Insets.xs),
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: "${player.weight}",
                    style:
                        TextStyles.body1.copyWith(fontWeight: FontWeight.bold)),
                const TextSpan(text: " lbs", style: TextStyles.body2),
              ])),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                "Gender",
                style: TextStyles.caption.copyWith(
                  color: AppColors.of(context).captionColor,
                ),
              ),
              Text("${player.gender}", style: TextStyles.title1),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                "Side",
                style: TextStyles.caption.copyWith(
                  color: AppColors.of(context).captionColor,
                ),
              ),
              Text("${player.sidePreference}", style: TextStyles.title1),
            ],
          ),
        ),
      ],
    );
  }
}
