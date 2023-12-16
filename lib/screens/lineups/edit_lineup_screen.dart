import 'package:dragonator/data/lineup.dart';
import 'package:dragonator/data/paddler.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/screens/lineups/list_tiles.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

const int _kBoatCapacity = 22;

class EditLineupScreen extends StatefulWidget {
  final String lineupID;

  const EditLineupScreen({super.key, required this.lineupID});

  @override
  State<EditLineupScreen> createState() => _EditLineupScreenState();
}

class _EditLineupScreenState extends State<EditLineupScreen> {
  late final Lineup _lineup =
      context.read<RosterModel>().getLineup(widget.lineupID)!;

  // This is mutable state. The paddler list is updated on reorder through set
  // state.
  late final List<Paddler?> _paddlerList = [
    ..._lineup.paddlers,
    for (int i = _lineup.paddlers.length; i < _kBoatCapacity; i++) null,
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      leading: CustomIconButton(
        onTap: context.pop,
        icon: Icons.close_rounded,
      ),
      center: Text(_lineup.name, style: TextStyles.title1),
      trailing: CustomIconButton(
        onTap: () {
          context
              .read<RosterModel>()
              .setLineup(_lineup.copyWith(paddlers: _paddlerList));
          context.pop();
        },
        icon: Icons.check_rounded,
      ),
      child: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                for (int i = 0; i < _kBoatCapacity; i++)
                  PositionLabelTile(position: i)
              ],
            ),
            Expanded(
              child: ReorderableListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                buildDefaultDragHandles: false,
                onReorder: (int oldIndex, int newIndex) => setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final paddler = _paddlerList.removeAt(oldIndex);
                  _paddlerList.insert(newIndex, paddler);
                }),
                children: [
                  for (int i = 0; i < _kBoatCapacity; i++)
                    if (_paddlerList[i] != null)
                      PaddlerTile.reorderable(
                        key: ValueKey(_paddlerList[i]!.id),
                        paddler: _paddlerList[i]!,
                        index: i,
                      )
                    else
                      AddPaddlerTile(key: ValueKey(i))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
