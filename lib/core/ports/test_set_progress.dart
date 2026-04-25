import 'package:equatable/equatable.dart';

class TestSetProgress extends Equatable {
  const TestSetProgress({required this.completed, required this.total});

  final int completed;
  final int total;

  static const empty = TestSetProgress(completed: 0, total: 0);

  String get display => '$completed/$total';

  @override
  List<Object?> get props => [completed, total];
}
