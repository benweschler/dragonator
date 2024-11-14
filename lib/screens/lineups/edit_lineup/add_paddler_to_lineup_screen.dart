import 'package:dragonator/data/paddler.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/buttons/selector_button.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:dragonator/widgets/paddler_preview_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddPaddlerToLineupScreen extends StatefulWidget {
  final String lineupID;
  final ValueChanged<Paddler?> addPaddler;

  const AddPaddlerToLineupScreen({
    super.key,
    required this.lineupID,
    required this.addPaddler,
  });

  @override
  State<AddPaddlerToLineupScreen> createState() => _AddPaddlerToLineupScreenState();
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
            SelectorButton(
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
