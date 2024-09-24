import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/platform_aware/platform_aware_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Builds as a CupertinoSwitch on iOS, and as a Material Design Switch otherwise.
class PlatformAwareSwitch extends PlatformAwareWidget<CupertinoSwitch, Switch> {
  final bool value;
  final ValueChanged<bool> onChanged;

  const PlatformAwareSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  buildCupertinoWidget(BuildContext context) {
    return CupertinoSwitch(
      value: value,
      activeColor: AppColors.of(context).accent,
      onChanged: onChanged,
    );
  }

  @override
  buildMaterialWidget(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
    );
  }
}
