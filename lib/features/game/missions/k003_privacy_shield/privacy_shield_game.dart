import 'package:flutter/material.dart';
import '../../../../core/models/mission.dart';
import '../../../../core/models/user_session.dart';
import '../../../../core/theme/age_tier_theme.dart';
import '../../game_scaffold.dart';

class _InfoItem {
  final String label;
  final String emoji;
  final bool isPrivate;
  final String explanation;

  const _InfoItem({
    required this.label,
    required this.emoji,
    required this.isPrivate,
    required this.explanation,
  });
}

const List<_InfoItem> _infoItems = [
  _InfoItem(
    label: 'Home Address',
    emoji: '🏠',
    isPrivate: true,
    explanation: 'Never share your home address online — strangers could find you!',
  ),
  _InfoItem(
    label: 'Favourite Color',
    emoji: '🎨',
    isPrivate: false,
    explanation: 'Your favourite color is safe to share — it tells nothing personal!',
  ),
  _InfoItem(
    label: 'Phone Number',
    emoji: '📱',
    isPrivate: true,
    explanation: 'Your phone number is private — only share with trusted family!',
  ),
  _InfoItem(
    label: 'Favourite Game',
    emoji: '🎮',
    isPrivate: false,
    explanation: 'Sharing your favourite game is fine — it\'s not personal info!',
  ),
  _InfoItem(
    label: 'School Name',
    emoji: '🏫',
    isPrivate: true,
    explanation: 'Your school name can help strangers find where you are. Keep it private!',
  ),
  _InfoItem(
    label: 'Pet\'s Name',
    emoji: '🐶',
    isPrivate: false,
    explanation: 'Your pet\'s name is harmless to share with friends!',
  ),
  _InfoItem(
    label: 'Full Name',
    emoji: '📛',
    isPrivate: true,
    explanation: 'Your full name is personal — use a nickname online instead!',
  ),
  _InfoItem(
    label: 'Favourite Food',
    emoji: '🍕',
    isPrivate: false,
    explanation: 'Favourite food is totally safe — everyone loves pizza!',
  ),
  _InfoItem(
    label: 'Password',
    emoji: '🔑',
    isPrivate: true,
    explanation: 'NEVER share your password — not even with friends!',
  ),
  _InfoItem(
    label: 'Favourite Movie',
    emoji: '🎬',
    isPrivate: false,
    explanation: 'Your favourite movie is fun to share — no personal info here!',
  ),
];

class PrivacyShieldGame extends StatefulWidget {
  final Mission mission;
  final void Function(int score) onComplete;

  const PrivacyShieldGame({
    super.key,
    required this.mission,
    required this.onComplete,
  });

  @override
  State<PrivacyShieldGame> createState() => _PrivacyShieldGameState();
}

class _PrivacyShieldGameState extends State<PrivacyShieldGame>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _score = 0;
  int _correct = 0;
  String? _feedbackText;
  bool? _lastCorrect;
  bool _showFeedback = false;
  Offset _dragOffset = Offset.zero;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _shakeAnim = Tween(begin: 0.0, end: 10.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _answer(bool markedPrivate) {
    if (_showFeedback) return;
    final item = _infoItems[_currentIndex];
    final isCorrect = item.isPrivate == markedPrivate;
    setState(() {
      _lastCorrect = isCorrect;
      _feedbackText = isCorrect ? '✅ Correct! ${item.explanation}' : '❌ ${item.explanation}';
      _showFeedback = true;
      if (isCorrect) {
        _score += 10;
        _correct++;
      }
    });
    if (!isCorrect) _shakeController.forward(from: 0);
    Future.delayed(const Duration(milliseconds: 1800), _next);
  }

  void _next() {
    if (!mounted) return;
    setState(() {
      _showFeedback = false;
      _dragOffset = Offset.zero;
      if (_currentIndex < _infoItems.length - 1) {
        _currentIndex++;
      } else {
        final finalScore = (_correct / _infoItems.length * 100).round();
        widget.onComplete(finalScore);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AgeTierTheme.forTier(AgeTier.kids7_10);
    final item = _infoItems[_currentIndex];

    return GameScaffold(
      mission: widget.mission,
      ageTier: AgeTier.kids7_10,
      score: _score,
      totalQuestions: _infoItems.length,
      answeredQuestions: _currentIndex,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Text(
              '🛡️ Is this info PRIVATE or SAFE TO SHARE?',
              style: TextStyle(
                color: theme.textColor,
                fontWeight: FontWeight.w800,
                fontSize: 17,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '${_currentIndex + 1} of ${_infoItems.length}',
              style: TextStyle(color: theme.subtextColor, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GestureDetector(
                onHorizontalDragUpdate: (d) {
                  setState(() => _dragOffset += Offset(d.delta.dx, 0));
                },
                onHorizontalDragEnd: (d) {
                  if (_dragOffset.dx < -60) _answer(true);  // private
                  if (_dragOffset.dx > 60) _answer(false);  // safe to share
                  setState(() => _dragOffset = Offset.zero);
                },
                child: AnimatedBuilder(
                  animation: _shakeAnim,
                  builder: (_, child) => Transform.translate(
                    offset: Offset(
                          _shakeAnim.value * (_lastCorrect == false ? 1 : 0),
                          0,
                        ) +
                        _dragOffset,
                    child: child,
                  ),
                  child: _buildInfoCard(item, theme),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_showFeedback)
              AnimatedOpacity(
                opacity: _showFeedback ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: _lastCorrect == true
                        ? const Color(0xFF06D6A0).withValues(alpha: 0.15)
                        : const Color(0xFFFF4444).withValues(alpha: 0.15),
                    border: Border.all(
                      color: _lastCorrect == true
                          ? const Color(0xFF06D6A0)
                          : const Color(0xFFFF4444),
                    ),
                  ),
                  child: Text(
                    _feedbackText ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _lastCorrect == true
                          ? const Color(0xFF06D6A0)
                          : const Color(0xFFFF4444),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: '🔒 PRIVATE',
                    color: const Color(0xFFFF6B35),
                    onTap: () => _answer(true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    label: '✅ SAFE TO SHARE',
                    color: const Color(0xFF06D6A0),
                    onTap: () => _answer(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '👈 Swipe left = Private  •  Swipe right = Safe to Share',
              style: TextStyle(color: theme.subtextColor, fontSize: 11),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(_InfoItem item, AgeTierTheme theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: theme.cardColor,
        border: Border.all(
            color: theme.primaryColor.withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Shield icon at top
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.primaryColor.withValues(alpha: 0.12),
            ),
            child: Center(
              child: Text('🛡️', style: const TextStyle(fontSize: 36)),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Someone online asks for your...',
            style: TextStyle(
              color: theme.subtextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Info item display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: theme.backgroundColor.withValues(alpha: 0.6),
              border: Border.all(
                  color: theme.primaryColor.withValues(alpha: 0.15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.emoji, style: const TextStyle(fontSize: 36)),
                const SizedBox(width: 14),
                Text(
                  item.label,
                  style: TextStyle(
                    color: theme.textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Would you share this with a stranger?',
            style: TextStyle(
              color: theme.subtextColor,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: _showFeedback ? null : onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: color.withValues(alpha: 0.15),
          border: Border.all(color: color, width: 2),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}