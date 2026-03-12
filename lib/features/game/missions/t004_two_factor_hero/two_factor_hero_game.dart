import 'package:flutter/material.dart';
import '../../../../core/models/mission.dart';
import '../../../../core/models/user_session.dart';
import '../../../../core/theme/age_tier_theme.dart';
import '../../game_scaffold.dart';

class _LoginMethod {
  final String name;
  final String icon;
  final int securityRank; // 1 = best, 4 = worst
  final String explanation;
  final Color color;

  const _LoginMethod({
    required this.name,
    required this.icon,
    required this.securityRank,
    required this.explanation,
    required this.color,
  });
}

class _Scenario {
  final String situation;
  final String emoji;
  final List<_LoginMethod> methods;
  final int correctRank; // the securityRank that is the BEST choice here
  final String verdict;

  const _Scenario({
    required this.situation,
    required this.emoji,
    required this.methods,
    required this.correctRank,
    required this.verdict,
  });
}

const _scenarios = [
  _Scenario(
    situation: 'You\'re setting up a new Instagram account. Which login protection should you enable?',
    emoji: '📸',
    methods: [
      _LoginMethod(
        name: 'No extra protection',
        icon: '🔓',
        securityRank: 4,
        explanation: 'Just a password is the weakest option — if it\'s stolen, your account is gone!',
        color: Color(0xFFFF4444),
      ),
      _LoginMethod(
        name: 'SMS text code',
        icon: '📱',
        securityRank: 3,
        explanation: 'SMS codes are better than nothing but can be intercepted by SIM-swapping attacks.',
        color: Color(0xFFFFD166),
      ),
      _LoginMethod(
        name: 'Authenticator App',
        icon: '🔐',
        securityRank: 1,
        explanation: 'Authenticator apps generate time-based codes that can\'t be intercepted remotely — the strongest option!',
        color: Color(0xFF43E97B),
      ),
      _LoginMethod(
        name: 'Backup email code',
        icon: '📧',
        securityRank: 2,
        explanation: 'Email codes are decent but only as secure as your email account itself.',
        color: Color(0xFF6C63FF),
      ),
    ],
    correctRank: 1,
    verdict: 'Authenticator App is strongest — time-based codes can\'t be intercepted like SMS!',
  ),
  _Scenario(
    situation: 'Someone is trying to log into your account from an unknown device. You get a 2FA prompt. What do you do?',
    emoji: '🚨',
    methods: [
      _LoginMethod(
        name: 'Approve it — might be me',
        icon: '✅',
        securityRank: 4,
        explanation: 'NEVER approve a 2FA request you didn\'t initiate — someone else is trying to get in!',
        color: Color(0xFFFF4444),
      ),
      _LoginMethod(
        name: 'Ignore it',
        icon: '🙈',
        securityRank: 3,
        explanation: 'Ignoring is better than approving, but you should still change your password immediately!',
        color: Color(0xFFFFD166),
      ),
      _LoginMethod(
        name: 'Deny and change password',
        icon: '🛡️',
        securityRank: 1,
        explanation: 'Deny the request immediately AND change your password — your credentials are compromised!',
        color: Color(0xFF43E97B),
      ),
      _LoginMethod(
        name: 'Just deny it',
        icon: '🚫',
        securityRank: 2,
        explanation: 'Denying stops this attempt, but without changing your password they could keep trying.',
        color: Color(0xFF6C63FF),
      ),
    ],
    correctRank: 1,
    verdict: 'Deny AND change your password — someone has your password and is actively trying to break in!',
  ),
  _Scenario(
    situation: 'Your friend asks for your SMS 2FA code because they "need to verify something for you". What do you do?',
    emoji: '👥',
    methods: [
      _LoginMethod(
        name: 'Share it — they\'re my friend',
        icon: '🤝',
        securityRank: 4,
        explanation: 'NEVER share 2FA codes — even with friends! This is a social engineering attack.',
        color: Color(0xFFFF4444),
      ),
      _LoginMethod(
        name: 'Share only the first 3 digits',
        icon: '🔢',
        securityRank: 3,
        explanation: 'Still dangerous! Partial codes can sometimes be used and you\'re still being manipulated.',
        color: Color(0xFFFFD166),
      ),
      _LoginMethod(
        name: 'Refuse and call them',
        icon: '📞',
        securityRank: 1,
        explanation: 'Correct! Refuse to share any code and call your friend directly — their account may be hacked!',
        color: Color(0xFF43E97B),
      ),
      _LoginMethod(
        name: 'Just ignore the message',
        icon: '😶',
        securityRank: 2,
        explanation: 'Better than sharing, but you should warn your friend their account might be compromised.',
        color: Color(0xFF6C63FF),
      ),
    ],
    correctRank: 1,
    verdict: 'Real services NEVER ask for your 2FA code. This is classic social engineering — refuse and call your friend!',
  ),
  _Scenario(
    situation: 'You\'re creating a password for your school account. Which is the most secure?',
    emoji: '🏫',
    methods: [
      _LoginMethod(
        name: 'password123',
        icon: '😬',
        securityRank: 4,
        explanation: 'This is one of the most common passwords in the world — hackers try it first!',
        color: Color(0xFFFF4444),
      ),
      _LoginMethod(
        name: 'YourBirthday2010',
        icon: '🎂',
        securityRank: 3,
        explanation: 'Personal info like birthdays is easy to guess from social media profiles.',
        color: Color(0xFFFFD166),
      ),
      _LoginMethod(
        name: r'T!ger$Jump99#Blue',
        icon: '🔑',
        securityRank: 1,
        explanation: 'Random mix of uppercase, symbols and numbers with no personal info — excellent password!',
        color: Color(0xFF43E97B),
      ),
      _LoginMethod(
        name: 'SchoolName2024!',
        icon: '📚',
        securityRank: 2,
        explanation: 'Has a symbol but uses predictable school context — still guessable.',
        color: Color(0xFF6C63FF),
      ),
    ],
    correctRank: 1,
    verdict: r'T!ger$Jump99#Blue' ' wins — random mixed characters with no personal info is the gold standard!',
  ),
  _Scenario(
    situation: 'You\'re logging into your bank app on your phone. Which is the safest option?',
    emoji: '🏦',
    methods: [
      _LoginMethod(
        name: 'Public WiFi + password',
        icon: '📶',
        securityRank: 4,
        explanation: 'NEVER use banking on public WiFi — attackers can intercept your data with man-in-the-middle attacks!',
        color: Color(0xFFFF4444),
      ),
      _LoginMethod(
        name: 'Mobile data + password',
        icon: '📡',
        securityRank: 3,
        explanation: 'Mobile data is safer than public WiFi but a password alone is still weak for banking.',
        color: Color(0xFFFFD166),
      ),
      _LoginMethod(
        name: 'Mobile data + biometric 2FA',
        icon: '👆',
        securityRank: 1,
        explanation: 'Mobile data plus fingerprint/face ID is the most secure — biometrics can\'t be phished!',
        color: Color(0xFF43E97B),
      ),
      _LoginMethod(
        name: 'Home WiFi + SMS code',
        icon: '🏠',
        securityRank: 2,
        explanation: 'Home WiFi with SMS 2FA is decent but biometric 2FA is stronger and faster.',
        color: Color(0xFF6C63FF),
      ),
    ],
    correctRank: 1,
    verdict: 'Mobile data + biometric 2FA is the winner — secure network AND the strongest authentication method!',
  ),
];

class TwoFactorHeroGame extends StatefulWidget {
  final Mission mission;
  final void Function(int score) onComplete;

  const TwoFactorHeroGame({
    super.key,
    required this.mission,
    required this.onComplete,
  });

  @override
  State<TwoFactorHeroGame> createState() => _TwoFactorHeroGameState();
}

class _TwoFactorHeroGameState extends State<TwoFactorHeroGame>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _score = 0;
  int _correct = 0;
  bool _showFeedback = false;
  bool? _lastCorrect;
  String? _feedbackText;
  int? _selectedMethodRank;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _shakeAnim = Tween(begin: 0.0, end: 8.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _selectMethod(_LoginMethod method) {
    if (_showFeedback) return;
    final scenario = _scenarios[_currentIndex];
    final isCorrect = method.securityRank == scenario.correctRank;
    setState(() {
      _selectedMethodRank = method.securityRank;
      _lastCorrect = isCorrect;
      _feedbackText = isCorrect
          ? '✅ ${method.explanation}'
          : '❌ ${method.explanation}\n\n💡 Best choice: ${scenario.verdict}';
      _showFeedback = true;
      if (isCorrect) {
        _score += 20;
        _correct++;
      }
    });
    if (!isCorrect) _shakeController.forward(from: 0);
    Future.delayed(const Duration(milliseconds: 2400), _next);
  }

  void _next() {
    if (!mounted) return;
    setState(() {
      _showFeedback = false;
      _selectedMethodRank = null;
      if (_currentIndex < _scenarios.length - 1) {
        _currentIndex++;
      } else {
        final finalScore = (_correct / _scenarios.length * 100).round();
        widget.onComplete(finalScore);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AgeTierTheme.forTier(AgeTier.tweens11_14);
    final scenario = _scenarios[_currentIndex];

    return GameScaffold(
      mission: widget.mission,
      ageTier: AgeTier.tweens11_14,
      score: _score,
      totalQuestions: _scenarios.length,
      answeredQuestions: _currentIndex,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              '🔐 Choose the SAFEST option!',
              style: TextStyle(
                color: theme.textColor,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          // Scenario card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AnimatedBuilder(
              animation: _shakeAnim,
              builder: (_, child) => Transform.translate(
                offset: Offset(
                  _shakeAnim.value * (_lastCorrect == false ? 1 : 0),
                  0,
                ),
                child: child,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: theme.cardColor,
                  border: Border.all(
                      color: theme.primaryColor.withValues(alpha: 0.25),
                      width: 1.5),
                ),
                child: Row(
                  children: [
                    Text(scenario.emoji,
                        style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        scenario.situation,
                        style: TextStyle(
                          color: theme.textColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Method options
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: scenario.methods.map((method) {
                  final isSelected =
                      _selectedMethodRank == method.securityRank;
                  final isBest = method.securityRank == scenario.correctRank;
                  final showResult = _showFeedback;

                  Color borderColor = theme.primaryColor.withValues(alpha: 0.2);
                  Color bgColor = theme.cardColor;

                  if (showResult) {
                    if (isBest) {
                      borderColor = const Color(0xFF43E97B);
                      bgColor = const Color(0xFF43E97B).withValues(alpha: 0.1);
                    } else if (isSelected && !isBest) {
                      borderColor = const Color(0xFFFF4444);
                      bgColor = const Color(0xFFFF4444).withValues(alpha: 0.1);
                    }
                  }

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GestureDetector(
                        onTap: _showFeedback ? null : () => _selectMethod(method),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: bgColor,
                            border: Border.all(color: borderColor, width: 1.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            child: Row(
                              children: [
                                Text(method.icon,
                                    style: const TextStyle(fontSize: 26)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    method.name,
                                    style: TextStyle(
                                      color: theme.textColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                if (showResult && isBest)
                                  const Text('✅',
                                      style: TextStyle(fontSize: 18)),
                                if (showResult && isSelected && !isBest)
                                  const Text('❌',
                                      style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Feedback
          if (_showFeedback)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
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
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}