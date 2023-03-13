import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/easy_notifier.dart';

class AppModel extends EasyNotifier {
  static const ThemeType _defaultThemeType = ThemeType.light;

  /// The active theme for the app.
  ThemeType _themeType = _defaultThemeType;

  ThemeType get themeType => _themeType;
  set theme(ThemeType theme) => notify(() => _themeType = theme);
}
