// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paddler.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Paddler _$PaddlerFromJson(Map<String, dynamic> json) => _Paddler(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      weight: (json['weight'] as num).toInt(),
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      sidePreference:
          $enumDecodeNullable(_$SidePreferenceEnumMap, json['sidePreference']),
      ageGroup: $enumDecode(_$AgeGroupEnumMap, json['ageGroup']),
      drummerPreference: json['drummerPreference'] as bool,
      steersPersonPreference: json['steersPersonPreference'] as bool,
      strokePreference: json['strokePreference'] as bool,
      cancerSurvivor: json['cancerSurvivor'] as bool,
    );

Map<String, dynamic> _$PaddlerToJson(_Paddler instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'weight': instance.weight,
      'gender': _$GenderEnumMap[instance.gender]!,
      'sidePreference': _$SidePreferenceEnumMap[instance.sidePreference],
      'ageGroup': _$AgeGroupEnumMap[instance.ageGroup]!,
      'drummerPreference': instance.drummerPreference,
      'steersPersonPreference': instance.steersPersonPreference,
      'strokePreference': instance.strokePreference,
      'cancerSurvivor': instance.cancerSurvivor,
    };

const _$GenderEnumMap = {
  Gender.M: 'M',
  Gender.F: 'F',
  Gender.X: 'X',
};

const _$SidePreferenceEnumMap = {
  SidePreference.left: 'left',
  SidePreference.strongLeft: 'strongLeft',
  SidePreference.right: 'right',
  SidePreference.strongRight: 'strongRight',
  SidePreference.none: 'none',
};

const _$AgeGroupEnumMap = {
  AgeGroup.youth: 'youth',
  AgeGroup.underForty: 'underForty',
  AgeGroup.forties: 'forties',
  AgeGroup.fifties: 'fifties',
  AgeGroup.sixties: 'sixties',
  AgeGroup.aboveSeventies: 'aboveSeventies',
};
