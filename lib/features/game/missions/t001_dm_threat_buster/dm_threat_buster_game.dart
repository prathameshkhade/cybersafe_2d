import 'package:flutter/material.dart';
import '../../../../core/models/mission.dart';
import '../../../../core/models/user_session.dart';
import '../../../../core/theme/age_tier_theme.dart';
import '../../game_scaffold.dart';

class _DmCard {
  final String username;
  final String handle;
  final String message;
  final bool isThreat;
  final String explanation;
  final String avatar;

  const _DmCard({
    required this.username,
    required this.handle,
    required this.message,
    required this.isThreat,
    required this.explanation,
    required this.avatar,
  });
}

const List<_DmCard> _dmCards = [
  _DmCard(
    username: 'Gr@b_Prizes',
    handle: '@gr4b_pr1zes',
    message:
        'You won a FREE iPhone 15!! Click bit.ly/claim-now to claim your prize 🎉',
    isThreat: true,
    explanation:
        'Classic phishing! Fake prize links steal your login credentials.',
    avatar: '💰',
  ),
  _DmCard(
    username: 'Sophia Martinez',
    handle: '@sophiam_real',
    message: 'Hey! Are you going to Lily\'s party this Saturday? 🎂',
    isThreat: false,
    explanation: 'Safe — a normal message from a classmate about a party.',
    avatar: '😊',
  ),
  _DmCard(
    username: 'Insta_Support',
    handle: '@inst4gram_help',
    message:
        'Your account will be deleted in 24h! Verify now at instagram-verify.xyz',
    isThreat: true,
    explanation:
        'Fake account warning! Real Instagram never DMs you with sketchy domains.',
    avatar: '⚠️',
  ),
  _DmCard(
    username: 'Jake Wilson',
    handle: '@jakewilson',
    message: 'Did you finish the math homework? I\'m stuck on question 5 😅',
    isThreat: false,
    explanation: 'Safe — a classmate asking about homework.',
    avatar: '📚',
  ),
  _DmCard(
    username: 'Secret.Admirer',
    handle: '@xo_secret2024',
    message:
        'I know where you live. Send me \$50 in gift cards or I will post your pictures.',
    isThreat: true,
    explanation:
        'This is SEXTORTION! Block, screenshot, and tell a trusted adult IMMEDIATELY.',
    avatar: '🚨',
  ),
  _DmCard(
    username: 'FashionQueen',
    handle: '@fashionqueen_merch',
    message:
        'DM me your credit card number for 80% off! Limited time offer 👗',
    isThreat: true,
    explanation:
        'Never share payment info in DMs! Real stores use secure checkout pages.',
    avatar: '💳',
  ),
  _DmCard(
    username: 'Mrs. Thompson',
    handle: '@mrst_history',
    message: 'Reminder: project due Monday! Great work everyone 📝',
    isThreat: false,
    explanation: 'Safe — a reminder from your teacher.',
    avatar: '👩‍🏫',
  ),
  _DmCard(
    username: 'GameBro2024',
    handle: '@gamebro_offical',
    message:
        'Get free Robux! Just send me your Roblox username AND password right now!',
    isThreat: true,
    explanation:
        'SCAM! No one legitimate ever needs your password. Free Robux offers are always fake.',
    avatar: '🎮',
  ),
];

class DmThreatBusterGame extends StatefulWidget {
  final Mission mission;
  final void Function(int score) onComplete;

  const DmThreatBusterGame({
    super.key,
    required this.mission,
    required this.onComplete,
  });

  @override
  State<DmThreatBusterGame> createState() => _DmThreatBusterGameState();
}

class _DmThreatBusterGameState extends State<DmThreatBusterGame>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _score = 0;
  int _correct = 0;
  bool _showFeedback = false;
  bool? _lastCorrect;
  String? _feedbackText;
  double _dragX = 0;
  late AnimationController _cardAnim;

  @override
  void initState() {
    super.initState();
    _cardAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _cardAnim.dispose();
    super.dispose();
  }

  void _answer(bool isBlocking) {
    if (_showFeedback) return;
    final card = _dmCards[_currentIndex];
    final correct = card.isThreat == isBlocking;
    setState(() {
      _lastCorrect = correct;
      _feedbackText = correct ? '✅ Correct!' : '❌ ${card.explanation}';
      _showFeedback = true;
      if (correct) {
        _score += 12;
        _correct++;
      }
    });
    Future.delayed(const Duration(milliseconds: 1800), _next);
  }

  void _next() {
    if (!mounted) return;
    setState(() {
      _showFeedback = false;
      _dragX = 0;
      if (_currentIndex < _dmCards.length - 1) {
        _currentIndex++;
      } else {
        final finalScore = (_correct / _dmCards.length * 100).round();
        widget.onComplete(finalScore);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AgeTierTheme.forTier(AgeTier.tweens11_14);
    final card = _dmCards[_currentIndex];

    final swipeProgress = (_dragX / 150).clamp(-1.0, 1.0);
    final isSwipingBlock = swipeProgress < -0.2;
    final isSwipingReply = swipeProgress > 0.2;

    return GameScaffold(
      mission: widget.mission,
      ageTier: AgeTier.tweens11_14,
      score: _score,
      totalQuestions: _dmCards.length,
      answeredQuestions: _currentIndex,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '📱 Block or Reply?',
              style: TextStyle(
                color: theme.textColor,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onHorizontalDragUpdate: (d) {
                  if (_showFeedback) return;
                  setState(() => _dragX += d.delta.dx);
                },
                onHorizontalDragEnd: (_) {
                  if (_showFeedback) return;
                  if (_dragX < -80) {
                    _answer(true); // block
                  } else if (_dragX > 80) {
                    _answer(false);
                  } // reply
                  else {
                    setState(() => _dragX = 0);
                  }
                },
                child: Transform.translate(
                  offset: Offset(_dragX, 0),
                  child: Transform.rotate(
                    angle: (_dragX / 20) * 0.05,
                    child: Stack(
                      children: [
                        _buildCard(card, theme),
                        if (isSwipingBlock)
                          _buildSwipeOverlay('🚫 BLOCK', const Color(0xFFFF4444)),
                        if (isSwipingReply)
                          _buildSwipeOverlay('💬 REPLY', const Color(0xFF43E97B)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_showFeedback)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: _lastCorrect == true
                      ? const Color(0xFF43E97B).withValues(alpha: 0.15)
                      : const Color(0xFFFF4444).withValues(alpha: 0.15),
                  border: Border.all(
                    color: _lastCorrect == true
                        ? const Color(0xFF43E97B)
                        : const Color(0xFFFF4444),
                  ),
                ),
                child: Text(
                  _feedbackText ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _lastCorrect == true
                        ? const Color(0xFF43E97B)
                        : const Color(0xFFFF4444),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _answer(true),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: const Color(0xFFFF4444).withValues(alpha: 0.15),
                      border: Border.all(color: const Color(0xFFFF4444), width: 2),
                    ),
                    child: const Center(
                      child: Text('🚫 Block',
                          style: TextStyle(
                              color: Color(0xFFFF4444),
                              fontWeight: FontWeight.w700,
                              fontSize: 16)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => _answer(false),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: const Color(0xFF43E97B).withValues(alpha: 0.15),
                      border: Border.all(color: const Color(0xFF43E97B), width: 2),
                    ),
                    child: const Center(
                      child: Text('💬 Reply',
                          style: TextStyle(
                              color: Color(0xFF43E97B),
                              fontWeight: FontWeight.w700,
                              fontSize: 16)),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(_DmCard card, AgeTierTheme theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.cardColor,
        border: Border.all(color: theme.primaryColor.withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [theme.primaryColor, theme.secondaryColor],
                  ),
                ),
                child: Center(
                  child: Text(card.avatar,
                      style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.username,
                      style: TextStyle(
                        color: theme.textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      card.handle,
                      style: TextStyle(
                          color: theme.subtextColor, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: theme.primaryColor.withValues(alpha: 0.1),
                ),
                child: Text(
                  'DM',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: theme.backgroundColor.withValues(alpha: 0.7),
            ),
            child: Text(
              card.message,
              style: TextStyle(
                color: theme.textColor,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Swipe left to block • Swipe right to reply',
            style: TextStyle(color: theme.subtextColor, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeOverlay(String text, Color color) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color.withValues(alpha: 0.2),
          border: Border.all(color: color, width: 3),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
