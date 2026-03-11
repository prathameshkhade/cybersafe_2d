import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/bloc/session_bloc.dart';
import '../../core/bloc/session_event.dart';
import '../../core/bloc/session_state.dart';
import '../../core/models/user_session.dart';
import '../../core/models/mission.dart';
import '../../core/theme/age_tier_theme.dart';
import '../home/home_page.dart';
import '../game/game_screen.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _resetSession() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0D1B2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('New Session?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'All progress will be erased. This is by design — CyberSafe 2D stores nothing!',
          style: TextStyle(color: Color(0xFF6A8FAF)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF6A8FAF))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4444),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<SessionBloc>().add(const ResetSessionEvent());
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            },
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _exitGame() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0D1B2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Exit Game?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'All session data will be permanently erased.',
          style: TextStyle(color: Color(0xFF6A8FAF)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF6A8FAF))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4444),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Exit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        if (state is! SessionActive) {
          return const HomePage();
        }
        final session = state.session;
        final theme = AgeTierTheme.forTier(session.ageTier!);
        final missions = MissionRepository.getMissionsForTier(session.ageTier!);

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.backgroundColor,
                  theme.backgroundColor,
                  theme.primaryColor.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    _buildTopBar(session, theme),
                    _buildWelcomeBanner(session, theme),
                    _buildProgressRing(session, theme),
                    const SizedBox(height: 24),
                    Expanded(
                      child: _buildMissionCards(
                          missions, session, theme, context),
                    ),
                    _buildBottomBar(theme),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(UserSession session, AgeTierTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Text(session.ageTier!.emoji,
                style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(
              session.ageTier!.label,
              style: TextStyle(
                color: theme.primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 13,
                letterSpacing: 1.5,
              ),
            ),
          ]),
          GestureDetector(
            onTap: _resetSession,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: theme.primaryColor.withValues(alpha: 0.4), width: 1),
                color: theme.primaryColor.withValues(alpha:0.08),
              ),
              child: Row(children: [
                Icon(Icons.refresh_rounded,
                    color: theme.primaryColor, size: 16),
                const SizedBox(width: 6),
                Text('New Session',
                    style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeBanner(UserSession session, AgeTierTheme theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            theme.primaryColor.withValues(alpha:0.15),
            theme.secondaryColor.withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(
            color: theme.primaryColor.withValues(alpha: 0.25), width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi @${session.username}! 👋',
                  style: TextStyle(
                    color: theme.textColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ready to become a Cyber Hero?',
                  style: TextStyle(color: theme.subtextColor, fontSize: 13),
                ),
              ],
            ),
          ),
          const Text('🦸', style: TextStyle(fontSize: 42)),
        ],
      ),
    );
  }

  Widget _buildProgressRing(UserSession session, AgeTierTheme theme) {
    final completedCount = session.completedMissions;
    final total = MissionRepository.getMissionsForTier(session.ageTier!).length;
    final progress = total > 0 ? completedCount / total : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Text(
            'SESSION PROGRESS',
            style: TextStyle(
              color: theme.subtextColor,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 110,
            height: 110,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 110,
                  height: 110,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 10,
                    backgroundColor: theme.cardColor,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(theme.primaryColor),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$completedCount/$total',
                      style: TextStyle(
                        color: theme.textColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      'done',
                      style:
                          TextStyle(color: theme.subtextColor, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCards(List<Mission> missions, UserSession session,
      AgeTierTheme theme, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'YOUR MISSIONS',
            style: TextStyle(
              color: theme.subtextColor,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView.separated(
              itemCount: missions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final mission = missions[index];
                final score = session.missionProgress[mission.id];
                final isCompleted = score != null;
                return _buildMissionCard(
                    mission, isCompleted, score, theme, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard(Mission mission, bool isCompleted, int? score,
      AgeTierTheme theme, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => GameScreen(mission: mission),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: theme.cardColor,
          border: Border.all(
            color: isCompleted
                ? theme.accentColor.withValues(alpha: 0.5)
                : theme.primaryColor.withValues(alpha: 0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isCompleted
                      ? [theme.accentColor, theme.accentColor.withValues(alpha: 0.6)]
                      : [theme.primaryColor, theme.secondaryColor],
                ),
              ),
              child: Center(
                child: Text(mission.emoji,
                    style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          mission.title,
                          style: TextStyle(
                            color: theme.textColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      if (isCompleted)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.accentColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$score pts',
                            style: TextStyle(
                              color: theme.accentColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mission.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: theme.subtextColor, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.gamepad_outlined,
                          color: theme.primaryColor, size: 13),
                      const SizedBox(width: 4),
                      Text(
                        mission.flameMechanic,
                        style: TextStyle(
                          color: theme.primaryColor.withValues(alpha: 0.8),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isCompleted
                  ? Icons.check_circle_rounded
                  : Icons.play_circle_rounded,
              color: isCompleted ? theme.accentColor : theme.primaryColor,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(AgeTierTheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
                color: theme.primaryColor.withValues(alpha: 0.1), width: 1)),
      ),
      child: GestureDetector(
        onTap: _exitGame,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.power_settings_new_rounded,
                color: theme.subtextColor, size: 18),
            const SizedBox(width: 8),
            Text(
              'Exit Game',
              style: TextStyle(
                color: theme.subtextColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
