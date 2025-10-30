// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Team _$TeamFromJson(Map<String, dynamic> json) => _Team(
      id: json['id'] as String,
      name: json['name'] as String,
      boats: const _BoatMapConverter()
          .fromJson(json['boats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TeamToJson(_Team instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'boats': const _BoatMapConverter().toJson(instance.boats),
    };
