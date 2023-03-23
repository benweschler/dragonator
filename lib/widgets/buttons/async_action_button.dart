import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:dragonator/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

/// A button that should be used to execute asynchronous actions that can
/// display a loading indicator.
class AsyncActionButton<T extends Object> extends StatefulWidget {
  final String label;
  final bool isEnabled;
  final Future? Function() action;
  final void Function(T error)? catchError;

  const AsyncActionButton({
    Key? key,
    required this.label,
    required this.isEnabled,
    required this.action,
    required this.catchError,
  }) : super(key: key);

  @override
  State<AsyncActionButton> createState() => AsyncActionButtonState<T>();
}

//TODO: ask stackoverflow question about why tf I have to do this absolute baboonery of tightening State<AsyncActionButton> to State<AsyncActionButton<T>>. T should be passed correctly through createState.
// Allow onTap to be called programmatically through a GlobalKey by making the
// State class public.
class AsyncActionButtonState<T extends Object>
    extends State<AsyncActionButton<T>> {
  bool isLoading = false;

  void executeAction() async {
    setState(() => isLoading = true);

    try {
      await widget.action()?.whenComplete(() {
        // This widget may have been removed from the tree while or after its
        // async action completes.
        if (mounted) {
          setState(() => isLoading = false);
        }
      });
    } on T catch (error) {
      widget.catchError?.call(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = AppColors.of(context).accent;

    return IgnorePointer(
      ignoring: !widget.isEnabled || isLoading,
      child: ResponsiveButton.large(
        onTap: executeAction,
        builder: (overlay) => Container(
          padding: const EdgeInsets.all(Insets.med),
          decoration: BoxDecoration(
            borderRadius: Corners.medBorderRadius,
            color: widget.isEnabled
                ? Color.alphaBlend(overlay, buttonColor)
                : buttonColor.withOpacity(0.5),
          ),
          child: _AsyncActionButtonContent(
            labelText: widget.label,
            isLoading: isLoading,
            loadingIndicatorColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// The content of a [AsyncActionButton].
///
/// Wrap this widget in a button body to build a complete button.
class _AsyncActionButtonContent extends StatelessWidget {
  final String labelText;
  final bool isLoading;
  final Color loadingIndicatorColor;

  const _AsyncActionButtonContent({
    Key? key,
    required this.labelText,
    required this.isLoading,
    required this.loadingIndicatorColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final label = Text(
      labelText,
      style: TextStyles.body1.copyWith(
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );

    // Give the CustomMultiChildLayout the height of the label, so use an
    // indexed stack to take on the size of the label and pass it to the
    // CustomMultiChildLayout using IntrinsicHeight. Because the IndexedStack
    // has a hardcoded index, the label widget is never painted.
    return IntrinsicHeight(
      child: IndexedStack(
        index: 1,
        children: [
          label,
          CustomMultiChildLayout(
            delegate: _LoadingButtonLayoutDelegate(isLoading),
            children: [
              LayoutId(
                id: 'text',
                child: Opacity(opacity: !isLoading ? 1 : 0, child: label),
              ),
              LayoutId(
                id: 'indicator',
                child: Opacity(
                  opacity: isLoading ? 1 : 0,
                  child: LoadingIndicator(loadingIndicatorColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoadingButtonLayoutDelegate extends MultiChildLayoutDelegate {
  final bool isLoading;

  _LoadingButtonLayoutDelegate(this.isLoading);

  @override
  void performLayout(Size size) {
    final textSize = layoutChild('text', BoxConstraints.loose(size));
    positionChild('text', Offset(size.width / 2 - textSize.width / 2, 0));

    final indicatorSize = layoutChild(
      'indicator',
      BoxConstraints.expand(width: textSize.height, height: textSize.height),
    );
    positionChild(
      'indicator',
      Offset(size.width / 2 - indicatorSize.width / 2, 0),
    );
  }

  @override
  bool shouldRelayout(_LoadingButtonLayoutDelegate oldDelegate) {
    return false;
  }
}
