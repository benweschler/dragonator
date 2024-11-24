import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'boat.freezed.dart';
part 'boat.g.dart';

@Freezed(equal: false)
class Boat extends Equatable with _$Boat {
  const Boat._();

  const factory Boat({
    required String id,
    required String name,
    required int capacity,
    required double weight,
  }) = _Boat;

  factory Boat.fromJson(Map<String, Object?> json) => _$BoatFromJson(json);

  factory Boat.fromFirestore({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return Boat.fromJson(data..['id'] = id);
  }

  // Lineups in Firestore have their ID as their key rather than a data member.
  Map<String, dynamic> toFirestore() => toJson()..remove('id');

  @override
  List<Object?> get props => [id, name, capacity, weight];
}
