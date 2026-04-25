import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../notification/data/datasource/notification_local_datasource.dart';
import '../../../test/data/datasource/test_local_datasource.dart';
import '../../../test_set/data/datasource/test_set_local_datasource.dart';
import '../models/site_model.dart';

@injectable
class SiteLocalDatasource {
  const SiteLocalDatasource(this._db);

  final Database _db;

  static const String tableName = 'sites';
  static const String _dbFileName = 'cubetest.db';
  static const int _dbVersion = 4;

  static Future<Database> openDatabaseInstance() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, _dbFileName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            location TEXT,
            description TEXT,
            status TEXT NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            deleted_at TEXT,
            is_deleted INTEGER NOT NULL DEFAULT 0
          )
        ''');
        await TestSetLocalDatasource.createTable(db);
        await TestLocalDatasource.createTables(db);
        await NotificationLocalDatasource.createTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await TestLocalDatasource.createTables(db);
        } else if (oldVersion < 3) {
          await TestLocalDatasource.upgradeToV3(db);
        }
        if (oldVersion < 4) {
          await NotificationLocalDatasource.createTable(db);
        }
      },
    );
  }

  Future<SiteModel> create(SiteModel model) async {
    await _db.insert(tableName, model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort);
    return model;
  }

  Future<List<SiteModel>> getAll() async {
    final rows = await _db.query(
      tableName,
      where: 'is_deleted = ?',
      whereArgs: [0],
      orderBy: 'created_at DESC',
    );
    return rows.map(SiteModel.fromMap).toList();
  }

  Future<List<SiteModel>> getArchived() async {
    final rows = await _db.query(
      tableName,
      where: 'is_deleted = ?',
      whereArgs: [1],
      orderBy: 'deleted_at DESC',
    );
    return rows.map(SiteModel.fromMap).toList();
  }

  Future<SiteModel?> getById(String id) async {
    final rows = await _db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return SiteModel.fromMap(rows.first);
  }

  Future<SiteModel> update(SiteModel model) async {
    final affected = await _db.update(
      tableName,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
    if (affected == 0) {
      throw Exception('Site not found for update: ${model.id}');
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
      throw Exception('Site not found for softDelete: $id');
    }
  }

  Future<void> hardDelete(String id) async {
    final affected = await _db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (affected == 0) {
      throw Exception('Site not found for hardDelete: $id');
    }
  }
}
