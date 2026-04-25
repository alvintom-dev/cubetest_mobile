// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleDataModel _$ScheduleDataModelFromJson(Map<String, dynamic> json) =>
    ScheduleDataModel(
      id: (json['id'] as num).toInt(),
      triggerDate: json['triggerDate'] as String,
      testCount: (json['testCount'] as num).toInt(),
    );

Map<String, dynamic> _$ScheduleDataModelToJson(ScheduleDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'triggerDate': instance.triggerDate,
      'testCount': instance.testCount,
    };
