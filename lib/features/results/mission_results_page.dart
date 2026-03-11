import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/bloc/session_bloc.dart';
import '../../core/bloc/session_state.dart';
import '../../core/models/mission.dart';
import '../../core/models/user_session.dart';
import '../../core/theme/age_tier_theme.dart';
import '../dashboard/dashboard_page.dart';
import '../game/game_screen.dart';

class MissionResultsPage extends StatefulWidget {
  final Mission mission;
  final int score;

  const MissionResultsPage({
    super.key,
    required this.mission,
    required this.score,
  });

  @override
  State<MissionResultsPage> createState() => _MissionResultsPageState();
}

class _MissionResultsPageState extends State<MissionResultsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnim = CurvedAnimation(
        parent: _animController, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(
        parent: _animController, curve: Curves.easeOutCubic);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String _getGrade() {
    if (widget.score >= 90) return 'S';
    if (widget.score >= 75) return 'A';
    if (widget.score >= 60) return 'B';
    if (widget.score >= 40) return 'C';
    return 'D';
  }

  String _getTitle(AgeTier tier) {
    final score = widget.score;
    if (tier == AgeTier.kids7_10) {
      if (score >= 80) return "You're a Super Cyber Hero! 🦸";
      if (score >= 60) return "Good job, Hero in Training! 🌟";
      return "Keep practicing, Hero! 💪";
    } else if (tier == AgeTier.tweens11_14) {
      if (score >= 80) return "DM Detective Certified! 🕵️";
      if (score >= 60) return "Getting sharper every day! ⚡";
      return "The hackers almost got you! 📱";
    } else {
      if (score >= 80) return "Elite Cyber Analyst! 🔐";
      if (score >= 60) return "Solid security instincts! 🧠";
      return "Study those attack vectors! 💻";
    }
  }

  String _getExplanation(AgeTier tier) {
    final missionId = widget.mission.id;
    switch (missionId) {
      case 'k001':
        return tier == AgeTier.kids7_10
            ? '🛡️ Remember: Never talk to strangers online without telling a grown-up. Messages asking for your address, phone, or to meet up are always DANGER signals!'
            : 'Key lesson: Strangers online can pretend to be anyone. Always verify identity through trusted channels.';
      case 'k002':
        return '🏰 Great passwords use uppercase letters, numbers, and special symbols. Never use simple words or your name. A strong password is your digital fortress!';
      case 't001':
        return '📱 Phishing DMs create false urgency and use fake domains. Real companies never ask for passwords via DM. When in doubt — Block and Report!';
      case 't002':
        return '🎭 Catfishers use stolen photos, new accounts, and emotional manipulation. Always verify through video call or mutual friends before trusting someone online.';
      case 'n001':
        return '🧠 Social engineering exploits trust, urgency, and authority. The three rules: (1) Verify caller identity independently, (2) Never share passwords, (3) When pressured — slow down and think.';
      case 'n002':
        return '🔍 URL inspection checklist: (1) Check for HTTPS, (2) Verify the exact domain name character by character, (3) Watch for typosquatting (paypa1 vs paypal), (4) Subdomain tricks (amazon.com.evil.ru), (5) Suspicious TLDs (.tk, .xyz, .ru for banking).';
      default:
        return 'Stay safe online! Always think before you click.';
    }
  }

  Color _getScoreColor() {
    if (widget.score >= 80) return const Color(0xFF00D4FF);
    if (widget.score >= 60) return const Color(0xFF43E97B);
    if (widget.score >= 40) return const Color(0xFFFFD166);
    return const Color(0xFFFF4444);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        final ageTier = state is SessionActive
            ? state.session.ageTier ?? AgeTier.teens15_18
            : AgeTier.teens15_18;
        final theme = AgeTierTheme.forTier(ageTier);

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
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      ScaleTransition(
                        scale: _scaleAnim,
                        child: _buildScoreCircle(theme),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _getTitle(ageTier),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.mission.title,
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 28),
                      _buildLearningCard(ageTier, theme),
                      const SizedBox(height: 24),
                      _buildStatsRow(theme),
                      const SizedBox(height: 32),
                      _buildActionButtons(context, theme),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildScoreCircle(AgeTierTheme theme) {
    final scoreColor = _getScoreColor();
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 160,
          height: 160,
          child: CircularProgressIndicator(
            value: widget.score / 100,
            strokeWidth: 14,
            backgroundColor: theme.cardColor,
            valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
            strokeCap: StrokeCap.round,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${widget.score}',
              style: TextStyle(
                color: scoreColor,
                fontSize: 44,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'Grade ${_getGrade()}',
              style: TextStyle(
                color: theme.subtextColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        // Confetti-like decorative ring
        if (widget.score >= 80)
          ...List.generate(8, (i) {
            final angle = i * 45.0 * 3.14159 / 180;
            return Transform(
              transform: Matrix4.translationValues(
                80 * (i % 2 == 0 ? 0.7 : 0.85) *
                    (angle < 1.57 || angle > 4.71 ? 1 : -1) *
                    (i < 4 ? 0.9 : -0.9),
                80 * (i % 2 == 0 ? 0.85 : 0.7) *
                    (i < 2 || i > 5 ? -1 : 1),
                0,
              ),
              child: Text(['🌟', '✨', '⭐', '💫'][i % 4],
                  style: const TextStyle(fontSize: 14)),
            );
          }),
      ],
    );
  }

  Widget _buildLearningCard(AgeTier ageTier, AgeTierTheme theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: theme.cardColor,
        border: Border.all(
            color: theme.primaryColor.withValues(alpha: 0.25), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(widget.mission.emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Text(
              'What You Learned',
              style: TextStyle(
                color: theme.primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ]),
          const SizedBox(height: 14),
          Text(
            _getExplanation(ageTier),
            style: TextStyle(
              color: theme.textColor,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(AgeTierTheme theme) {
    return Row(
      children: [
        _statCard('Mission', widget.mission.emoji, theme),
        const SizedBox(width: 12),
        _statCard('Mechanic', '🎮', theme,
            subtitle: widget.mission.flameMechanic),
        const SizedBox(width: 12),
        _statCard('Goal', '🎯', theme, subtitle: widget.mission.learningGoal),
      ],
    );
  }

  Widget _statCard(String title, String emoji, AgeTierTheme theme,
      {String? subtitle}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: theme.cardColor,
          border: Border.all(
              color: theme.primaryColor.withValues(alpha: 0.15), width: 1),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                  color: theme.subtextColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: TextStyle(color: theme.textColor, fontSize: 9),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, AgeTierTheme theme) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DashboardPage()),
          ),
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [theme.primaryColor, theme.secondaryColor],
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withValues(alpha: 0.35),
                  blurRadius: 16,
                  spreadRadius: 1,
                )
              ],
            ),
            child: const Center(
              child: Text(
                '🏠  Back to Mission Hub',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => GameScreen(mission: widget.mission),
            ),
          ),
          child: Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: theme.primaryColor.withValues(alpha: 0.4), width: 1.5),
              color: theme.primaryColor.withValues(alpha: 0.08),
            ),
            child: Center(
              child: Text(
                '🔄  Try Again',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
