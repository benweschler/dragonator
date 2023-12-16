import 'package:dragonator/data/paddler.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:flutter/material.dart';

final double _kTileHeight = Insets.sm * 2 +
    TextStyles.title1.fontSize! +
    Insets.xs +
    TextStyles.body1.fontSize! +
    5;

class PaddlerTile extends StatelessWidget {
  final Paddler paddler;
  final int? index;
  final bool _isReorderable;

  const PaddlerTile(this.paddler, {super.key})
      : _isReorderable = false,
        index = null;

  /// A paddler tile for use in a [ReorderableListView].
  const PaddlerTile.reorderable({
    super.key,
    required this.paddler,
    required int this.index,
  })  : _isReorderable = true;

  @override
  Widget build(BuildContext context) {
    Widget content = Row(
      children: [
        Expanded(
          flex: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                style: TextStyles.title1.copyWith(
                  color: AppColors.of(context).accent,
                ),
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
        const SizedBox(width: Insets.med),
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
                    color: AppColors.of(context).neutralContent,
                  ),
                ),
                Text('${paddler.sidePreference}', style: TextStyles.title1),
              ],
            ),
          ),
        ),
      ],
    );

    if (_isReorderable) {
      content = IntrinsicHeight(
        child: Row(
          children: [
            Expanded(child: content),
            ReorderableDragStartListener(
              index: index!,
              child: Material(
                child: SizedBox(
                  height: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Insets.sm),
                    child: Icon(
                      Icons.drag_handle_rounded,
                      color: AppColors.of(context).neutralContent,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: _kTileHeight,
      child: Padding(
        padding: const EdgeInsets.only(left: Insets.med),
        child: content,
      ),
    );
  }
}

class PositionLabelTile extends StatelessWidget {
  final int position;

  const PositionLabelTile({super.key, required this.position})
      : assert(0 <= position && position < 22);

  @override
  Widget build(BuildContext context) {
    //TODO: hardcoded positions
    final List<String> positionLabels = [
      'D',
      for (int i = 1; i <= 10; i++) ...[
        '${i}R',
        '${i}L',
      ],
      'S',
    ];

    return SizedBox(
      height: _kTileHeight,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(Insets.sm + 1.5),
          child: Text(
            positionLabels[position],
            style: TextStyles.title1,
            softWrap: false,
          ),
        ),
      ),
    );
  }
}

class AddPaddlerTile extends StatelessWidget {
  const AddPaddlerTile({super.key});

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
                Text(
                  'Add',
                  style: TextStyles.body1
                      .copyWith(color: AppColors.of(context).accent),
                ),
                const SizedBox(
                  width: Insets.med,
                ),
                Icon(Icons.add_rounded, color: AppColors.of(context).accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyPaddlerTile extends StatelessWidget {
  const EmptyPaddlerTile({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kTileHeight,
      child: Padding(
        padding: const EdgeInsets.all(Insets.sm),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.of(context).largeSurface,
            borderRadius: Corners.smBorderRadius,
          ),
          child: Center(
            child: Text(
              'Empty',
              style: TextStyles.body2.copyWith(
                color: AppColors.of(context).neutralContent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
