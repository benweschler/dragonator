// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paddler.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Paddler _$$_PaddlerFromJson(Map<String, dynamic> json) => _$_Paddler(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      weight: json['weight'] as int,
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      sidePreference:
          $enumDecode(_$SidePreferenceEnumMap, json['sidePreference']),
      ageGroup: json['ageGroup'] as String,
      drummerPreference: json['drummerPreference'] as bool,
      steersPersonPreference: json['steersPersonPreference'] as bool,
      strokePreference: json['strokePreference'] as bool,
    );

Map<String, dynamic> _$$_PaddlerToJson(_$_Paddler instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'weight': instance.weight,
      'gender': _$GenderEnumMap[instance.gender]!,
      'sidePreference': _$SidePreferenceEnumMap[instance.sidePreference]!,
      'ageGroup': instance.ageGroup,
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
