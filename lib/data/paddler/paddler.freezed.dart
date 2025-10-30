// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paddler.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Paddler {
  String get id;
  String get firstName;
  String get lastName;
  int get weight;
  Gender get gender;
  SidePreference? get sidePreference;
  AgeGroup get ageGroup;
  bool get drummerPreference;
  bool get steersPersonPreference;
  bool get strokePreference;
  bool get cancerSurvivor;

  /// Create a copy of Paddler
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PaddlerCopyWith<Paddler> get copyWith =>
      _$PaddlerCopyWithImpl<Paddler>(this as Paddler, _$identity);

  /// Serializes this Paddler to a JSON map.
  Map<String, dynamic> toJson();
}

/// @nodoc
abstract mixin class $PaddlerCopyWith<$Res> {
  factory $PaddlerCopyWith(Paddler value, $Res Function(Paddler) _then) =
      _$PaddlerCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String firstName,
      String lastName,
      int weight,
      Gender gender,
      SidePreference? sidePreference,
      AgeGroup ageGroup,
      bool drummerPreference,
      bool steersPersonPreference,
      bool strokePreference,
      bool cancerSurvivor});
}

/// @nodoc
class _$PaddlerCopyWithImpl<$Res> implements $PaddlerCopyWith<$Res> {
  _$PaddlerCopyWithImpl(this._self, this._then);

  final Paddler _self;
  final $Res Function(Paddler) _then;

  /// Create a copy of Paddler
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? weight = null,
    Object? gender = null,
    Object? sidePreference = freezed,
    Object? ageGroup = null,
    Object? drummerPreference = null,
    Object? steersPersonPreference = null,
    Object? strokePreference = null,
    Object? cancerSurvivor = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _self.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _self.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      weight: null == weight
          ? _self.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as int,
      gender: null == gender
          ? _self.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as Gender,
      sidePreference: freezed == sidePreference
          ? _self.sidePreference
          : sidePreference // ignore: cast_nullable_to_non_nullable
              as SidePreference?,
      ageGroup: null == ageGroup
          ? _self.ageGroup
          : ageGroup // ignore: cast_nullable_to_non_nullable
              as AgeGroup,
      drummerPreference: null == drummerPreference
          ? _self.drummerPreference
          : drummerPreference // ignore: cast_nullable_to_non_nullable
              as bool,
      steersPersonPreference: null == steersPersonPreference
          ? _self.steersPersonPreference
          : steersPersonPreference // ignore: cast_nullable_to_non_nullable
              as bool,
      strokePreference: null == strokePreference
          ? _self.strokePreference
          : strokePreference // ignore: cast_nullable_to_non_nullable
              as bool,
      cancerSurvivor: null == cancerSurvivor
          ? _self.cancerSurvivor
          : cancerSurvivor // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [Paddler].
extension PaddlerPatterns on Paddler {
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
    TResult Function(_Paddler value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Paddler() when $default != null:
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
    TResult Function(_Paddler value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Paddler():
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
    TResult? Function(_Paddler value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Paddler() when $default != null:
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
    TResult Function(
            String id,
            String firstName,
            String lastName,
            int weight,
            Gender gender,
            SidePreference? sidePreference,
            AgeGroup ageGroup,
            bool drummerPreference,
            bool steersPersonPreference,
            bool strokePreference,
            bool cancerSurvivor)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Paddler() when $default != null:
        return $default(
            _that.id,
            _that.firstName,
            _that.lastName,
            _that.weight,
            _that.gender,
            _that.sidePreference,
            _that.ageGroup,
            _that.drummerPreference,
            _that.steersPersonPreference,
            _that.strokePreference,
            _that.cancerSurvivor);
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
            String id,
            String firstName,
            String lastName,
            int weight,
            Gender gender,
            SidePreference? sidePreference,
            AgeGroup ageGroup,
            bool drummerPreference,
            bool steersPersonPreference,
            bool strokePreference,
            bool cancerSurvivor)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Paddler():
        return $default(
            _that.id,
            _that.firstName,
            _that.lastName,
            _that.weight,
            _that.gender,
            _that.sidePreference,
            _that.ageGroup,
            _that.drummerPreference,
            _that.steersPersonPreference,
            _that.strokePreference,
            _that.cancerSurvivor);
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
    TResult? Function(
            String id,
            String firstName,
            String lastName,
            int weight,
            Gender gender,
            SidePreference? sidePreference,
            AgeGroup ageGroup,
            bool drummerPreference,
            bool steersPersonPreference,
            bool strokePreference,
            bool cancerSurvivor)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Paddler() when $default != null:
        return $default(
            _that.id,
            _that.firstName,
            _that.lastName,
            _that.weight,
            _that.gender,
            _that.sidePreference,
            _that.ageGroup,
            _that.drummerPreference,
            _that.steersPersonPreference,
            _that.strokePreference,
            _that.cancerSurvivor);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Paddler extends Paddler {
  const _Paddler(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.weight,
      required this.gender,
      required this.sidePreference,
      required this.ageGroup,
      required this.drummerPreference,
      required this.steersPersonPreference,
      required this.strokePreference,
      required this.cancerSurvivor})
      : super._();
  factory _Paddler.fromJson(Map<String, dynamic> json) =>
      _$PaddlerFromJson(json);

  @override
  final String id;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final int weight;
  @override
  final Gender gender;
  @override
  final SidePreference? sidePreference;
  @override
  final AgeGroup ageGroup;
  @override
  final bool drummerPreference;
  @override
  final bool steersPersonPreference;
  @override
  final bool strokePreference;
  @override
  final bool cancerSurvivor;

  /// Create a copy of Paddler
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PaddlerCopyWith<_Paddler> get copyWith =>
      __$PaddlerCopyWithImpl<_Paddler>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PaddlerToJson(
      this,
    );
  }
}

/// @nodoc
abstract mixin class _$PaddlerCopyWith<$Res> implements $PaddlerCopyWith<$Res> {
  factory _$PaddlerCopyWith(_Paddler value, $Res Function(_Paddler) _then) =
      __$PaddlerCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String firstName,
      String lastName,
      int weight,
      Gender gender,
      SidePreference? sidePreference,
      AgeGroup ageGroup,
      bool drummerPreference,
      bool steersPersonPreference,
      bool strokePreference,
      bool cancerSurvivor});
}

/// @nodoc
class __$PaddlerCopyWithImpl<$Res> implements _$PaddlerCopyWith<$Res> {
  __$PaddlerCopyWithImpl(this._self, this._then);

  final _Paddler _self;
  final $Res Function(_Paddler) _then;

  /// Create a copy of Paddler
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? weight = null,
    Object? gender = null,
    Object? sidePreference = freezed,
    Object? ageGroup = null,
    Object? drummerPreference = null,
    Object? steersPersonPreference = null,
    Object? strokePreference = null,
    Object? cancerSurvivor = null,
  }) {
    return _then(_Paddler(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _self.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _self.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      weight: null == weight
          ? _self.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as int,
      gender: null == gender
          ? _self.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as Gender,
      sidePreference: freezed == sidePreference
          ? _self.sidePreference
          : sidePreference // ignore: cast_nullable_to_non_nullable
              as SidePreference?,
      ageGroup: null == ageGroup
          ? _self.ageGroup
          : ageGroup // ignore: cast_nullable_to_non_nullable
              as AgeGroup,
      drummerPreference: null == drummerPreference
          ? _self.drummerPreference
          : drummerPreference // ignore: cast_nullable_to_non_nullable
              as bool,
      steersPersonPreference: null == steersPersonPreference
          ? _self.steersPersonPreference
          : steersPersonPreference // ignore: cast_nullable_to_non_nullable
              as bool,
      strokePreference: null == strokePreference
          ? _self.strokePreference
          : strokePreference // ignore: cast_nullable_to_non_nullable
              as bool,
      cancerSurvivor: null == cancerSurvivor
          ? _self.cancerSurvivor
          : cancerSurvivor // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
