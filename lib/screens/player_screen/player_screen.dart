import 'package:dragonator/data/player.dart';
import 'package:dragonator/dummy_data.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/widgets/buttons/action_button_card.dart';
import 'package:dragonator/widgets/buttons/custom_back_button.dart';
import 'package:dragonator/widgets/buttons/option_button.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/labeled_table.dart';
import 'preference_row.dart';

class PlayerScreen extends StatelessWidget {
  final Player player;

  PlayerScreen(String playerID, {Key? key})
      : player = playerIDMap[playerID]!,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      leading: const CustomBackButton(),
      trailing: OptionButton(
        onTap: () => context.push(ScreenPaths.editPlayer(player.id)),
        icon: Icons.edit_rounded,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text(
                "${player.firstName} ${player.lastName}",
                style: TextStyles.h2.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: Insets.xl),
            PlayerStatTable(player),
            const SizedBox(height: Insets.xl),
            Row(
              children: [
                Expanded(
                  child: PreferenceRow(
                    label: "Drummer",
                    hasPreference: player.drummerPreference,
                  ),
                ),
                Expanded(
                  child: PreferenceRow(
                    label: "Steers Person",
                    hasPreference: player.steersPersonPreference,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Insets.med),
            PreferenceRow(
              label: "Stroke",
              hasPreference: player.strokePreference,
            ),
            const SizedBox(height: Insets.xl),
            ActionButtonCard([
              ActionButton(
                onTap: () {},
                label: "Add to team",
                icon: Icons.add_rounded,
              ),
              ActionButton(
                onTap: () {},
                label: "View active lineups",
                icon: Icons.library_books_rounded,
              ),
              ActionButton(
                onTap: () {},
                label: "Delete",
                icon: Icons.delete_rounded,
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class PlayerStatTable extends StatelessWidget {
  final Player player;

  const PlayerStatTable(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LabeledTable(
      rows: [
        LabeledTableRow(
          labels: ["Weight", "Gender"],
          stats: [
            Text.rich(TextSpan(children: [
              TextSpan(
                text: "${player.weight}",
                style: TextStyles.title1,
              ),
              const TextSpan(text: " lbs", style: TextStyles.body2),
            ])),
            Text("${player.gender}", style: TextStyles.title1),
          ],
        ),
        LabeledTableRow(
          labels: ["Side Preference", "Age Group"],
          stats: [
            Text("${player.sidePreference}", style: TextStyles.title1),
            Text(player.ageGroup, style: TextStyles.title1),
          ],
        ),
      ],
    );
  }
}
