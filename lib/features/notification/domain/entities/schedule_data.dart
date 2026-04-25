import 'package:equatable/equatable.dart';

class ScheduleData extends Equatable {
  const ScheduleData({
    required this.id,
    required this.triggerDate,
    required this.testCount,
  });

  final int id;
  final DateTime triggerDate;
  final int testCount;

  @override
  List<Object?> get props => [id, triggerDate, testCount];
}
