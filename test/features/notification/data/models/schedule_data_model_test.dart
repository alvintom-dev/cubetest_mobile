import 'package:cubetest_mobile/features/notification/data/models/schedule_data_model.dart';
import 'package:cubetest_mobile/features/notification/domain/entities/schedule_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScheduleDataModel', () {
    const model = ScheduleDataModel(
      id: 20260425,
      triggerDate: '2026-04-25',
      testCount: 3,
    );

    test('fromMap / toMap round-trip preserves all fields', () {
      final map = model.toMap();
      expect(map, {
        'id': 20260425,
        'trigger_date': '2026-04-25',
        'test_count': 3,
      });
      final parsed = ScheduleDataModel.fromMap(map);
      expect(parsed, model);
    });

    test('toEntity parses triggerDate to date-only DateTime', () {
      final entity = model.toEntity();
      expect(entity.id, 20260425);
      expect(entity.triggerDate, DateTime(2026, 4, 25));
      expect(entity.testCount, 3);
    });

    test('fromEntity formats triggerDate as YYYY-MM-DD', () {
      final entity = ScheduleData(
        id: 20260101,
        triggerDate: DateTime(2026, 1, 1),
        testCount: 1,
      );
      final result = ScheduleDataModel.fromEntity(entity);
      expect(result.id, 20260101);
      expect(result.triggerDate, '2026-01-01');
      expect(result.testCount, 1);
    });

    test('fromEntity pads single-digit month and day with zero', () {
      final entity = ScheduleData(
        id: 20260205,
        triggerDate: DateTime(2026, 2, 5),
        testCount: 2,
      );
      expect(ScheduleDataModel.fromEntity(entity).triggerDate, '2026-02-05');
    });
  });
}
