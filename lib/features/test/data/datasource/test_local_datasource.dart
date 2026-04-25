import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import '../models/cube_result_set_model.dart';
import '../models/test_model.dart';

@injectable
class TestLocalDatasource {
  const TestLocalDatasource(this._db);

  final Database _db;

  static const String testsTable = 'tests';
  static const String resultsTable = 'cube_result_sets';

  static Future<void> createTables(Database db) async {
    await db.execute('''
      CREATE TABLE $testsTable (
        id TEXT PRIMARY KEY,
        test_set_id TEXT NOT NULL,
        type TEXT NOT NULL,
        due_date TEXT NOT NULL,
        status TEXT NOT NULL,
        remark TEXT,
        completed_at TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        UNIQUE(test_set_id, type)
      )
    ''');
    await db.execute(
        'CREATE INDEX idx_tests_test_set ON $testsTable(test_set_id)');

    await db.execute('''
      CREATE TABLE $resultsTable (
        id TEXT PRIMARY KEY,
        test_id TEXT NOT NULL,
        load1 REAL,
        load2 REAL,
        load3 REAL,
        strength1 REAL NOT NULL,
        strength2 REAL NOT NULL,
        strength3 REAL NOT NULL,
        notes TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    await db.execute(
        'CREATE INDEX idx_cube_result_sets_test ON $resultsTable(test_id)');
  }

  static Future<void> upgradeToV3(Database db) async {
    await db.execute('DROP TABLE IF EXISTS test_results');
    await db.execute('''
      CREATE TABLE $resultsTable (
        id TEXT PRIMARY KEY,
        test_id TEXT NOT NULL,
        load1 REAL,
        load2 REAL,
        load3 REAL,
        strength1 REAL NOT NULL,
        strength2 REAL NOT NULL,
        strength3 REAL NOT NULL,
        notes TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    await db.execute(
        'CREATE INDEX idx_cube_result_sets_test ON $resultsTable(test_id)');
  }

  Future<TestModel> createTest(TestModel model) async {
    await _db.insert(testsTable, model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort);
    return model;
  }

  Future<List<String>> getDueDatesFromDate(String isoDate) async {
    final rows = await _db.query(
      testsTable,
      columns: ['due_date'],
      where: 'due_date >= ?',
      whereArgs: [isoDate],
    );
    return rows.map((row) => row['due_date'] as String).toList();
  }

  Future<List<TestModel>> getTests(String testSetId) async {
    final rows = await _db.query(
      testsTable,
      where: 'test_set_id = ?',
      whereArgs: [testSetId],
      orderBy: 'due_date ASC',
    );
    return rows.map(TestModel.fromMap).toList();
  }

  Future<TestModel?> getTestById(String id) async {
    final rows = await _db.query(
      testsTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return TestModel.fromMap(rows.first);
  }

  Future<TestModel?> findByTestSetAndType({
    required String testSetId,
    required String type,
  }) async {
    final rows = await _db.query(
      testsTable,
      where: 'test_set_id = ? AND type = ?',
      whereArgs: [testSetId, type],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return TestModel.fromMap(rows.first);
  }

  Future<TestModel> updateTest(TestModel model) async {
    final affected = await _db.update(
      testsTable,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
    if (affected == 0) {
      throw Exception('Test not found for update: ${model.id}');
    }
    return model;
  }

  Future<void> deleteTest(String id) async {
    await _db.transaction((txn) async {
      await txn.delete(
        resultsTable,
        where: 'test_id = ?',
        whereArgs: [id],
      );
      final affected = await txn.delete(
        testsTable,
        where: 'id = ?',
        whereArgs: [id],
      );
      if (affected == 0) {
        throw Exception('Test not found for delete: $id');
      }
    });
  }

  Future<void> deleteTestsByTestSet(String testSetId) async {
    await _db.transaction((txn) async {
      final tests = await txn.query(
        testsTable,
        columns: ['id'],
        where: 'test_set_id = ?',
        whereArgs: [testSetId],
      );
      final testIds = tests.map((row) => row['id'] as String).toList();
      if (testIds.isNotEmpty) {
        final placeholders = List.filled(testIds.length, '?').join(',');
        await txn.delete(
          resultsTable,
          where: 'test_id IN ($placeholders)',
          whereArgs: testIds,
        );
      }
      await txn.delete(
        testsTable,
        where: 'test_set_id = ?',
        whereArgs: [testSetId],
      );
    });
  }

  Future<List<CubeResultSetModel>> getResults(String testId) async {
    final rows = await _db.query(
      resultsTable,
      where: 'test_id = ?',
      whereArgs: [testId],
      orderBy: 'created_at ASC',
    );
    return rows.map(CubeResultSetModel.fromMap).toList();
  }

  Future<CubeResultSetModel?> getResultById(String id) async {
    final rows = await _db.query(
      resultsTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return CubeResultSetModel.fromMap(rows.first);
  }

  Future<CubeResultSetModel> createResult(CubeResultSetModel model) async {
    await _db.insert(resultsTable, model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort);
    return model;
  }

  Future<CubeResultSetModel> updateResult(CubeResultSetModel model) async {
    final affected = await _db.update(
      resultsTable,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
    if (affected == 0) {
      throw Exception('Cube result set not found for update: ${model.id}');
    }
    return model;
  }

  Future<void> deleteResult(String id) async {
    final affected = await _db.delete(
      resultsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (affected == 0) {
      throw Exception('Cube result set not found for delete: $id');
    }
  }
}
