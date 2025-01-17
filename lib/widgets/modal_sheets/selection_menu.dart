import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/widgets/buttons/modal_sheet_expanded_button.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'modal_sheet.dart';

class SelectionMenu<T> extends StatefulWidget {
  final Iterable<T> options;
  final Set<T> initiallySelectedOptions;
  final String Function(T)? labelBuilder;
  final ValueChanged<Set<T>> onSelect;
  final _SelectionBehavior _behavior;

  SelectionMenu({
    super.key,
    required this.options,
    required T? initiallySelectedOption,
    this.labelBuilder,
    required ValueChanged<T> onSelect,
  })  : initiallySelectedOptions =
            initiallySelectedOption == null ? {} : {initiallySelectedOption},
        onSelect = ((options) => onSelect(options.single)),
        _behavior = _AutoSelectionBehavior<T>();

  SelectionMenu.single({
    super.key,
    required this.options,
    required T? initiallySelectedOption,
    bool allowNoSelection = false,
    this.labelBuilder,
    required ValueChanged<T?> onSelect,
  })  : initiallySelectedOptions =
            initiallySelectedOption == null ? {} : {initiallySelectedOption},
        onSelect = ((options) => onSelect(options.singleOrNull)),
        _behavior = _SingleSelectionBehavior<T>(
          allowNoSelection: allowNoSelection,
        );

  SelectionMenu.multi({
    super.key,
    required this.options,
    Set<T>? initiallySelectedOptions,
    Iterable<T>? lockedSelections,
    this.labelBuilder,
    required this.onSelect,
  })  : initiallySelectedOptions = initiallySelectedOptions ?? {},
        _behavior = _MultiSelectionBehavior<T>(
          lockedSelections: lockedSelections ?? Iterable.empty(),
        );

  String _defaultLabelBuilder(T option) => option.toString();

  @override
  State<SelectionMenu> createState() => _SelectionMenuState<T>();
}

class _SelectionMenuState<T> extends State<SelectionMenu<T>> {
  @override
  void initState() {
    super.initState();
    widget._behavior.initialize(widget, setState);
  }

  @override
  void didUpdateWidget(covariant SelectionMenu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget._behavior.initialize(widget, setState);
  }

  @override
  Widget build(BuildContext context) {
    return ModalSheet(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...widget.options
                .map<Widget>(
                  (option) => SelectionMenuTile(
                    label: widget.labelBuilder?.call(option) ??
                        widget._defaultLabelBuilder(option),
                    isSelected: widget._behavior.isTileSelected(option),
                    onTap: () {
                      widget._behavior.onTap(option);
                      if (widget._behavior is _AutoSelectionBehavior) {
                        context.pop();
                      }
                    },
                  ),
                )
                .separate(const Divider(height: 0.5, thickness: 0.5)),
            if (widget._behavior.action != null)
              ModalSheetButtonTile(
                enabled: widget._behavior.selection.isNotEmpty,
                color: AppColors.of(context).primary,
                //TODO: bad!
                autoPop: false,
                onTap: () {
                  widget._behavior.action!();
                  HapticFeedback.lightImpact();
                },
                label: 'Apply',
              ),
          ],
        ),
      ),
    );
  }
}

class _AutoSelectionBehavior<T> extends _SelectionBehavior<T>
    with _SingleSelectionBehaviorMixin {
  @override
  void onTap(T option) {
    if (_selectedOption != option) {
      widget.onSelect({option});
      setState(() => _selectedOption = option);
      HapticFeedback.lightImpact();
    }
  }
}

class _SingleSelectionBehavior<T> extends _SelectionBehavior<T>
    with _SingleSelectionBehaviorMixin {
  final bool allowNoSelection;

  _SingleSelectionBehavior({required this.allowNoSelection});

  @override
  void onTap(T option) {
    setState(() {
      if (_selectedOption != option) {
        _selectedOption = option;
      } else if (allowNoSelection) {
        _selectedOption = null;
      }
    });
  }

  @override
  VoidCallback? get action =>
      () => widget.onSelect({if (_selectedOption != null) _selectedOption!});
}

class _MultiSelectionBehavior<T> extends _SelectionBehavior<T> {
  final Iterable<T> lockedSelections;

  _MultiSelectionBehavior({required this.lockedSelections});

  late final Set<T> _selectedOptions = widget.initiallySelectedOptions;

  @override
  Set<T> get selection => _selectedOptions;

  @override
  void onTap(T option) {
    setState(() {
      if (!_selectedOptions.add(option) && !lockedSelections.contains(option)) {
        _selectedOptions.remove(option);
      }
    });
  }

  @override
  VoidCallback? get action => () => widget.onSelect(_selectedOptions);

  @override
  bool isTileSelected(T option) => _selectedOptions.contains(option);
}

mixin _SingleSelectionBehaviorMixin<T> on _SelectionBehavior<T> {
  late T? _selectedOption;

  @override
  Set<T> get selection => {if (_selectedOption != null) _selectedOption!};

  @override
  void initialize(
      SelectionMenu<T> widget, void Function(VoidCallback) setState) {
    _selectedOption = widget.initiallySelectedOptions.isEmpty
        ? null
        : widget.initiallySelectedOptions.first;

    super.initialize(widget, setState);
  }

  @override
  bool isTileSelected(T option) => _selectedOption == option;
}

abstract class _SelectionBehavior<T> {
  late final SelectionMenu<T> widget;
  late final void Function(VoidCallback) setState;

  void initialize(
    SelectionMenu<T> widget,
    void Function(VoidCallback) setState,
  ) {
    this.widget = widget;
    this.setState = setState;
  }

  Set<T> get selection;

  VoidCallback? action;

  void onTap(T option);

  bool isTileSelected(T option);
}

class SelectionMenuTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final GestureTapCallback onTap;

  const SelectionMenuTile({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveStrokeButton(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(Insets.lg),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.of(context).primary : null,
                ),
              ),
            ),
            const SizedBox(width: Insets.lg),
            Icon(
              Icons.check_rounded,
              color: isSelected
                  ? AppColors.of(context).primary
                  : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
