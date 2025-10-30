// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Boat _$BoatFromJson(Map<String, dynamic> json) => _Boat(
      id: json['id'] as String,
      name: json['name'] as String,
      capacity: (json['capacity'] as num).toInt(),
      weight: (json['weight'] as num).toDouble(),
    );

Map<String, dynamic> _$BoatToJson(_Boat instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'capacity': instance.capacity,
      'weight': instance.weight,
    };
