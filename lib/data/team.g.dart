// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Team _$$_TeamFromJson(Map<String, dynamic> json) => _$_Team(
      id: json['id'] as String,
      name: json['name'] as String,
      paddlerIDs:
          (json['paddlerIDs'] as List<dynamic>).map((e) => e as String).toSet(),
    );

Map<String, dynamic> _$$_TeamToJson(_$_Team instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'paddlerIDs': instance.paddlerIDs.toList(),
    };
