import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/test.dart';

part 'test_model.g.dart';

@JsonSerializable()
class TestModel extends Equatable {
  const TestModel({
    required this.id,
    required this.testSetId,
    required this.type,
    required this.dueDate,
    required this.status,
    this.remark,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String testSetId;
  final String type;
  final String dueDate;
  final String status;
  final String? remark;
  final String? completedAt;
  final String createdAt;
  final String updatedAt;

  factory TestModel.fromJson(Map<String, dynamic> json) =>
      _$TestModelFromJson(json);
  Map<String, dynamic> toJson() => _$TestModelToJson(this);

  factory TestModel.fromMap(Map<String, dynamic> map) {
    return TestModel(
      id: map['id'] as String,
      testSetId: map['test_set_id'] as String,
      type: map['type'] as String,
      dueDate: map['due_date'] as String,
      status: map['status'] as String,
      remark: map['remark'] as String?,
      completedAt: map['completed_at'] as String?,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'test_set_id': testSetId,
      'type': type,
      'due_date': dueDate,
      'status': status,
      'remark': remark,
      'completed_at': completedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  Test toEntity() {
    return Test(
      id: id,
      testSetId: testSetId,
      type: _typeFromString(type),
      dueDate: DateTime.parse(dueDate),
      status: _statusFromString(status),
      remark: remark,
      completedAt: completedAt == null ? null : DateTime.parse(completedAt!),
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }

  factory TestModel.fromEntity(Test test) {
    return TestModel(
      id: test.id,
      testSetId: test.testSetId,
      type: test.type.name,
      dueDate: test.dueDate.toIso8601String(),
      status: test.status.name,
      remark: test.remark,
      completedAt: test.completedAt?.toIso8601String(),
      createdAt: test.createdAt.toIso8601String(),
      updatedAt: test.updatedAt.toIso8601String(),
    );
  }

  static TestType _typeFromString(String value) {
    return TestType.values.firstWhere(
      (t) => t.name == value,
      orElse: () => TestType.day7,
    );
  }

  static TestStatus _statusFromString(String value) {
    return TestStatus.values.firstWhere(
      (s) => s.name == value,
      orElse: () => TestStatus.pending,
    );
  }

  @override
  List<Object?> get props => [
        id,
        testSetId,
        type,
        dueDate,
        status,
        remark,
        completedAt,
        createdAt,
        updatedAt,
      ];
}
