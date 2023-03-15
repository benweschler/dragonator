import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'modal_sheet.dart';

class SelectionMenu extends StatefulWidget {
  final List<String> items;
  final int initiallySelectedIndex;
  final ValueChanged<int> onItemTap;

  const SelectionMenu({
    Key? key,
    required this.items,
    required this.initiallySelectedIndex,
    required this.onItemTap,
  }) : super(key: key);

  @override
  State<SelectionMenu> createState() => _SelectionMenuState();
}

class _SelectionMenuState extends State<SelectionMenu> {
  late int selectedItemIndex = widget.initiallySelectedIndex;

  @override
  Widget build(BuildContext context) {
    return ModalSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List<Widget>.generate(
              widget.items.length,
              (index) => _SelectionMenuItem(
                label: widget.items[index],
                isSelected: index == selectedItemIndex,
                onTap: () {
                  if(selectedItemIndex != index) {
                    widget.onItemTap(index);
                    setState(() => selectedItemIndex = index);
                    HapticFeedback.lightImpact();
                    context.pop();
                  }
                },
              ),
            )
                //TODO: using divider here
                .separate(const Divider(height: 0.5, thickness: 0.5))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _SelectionMenuItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final GestureTapCallback onTap;

  const _SelectionMenuItem({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.offset,
          vertical: Insets.lg,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyles.body1.copyWith(
                  color: isSelected ? AppColors.of(context).accent : null,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: Insets.lg),
            if (isSelected)
              Icon(Icons.check_rounded, color: AppColors.of(context).accent),
          ],
        ),
      ),
    );
  }
}
