import 'package:injectable/injectable.dart';

import 'clock.dart';

@LazySingleton(as: Clock)
class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}
