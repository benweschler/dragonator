// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lineup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LineupImpl _$$LineupImplFromJson(Map<String, dynamic> json) => _$LineupImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      boatID: json['boatID'] as String,
      paddlerIDs:
          (json['paddlerIDs'] as List<dynamic>).map((e) => e as String?),
    );

Map<String, dynamic> _$$LineupImplToJson(_$LineupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'boatID': instance.boatID,
      'paddlerIDs': instance.paddlerIDs.toList(),
    };
