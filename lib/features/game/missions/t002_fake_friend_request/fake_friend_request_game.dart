import 'package:flutter/material.dart';
import '../../../../core/models/mission.dart';
import '../../../../core/models/user_session.dart';
import '../../../../core/theme/age_tier_theme.dart';
import '../../game_scaffold.dart';

class _Profile {
  final String name;
  final String handle;
  final String bio;
  final int followers;
  final int following;
  final List<String> redFlags;
  final bool isFake;
  final String explanation;
  final String avatar;

  const _Profile({
    required this.name,
    required this.handle,
    required this.bio,
    required this.followers,
    required this.following,
    required this.redFlags,
    required this.isFake,
    required this.explanation,
    required this.avatar,
  });
}

const List<_Profile> _profiles = [
  _Profile(
    name: 'Emma Wilson',
    handle: '@emrna_wils0n',
    bio: 'Living my best life 🌟 DM for AMAZING opportunities!!',
    followers: 47,
    following: 1823,
    redFlags: [
      '⚠️ Account is only 2 days old',
      '⚠️ Following way more than followers',
      '⚠️ Handle has suspicious substitutions (rn→m, 0→o)',
    ],
    isFake: true,
    explanation:
        'Catfish alert! New account, suspicious username, and following 40x more than followers.',
    avatar: '🎭',
  ),
  _Profile(
    name: 'Alex Chen',
    handle: '@alexchen_music',
    bio: 'Music producer 🎵 Guitar nerd. Posts about bands and concerts.',
    followers: 892,
    following: 310,
    redFlags: [],
    isFake: false,
    explanation: 'Looks genuine — real photos, consistent content, normal ratio.',
    avatar: '🎸',
  ),
  _Profile(
    name: 'Giveaway_King2024',
    handle: '@giveaway_king2024',
    bio: 'FREE ROBUX every week! Follow + DM to claim. 100% legit!',
    followers: 3,
    following: 5000,
    redFlags: [
      '⚠️ Free offers are almost always scams',
      '⚠️ 3 followers, 5000 following — obvious bot',
      '⚠️ Generic "king/queen" giveaway username',
    ],
    isFake: true,
    explanation:
        'Scam bot! No one gives free Robux. This account exists to steal your credentials.',
    avatar: '🤖',
  ),
  _Profile(
    name: 'Jordan Rivers',
    handle: '@j_rivers_art',
    bio: 'Digital artist 🎨 sharing my journey. Open commissions!',
    followers: 2341,
    following: 567,
    redFlags: [],
    isFake: false,
    explanation: 'Seems real — portfolio presence, reasonable follower ratio.',
    avatar: '🎨',
  ),
  _Profile(
    name: 'Celebrity Fan',
    handle: '@officiall_celebfan',
    bio: 'I know Justin B personally! DM me for his number 😉',
    followers: 12,
    following: 3400,
    redFlags: [
      '⚠️ Claims to know celebrities',
      '⚠️ Offering celebrity contacts is a classic scam',
      '⚠️ Double-L in "officiall" — fake verification trick',
    ],
    isFake: true,
    explanation:
        'Social engineering! Nobody has celebrity contact info to give away for free.',
    avatar: '⭐',
  ),
];

class FakeFriendRequestGame extends StatefulWidget {
  final Mission mission;
  final void Function(int score) onComplete;

  const FakeFriendRequestGame({
    super.key,
    required this.mission,
    required this.onComplete,
  });

  @override
  State<FakeFriendRequestGame> createState() =>
      _FakeFriendRequestGameState();
}

class _FakeFriendRequestGameState extends State<FakeFriendRequestGame> {
  int _currentIndex = 0;
  int _score = 0;
  int _correct = 0;
  bool _flipped = false;
  bool _showFeedback = false;
  bool? _lastCorrect;
  String? _feedbackText;

  void _flip() {
    setState(() => _flipped = !_flipped);
  }

  void _answer(bool isRejecting) {
    if (_showFeedback) return;
    final profile = _profiles[_currentIndex];
    final correct = profile.isFake == isRejecting;
    setState(() {
      _lastCorrect = correct;
      _feedbackText = correct
          ? '✅ Correct! ${profile.explanation}'
          : '❌ ${profile.explanation}';
      _showFeedback = true;
      if (correct) {
        _score += 20;
        _correct++;
      }
    });
    Future.delayed(const Duration(milliseconds: 2200), _next);
  }

  void _next() {
    if (!mounted) return;
    setState(() {
      _showFeedback = false;
      _flipped = false;
      if (_currentIndex < _profiles.length - 1) {
        _currentIndex++;
      } else {
        final finalScore = (_correct / _profiles.length * 100).round();
        widget.onComplete(finalScore);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AgeTierTheme.forTier(AgeTier.tweens11_14);
    final profile = _profiles[_currentIndex];

    return GameScaffold(
      mission: widget.mission,
      ageTier: AgeTier.tweens11_14,
      score: _score,
      totalQuestions: _profiles.length,
      answeredQuestions: _currentIndex,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Accept or Reject this Friend Request?',
              style: TextStyle(
                color: theme.textColor,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Tap the card to flip and see red flags 👇',
              style: TextStyle(color: theme.subtextColor, fontSize: 12),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GestureDetector(
                onTap: _flip,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, anim) => RotationYTransition(
                    turns: anim,
                    child: child,
                  ),
                  child: _flipped
                      ? _buildBackCard(profile, theme)
                      : _buildFrontCard(profile, theme),
                ),
              ),
            ),
            if (_showFeedback)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
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
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            Row(children: [
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
                      child: Text('❌ Reject',
                          style: TextStyle(
                              color: Color(0xFFFF4444),
                              fontWeight: FontWeight.w700,
                              fontSize: 15)),
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
                      child: Text('✅ Accept',
                          style: TextStyle(
                              color: Color(0xFF43E97B),
                              fontWeight: FontWeight.w700,
                              fontSize: 15)),
                    ),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildFrontCard(_Profile profile, AgeTierTheme theme) {
    return Container(
      key: const ValueKey('front'),
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: theme.cardColor,
        border: Border.all(color: theme.primaryColor.withValues(alpha: 0.2), width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [theme.primaryColor, theme.secondaryColor],
              ),
            ),
            child: Center(
              child: Text(profile.avatar, style: const TextStyle(fontSize: 40)),
            ),
          ),
          const SizedBox(height: 14),
          Text(profile.name,
              style: TextStyle(
                  color: theme.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w800)),
          Text(profile.handle,
              style: TextStyle(color: theme.subtextColor, fontSize: 13)),
          const SizedBox(height: 14),
          Text(profile.bio,
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.textColor, fontSize: 14)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _statItem('Followers', profile.followers, theme),
              _statItem('Following', profile.following, theme),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: theme.primaryColor.withValues(alpha: 0.1),
              border: Border.all(color: theme.primaryColor.withValues(alpha: 0.3)),
            ),
            child: Text(
              '🔍 Tap to investigate →',
              style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard(_Profile profile, AgeTierTheme theme) {
    return Container(
      key: const ValueKey('back'),
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: theme.cardColor,
        border: Border.all(
          color: profile.isFake
              ? const Color(0xFFFF4444).withValues(alpha: 0.5)
              : const Color(0xFF43E97B).withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profile.redFlags.isEmpty ? '🔍 Investigation Results' : '🚩 Red Flags Found!',
            style: TextStyle(
              color: profile.isFake
                  ? const Color(0xFFFF4444)
                  : const Color(0xFF43E97B),
              fontWeight: FontWeight.w800,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 16),
          if (profile.redFlags.isEmpty)
            Text(
              '✅ No obvious red flags found. Profile appears legitimate.',
              style: TextStyle(color: theme.textColor, fontSize: 14),
            )
          else
            ...profile.redFlags.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(f,
                    style: const TextStyle(
                        color: Color(0xFFFF6B6B), fontSize: 13)),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            'Tap to flip back',
            style: TextStyle(color: theme.subtextColor, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, int value, AgeTierTheme theme) {
    return Column(
      children: [
        Text(
          value > 999 ? '${(value / 1000).toStringAsFixed(1)}K' : '$value',
          style: TextStyle(
              color: theme.textColor, fontSize: 18, fontWeight: FontWeight.w800),
        ),
        Text(label, style: TextStyle(color: theme.subtextColor, fontSize: 12)),
      ],
    );
  }
}

class RotationYTransition extends AnimatedWidget {
  final Widget child;
  const RotationYTransition(
      {super.key, required Animation<double> turns, required this.child})
      : super(listenable: turns);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Transform(
      transform: Matrix4.rotationY(animation.value * 3.14),
      alignment: Alignment.center,
      child: child,
    );
  }
}
