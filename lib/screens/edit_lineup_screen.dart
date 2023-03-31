import 'package:dragonator/data/lineup.dart';
import 'package:dragonator/data/paddler.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/custom_back_button.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

const int _kBoatCapacity = 22;
final double _kTileHeight = Insets.sm * 2 +
    TextStyles.title1.fontSize! +
    Insets.xs +
    TextStyles.body1.fontSize! +
    5;

List<String> _getPositionLabels() => [
  'D',
  for (int i = 1; i <= 10; i++) ...[
    '${i}R',
    '${i}L',
  ],
  'S',
];

class EditLineupScreen extends StatefulWidget {
  final String lineupID;

  const EditLineupScreen({
    Key? key,
    required this.lineupID,
  }) : super(key: key);

  @override
  State<EditLineupScreen> createState() => _EditLineupScreenState();
}

class _EditLineupScreenState extends State<EditLineupScreen> {
  late final Lineup _lineup =
      context.read<RosterModel>().getLineup(widget.lineupID)!;
  late final List<Paddler?> _paddlerList = [
    ..._lineup.paddlers,
    for (int i = _lineup.paddlers.length; i < _kBoatCapacity; i++) null,
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      leading: const CustomBackButton(),
      center: Text(_lineup.name, style: TextStyles.title1),
      trailing: CustomIconButton(
        onTap: () {
          context.read<RosterModel>().setLineup(
                widget.lineupID,
                _lineup.copyWith(paddlers: _paddlerList),
              );
          context.pop();
        },
        icon: Icons.check_rounded,
      ),
      child: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: _getPositionLabels()
                  .map((label) => _PositionLabelTile(label))
                  .toList(),
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
                      _PaddlerTile(
                        key: ValueKey(_paddlerList[i]!.id),
                        paddler: _paddlerList[i]!,
                        index: i,
                      )
                    else
                      _AddPaddlerTile(key: ValueKey(i))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaddlerTile extends StatelessWidget {
  final Paddler paddler;
  final int index;

  const _PaddlerTile({
    Key? key,
    required this.paddler,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kTileHeight,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Insets.med),
          child: _buildContent(paddler, AppColors.of(context)),
        ),
      ),
    );
  }

  Widget _buildContent(Paddler paddler, AppColors appColors) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${paddler.firstName} ${paddler.lastName}',
                  // Since the height of a list tile is hardcoded, the height of
                  // the name text can not be dynamic and depend on the length
                  // of an arbitrarily long user name. A name spanning more than
                  // one line would lead to a render overflow of the tile.
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.title1.copyWith(color: appColors.accent),
                ),
                const SizedBox(height: Insets.xs),
                Text.rich(TextSpan(children: [
                  TextSpan(
                    text: '${paddler.weight}',
                    style:
                        TextStyles.body1.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: ' lbs', style: TextStyles.body2),
                ])),
              ],
            ),
          ),
          SizedBox(
            width: Insets.med,
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
          ),
          ReorderableDragStartListener(
            index: index,
            child: Material(
              child: SizedBox(
                height: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Insets.sm),
                  child: Icon(
                    Icons.drag_handle_rounded,
                    color: appColors.neutralContent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PositionLabelTile extends StatelessWidget {
  final String label;

  const _PositionLabelTile(this.label, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kTileHeight,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(Insets.sm + 1.5),
          child: Text(label, style: TextStyles.title1, softWrap: false),
        ),
      ),
    );
  }
}

class _AddPaddlerTile extends StatelessWidget {
  const _AddPaddlerTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kTileHeight,
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(Insets.sm),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: Corners.smBorderRadius,
              color: AppColors.of(context).accent.withOpacity(0.2),
              border: Border.all(color: AppColors.of(context).accent),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Add', style: TextStyles.body1.copyWith(color: AppColors.of(context).accent),),
                const SizedBox(width: Insets.med,),
                Icon(Icons.add_rounded, color: AppColors.of(context).accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
