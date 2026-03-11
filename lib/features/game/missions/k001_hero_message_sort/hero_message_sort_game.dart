import 'package:flutter/material.dart';
import '../../../../core/models/mission.dart';
import '../../../../core/models/user_session.dart';
import '../../../../core/theme/age_tier_theme.dart';
import '../../game_scaffold.dart';

class _Message {
  final String text;
  final String sender;
  final bool isSafe;
  final String explanation;

  const _Message({
    required this.text,
    required this.sender,
    required this.isSafe,
    required this.explanation,
  });
}

const List<_Message> _messages = [
  _Message(
    text: "Hey! Want free candy? Come to my house!",
    sender: "Unknown123",
    isSafe: false,
    explanation: "Never go to a stranger's house!",
  ),
  _Message(
    text: "Hi! What's your home address?",
    sender: "CoolKid99",
    isSafe: false,
    explanation: "Never share your address with strangers!",
  ),
  _Message(
    text: "Great job at soccer today! 🏅",
    sender: "Coach Mike",
    isSafe: true,
    explanation: "A kind message from someone you know!",
  ),
  _Message(
    text: "Click this link to win a PS5!! 🎮",
    sender: "Prize_Bot",
    isSafe: false,
    explanation: "Fake prize links can steal your info!",
  ),
  _Message(
    text: "See you at school tomorrow! 😊",
    sender: "Emma (classmate)",
    isSafe: true,
    explanation: "A normal message from a classmate!",
  ),
  _Message(
    text: "Send me your photo or I'll tell your parents!",
    sender: "Mystery_guy",
    isSafe: false,
    explanation: "This is blackmail! Tell a trusted adult!",
  ),
  _Message(
    text: "Dinner is ready! Come downstairs 🍕",
    sender: "Mom",
    isSafe: true,
    explanation: "A family message — totally safe!",
  ),
  _Message(
    text: "I'm your secret admirer! Meet me alone...",
    sender: "Anonymous",
    isSafe: false,
    explanation: "Anonymous strangers can be dangerous!",
  ),
];

class HeroMessageSortGame extends StatefulWidget {
  final Mission mission;
  final void Function(int score) onComplete;

  const HeroMessageSortGame({
    super.key,
    required this.mission,
    required this.onComplete,
  });

  @override
  State<HeroMessageSortGame> createState() => _HeroMessageSortGameState();
}

class _HeroMessageSortGameState extends State<HeroMessageSortGame>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _score = 0;
  int _correct = 0;
  String? _feedbackText;
  bool? _lastCorrect;
  bool _showFeedback = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnim;
  Offset _dragOffset = Offset.zero;

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

  void _answer(bool markedSafe) {
    if (_showFeedback) return;
    final msg = _messages[_currentIndex];
    final isCorrect = msg.isSafe == markedSafe;
    setState(() {
      _lastCorrect = isCorrect;
      _feedbackText = isCorrect ? '✅ Correct!' : '❌ ${msg.explanation}';
      _showFeedback = true;
      if (isCorrect) {
        _score += 12;
        _correct++;
      }
    });
    if (!isCorrect) _shakeController.forward(from: 0);
    Future.delayed(const Duration(milliseconds: 1600), _next);
  }

  void _next() {
    if (!mounted) return;
    setState(() {
      _showFeedback = false;
      _dragOffset = Offset.zero;
      if (_currentIndex < _messages.length - 1) {
        _currentIndex++;
      } else {
        final finalScore = (_correct / _messages.length * 100).round();
        widget.onComplete(finalScore);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AgeTierTheme.forTier(AgeTier.kids7_10);
    final msg = _messages[_currentIndex];

    return GameScaffold(
      mission: widget.mission,
      ageTier: AgeTier.kids7_10,
      score: _score,
      totalQuestions: _messages.length,
      answeredQuestions: _currentIndex,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Text(
              '📬 Is this message SAFE or DANGER?',
              style: TextStyle(
                color: theme.textColor,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              '${_currentIndex + 1} of ${_messages.length}',
              style: TextStyle(color: theme.subtextColor, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GestureDetector(
                onHorizontalDragUpdate: (d) {
                  setState(() => _dragOffset += Offset(d.delta.dx, 0));
                },
                onHorizontalDragEnd: (d) {
                  if (_dragOffset.dx < -60) _answer(false); // danger
                  if (_dragOffset.dx > 60) _answer(true); // safe
                  setState(() => _dragOffset = Offset.zero);
                },
                child: AnimatedBuilder(
                  animation: _shakeAnim,
                  builder: (_, child) => Transform.translate(
                    offset: Offset(_shakeAnim.value * (_lastCorrect == false ? 1 : 0), 0) + _dragOffset,
                    child: child,
                  ),
                  child: _buildMessageCard(msg, theme),
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
                  padding: const EdgeInsets.all(16),
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
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: '☠️ DANGER',
                    color: const Color(0xFFFF4444),
                    onTap: () => _answer(false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    label: '✅ SAFE',
                    color: const Color(0xFF06D6A0),
                    onTap: () => _answer(true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '👈 Swipe or tap buttons',
              style: TextStyle(color: theme.subtextColor, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageCard(_Message msg, AgeTierTheme theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: theme.cardColor,
        border: Border.all(color: theme.primaryColor.withValues(alpha: 0.2), width: 1.5),
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
          CircleAvatar(
            radius: 34,
            backgroundColor: theme.primaryColor.withValues(alpha: 0.15),
            child: Text(
              msg.sender[0].toUpperCase(),
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            msg.sender,
            style: TextStyle(
              color: theme.subtextColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: theme.backgroundColor.withValues(alpha: 0.5),
            ),
            child: Text(
              '"${msg.text}"',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.textColor,
                fontSize: 17,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
              ),
            ),
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
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
