import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
abstract class AppUser with _$AppUser {
  const AppUser._();

  const factory AppUser({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, Object?> json)
      => _$AppUserFromJson(json);
}
