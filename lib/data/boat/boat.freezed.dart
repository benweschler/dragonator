// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'boat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Boat _$BoatFromJson(Map<String, dynamic> json) {
  return _Boat.fromJson(json);
}

/// @nodoc
mixin _$Boat {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get capacity => throw _privateConstructorUsedError;
  double get weight => throw _privateConstructorUsedError;

  /// Serializes this Boat to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Boat
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BoatCopyWith<Boat> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoatCopyWith<$Res> {
  factory $BoatCopyWith(Boat value, $Res Function(Boat) then) =
      _$BoatCopyWithImpl<$Res, Boat>;
  @useResult
  $Res call({String id, String name, int capacity, double weight});
}

/// @nodoc
class _$BoatCopyWithImpl<$Res, $Val extends Boat>
    implements $BoatCopyWith<$Res> {
  _$BoatCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Boat
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? capacity = null,
    Object? weight = null,
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
      capacity: null == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BoatImplCopyWith<$Res> implements $BoatCopyWith<$Res> {
  factory _$$BoatImplCopyWith(
          _$BoatImpl value, $Res Function(_$BoatImpl) then) =
      __$$BoatImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, int capacity, double weight});
}

/// @nodoc
class __$$BoatImplCopyWithImpl<$Res>
    extends _$BoatCopyWithImpl<$Res, _$BoatImpl>
    implements _$$BoatImplCopyWith<$Res> {
  __$$BoatImplCopyWithImpl(_$BoatImpl _value, $Res Function(_$BoatImpl) _then)
      : super(_value, _then);

  /// Create a copy of Boat
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? capacity = null,
    Object? weight = null,
  }) {
    return _then(_$BoatImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      capacity: null == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BoatImpl extends _Boat {
  const _$BoatImpl(
      {required this.id,
      required this.name,
      required this.capacity,
      required this.weight})
      : super._();

  factory _$BoatImpl.fromJson(Map<String, dynamic> json) =>
      _$$BoatImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int capacity;
  @override
  final double weight;

  /// Create a copy of Boat
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BoatImplCopyWith<_$BoatImpl> get copyWith =>
      __$$BoatImplCopyWithImpl<_$BoatImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BoatImplToJson(
      this,
    );
  }
}

abstract class _Boat extends Boat {
  const factory _Boat(
      {required final String id,
      required final String name,
      required final int capacity,
      required final double weight}) = _$BoatImpl;
  const _Boat._() : super._();

  factory _Boat.fromJson(Map<String, dynamic> json) = _$BoatImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get capacity;
  @override
  double get weight;

  /// Create a copy of Boat
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BoatImplCopyWith<_$BoatImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
