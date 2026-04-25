// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_set_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestSetModel _$TestSetModelFromJson(Map<String, dynamic> json) => TestSetModel(
  id: json['id'] as String,
  siteId: json['siteId'] as String,
  appointDate: json['appointDate'] as String,
  name: json['name'] as String?,
  description: json['description'] as String?,
  requiredStrength: (json['requiredStrength'] as num).toDouble(),
  status: json['status'] as String,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
  deletedAt: json['deletedAt'] as String?,
  isDeleted: json['isDeleted'] as bool? ?? false,
);

Map<String, dynamic> _$TestSetModelToJson(TestSetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'siteId': instance.siteId,
      'appointDate': instance.appointDate,
      'name': instance.name,
      'description': instance.description,
      'requiredStrength': instance.requiredStrength,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'isDeleted': instance.isDeleted,
    };
