import 'package:flutter/material.dart';

import '../../../../core/formatters.dart';
import '../../../../core/theme.dart';
import '../../../../core/widgets/interactive_card.dart';
import '../../domain/session.dart';

/// Mockup `.session-card`: scenario name + recency on the left, colored
/// overall score on the right. Shared by the home tab's Recent Sessions and
/// the stats tab's Session History; tapping opens the scorecard.
class SessionCard extends StatelessWidget {
  const SessionCard({super.key, required this.session, required this.onTap});

  final Session session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InteractiveCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.scenarioName,
                  style:
                      AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  formatSessionTimestamp(session.timestamp),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Text(
            '${session.overallScore.round()}',
            style: AppTextStyles.heading.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.scoreColor(session.overallScore),
            ),
          ),
        ],
      ),
    );
  }
}
