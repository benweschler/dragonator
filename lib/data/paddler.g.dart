// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paddler.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaddlerImpl _$$PaddlerImplFromJson(Map<String, dynamic> json) =>
    _$PaddlerImpl(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      weight: (json['weight'] as num).toInt(),
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      sidePreference:
          $enumDecode(_$SidePreferenceEnumMap, json['sidePreference']),
      ageGroup: $enumDecode(_$AgeGroupEnumMap, json['ageGroup']),
      drummerPreference: json['drummerPreference'] as bool,
      steersPersonPreference: json['steersPersonPreference'] as bool,
      strokePreference: json['strokePreference'] as bool,
    );

Map<String, dynamic> _$$PaddlerImplToJson(_$PaddlerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'weight': instance.weight,
      'gender': _$GenderEnumMap[instance.gender]!,
      'sidePreference': _$SidePreferenceEnumMap[instance.sidePreference]!,
      'ageGroup': _$AgeGroupEnumMap[instance.ageGroup]!,
      'drummerPreference': instance.drummerPreference,
      'steersPersonPreference': instance.steersPersonPreference,
      'strokePreference': instance.strokePreference,
    };

const _$GenderEnumMap = {
  Gender.M: 'M',
  Gender.F: 'F',
  Gender.X: 'X',
};

const _$SidePreferenceEnumMap = {
  SidePreference.left: 'left',
  SidePreference.right: 'right',
};

const _$AgeGroupEnumMap = {
  AgeGroup.youth: 'youth',
  AgeGroup.underForty: 'underForty',
  AgeGroup.forties: 'forties',
  AgeGroup.fifties: 'fifties',
  AgeGroup.sixties: 'sixties',
  AgeGroup.aboveSeventies: 'aboveSeventies',
};
