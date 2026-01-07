import 'package:flutter/material.dart';

/// Utility class for time formatting
class TimeFormatter {
  TimeFormatter._();

  /// Formats a TimeOfDay to a readable string (e.g., "5:23 PM")
  static String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
