/// Pure derivations over a user's session history (streaks, averages,
/// trends). Kept as functions so they're trivially testable and impose no
/// state of their own — screens call them on the sessions stream's value.
library;

import 'session.dart';

/// Consecutive days with at least one session, anchored on today — or on
/// yesterday, so a streak survives until the current day ends without
/// practice. 0 means no active streak (broken, or no sessions yet).
int computeStreak(List<Session> sessions, {DateTime? clock}) {
  if (sessions.isEmpty) return 0;
  final now = clock ?? DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final practiceDays = {
    for (final session in sessions)
      DateTime(
        session.timestamp.year,
        session.timestamp.month,
        session.timestamp.day,
      ),
  };

  var anchor = today;
  if (!practiceDays.contains(anchor)) {
    anchor = today.subtract(const Duration(days: 1));
    if (!practiceDays.contains(anchor)) return 0;
  }

  var streak = 0;
  while (practiceDays.contains(anchor)) {
    streak++;
    anchor = anchor.subtract(const Duration(days: 1));
  }
  return streak;
}

/// Whether any session happened today (drives streak-bar copy).
bool practicedToday(List<Session> sessions, {DateTime? clock}) {
  final now = clock ?? DateTime.now();
  return sessions.any(
    (session) =>
        session.timestamp.year == now.year &&
        session.timestamp.month == now.month &&
        session.timestamp.day == now.day,
  );
}

/// Mean of all overall scores; 0 when there are no sessions.
double averageOverallScore(List<Session> sessions) {
  if (sessions.isEmpty) return 0;
  final total = sessions.fold<double>(0, (sum, s) => sum + s.overallScore);
  return total / sessions.length;
}

/// Mean of [category] across [sessions] (missing entries count as 0, which
/// only happens for malformed documents); 0 when there are no sessions.
double averageCategoryScore(List<Session> sessions, ScoreCategory category) {
  if (sessions.isEmpty) return 0;
  final total = sessions.fold<double>(
    0,
    (sum, s) => sum + (s.categoryScores[category.key] ?? 0),
  );
  return total / sessions.length;
}

/// Trend points for a category: average over the [recentCount] most recent
/// sessions minus the all-time average. Positive = improving. [sessions]
/// must be ordered newest-first (as the repository streams them).
double categoryTrend(
  List<Session> sessions,
  ScoreCategory category, {
  int recentCount = 3,
}) {
  if (sessions.isEmpty) return 0;
  final recent = sessions.take(recentCount).toList();
  return averageCategoryScore(recent, category) -
      averageCategoryScore(sessions, category);
}
