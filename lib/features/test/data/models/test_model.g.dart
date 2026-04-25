// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestModel _$TestModelFromJson(Map<String, dynamic> json) => TestModel(
  id: json['id'] as String,
  testSetId: json['testSetId'] as String,
  type: json['type'] as String,
  dueDate: json['dueDate'] as String,
  status: json['status'] as String,
  remark: json['remark'] as String?,
  completedAt: json['completedAt'] as String?,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$TestModelToJson(TestModel instance) => <String, dynamic>{
  'id': instance.id,
  'testSetId': instance.testSetId,
  'type': instance.type,
  'dueDate': instance.dueDate,
  'status': instance.status,
  'remark': instance.remark,
  'completedAt': instance.completedAt,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
