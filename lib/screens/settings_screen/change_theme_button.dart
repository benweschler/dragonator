import 'package:dragonator/models/app_model.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeThemeButton extends StatelessWidget {
  final ThemeMode themeMode;

  const ChangeThemeButton({Key? key, required this.themeMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appModel = context.read<AppModel>();
    final String label;
    final Widget themeWindow;

    switch (themeMode) {
      case ThemeMode.light:
        label = 'Light';
        themeWindow = Theme(
          data: AppColors.fromType(ThemeType.light).toThemeData(),
          child: const _ThemeWindow(),
        );
        break;
      case ThemeMode.dark:
        label = 'Dark';
        themeWindow = Theme(
          data: AppColors.fromType(ThemeType.dark).toThemeData(),
          child: const _ThemeWindow(),
        );
        break;
      case ThemeMode.system:
        label = 'System';
        themeWindow = Stack(
          children: [
            Theme(
              data: AppColors.fromType(ThemeType.light).toThemeData(),
              child: const _ThemeWindow(),
            ),
            ClipPath(
              clipper: _DiagonalClipper(),
              child: Theme(
                data: AppColors.fromType(ThemeType.dark).toThemeData(),
                child: const _ThemeWindow(),
              ),
            ),
          ],
        );
        break;
    }

    return ResponsiveButton.large(
      onTap: () => appModel.themeMode = themeMode,
      builder: (overlay) => AspectRatio(
        aspectRatio: 0.65,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: Corners.lgBorderRadius,
                color: AppColors.of(context).largeSurface,
                border: Border.all(
                  color: appModel.themeMode == themeMode
                      ? AppColors.of(context).accent
                      : Colors.transparent,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Insets.lg),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: Corners.medBorderRadius,
                          border: Border.all(
                            color: AppColors.of(context).smallSurface,
                            width: 2,
                          ),
                        ),
                        child: Material(
                          elevation: 8,
                          borderRadius: Corners.medBorderRadius,
                          child: themeWindow,
                        ),
                      ),
                    ),
                    const SizedBox(height: Insets.lg),
                    Text(
                      label,
                      style: TextStyles.body1
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: overlay,
                  borderRadius: Corners.lgBorderRadius,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Clips along the diagonal from bottom left to top right.
class _DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_DiagonalClipper oldClipper) => false;
}

class _ThemeWindow extends StatelessWidget {
  const _ThemeWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppColors appColors = AppColors.of(context);
    final textColor = appColors.neutralContent;
    final neutralContent = appColors.neutralContent.withOpacity(0.2);
    final largeSurface = appColors.smallSurface;
    final smallSurface = appColors.smallSurface.withOpacity(0.15);

    return Container(
      padding: const EdgeInsets.all(Insets.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: Corners.medBorderRadius,
      ),
      child: Column(
        children: [
          _WindowElement(
            color: (appColors.isDark ? Colors.white : Colors.black)
                .withOpacity(0.65),
          ),
          const Spacer(flex: 2),
          Expanded(
            flex: 2,
            child: Row(
              children: <Widget>[
                _WindowElement(flex: 3, color: appColors.accent),
                _WindowElement(flex: 3, color: smallSurface),
                _WindowElement(flex: 3, color: smallSurface),
              ].separate(const Spacer()).toList(),
            ),
          ),
          const Spacer(flex: 3),
          _WindowElement(
            flex: 10,
            color: largeSurface,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _WindowElement(color: textColor),
                      const Spacer(),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
                _WindowElement(color: neutralContent),
                const Spacer(flex: 2),
                _WindowElement(color: neutralContent),
              ],
            ),
          ),
          const Spacer(flex: 2),
          _WindowElement(
            flex: 10,
            color: largeSurface,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _WindowElement(color: textColor),
                      const Spacer(),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
                _WindowElement(color: neutralContent),
                const Spacer(flex: 2),
                _WindowElement(color: neutralContent),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WindowElement extends StatelessWidget {
  final int flex;
  final Color color;
  final Widget? child;

  const _WindowElement({
    Key? key,
    this.flex = 1,
    this.child,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.all(Insets.xs),
        decoration: BoxDecoration(
          color: color,
          borderRadius: Corners.smBorderRadius,
        ),
        child: child,
      ),
    );
  }
}
