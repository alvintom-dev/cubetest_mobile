import 'package:equatable/equatable.dart';

enum TestType { day7, day14, day28 }

enum TestStatus { pending, passed, failed, skipped }

extension TestTypeDays on TestType {
  int get days {
    switch (this) {
      case TestType.day7:
        return 7;
      case TestType.day14:
        return 14;
      case TestType.day28:
        return 28;
    }
  }
}

class Test extends Equatable {
  const Test({
    required this.id,
    required this.testSetId,
    required this.type,
    required this.dueDate,
    this.status = TestStatus.pending,
    this.remark,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String testSetId;
  final TestType type;
  final DateTime dueDate;
  final TestStatus status;
  final String? remark;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool isOverdue(DateTime now) =>
      status == TestStatus.pending && now.isAfter(dueDate);

  bool get isCompleted =>
      status == TestStatus.passed ||
      status == TestStatus.failed ||
      status == TestStatus.skipped;

  Test copyWith({
    String? id,
    String? testSetId,
    TestType? type,
    DateTime? dueDate,
    TestStatus? status,
    String? remark,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Test(
      id: id ?? this.id,
      testSetId: testSetId ?? this.testSetId,
      type: type ?? this.type,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      remark: remark ?? this.remark,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
