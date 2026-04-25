import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/test_set.dart';

part 'test_set_model.g.dart';

@JsonSerializable()
class TestSetModel extends Equatable {
  const TestSetModel({
    required this.id,
    required this.siteId,
    required this.appointDate,
    this.name,
    this.description,
    required this.requiredStrength,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.isDeleted = false,
  });

  final String id;
  final String siteId;
  final String appointDate;
  final String? name;
  final String? description;
  final double requiredStrength;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final bool isDeleted;

  factory TestSetModel.fromJson(Map<String, dynamic> json) =>
      _$TestSetModelFromJson(json);
  Map<String, dynamic> toJson() => _$TestSetModelToJson(this);

  factory TestSetModel.fromMap(Map<String, dynamic> map) {
    return TestSetModel(
      id: map['id'] as String,
      siteId: map['site_id'] as String,
      appointDate: map['appoint_date'] as String,
      name: map['name'] as String?,
      description: map['description'] as String?,
      requiredStrength: (map['required_strength'] as num).toDouble(),
      status: map['status'] as String,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
      deletedAt: map['deleted_at'] as String?,
      isDeleted: (map['is_deleted'] as int? ?? 0) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'site_id': siteId,
      'appoint_date': appointDate,
      'name': name,
      'description': description,
      'required_strength': requiredStrength,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'is_deleted': isDeleted ? 1 : 0,
    };
  }

  TestSet toEntity() {
    return TestSet(
      id: id,
      siteId: siteId,
      appointDate: DateTime.parse(appointDate),
      name: name,
      description: description,
      requiredStrength: requiredStrength,
      status: _statusFromString(status),
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      deletedAt: deletedAt == null ? null : DateTime.parse(deletedAt!),
      isDeleted: isDeleted,
    );
  }

  factory TestSetModel.fromEntity(TestSet testSet) {
    return TestSetModel(
      id: testSet.id,
      siteId: testSet.siteId,
      appointDate: testSet.appointDate.toIso8601String(),
      name: testSet.name,
      description: testSet.description,
      requiredStrength: testSet.requiredStrength,
      status: testSet.status.name,
      createdAt: testSet.createdAt.toIso8601String(),
      updatedAt: testSet.updatedAt.toIso8601String(),
      deletedAt: testSet.deletedAt?.toIso8601String(),
      isDeleted: testSet.isDeleted,
    );
  }

  static TestSetStatus _statusFromString(String value) {
    return TestSetStatus.values.firstWhere(
      (s) => s.name == value,
      orElse: () => TestSetStatus.active,
    );
  }

  @override
  List<Object?> get props => [
        id,
        siteId,
        appointDate,
        name,
        description,
        requiredStrength,
        status,
        createdAt,
        updatedAt,
        deletedAt,
        isDeleted,
      ];
}
