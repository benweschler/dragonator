// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lineup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Lineup {
  String get id;
  String get name;
  String get boatID;
  Iterable<String?> get paddlerIDs;

  /// Create a copy of Lineup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LineupCopyWith<Lineup> get copyWith =>
      _$LineupCopyWithImpl<Lineup>(this as Lineup, _$identity);

  /// Serializes this Lineup to a JSON map.
  Map<String, dynamic> toJson();
}

/// @nodoc
abstract mixin class $LineupCopyWith<$Res> {
  factory $LineupCopyWith(Lineup value, $Res Function(Lineup) _then) =
      _$LineupCopyWithImpl;
  @useResult
  $Res call(
      {String id, String name, String boatID, Iterable<String?> paddlerIDs});
}

/// @nodoc
class _$LineupCopyWithImpl<$Res> implements $LineupCopyWith<$Res> {
  _$LineupCopyWithImpl(this._self, this._then);

  final Lineup _self;
  final $Res Function(Lineup) _then;

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
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      boatID: null == boatID
          ? _self.boatID
          : boatID // ignore: cast_nullable_to_non_nullable
              as String,
      paddlerIDs: null == paddlerIDs
          ? _self.paddlerIDs
          : paddlerIDs // ignore: cast_nullable_to_non_nullable
              as Iterable<String?>,
    ));
  }
}

/// Adds pattern-matching-related methods to [Lineup].
extension LineupPatterns on Lineup {
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
    TResult Function(_Lineup value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Lineup() when $default != null:
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
    TResult Function(_Lineup value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Lineup():
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
    TResult? Function(_Lineup value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Lineup() when $default != null:
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
    TResult Function(String id, String name, String boatID,
            Iterable<String?> paddlerIDs)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Lineup() when $default != null:
        return $default(_that.id, _that.name, _that.boatID, _that.paddlerIDs);
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
    TResult Function(
            String id, String name, String boatID, Iterable<String?> paddlerIDs)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Lineup():
        return $default(_that.id, _that.name, _that.boatID, _that.paddlerIDs);
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
    TResult? Function(String id, String name, String boatID,
            Iterable<String?> paddlerIDs)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Lineup() when $default != null:
        return $default(_that.id, _that.name, _that.boatID, _that.paddlerIDs);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Lineup extends Lineup {
  const _Lineup(
      {required this.id,
      required this.name,
      required this.boatID,
      required this.paddlerIDs})
      : super._();
  factory _Lineup.fromJson(Map<String, dynamic> json) => _$LineupFromJson(json);

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
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LineupCopyWith<_Lineup> get copyWith =>
      __$LineupCopyWithImpl<_Lineup>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LineupToJson(
      this,
    );
  }
}

/// @nodoc
abstract mixin class _$LineupCopyWith<$Res> implements $LineupCopyWith<$Res> {
  factory _$LineupCopyWith(_Lineup value, $Res Function(_Lineup) _then) =
      __$LineupCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id, String name, String boatID, Iterable<String?> paddlerIDs});
}

/// @nodoc
class __$LineupCopyWithImpl<$Res> implements _$LineupCopyWith<$Res> {
  __$LineupCopyWithImpl(this._self, this._then);

  final _Lineup _self;
  final $Res Function(_Lineup) _then;

  /// Create a copy of Lineup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? boatID = null,
    Object? paddlerIDs = null,
  }) {
    return _then(_Lineup(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      boatID: null == boatID
          ? _self.boatID
          : boatID // ignore: cast_nullable_to_non_nullable
              as String,
      paddlerIDs: null == paddlerIDs
          ? _self.paddlerIDs
          : paddlerIDs // ignore: cast_nullable_to_non_nullable
              as Iterable<String?>,
    ));
  }
}

// dart format on
