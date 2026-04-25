import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import '../models/test_set_model.dart';

@injectable
class TestSetLocalDatasource {
  const TestSetLocalDatasource(this._db);

  final Database _db;

  static const String tableName = 'test_sets';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        site_id TEXT NOT NULL,
        appoint_date TEXT NOT NULL,
        name TEXT,
        description TEXT,
        required_strength REAL NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT,
        is_deleted INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await db.execute(
        'CREATE INDEX idx_test_sets_site ON $tableName(site_id)');
  }

  Future<TestSetModel> create(TestSetModel model) async {
    await _db.insert(tableName, model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort);
    return model;
  }

  Future<List<TestSetModel>> getAll({String? siteId, bool? isDeleted}) async {
    final whereClauses = <String>[];
    final whereArgs = <Object>[];
    if (siteId != null) {
      whereClauses.add('site_id = ?');
      whereArgs.add(siteId);
    }
    if (isDeleted != null) {
      whereClauses.add('is_deleted = ?');
      whereArgs.add(isDeleted ? 1 : 0);
    }
    final rows = await _db.query(
      tableName,
      where: whereClauses.isEmpty ? null : whereClauses.join(' AND '),
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: 'appoint_date DESC',
    );
    return rows.map(TestSetModel.fromMap).toList();
  }

  Future<TestSetModel?> getById(String id) async {
    final rows = await _db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return TestSetModel.fromMap(rows.first);
  }

  Future<TestSetModel> update(TestSetModel model) async {
    final affected = await _db.update(
      tableName,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
    if (affected == 0) {
      throw Exception('Test set not found for update: ${model.id}');
    }
    return model;
  }

  Future<void> softDelete(String id, {required String deletedAtIso}) async {
    final affected = await _db.update(
      tableName,
      {'is_deleted': 1, 'deleted_at': deletedAtIso, 'updated_at': deletedAtIso},
      where: 'id = ?',
      whereArgs: [id],
    );
    if (affected == 0) {
      throw Exception('Test set not found for softDelete: $id');
    }
  }

  Future<void> hardDelete(String id) async {
    final affected = await _db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (affected == 0) {
      throw Exception('Test set not found for hardDelete: $id');
    }
  }

  Future<int> countBySiteId(String siteId) async {
    final rows = await _db.rawQuery(
      'SELECT COUNT(*) AS c FROM $tableName WHERE site_id = ? AND is_deleted = 0',
      [siteId],
    );
    return Sqflite.firstIntValue(rows) ?? 0;
  }
}
