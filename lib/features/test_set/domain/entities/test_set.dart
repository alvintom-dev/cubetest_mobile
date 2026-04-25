import 'package:equatable/equatable.dart';

enum TestSetStatus { notStarted, active, blocked, completed }

class TestSet extends Equatable {
  const TestSet({
    required this.id,
    required this.siteId,
    required this.appointDate,
    this.name,
    this.description,
    required this.requiredStrength,
    this.status = TestSetStatus.active,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.isDeleted = false,
  });

  final String id;
  final String siteId;
  final DateTime appointDate;
  final String? name;
  final String? description;
  final double requiredStrength;
  final TestSetStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final bool isDeleted;

  TestSet copyWith({
    String? id,
    String? siteId,
    DateTime? appointDate,
    String? name,
    String? description,
    double? requiredStrength,
    TestSetStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isDeleted,
  }) {
    return TestSet(
      id: id ?? this.id,
      siteId: siteId ?? this.siteId,
      appointDate: appointDate ?? this.appointDate,
      name: name ?? this.name,
      description: description ?? this.description,
      requiredStrength: requiredStrength ?? this.requiredStrength,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
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
