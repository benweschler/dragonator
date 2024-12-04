// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lineup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Lineup _$LineupFromJson(Map<String, dynamic> json) {
  return _Lineup.fromJson(json);
}

/// @nodoc
mixin _$Lineup {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get boatID => throw _privateConstructorUsedError;
  Iterable<String?> get paddlerIDs => throw _privateConstructorUsedError;

  /// Serializes this Lineup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Lineup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LineupCopyWith<Lineup> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LineupCopyWith<$Res> {
  factory $LineupCopyWith(Lineup value, $Res Function(Lineup) then) =
      _$LineupCopyWithImpl<$Res, Lineup>;
  @useResult
  $Res call(
      {String id, String name, String boatID, Iterable<String?> paddlerIDs});
}

/// @nodoc
class _$LineupCopyWithImpl<$Res, $Val extends Lineup>
    implements $LineupCopyWith<$Res> {
  _$LineupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Lineup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? boatID = null,
    Object? paddlerIDs = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      boatID: null == boatID
          ? _value.boatID
          : boatID // ignore: cast_nullable_to_non_nullable
              as String,
      paddlerIDs: null == paddlerIDs
          ? _value.paddlerIDs
          : paddlerIDs // ignore: cast_nullable_to_non_nullable
              as Iterable<String?>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LineupImplCopyWith<$Res> implements $LineupCopyWith<$Res> {
  factory _$$LineupImplCopyWith(
          _$LineupImpl value, $Res Function(_$LineupImpl) then) =
      __$$LineupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String name, String boatID, Iterable<String?> paddlerIDs});
}

/// @nodoc
class __$$LineupImplCopyWithImpl<$Res>
    extends _$LineupCopyWithImpl<$Res, _$LineupImpl>
    implements _$$LineupImplCopyWith<$Res> {
  __$$LineupImplCopyWithImpl(
      _$LineupImpl _value, $Res Function(_$LineupImpl) _then)
      : super(_value, _then);

  /// Create a copy of Lineup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? boatID = null,
    Object? paddlerIDs = null,
  }) {
    return _then(_$LineupImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      boatID: null == boatID
          ? _value.boatID
          : boatID // ignore: cast_nullable_to_non_nullable
              as String,
      paddlerIDs: null == paddlerIDs
          ? _value.paddlerIDs
          : paddlerIDs // ignore: cast_nullable_to_non_nullable
              as Iterable<String?>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LineupImpl extends _Lineup {
  const _$LineupImpl(
      {required this.id,
      required this.name,
      required this.boatID,
      required this.paddlerIDs})
      : super._();

  factory _$LineupImpl.fromJson(Map<String, dynamic> json) =>
      _$$LineupImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String boatID;
  @override
  final Iterable<String?> paddlerIDs;

  /// Create a copy of Lineup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LineupImplCopyWith<_$LineupImpl> get copyWith =>
      __$$LineupImplCopyWithImpl<_$LineupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LineupImplToJson(
      this,
    );
  }
}

abstract class _Lineup extends Lineup {
  const factory _Lineup(
      {required final String id,
      required final String name,
      required final String boatID,
      required final Iterable<String?> paddlerIDs}) = _$LineupImpl;
  const _Lineup._() : super._();

  factory _Lineup.fromJson(Map<String, dynamic> json) = _$LineupImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get boatID;
  @override
  Iterable<String?> get paddlerIDs;

  /// Create a copy of Lineup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LineupImplCopyWith<_$LineupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
