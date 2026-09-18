import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  // =========================
  // BACKEND DATE PARSE
  //
  // Example:
  // 2026-09-10 10:00:00
  // =========================

  static DateTime? parseApiDate(
    dynamic value,
  ) {
    if (value == null) {
      return null;
    }

    final text = value
        .toString()
        .trim()
        .replaceFirst(' ', 'T');

    return DateTime.tryParse(text);
  }

  // =========================
  // API DATE
  //
  // 2026-09-10
  // =========================

  static String apiDate(
    DateTime date,
  ) {
    return DateFormat(
      'yyyy-MM-dd',
    ).format(date);
  }

  // =========================
  // API DATE TIME
  //
  // 2026-09-10 10:00:00
  // =========================

  static String apiDateTime(
    DateTime date,
  ) {
    return DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(date);
  }

  // =========================
  // DISPLAY DATE
  //
  // 10 Sep, 2026
  // =========================

  static String date(
    DateTime? date,
  ) {
    if (date == null) {
      return '--';
    }

    return DateFormat(
      'dd MMM, yyyy',
    ).format(date);
  }

  // =========================
  // SHORT DATE
  //
  // 10 Sep
  // =========================

  static String shortDate(
    DateTime? date,
  ) {
    if (date == null) {
      return '--';
    }

    return DateFormat(
      'dd MMM',
    ).format(date);
  }

  // =========================
  // DAY + DATE
  //
  // Thu, 10 Sep
  // =========================

  static String dayDate(
    DateTime? date,
  ) {
    if (date == null) {
      return '--';
    }

    return DateFormat(
      'EEE, dd MMM',
    ).format(date);
  }

  // =========================
  // TIME 12 HOUR
  //
  // 10:00 AM
  // =========================

  static String time(
    DateTime? date,
  ) {
    if (date == null) {
      return '--:--';
    }

    return DateFormat(
      'hh:mm a',
    ).format(date);
  }

  // =========================
  // TIME 24 HOUR
  //
  // 10:00
  // =========================

  static String time24(
    DateTime? date,
  ) {
    if (date == null) {
      return '--:--';
    }

    return DateFormat(
      'HH:mm',
    ).format(date);
  }

  // =========================
  // FULL DATE TIME
  //
  // 10 Sep, 2026 â€¢ 10:00 AM
  // =========================

  static String dateTime(
    DateTime? date,
  ) {
    if (date == null) {
      return '--';
    }

    return DateFormat(
      'dd MMM, yyyy â€¢ hh:mm a',
    ).format(date);
  }

  // =========================
  // DURATION BETWEEN
  // =========================

  static int durationMinutes(
    DateTime? start,
    DateTime? end,
  ) {
    if (start == null || end == null) {
      return 0;
    }

    final difference =
        end.difference(start);

    return difference.inMinutes;
  }

  // =========================
  // 135 => 2h 15m
  // =========================

  static String duration(
    int? minutes,
  ) {
    if (minutes == null ||
        minutes <= 0) {
      return '--';
    }

    final hours = minutes ~/ 60;

    final remaining =
        minutes % 60;

    if (hours == 0) {
      return '${remaining}m';
    }

    if (remaining == 0) {
      return '${hours}h';
    }

    return '${hours}h ${remaining}m';
  }

  // =========================
  // TODAY CHECK
  // =========================

  static bool isToday(
    DateTime date,
  ) {
    final now = DateTime.now();

    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // =========================
  // PAST DATE CHECK
  // =========================

  static bool isPast(
    DateTime date,
  ) {
    final today = DateTime.now();

    final currentDate = DateTime(
      today.year,
      today.month,
      today.day,
    );

    final selected = DateTime(
      date.year,
      date.month,
      date.day,
    );

    return selected.isBefore(
      currentDate,
    );
  }
}

