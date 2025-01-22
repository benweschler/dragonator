import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/buttons/selector_button.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:dragonator/widgets/preview_tiles/paddler_preview_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

//TODO: show message if no paddlers in team
class AddPaddlerToLineupScreen extends StatefulWidget {
  /// The list of paddlers in the current state of the edited lineup.
  final Iterable<Paddler> editedLineupPaddlers;

  /// A callback to add a paddler to the edited lineup.
  final ValueChanged<Paddler?> addPaddler;

  const AddPaddlerToLineupScreen({
    super.key,
    //TODO: just pass the paddlers we want?
    required this.editedLineupPaddlers,
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
    final rosterModel = context.watch<RosterModel>();
    // Only show paddlers that aren't in the lineup.
    final Set rosterPaddlers = rosterModel.paddlers.toSet();
    final List unassignedPaddlers =
        rosterPaddlers.difference(widget.editedLineupPaddlers.toSet()).toList();

    final Widget content;
    if (unassignedPaddlers.isEmpty) {
      content = Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.lg),
        child: Center(
          child: Text(
            rosterPaddlers.isEmpty
                ? 'This team has no paddlers.'
                : 'All paddlers are already in this lineup.',
            style: TextStyles.body1,
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      content = ListView.builder(
        itemCount: unassignedPaddlers.length,
        itemBuilder: (context, index) => IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SelectorButton(
                selected: _selected == index,
                onTap: () => setState(() {
                  _selected == index ? _selected = null : _selected = index;
                }),
              ),
              Expanded(
                child: PaddlerPreviewTile(unassignedPaddlers[index]),
              ),
            ],
          ),
        ),
      );
    }

    return CustomScaffold(
      leading: CustomIconButton(
        icon: Icons.close_rounded,
        onTap: () => context.pop(),
      ),
      center: const Text('Add Paddler to Lineup', style: TextStyles.title1),
      trailing: CustomIconButton(
        icon: Icons.check_rounded,
        onTap: () {
          widget.addPaddler(
              _selected != null ? unassignedPaddlers[_selected!] : null);
          context.pop();
        },
      ),
      child: content,
    );
  }
}
