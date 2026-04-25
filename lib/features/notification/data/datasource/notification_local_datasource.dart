import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import '../models/schedule_data_model.dart';

@injectable
class NotificationLocalDatasource {
  const NotificationLocalDatasource(this._db);

  final Database _db;

  static const String tableName = 'schedule_data';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY,
        trigger_date TEXT NOT NULL,
        test_count INTEGER NOT NULL
      )
    ''');
  }

  Future<List<ScheduleDataModel>> getAll() async {
    final rows = await _db.query(tableName);
    return rows.map(ScheduleDataModel.fromMap).toList();
  }

  Future<void> insert(ScheduleDataModel model) async {
    await _db.insert(
      tableName,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(ScheduleDataModel model) async {
    await _db.update(
      tableName,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> delete(int id) async {
    await _db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
