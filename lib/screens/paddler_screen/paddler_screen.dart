import 'package:dragonator/commands/delete_paddler_command.dart';
import 'package:dragonator/data/paddler.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/widgets/buttons/action_button_card.dart';
import 'package:dragonator/widgets/buttons/custom_back_button.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:dragonator/widgets/labeled_table.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'preference_row.dart';

class PaddlerScreen extends StatelessWidget {
  final String paddlerID;

  const PaddlerScreen(this.paddlerID, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      leading: const CustomBackButton(),
      trailing: CustomIconButton(
        onTap: () => context.push(RoutePaths.editPaddler(paddlerID: paddlerID)),
        icon: Icons.edit_rounded,
      ),
      child: SingleChildScrollView(
        child: Selector<RosterModel, Paddler>(
          selector: (_, model) => model.getPaddler(paddlerID)!,
          builder: (_, paddler, __) => Column(
            children: [
              Center(
                child: Text(
                  '${paddler.firstName} ${paddler.lastName}',
                  style: TextStyles.h2.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: Insets.xl),
              PaddlerStatTable(paddler),
              const SizedBox(height: Insets.xl),
              Row(
                children: [
                  Expanded(
                    child: PreferenceRow(
                      label: 'Drummer',
                      hasPreference: paddler.drummerPreference,
                    ),
                  ),
                  Expanded(
                    child: PreferenceRow(
                      label: 'Steers Person',
                      hasPreference: paddler.steersPersonPreference,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Insets.med),
              PreferenceRow(
                label: 'Stroke',
                hasPreference: paddler.strokePreference,
              ),
              const SizedBox(height: Insets.xl),
              //TODO: implement actions
              ActionButtonCard([
                ActionButton(
                  onTap: () {},
                  label: 'Add to team',
                  icon: Icons.add_rounded,
                ),
                ActionButton(
                  onTap: () {},
                  label: 'View active lineups',
                  icon: Icons.library_books_rounded,
                ),
                ActionButton(
                  onTap: () async {
                    final pop = context.pop;
                    await DeletePaddlerCommand.run(
                      //TODO: hardcoded team ID. change once state management with provider is implemented.
                      'gCyi30iKgjw11wk1Fvgn',
                      paddlerID,
                    );
                    pop();
                  },
                  label: 'Delete',
                  icon: Icons.delete_rounded,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class PaddlerStatTable extends StatelessWidget {
  final Paddler paddler;

  const PaddlerStatTable(this.paddler, {super.key});

  @override
  Widget build(BuildContext context) {
    return LabeledTable(
      rows: [
        LabeledTableRow(
          labels: ['Weight', 'Gender'],
          stats: [
            Text.rich(TextSpan(children: [
              TextSpan(
                text: '${paddler.weight}',
                style: TextStyles.title1,
              ),
              const TextSpan(text: ' lbs', style: TextStyles.body2),
            ])),
            Text('${paddler.gender}', style: TextStyles.title1),
          ],
        ),
        LabeledTableRow(
          labels: ['Side', 'Age Group'],
          stats: [
            Text('${paddler.sidePreference}', style: TextStyles.title1),
            Text(paddler.ageGroup.toString(), style: TextStyles.title1),
          ],
        ),
      ],
    );
  }
}
