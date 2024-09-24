import 'dart:io';
import 'package:flutter/material.dart';

/// Base class to be extended by all platform-aware widgets
abstract class PlatformAwareWidget<C extends Widget, M extends Widget>
    extends StatelessWidget {
  const PlatformAwareWidget({Key? key}) : super(key: key);

  C buildCupertinoWidget(BuildContext context);
  M buildMaterialWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if(Platform.isIOS) {
      // Use Cupertino Widget on iOS.
      return buildCupertinoWidget(context);
    }
    // Assume that the app will only ever run on either iOS or Android.
    // Use Material Widget on Android.
    return buildMaterialWidget(context);
  }
}
