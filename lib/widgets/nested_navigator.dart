import 'package:dragonator/utils/notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NestedNavigator extends StatelessWidget {
  final List<Page> Function(String path) pagesBuilder;
  final NestedNavigatorState _state = NestedNavigatorState();

  NestedNavigator({super.key, required this.pagesBuilder});

  static NestedNavigatorState of(BuildContext context) =>
      context.read<NestedNavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _state,
      child: Consumer<NestedNavigatorState>(
        builder: (context, state, child) => IntrinsicHeight(
          child: Navigator(
            observers: [HeroController()],
            pages: pagesBuilder(state.path),
            onDidRemovePage: (_) {},
          ),
        ),
      ),
    );
  }
}

class NestedNavigatorState extends Notifier {
  String _path = '/';

  String get path => _path;

  void pushNamed(String path) => notify(() => _path = path);

  void popHome() => notify(() => _path = '/');
}
