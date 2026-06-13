/// Date/time display formatting (session-recency directive: relative day
/// names for the last 24-48h, calendar dates beyond that). Hand-rolled to
/// keep `intl` out of the dependency tree for two formats.
library;

const List<String> _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// "Today, 6:14 PM" / "Yesterday, 3:22 PM" / "Jun 7, 9:41 AM" /
/// "Jun 7, 2025" (older than the current year).
String formatSessionTimestamp(DateTime timestamp, {DateTime? clock}) {
  final now = clock ?? DateTime.now();
  final day = DateTime(timestamp.year, timestamp.month, timestamp.day);
  final today = DateTime(now.year, now.month, now.day);
  final dayDiff = today.difference(day).inDays;

  if (dayDiff == 0) return 'Today, ${_time(timestamp)}';
  if (dayDiff == 1) return 'Yesterday, ${_time(timestamp)}';
  final month = _months[timestamp.month - 1];
  if (timestamp.year == now.year) {
    return '$month ${timestamp.day}, ${_time(timestamp)}';
  }
  return '$month ${timestamp.day}, ${timestamp.year}';
}

/// 12-hour clock, e.g. "6:14 PM".
String _time(DateTime timestamp) {
  final hour12 = switch (timestamp.hour % 12) {
    0 => 12,
    final h => h,
  };
  final minute = timestamp.minute.toString().padLeft(2, '0');
  final period = timestamp.hour < 12 ? 'AM' : 'PM';
  return '$hour12:$minute $period';
}
