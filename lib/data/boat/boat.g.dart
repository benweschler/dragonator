// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BoatImpl _$$BoatImplFromJson(Map<String, dynamic> json) => _$BoatImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      capacity: (json['capacity'] as num).toInt(),
      weight: (json['weight'] as num).toDouble(),
    );

Map<String, dynamic> _$$BoatImplToJson(_$BoatImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'capacity': instance.capacity,
      'weight': instance.weight,
    };
