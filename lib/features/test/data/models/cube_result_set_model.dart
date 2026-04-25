import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/cube_result_set.dart';

part 'cube_result_set_model.g.dart';

@JsonSerializable()
class CubeResultSetModel extends Equatable {
  const CubeResultSetModel({
    required this.id,
    required this.testId,
    this.load1,
    this.load2,
    this.load3,
    required this.strength1,
    required this.strength2,
    required this.strength3,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String testId;
  final double? load1;
  final double? load2;
  final double? load3;
  final double strength1;
  final double strength2;
  final double strength3;
  final String? notes;
  final String createdAt;
  final String updatedAt;

  factory CubeResultSetModel.fromJson(Map<String, dynamic> json) =>
      _$CubeResultSetModelFromJson(json);
  Map<String, dynamic> toJson() => _$CubeResultSetModelToJson(this);

  factory CubeResultSetModel.fromMap(Map<String, dynamic> map) {
    return CubeResultSetModel(
      id: map['id'] as String,
      testId: map['test_id'] as String,
      load1: (map['load1'] as num?)?.toDouble(),
      load2: (map['load2'] as num?)?.toDouble(),
      load3: (map['load3'] as num?)?.toDouble(),
      strength1: (map['strength1'] as num).toDouble(),
      strength2: (map['strength2'] as num).toDouble(),
      strength3: (map['strength3'] as num).toDouble(),
      notes: map['notes'] as String?,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'test_id': testId,
      'load1': load1,
      'load2': load2,
      'load3': load3,
      'strength1': strength1,
      'strength2': strength2,
      'strength3': strength3,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  CubeResultSet toEntity() {
    return CubeResultSet(
      id: id,
      testId: testId,
      load1: load1,
      load2: load2,
      load3: load3,
      strength1: strength1,
      strength2: strength2,
      strength3: strength3,
      notes: notes,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }

  factory CubeResultSetModel.fromEntity(CubeResultSet entity) {
    return CubeResultSetModel(
      id: entity.id,
      testId: entity.testId,
      load1: entity.load1,
      load2: entity.load2,
      load3: entity.load3,
      strength1: entity.strength1,
      strength2: entity.strength2,
      strength3: entity.strength3,
      notes: entity.notes,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        testId,
        load1,
        load2,
        load3,
        strength1,
        strength2,
        strength3,
        notes,
        createdAt,
        updatedAt,
      ];
}
