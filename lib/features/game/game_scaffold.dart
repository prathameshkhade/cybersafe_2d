import 'package:flutter/material.dart';
import '../../../../core/models/mission.dart';
import '../../../../core/models/user_session.dart';
import '../../../../core/theme/age_tier_theme.dart';

class GameScaffold extends StatefulWidget {
  final Mission mission;
  final AgeTier ageTier;
  final Widget child;
  final int score;
  final int totalQuestions;
  final int answeredQuestions;
  final int? timeLeft;
  final VoidCallback? onPause;

  const GameScaffold({
    super.key,
    required this.mission,
    required this.ageTier,
    required this.child,
    required this.score,
    required this.totalQuestions,
    required this.answeredQuestions,
    this.timeLeft,
    this.onPause,
  });

  @override
  State<GameScaffold> createState() => _GameScaffoldState();
}

class _GameScaffoldState extends State<GameScaffold> {
  @override
  Widget build(BuildContext context) {
    final theme = AgeTierTheme.forTier(widget.ageTier);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [theme.backgroundColor, theme.cardColor],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHUD(theme),
              Expanded(child: widget.child),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHUD(AgeTierTheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: 0.8),
        border: Border(
          bottom: BorderSide(color: theme.primaryColor.withValues(alpha: 0.2)),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.primaryColor.withValues(alpha: 0.1),
              ),
              child:
                  Icon(Icons.close, color: theme.primaryColor, size: 18),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.mission.title,
                  style: TextStyle(
                    color: theme.textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: widget.totalQuestions > 0
                      ? widget.answeredQuestions / widget.totalQuestions
                      : 0,
                  backgroundColor: theme.primaryColor.withValues(alpha: 0.15),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(theme.primaryColor),
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 5,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (widget.timeLeft != null)
            _buildTimer(widget.timeLeft!, theme),
          const SizedBox(width: 10),
          _buildScoreBadge(theme),
        ],
      ),
    );
  }

  Widget _buildTimer(int seconds, AgeTierTheme theme) {
    final isUrgent = seconds <= 10;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isUrgent
            ? const Color(0xFFFF4444).withValues(alpha: 0.15)
            : theme.primaryColor.withValues(alpha: 0.10),
        border: Border.all(
          color: isUrgent
              ? const Color(0xFFFF4444)
              : theme.primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.timer_outlined,
            color: isUrgent ? const Color(0xFFFF4444) : theme.primaryColor,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            '${seconds}s',
            style: TextStyle(
              color: isUrgent ? const Color(0xFFFF4444) : theme.primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBadge(AgeTierTheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [theme.primaryColor, theme.secondaryColor],
        ),
      ),
      child: Text(
        '${widget.score} pts',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}
