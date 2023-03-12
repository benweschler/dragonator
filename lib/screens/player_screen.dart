import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';

class PlayerScreen extends StatelessWidget {
  final String playerID;

  const PlayerScreen(this.playerID, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(child: Center(child: Text(playerID)));
  }
}
