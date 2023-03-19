import 'package:flutter/widgets.dart';

/// The content of a button that should be used to execute asynchronous actions
/// that can display a loading indicator.
///
/// Wrap this widget in a button body to build a complete button.
class LoadingButtonContent extends StatelessWidget {
  final bool isLoading;
  final Widget loadingIndicator;
  final Widget label;

  const LoadingButtonContent({
    Key? key,
    required this.isLoading,
    required this.loadingIndicator,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: IndexedStack(
        index: 1,
        children: [
          label,
          CustomMultiChildLayout(
            delegate: LoadingButtonLayoutDelegate(isLoading),
            children: [
              LayoutId(
                id: "text",
                child: Opacity(opacity: !isLoading ? 1 : 0, child: label),
              ),
              LayoutId(
                id: "indicator",
                child: Opacity(
                  opacity: isLoading ? 1 : 0,
                  child: loadingIndicator,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LoadingButtonLayoutDelegate extends MultiChildLayoutDelegate {
  final bool isLoading;

  LoadingButtonLayoutDelegate(this.isLoading);

  @override
  void performLayout(Size size) {
    final textSize = layoutChild("text", BoxConstraints.loose(size));
    positionChild("text", Offset(size.width / 2 - textSize.width / 2, 0));

    final indicatorSize = layoutChild(
      "indicator",
      BoxConstraints.expand(width: textSize.height, height: textSize.height),
    );
    positionChild(
      "indicator",
      Offset(size.width / 2 - indicatorSize.width / 2, 0),
    );
  }

  @override
  bool shouldRelayout(LoadingButtonLayoutDelegate oldDelegate) {
    return false;
  }
}
