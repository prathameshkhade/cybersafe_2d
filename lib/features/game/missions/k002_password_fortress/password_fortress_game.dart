import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/models/mission.dart';
import '../../../../core/models/user_session.dart';
import '../../../../core/theme/age_tier_theme.dart';
import '../../game_scaffold.dart';

class _FallingItem {
  final String label;
  final bool isGood;
  final String reason;
  double x;
  double y;
  double speed;
  final String id;

  _FallingItem({
    required this.label,
    required this.isGood,
    required this.reason,
    required this.x,
    required this.y,
    required this.speed,
    required this.id,
  });
}

const _goodItems = [
  ('A', 'Uppercase letters make passwords strong!'),
  ('#', 'Special symbols are great!'),
  ('9', 'Numbers help!'),
  ('Z', 'Uppercase rock!'),
  ('!', 'Special character — yes!'),
  ('@', 'Symbol power!'),
  ('7', 'Numbers are good!'),
  ('K', 'More uppercase!'),
];

const _badItems = [
  ('1', 'Too simple'),
  ('a', 'Only lowercase is weak'),
  ('?', 'Common, try something rarer'),
  ('o', 'Very common letter'),
  ('0', 'Easy to guess'),
];

class PasswordFortressGame extends StatefulWidget {
  final Mission mission;
  final void Function(int score) onComplete;

  const PasswordFortressGame({
    super.key,
    required this.mission,
    required this.onComplete,
  });

  @override
  State<PasswordFortressGame> createState() => _PasswordFortressGameState();
}

class _PasswordFortressGameState extends State<PasswordFortressGame> {
  final _random = Random();
  final List<_FallingItem> _items = [];
  int _score = 0;
  int _lives = 3;
  int _timeLeft = 60;
  Timer? _gameTimer;
  Timer? _spawnTimer;
  bool _gameOver = false;
  String? _feedback;
  bool? _feedbackGood;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _spawnTimer?.cancel();
    super.dispose();
  }

  void _startGame() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        _timeLeft--;
        // move items down
        for (final item in _items) {
          item.y += item.speed;
        }
        _items.removeWhere((item) {
          if (item.y > 1.0) {
            if (item.isGood) {
              _lives--;
              if (_lives <= 0) _endGame();
            }
            return true;
          }
          return false;
        });
        if (_timeLeft <= 0) _endGame();
      });
    });
    _spawnTimer = Timer.periodic(const Duration(milliseconds: 1200), (_) {
      if (!mounted || _gameOver) return;
      _spawnItem();
    });
  }

  void _spawnItem() {
    final useGood = _random.nextBool();
    final pool = useGood ? _goodItems : _badItems;
    final picked = pool[_random.nextInt(pool.length)];
    setState(() {
      _items.add(_FallingItem(
        label: picked.$1,
        isGood: useGood,
        reason: picked.$2,
        x: 0.1 + _random.nextDouble() * 0.8,
        y: -0.05,
        speed: 0.015 + _random.nextDouble() * 0.01,
        id: '${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(999)}',
      ));
    });
  }

  void _tapItem(_FallingItem item) {
    setState(() {
      _items.removeWhere((i) => i.id == item.id);
      if (item.isGood) {
        _score += 10;
        _feedback = '✅ ${item.reason}';
        _feedbackGood = true;
      } else {
        _score = max(0, _score - 5);
        _feedback = '❌ ${item.reason}';
        _feedbackGood = false;
      }
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _feedback = null);
    });
  }

  void _endGame() {
    _gameTimer?.cancel();
    _spawnTimer?.cancel();
    setState(() => _gameOver = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        final finalScore = min(100, _score);
        widget.onComplete(finalScore);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AgeTierTheme.forTier(AgeTier.kids7_10);

    return GameScaffold(
      mission: widget.mission,
      ageTier: AgeTier.kids7_10,
      score: _score,
      totalQuestions: 60,
      answeredQuestions: 60 - _timeLeft,
      timeLeft: _timeLeft,
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            // Background fortress
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.primaryColor.withValues(alpha: 0.3),
                      theme.secondaryColor.withValues(alpha: 0.2)
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    '🏰 YOUR FORTRESS',
                    style: TextStyle(
                      color: theme.textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            // Lives
            Positioned(
              top: 8,
              left: 16,
              child: Row(children: List.generate(3, (i) {
                return Text(i < _lives ? '❤️' : '🖤',
                    style: const TextStyle(fontSize: 20));
              })),
            ),
            // Feedback
            if (_feedback != null)
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: _feedbackGood == true
                          ? const Color(0xFF06D6A0).withValues(alpha: 0.9)
                          : const Color(0xFFFF4444).withValues(alpha: 0.9),
                    ),
                    child: Text(
                      _feedback!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13),
                    ),
                  ),
                ),
              ),
            // Falling items
            ..._items.map((item) {
              final x = item.x * constraints.maxWidth - 30;
              final y = item.y * constraints.maxHeight;
              return Positioned(
                left: x,
                top: y,
                child: GestureDetector(
                  onTap: () => _tapItem(item),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: item.isGood
                            ? [
                                const Color(0xFF06D6A0),
                                const Color(0xFF00B4D8)
                              ]
                            : [
                                const Color(0xFFFF6B6B),
                                const Color(0xFFFF4444)
                              ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (item.isGood
                                  ? const Color(0xFF06D6A0)
                                  : const Color(0xFFFF4444))
                              .withValues(alpha: 0.5),
                          blurRadius: 10,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    child: Center(
                      child: Text(
                        item.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
            // Instructions
            Positioned(
              bottom: 90,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Tap GOOD password elements! ✅ Avoid weak ones ❌',
                  style: TextStyle(
                    color: theme.subtextColor,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
