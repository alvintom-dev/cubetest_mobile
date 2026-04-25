import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/site.dart';

part 'site_model.g.dart';

@JsonSerializable()
class SiteModel extends Equatable {
  const SiteModel({
    required this.id,
    required this.name,
    this.location,
    this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.isDeleted = false,
  });

  final String id;
  final String name;
  final String? location;
  final String? description;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final bool isDeleted;

  factory SiteModel.fromJson(Map<String, dynamic> json) => _$SiteModelFromJson(json);
  Map<String, dynamic> toJson() => _$SiteModelToJson(this);

  factory SiteModel.fromMap(Map<String, dynamic> map) {
    return SiteModel(
      id: map['id'] as String,
      name: map['name'] as String,
      location: map['location'] as String?,
      description: map['description'] as String?,
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
      'name': name,
      'location': location,
      'description': description,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'is_deleted': isDeleted ? 1 : 0,
    };
  }

  Site toEntity() {
    return Site(
      id: id,
      name: name,
      location: location,
      description: description,
      status: _statusFromString(status),
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      deletedAt: deletedAt == null ? null : DateTime.parse(deletedAt!),
      isDeleted: isDeleted,
    );
  }

  factory SiteModel.fromEntity(Site site) {
    return SiteModel(
      id: site.id,
      name: site.name,
      location: site.location,
      description: site.description,
      status: _statusToString(site.status),
      createdAt: site.createdAt.toIso8601String(),
      updatedAt: site.updatedAt.toIso8601String(),
      deletedAt: site.deletedAt?.toIso8601String(),
      isDeleted: site.isDeleted,
    );
  }

  static SiteStatus _statusFromString(String value) {
    return SiteStatus.values.firstWhere(
      (s) => s.name == value,
      orElse: () => SiteStatus.open,
    );
  }

  static String _statusToString(SiteStatus status) => status.name;

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
      ];
}
