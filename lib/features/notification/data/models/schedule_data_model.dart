import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/schedule_data.dart';

part 'schedule_data_model.g.dart';

@JsonSerializable()
class ScheduleDataModel extends Equatable {
  const ScheduleDataModel({
    required this.id,
    required this.triggerDate,
    required this.testCount,
  });

  final int id;
  final String triggerDate;
  final int testCount;

  factory ScheduleDataModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleDataModelToJson(this);

  factory ScheduleDataModel.fromMap(Map<String, dynamic> map) {
    return ScheduleDataModel(
      id: map['id'] as int,
      triggerDate: map['trigger_date'] as String,
      testCount: map['test_count'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trigger_date': triggerDate,
      'test_count': testCount,
    };
  }

  ScheduleData toEntity() {
    final parts = triggerDate.split('-');
    return ScheduleData(
      id: id,
      triggerDate: DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      ),
      testCount: testCount,
    );
  }

  factory ScheduleDataModel.fromEntity(ScheduleData entity) {
    return ScheduleDataModel(
      id: entity.id,
      triggerDate: _formatDate(entity.triggerDate),
      testCount: entity.testCount,
    );
  }

  static String _formatDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  List<Object?> get props => [id, triggerDate, testCount];
}
