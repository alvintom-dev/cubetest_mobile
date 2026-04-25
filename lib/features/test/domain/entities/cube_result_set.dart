import 'package:equatable/equatable.dart';

class CubeResultSet extends Equatable {
  const CubeResultSet({
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
  final DateTime createdAt;
  final DateTime updatedAt;

  double get averageStrength => (strength1 + strength2 + strength3) / 3;

  CubeResultSet copyWith({
    String? id,
    String? testId,
    double? load1,
    double? load2,
    double? load3,
    double? strength1,
    double? strength2,
    double? strength3,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CubeResultSet(
      id: id ?? this.id,
      testId: testId ?? this.testId,
      load1: load1 ?? this.load1,
      load2: load2 ?? this.load2,
      load3: load3 ?? this.load3,
      strength1: strength1 ?? this.strength1,
      strength2: strength2 ?? this.strength2,
      strength3: strength3 ?? this.strength3,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
