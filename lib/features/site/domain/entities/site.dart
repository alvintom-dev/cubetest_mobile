import 'package:equatable/equatable.dart';

enum SiteStatus { open, close }

class Site extends Equatable {
  const Site({
    required this.id,
    required this.name,
    this.location,
    this.description,
    this.status = SiteStatus.open,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.isDeleted = false,
    this.testSets = 0,
  });

  final String id;
  final String name;
  final String? location;
  final String? description;
  final SiteStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final bool isDeleted;
  final int testSets;

  Site copyWith({
    String? id,
    String? name,
    String? location,
    String? description,
    SiteStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isDeleted,
    int? testSets,
  }) {
    return Site(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      testSets: testSets ?? this.testSets,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        location,
        description,
        status,
        createdAt,
        updatedAt,
        deletedAt,
        isDeleted,
        testSets,
      ];
}
