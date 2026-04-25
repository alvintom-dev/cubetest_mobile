// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cube_result_set_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CubeResultSetModel _$CubeResultSetModelFromJson(Map<String, dynamic> json) =>
    CubeResultSetModel(
      id: json['id'] as String,
      testId: json['testId'] as String,
      load1: (json['load1'] as num?)?.toDouble(),
      load2: (json['load2'] as num?)?.toDouble(),
      load3: (json['load3'] as num?)?.toDouble(),
      strength1: (json['strength1'] as num).toDouble(),
      strength2: (json['strength2'] as num).toDouble(),
      strength3: (json['strength3'] as num).toDouble(),
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$CubeResultSetModelToJson(CubeResultSetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'testId': instance.testId,
      'load1': instance.load1,
      'load2': instance.load2,
      'load3': instance.load3,
      'strength1': instance.strength1,
      'strength2': instance.strength2,
      'strength3': instance.strength3,
      'notes': instance.notes,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
