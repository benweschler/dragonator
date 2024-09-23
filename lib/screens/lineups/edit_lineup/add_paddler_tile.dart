import 'package:dragonator/data/paddler.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:dragonator/widgets/paddler_preview_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

//TODO: implement adding paddler
class AddPaddlerTile extends StatelessWidget {
  final String lineupID;
  final ValueChanged<Paddler?> addPaddler;

  const AddPaddlerTile({
    super.key,
    required this.lineupID,
    required this.addPaddler,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        RoutePaths.addPaddlerToLineup(lineupID),
        extra: addPaddler,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 0.4 * MediaQuery.of(context).size.width,
        ),
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: Color.alphaBlend(
            AppColors.of(context).errorSurface,
            Theme.of(context).scaffoldBackgroundColor,
          ),
          borderRadius: Corners.smBorderRadius,
          border: Border.all(color: AppColors.of(context).accent),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add',
              style: TextStyles.body1.copyWith(
                color: AppColors.of(context).accent,
              ),
              maxLines: 2,
            ),
            const SizedBox(width: Insets.xs),
            Icon(Icons.add_rounded, color: AppColors.of(context).accent),
          ],
        ),
      ),
    );
  }
}

class AddPaddlerToLineupScreen extends StatefulWidget {
  final String lineupID;
  final ValueChanged<Paddler?> addPaddler;

  const AddPaddlerToLineupScreen({
    super.key,
    required this.lineupID,
    required this.addPaddler,
  });

  @override
  State<AddPaddlerToLineupScreen> createState() =>
      _AddPaddlerToLineupScreenState();
}

class _AddPaddlerToLineupScreenState extends State<AddPaddlerToLineupScreen> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final paddlers = context.watch<RosterModel>().paddlers.toList();

    return CustomScaffold(
      leading: CustomIconButton(
        icon: Icons.close_rounded,
        onTap: () => context.pop(),
      ),
      center: const Text('Add Paddler to Lineup', style: TextStyles.title1),
      trailing: CustomIconButton(
        icon: Icons.check_rounded,
        onTap: () {
          widget.addPaddler(_selected != null ? paddlers[_selected!] : null);
          context.pop();
        },
      ),
      child: ListView.builder(
        itemCount: paddlers.length,
        itemBuilder: (context, index) => Row(
          children: [
            _SelectorButton(
              selected: _selected == index,
              onTap: () => setState(() {
                _selected == index ? _selected = null : _selected = index;
              }),
            ),
            const SizedBox(width: Insets.med),
            Expanded(child: PaddlerPreviewTile(paddlers[index])),
          ],
        ),
      ),
    );
  }
}

class _SelectorButton extends StatelessWidget {
  final bool selected;
  final GestureTapCallback onTap;

  const _SelectorButton({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: selected ? AppColors.of(context).accent : null,
          shape: BoxShape.circle,
          //TODO: black should be onBackground
          border: Border.all(
            color: selected ? Colors.transparent : Colors.black,
          ),
        ),
        child: selected
            //TODO: should be onAccent
            ? const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: Insets.lg,
              )
            : null,
      ),
    );
  }
}
