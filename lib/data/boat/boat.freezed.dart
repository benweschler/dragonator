// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'boat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Boat {
  String get id;
  String get name;
  int get capacity;
  double get weight;

  /// Create a copy of Boat
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BoatCopyWith<Boat> get copyWith =>
      _$BoatCopyWithImpl<Boat>(this as Boat, _$identity);

  /// Serializes this Boat to a JSON map.
  Map<String, dynamic> toJson();
}

/// @nodoc
abstract mixin class $BoatCopyWith<$Res> {
  factory $BoatCopyWith(Boat value, $Res Function(Boat) _then) =
      _$BoatCopyWithImpl;
  @useResult
  $Res call({String id, String name, int capacity, double weight});
}

/// @nodoc
class _$BoatCopyWithImpl<$Res> implements $BoatCopyWith<$Res> {
  _$BoatCopyWithImpl(this._self, this._then);

  final Boat _self;
  final $Res Function(Boat) _then;

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
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      capacity: null == capacity
          ? _self.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int,
      weight: null == weight
          ? _self.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [Boat].
extension BoatPatterns on Boat {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Boat value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Boat() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Boat value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Boat():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Boat value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Boat() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String name, int capacity, double weight)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Boat() when $default != null:
        return $default(_that.id, _that.name, _that.capacity, _that.weight);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, String name, int capacity, double weight)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Boat():
        return $default(_that.id, _that.name, _that.capacity, _that.weight);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, String name, int capacity, double weight)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Boat() when $default != null:
        return $default(_that.id, _that.name, _that.capacity, _that.weight);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Boat extends Boat {
  const _Boat(
      {required this.id,
      required this.name,
      required this.capacity,
      required this.weight})
      : super._();
  factory _Boat.fromJson(Map<String, dynamic> json) => _$BoatFromJson(json);

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
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BoatCopyWith<_Boat> get copyWith =>
      __$BoatCopyWithImpl<_Boat>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BoatToJson(
      this,
    );
  }
}

/// @nodoc
abstract mixin class _$BoatCopyWith<$Res> implements $BoatCopyWith<$Res> {
  factory _$BoatCopyWith(_Boat value, $Res Function(_Boat) _then) =
      __$BoatCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String name, int capacity, double weight});
}

/// @nodoc
class __$BoatCopyWithImpl<$Res> implements _$BoatCopyWith<$Res> {
  __$BoatCopyWithImpl(this._self, this._then);

  final _Boat _self;
  final $Res Function(_Boat) _then;

  /// Create a copy of Boat
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? capacity = null,
    Object? weight = null,
  }) {
    return _then(_Boat(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      capacity: null == capacity
          ? _self.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int,
      weight: null == weight
          ? _self.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
