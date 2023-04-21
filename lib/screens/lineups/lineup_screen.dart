import 'package:dragonator/data/paddler.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/utils/navigator_utils.dart';
import 'package:dragonator/widgets/buttons/custom_back_button.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:dragonator/widgets/modal_sheets/context_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'list_tiles.dart';

class LineupScreen extends StatelessWidget {
  final String lineupID;

  const LineupScreen({Key? key, required this.lineupID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lineup = context.read<RosterModel>().getLineup(lineupID)!;

    //TODO: standardize
    late final List<Paddler?> paddlerList = [
      ...lineup.paddlers,
      for (int i = lineup.paddlers.length; i < 22; i++) null,
    ];

    return CustomScaffold(
      leading: const CustomBackButton(),
      center: Text(lineup.name, style: TextStyles.title1),
      trailing: CustomIconButton(
        onTap: () => context.showModal(ContextMenu([
          ContextMenuAction(
            icon: Icons.edit_rounded,
            onTap: () => context.push(RoutePaths.nameLineup(lineupID)),
            label: 'Rename',
          ),
          ContextMenuAction(
            icon: Icons.view_list_rounded,
            onTap: () => context.push(RoutePaths.editLineup(lineupID)),
            label: 'Edit',
          ),
          ContextMenuAction(
            icon: Icons.delete_rounded,
            onTap: () {},
            label: 'Delete',
          ),
        ])),
        icon: Icons.more_horiz,
      ),
      child: SingleChildScrollView(
        child: Row(
          children: [
            Column(children: <Widget>[
              for (int i = 0; i < 22; i++) PositionLabelTile(position: i)
            ]),
            Expanded(
              child: Column(children: [
                for (int i = 0; i < 22; i++)
                  if (paddlerList[i] != null)
                    PaddlerTile(paddlerList[i]!)
                  else
                    const EmptyPaddlerTile()
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
