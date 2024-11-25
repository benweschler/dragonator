part of '../models/settings_model.dart';

const String themeKey = 'theme';
const String showComKey = 'show-com-overlay';

Future<Map<String, dynamic>> _getSettingsCommand(String userID) async {
  final snapshot = await getSettingsDoc(userID).get();
  return snapshot.data() ?? {};
}

Future<void> _setSettingsCommand(
  Map<String, dynamic> data,
  String userID,
) {
  return getSettingsDoc(userID).set(data, SetOptions(merge: true));
}
