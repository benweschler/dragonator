import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'modal_sheet.dart';

class ContextMenu extends StatelessWidget {
  final List<ContextMenuAction> actions;

  const ContextMenu(this.actions, {super.key});

  @override
  Widget build(BuildContext context) {
    return ModalSheet(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[...actions]
              .separate(const Divider(height: 0.5, thickness: 0.5))
              .toList(),
        ),
      ),
    );
  }
}

class ContextMenuAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDestructiveAction;
  final bool autoPop;
  final GestureTapCallback onTap;

  const ContextMenuAction({
    super.key,
    required this.icon,
    required this.label,
    this.isDestructiveAction = false,
    this.autoPop = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color? color = isDestructiveAction ? AppColors.of(context).error : null;

    return ResponsiveStrokeButton(
      onTap: () {
        onTap();
        // Modal sheets are shown on the root navigator.
        if(autoPop) context.pop();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.offset,
          vertical: Insets.lg,
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: Insets.lg),
            Expanded(child: Text(label, style: TextStyle(color: color))),
          ],
        ),
      ),
    );
  }
}
