part of '../models/settings_model.dart';

Future<Map<String, dynamic>> _getSettingsCommand(String userID) async {
  final snapshot = await getUserDoc(userID).get();
  return snapshot.get('settings');
}

Future<void> _setSettingsCommand(
  Map<String, dynamic> data,
  String userID,
) async {
  return getUserDoc(userID).set({'settings': data});
}
