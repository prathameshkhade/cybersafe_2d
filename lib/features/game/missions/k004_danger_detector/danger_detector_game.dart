import 'package:flutter/material.dart';
import '../../../../core/models/mission.dart';
import '../../../../core/models/user_session.dart';
import '../../../../core/theme/age_tier_theme.dart';
import '../../game_scaffold.dart';

enum _DangerLevel { green, yellow, red }

class _Scenario {
  final String situation;
  final String emoji;
  final _DangerLevel correctLevel;
  final String explanation;

  const _Scenario({
    required this.situation,
    required this.emoji,
    required this.correctLevel,
    required this.explanation,
  });
}

const List<_Scenario> _scenarios = [
  _Scenario(
    situation: 'A stranger online says "You\'re so cool! Want to be my best friend?"',
    emoji: '👤',
    correctLevel: _DangerLevel.red,
    explanation: 'DANGER! Strangers who try to befriend you quickly online could be trying to trick you. Tell a trusted adult!',
  ),
  _Scenario(
    situation: 'Your classmate Emma sends you a funny meme she found online.',
    emoji: '😂',
    correctLevel: _DangerLevel.green,
    explanation: 'SAFE! Sharing funny things with classmates you know is totally fine!',
  ),
  _Scenario(
    situation: 'Someone you just met online asks for your home address to "send you a gift".',
    emoji: '📦',
    correctLevel: _DangerLevel.red,
    explanation: 'DANGER! Never share your address. Real gifts come from people your parents know!',
  ),
  _Scenario(
    situation: 'A pop-up says "You won a FREE iPad! Click here to claim it NOW!"',
    emoji: '🎁',
    correctLevel: _DangerLevel.red,
    explanation: 'DANGER! Free prize pop-ups are almost always fake and can steal your info!',
  ),
  _Scenario(
    situation: 'Your cousin sends you a video game link your parents already approved.',
    emoji: '🎮',
    correctLevel: _DangerLevel.green,
    explanation: 'SAFE! Links from family that your parents have approved are fine to use!',
  ),
  _Scenario(
    situation: 'An online friend asks you to keep your conversations secret from your parents.',
    emoji: '🤫',
    correctLevel: _DangerLevel.red,
    explanation: 'DANGER! Anyone asking you to keep secrets from your parents is a big red flag!',
  ),
  _Scenario(
    situation: 'A new online friend seems nice but keeps asking which school you go to.',
    emoji: '🏫',
    correctLevel: _DangerLevel.yellow,
    explanation: 'BE CAREFUL! Repeatedly asking where you go to school is suspicious. Tell a parent!',
  ),
  _Scenario(
    situation: 'Your teacher posts homework instructions in the class group chat.',
    emoji: '📚',
    correctLevel: _DangerLevel.green,
    explanation: 'SAFE! Messages from your teacher in a class group chat are totally normal!',
  ),
  _Scenario(
    situation: 'Someone online says "Send me a photo of yourself or I\'ll tell everyone your secrets!"',
    emoji: '📸',
    correctLevel: _DangerLevel.red,
    explanation: 'DANGER! This is blackmail. Never send photos. Tell a trusted adult immediately!',
  ),
  _Scenario(
    situation: 'An unknown account starts following you and liking all your old posts.',
    emoji: '👀',
    correctLevel: _DangerLevel.yellow,
    explanation: 'BE CAREFUL! Unknown accounts following and watching everything you post is suspicious. Set your profile to private!',
  ),
];

class DangerDetectorGame extends StatefulWidget {
  final Mission mission;
  final void Function(int score) onComplete;

  const DangerDetectorGame({
    super.key,
    required this.mission,
    required this.onComplete,
  });

  @override
  State<DangerDetectorGame> createState() => _DangerDetectorGameState();
}

class _DangerDetectorGameState extends State<DangerDetectorGame>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _score = 0;
  int _correct = 0;
  String? _feedbackText;
  bool? _lastCorrect;
  bool _showFeedback = false;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnim;

  // Colors for each danger level
  static const _greenColor  = Color(0xFF06D6A0);
  static const _yellowColor = Color(0xFFFFD166);
  static const _redColor    = Color(0xFFFF4444);

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

  void _answer(_DangerLevel chosen) {
    if (_showFeedback) return;
    final scenario = _scenarios[_currentIndex];
    final isCorrect = scenario.correctLevel == chosen;
    setState(() {
      _lastCorrect = isCorrect;
      _feedbackText = isCorrect
          ? '✅ Correct! ${scenario.explanation}'
          : '${_levelEmoji(scenario.correctLevel)} ${scenario.explanation}';
      _showFeedback = true;
      if (isCorrect) {
        _score += 10;
        _correct++;
      }
    });
    if (!isCorrect) _shakeController.forward(from: 0);
    Future.delayed(const Duration(milliseconds: 2000), _next);
  }

  void _next() {
    if (!mounted) return;
    setState(() {
      _showFeedback = false;
      if (_currentIndex < _scenarios.length - 1) {
        _currentIndex++;
      } else {
        final finalScore = (_correct / _scenarios.length * 100).round();
        widget.onComplete(finalScore);
      }
    });
  }

  String _levelEmoji(_DangerLevel level) {
    switch (level) {
      case _DangerLevel.green:  return '🟢';
      case _DangerLevel.yellow: return '🟡';
      case _DangerLevel.red:    return '🔴';
    }
  }

  Color _levelColor(_DangerLevel level) {
    switch (level) {
      case _DangerLevel.green:  return _greenColor;
      case _DangerLevel.yellow: return _yellowColor;
      case _DangerLevel.red:    return _redColor;
    }
  }

  String _levelLabel(_DangerLevel level) {
    switch (level) {
      case _DangerLevel.green:  return 'SAFE';
      case _DangerLevel.yellow: return 'BE CAREFUL';
      case _DangerLevel.red:    return 'DANGER!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AgeTierTheme.forTier(AgeTier.kids7_10);
    final scenario = _scenarios[_currentIndex];

    return GameScaffold(
      mission: widget.mission,
      ageTier: AgeTier.kids7_10,
      score: _score,
      totalQuestions: _scenarios.length,
      answeredQuestions: _currentIndex,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Text(
              '🚨 How dangerous is this situation?',
              style: TextStyle(
                color: theme.textColor,
                fontWeight: FontWeight.w800,
                fontSize: 17,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '${_currentIndex + 1} of ${_scenarios.length}',
              style: TextStyle(color: theme.subtextColor, fontSize: 13),
            ),
            const SizedBox(height: 20),

            // Scenario card
            Expanded(
              child: AnimatedBuilder(
                animation: _shakeAnim,
                builder: (_, child) => Transform.translate(
                  offset: Offset(
                    _shakeAnim.value * (_lastCorrect == false ? 1 : 0),
                    0,
                  ),
                  child: child,
                ),
                child: _buildScenarioCard(scenario, theme),
              ),
            ),

            const SizedBox(height: 16),

            // Feedback banner
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
                        ? _greenColor.withValues(alpha: 0.15)
                        : _redColor.withValues(alpha: 0.15),
                    border: Border.all(
                      color: _lastCorrect == true ? _greenColor : _redColor,
                    ),
                  ),
                  child: Text(
                    _feedbackText ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _lastCorrect == true ? _greenColor : _redColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 12),

            // Traffic light buttons
            Row(
              children: [
                Expanded(
                  child: _buildTrafficButton(
                    level: _DangerLevel.green,
                    onTap: () => _answer(_DangerLevel.green),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTrafficButton(
                    level: _DangerLevel.yellow,
                    onTap: () => _answer(_DangerLevel.yellow),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTrafficButton(
                    level: _DangerLevel.red,
                    onTap: () => _answer(_DangerLevel.red),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildScenarioCard(_Scenario scenario, AgeTierTheme theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
          // Traffic light visual
          _buildTrafficLight(),
          const SizedBox(height: 24),
          // Scenario emoji
          Text(scenario.emoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          // Situation text
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: theme.backgroundColor.withValues(alpha: 0.5),
            ),
            child: Text(
              scenario.situation,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.textColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tap the correct traffic light below 👇',
            style: TextStyle(
              color: theme.subtextColor,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrafficLight() {
    return Container(
      width: 56,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color(0xFF1A1A2E),
      ),
      child: Column(
        children: [
          _trafficDot(_redColor, 0.4),
          const SizedBox(height: 6),
          _trafficDot(_yellowColor, 0.4),
          const SizedBox(height: 6),
          _trafficDot(_greenColor, 0.4),
        ],
      ),
    );
  }

  Widget _trafficDot(Color color, double opacity) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: opacity),
        border: Border.all(color: color.withValues(alpha: 0.6), width: 1.5),
      ),
    );
  }

  Widget _buildTrafficButton({
    required _DangerLevel level,
    required VoidCallback onTap,
  }) {
    final color = _levelColor(level);
    final label = _levelLabel(level);
    final emoji = _levelEmoji(level);

    return GestureDetector(
      onTap: _showFeedback ? null : onTap,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: color.withValues(alpha: 0.15),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}