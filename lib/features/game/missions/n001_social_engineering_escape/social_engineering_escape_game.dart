import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/models/mission.dart';
import '../../../../core/models/user_session.dart';
import '../../../../core/theme/age_tier_theme.dart';
import '../../game_scaffold.dart';

class _DialogueNode {
  final String speaker;
  final String message;
  final List<_Choice> choices;
  final bool isEnd;
  final String? endExplanation;
  final bool isGoodEnd;

  const _DialogueNode({
    required this.speaker,
    required this.message,
    this.choices = const [],
    this.isEnd = false,
    this.endExplanation,
    this.isGoodEnd = false,
  });
}

class _Choice {
  final String text;
  final String nextNodeId;
  final int scoreChange;
  final String? reaction;

  const _Choice({
    required this.text,
    required this.nextNodeId,
    this.scoreChange = 0,
    this.reaction,
  });
}

final Map<String, _DialogueNode> _dialogueTree = {
  'start': const _DialogueNode(
    speaker: 'Unknown Caller',
    message:
        '"Hi, this is Mark from IT Support. We\'ve detected a virus on your device. I need remote access to fix it immediately. Can you download this tool: bit.ly/it-remote-fix?"',
    choices: [
      _Choice(
        text: '✅ Sure, downloading now...',
        nextNodeId: 'bad_end_1',
        scoreChange: -20,
      ),
      _Choice(
        text: '🤔 Can I verify your identity first?',
        nextNodeId: 'verify',
        scoreChange: 15,
        reaction: '💪 Smart move!',
      ),
      _Choice(
        text: '❌ Hang up immediately',
        nextNodeId: 'good_end_1',
        scoreChange: 25,
        reaction: '🎉 Perfect!',
      ),
    ],
  ),
  'verify': const _DialogueNode(
    speaker: 'Unknown Caller',
    message:
        '"Of course! My employee ID is 7742 and I\'m calling from 555-0199. Now please hurry, every minute matters! Just give me your admin password so I can start the fix remotely."',
    choices: [
      _Choice(
        text: 'Ok, my password is admin123',
        nextNodeId: 'bad_end_2',
        scoreChange: -30,
      ),
      _Choice(
        text: 'Real IT never asks for passwords',
        nextNodeId: 'good_end_2',
        scoreChange: 30,
        reaction: '🔐 Exactly right!',
      ),
      _Choice(
        text: 'Let me call back on the official number',
        nextNodeId: 'good_end_2',
        scoreChange: 25,
        reaction: '✅ Smart verification!',
      ),
    ],
  ),
  'bad_end_1': const _DialogueNode(
    speaker: 'System',
    message: '',
    isEnd: true,
    isGoodEnd: false,
    endExplanation:
        '❌ You installed malware! Social engineers use urgency to bypass your judgment. Real IT support never cold-calls asking you to download remote access tools from random links.',
  ),
  'bad_end_2': const _DialogueNode(
    speaker: 'System',
    message: '',
    isEnd: true,
    isGoodEnd: false,
    endExplanation:
        '❌ Your password was stolen! Employee IDs and phone numbers can be faked. The golden rule: NO legitimate IT team EVER asks for your password.',
  ),
  'good_end_1': const _DialogueNode(
    speaker: 'System',
    message: '',
    isEnd: true,
    isGoodEnd: true,
    endExplanation:
        '✅ Excellent! Hanging up on unknown callers claiming urgency is often the safest move. You can always call your IT department\'s official number to verify.',
  ),
  'good_end_2': const _DialogueNode(
    speaker: 'System',
    message: '',
    isEnd: true,
    isGoodEnd: true,
    endExplanation:
        '✅ Perfect! You identified the key social engineering tactics: false urgency + password request. Real IT professionals never need your password.',
  ),
};

class SocialEngineeringEscapeGame extends StatefulWidget {
  final Mission mission;
  final void Function(int score) onComplete;

  const SocialEngineeringEscapeGame({
    super.key,
    required this.mission,
    required this.onComplete,
  });

  @override
  State<SocialEngineeringEscapeGame> createState() =>
      _SocialEngineeringEscapeGameState();
}

class _SocialEngineeringEscapeGameState
    extends State<SocialEngineeringEscapeGame> {
  String _currentNodeId = 'start';
  int _score = 50;
  int _timeLeft = 90;
  Timer? _timer;
  String? _reactionText;
  int _step = 0;
  final int _totalSteps = 3;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) {
          _timer?.cancel();
          Future.delayed(Duration.zero, () {
            if (mounted) widget.onComplete((_score).clamp(0, 100));
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _choose(_Choice choice) {
    setState(() {
      _score = (_score + choice.scoreChange).clamp(0, 100);
      _reactionText = choice.reaction;
      _currentNodeId = choice.nextNodeId;
      _step++;
    });
    final node = _dialogueTree[_currentNodeId]!;
    if (node.isEnd) {
      _timer?.cancel();
      Future.delayed(const Duration(milliseconds: 2500), () {
        if (mounted) widget.onComplete(_score.clamp(0, 100));
      });
    } else {
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) setState(() => _reactionText = null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AgeTierTheme.forTier(AgeTier.teens15_18);
    final node = _dialogueTree[_currentNodeId]!;

    return GameScaffold(
      mission: widget.mission,
      ageTier: AgeTier.teens15_18,
      score: _score,
      totalQuestions: _totalSteps,
      answeredQuestions: _step,
      timeLeft: _timeLeft,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: node.isEnd
            ? _buildEndScreen(node, theme)
            : _buildDialogueScreen(node, theme),
      ),
    );
  }

  Widget _buildDialogueScreen(_DialogueNode node, AgeTierTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🧠 Social Engineering Scenario',
          style: TextStyle(
            color: theme.primaryColor,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: theme.cardColor,
            border: Border.all(
                color: const Color(0xFFFF4444).withValues(alpha: 0.3), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFF4444).withValues(alpha: 0.15),
                    ),
                    child:
                        const Text('📞', style: TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        node.speaker,
                        style: const TextStyle(
                          color: Color(0xFFFF4444),
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const Text(
                        'Incoming Call',
                        style: TextStyle(
                          color: Color(0xFF6A8FAF),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                node.message,
                style: TextStyle(
                  color: theme.textColor,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        if (_reactionText != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: theme.accentColor.withValues(alpha: 0.15),
                border: Border.all(color: theme.accentColor),
              ),
              child: Text(
                _reactionText!,
                style: TextStyle(
                  color: theme.accentColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        const SizedBox(height: 20),
        Text(
          'YOUR RESPONSE:',
          style: TextStyle(
            color: theme.subtextColor,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemCount: node.choices.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final choice = node.choices[i];
              final isRed = choice.scoreChange < 0;
              return GestureDetector(
                onTap: () => _choose(choice),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: isRed
                        ? const Color(0xFFFF4444).withValues(alpha: 0.06)
                        : theme.cardColor,
                    border: Border.all(
                      color: isRed
                          ? const Color(0xFFFF4444).withValues(alpha: 0.3)
                          : theme.primaryColor.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    choice.text,
                    style: TextStyle(
                      color: theme.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEndScreen(_DialogueNode node, AgeTierTheme theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            node.isGoodEnd ? '🛡️ Scenario Complete!' : '⚠️ Compromised!',
            style: TextStyle(
              color: node.isGoodEnd
                  ? const Color(0xFF00D4FF)
                  : const Color(0xFFFF4444),
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: theme.cardColor,
              border: Border.all(
                color: node.isGoodEnd
                    ? const Color(0xFF00D4FF).withValues(alpha: 0.4)
                    : const Color(0xFFFF4444).withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: Text(
              node.endExplanation ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.textColor,
                fontSize: 15,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Score: $_score / 100',
            style: TextStyle(
              color: theme.primaryColor,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Returning to results...',
            style: TextStyle(color: theme.subtextColor, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
