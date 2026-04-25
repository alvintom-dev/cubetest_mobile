import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  /// 13 Aug 2026
  static String toReadable(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Friday, 13 Aug 2026
  static String toFull(DateTime date) {
    return DateFormat('EEEE, dd MMM yyyy').format(date);
  }

  /// 13/08/2026
  static String toShort(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}

extension DateTimeX on DateTime {
  String toReadable() {
    return DateFormatter.toReadable(this);
  }

  String toFull() {
    return DateFormatter.toFull(this);
  }

  String toShort() {
    return DateFormatter.toShort(this);
  }
}