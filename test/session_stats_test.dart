// Pure-function coverage for streaks, averages, trends, and timestamp
// display — the logic with date-boundary edge cases.
import 'package:flutter_test/flutter_test.dart';

import 'package:slicksale/core/formatters.dart';
import 'package:slicksale/features/stats/domain/session.dart';
import 'package:slicksale/features/stats/domain/session_stats.dart';

Session _session(DateTime timestamp, {double score = 80}) => Session(
      id: 'id-$timestamp',
      scenarioId: 'skeptical_cfo',
      scenarioName: 'The Skeptical CFO',
      timestamp: timestamp,
      overallScore: score,
      categoryScores: {
        for (final category in ScoreCategory.values) category.key: score,
      },
      feedbackSummary: 'Solid session.',
    );

void main() {
  final clock = DateTime(2026, 6, 12, 18, 30);

  group('computeStreak', () {
    test('is 0 with no sessions', () {
      expect(computeStreak(const [], clock: clock), 0);
    });

    test('anchors on today when practiced today', () {
      final sessions = [
        _session(DateTime(2026, 6, 12, 9)),
        _session(DateTime(2026, 6, 11, 20)),
        _session(DateTime(2026, 6, 10, 7)),
      ];
      expect(computeStreak(sessions, clock: clock), 3);
    });

    test('survives on yesterday until today ends', () {
      final sessions = [
        _session(DateTime(2026, 6, 11, 20)),
        _session(DateTime(2026, 6, 10, 7)),
      ];
      expect(computeStreak(sessions, clock: clock), 2);
      expect(practicedToday(sessions, clock: clock), isFalse);
    });

    test('breaks after a missed day', () {
      final sessions = [_session(DateTime(2026, 6, 10, 7))];
      expect(computeStreak(sessions, clock: clock), 0);
    });

    test('counts multiple sessions on one day once', () {
      final sessions = [
        _session(DateTime(2026, 6, 12, 9)),
        _session(DateTime(2026, 6, 12, 14)),
      ];
      expect(computeStreak(sessions, clock: clock), 1);
    });
  });

  group('averages and trends', () {
    test('averageOverallScore means all sessions', () {
      final sessions = [
        _session(DateTime(2026, 6, 12), score: 90),
        _session(DateTime(2026, 6, 11), score: 70),
      ];
      expect(averageOverallScore(sessions), 80);
    });

    test('categoryTrend compares recent sessions to all-time', () {
      // Newest-first: three 90s then two 60s -> recent avg 90, overall 78.
      final sessions = [
        _session(DateTime(2026, 6, 12), score: 90),
        _session(DateTime(2026, 6, 11), score: 90),
        _session(DateTime(2026, 6, 10), score: 90),
        _session(DateTime(2026, 6, 9), score: 60),
        _session(DateTime(2026, 6, 8), score: 60),
      ];
      expect(
        categoryTrend(sessions, ScoreCategory.objectionHandling),
        closeTo(12, 0.001),
      );
    });

    test('single session trends flat', () {
      final sessions = [_session(DateTime(2026, 6, 12), score: 90)];
      expect(categoryTrend(sessions, ScoreCategory.activeListening), 0);
    });
  });

  group('formatSessionTimestamp', () {
    test('today renders as relative time', () {
      expect(
        formatSessionTimestamp(DateTime(2026, 6, 12, 18, 14), clock: clock),
        'Today, 6:14 PM',
      );
    });

    test('yesterday renders as relative time', () {
      expect(
        formatSessionTimestamp(DateTime(2026, 6, 11, 15, 22), clock: clock),
        'Yesterday, 3:22 PM',
      );
    });

    test('same year renders month + day + time', () {
      expect(
        formatSessionTimestamp(DateTime(2026, 6, 7, 9, 41), clock: clock),
        'Jun 7, 9:41 AM',
      );
    });

    test('older years render the date only', () {
      expect(
        formatSessionTimestamp(DateTime(2025, 6, 7, 9, 41), clock: clock),
        'Jun 7, 2025',
      );
    });

    test('midnight and noon use 12-hour names', () {
      expect(
        formatSessionTimestamp(DateTime(2026, 6, 12, 0, 5), clock: clock),
        'Today, 12:05 AM',
      );
      expect(
        formatSessionTimestamp(DateTime(2026, 6, 12, 12, 0), clock: clock),
        'Today, 12:00 PM',
      );
    });
  });
}
