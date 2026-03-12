import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/models/mission.dart';
import '../../../../core/models/user_session.dart';
import '../../../../core/theme/age_tier_theme.dart';
import '../../game_scaffold.dart';

class _ProfileDetail {
  final String label;
  final String value;
  final String icon;
  final bool isDangerous;
  final String explanation;

  const _ProfileDetail({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDangerous,
    required this.explanation,
  });
}

class _OsintProfile {
  final String name;
  final String handle;
  final String avatar;
  final String bio;
  final List<_ProfileDetail> details;
  final List<String> combinedRisks;
  final String verdict;

  const _OsintProfile({
    required this.name,
    required this.handle,
    required this.avatar,
    required this.bio,
    required this.details,
    required this.combinedRisks,
    required this.verdict,
  });
}

const List<_OsintProfile> _profiles = [
  _OsintProfile(
    name: 'Jordan Lee',
    handle: '@jordanlee_life',
    avatar: '🧑',
    bio: 'Year 10 @ Westside High 🏫 | Football captain ⚽ | Lives in Riverside, CA',
    details: [
      _ProfileDetail(
        label: 'School',
        value: 'Westside High School',
        icon: '🏫',
        isDangerous: true,
        explanation: 'School name narrows your location to a specific neighbourhood instantly.',
      ),
      _ProfileDetail(
        label: 'Sport + Schedule',
        value: 'Football captain — practice every Tuesday & Thursday 4pm',
        icon: '⚽',
        isDangerous: true,
        explanation: 'Your sport schedule tells strangers exactly where you\'ll be and when.',
      ),
      _ProfileDetail(
        label: 'Location Tag',
        value: 'Riverside, CA',
        icon: '📍',
        isDangerous: true,
        explanation: 'City + school + sport = a stalker can find you within a few streets.',
      ),
      _ProfileDetail(
        label: 'Profile Photo',
        value: 'Wearing school uniform with badge visible',
        icon: '📸',
        isDangerous: true,
        explanation: 'School badge in photos can be searched to find the exact school address.',
      ),
      _ProfileDetail(
        label: 'Followers',
        value: '847 followers, public profile',
        icon: '👥',
        isDangerous: false,
        explanation: 'Follower count alone isn\'t dangerous, but a public profile means anyone can see all this.',
      ),
    ],
    combinedRisks: [
      '🏫 + 📍 = Someone knows your school address',
      '⚽ + 🕐 = Someone knows where you\'ll be Tuesday at 4pm',
      '📸 + 🏫 = School badge visible — searchable',
      'All 4 combined = Full location triangulation in minutes',
    ],
    verdict: 'HIGH RISK — 4 pieces of info combined allow complete location triangulation. Set profile to private and remove school name and schedule.',
  ),
  _OsintProfile(
    name: 'Alex Chen',
    handle: '@alexchen_dev',
    avatar: '👩‍💻',
    bio: 'CS student 💻 | Coffee addict ☕ | Into hiking and coding',
    details: [
      _ProfileDetail(
        label: 'Field of study',
        value: 'Computer Science student',
        icon: '💻',
        isDangerous: false,
        explanation: 'General field of study without a specific university name is low risk.',
      ),
      _ProfileDetail(
        label: 'Hobbies',
        value: 'Hiking and coding',
        icon: '🥾',
        isDangerous: false,
        explanation: 'Generic hobbies shared by millions — not enough to identify or locate you.',
      ),
      _ProfileDetail(
        label: 'Profile visibility',
        value: 'Private — 312 followers',
        icon: '🔒',
        isDangerous: false,
        explanation: 'Private profile means only approved followers can see posts. Good practice!',
      ),
      _ProfileDetail(
        label: 'Photos',
        value: 'Landscape and coffee shop photos, no location tags',
        icon: '🖼️',
        isDangerous: false,
        explanation: 'No location tags and no identifying landmarks in photos — safe.',
      ),
    ],
    combinedRisks: [
      '✅ No school or employer name visible',
      '✅ No location or neighbourhood info',
      '✅ Private account — strangers can\'t see posts',
      '✅ No schedule or routine information',
    ],
    verdict: 'LOW RISK — This profile is well managed. No location, no schedule, private account. Good digital hygiene!',
  ),
  _OsintProfile(
    name: 'Sam Rivera',
    handle: '@sam_rivera_real',
    avatar: '🧒',
    bio: 'Just moved to 42 Oakwood Ave! New city, new start 🌆 | Barista at Central Brew ☕',
    details: [
      _ProfileDetail(
        label: 'Home address',
        value: '42 Oakwood Ave (posted in bio)',
        icon: '🏠',
        isDangerous: true,
        explanation: 'A full street address in a bio is one of the most dangerous things you can post — anyone can find your home.',
      ),
      _ProfileDetail(
        label: 'Workplace',
        value: 'Barista at Central Brew',
        icon: '☕',
        isDangerous: true,
        explanation: 'Named workplace = someone knows where you work, your shifts, and your commute route.',
      ),
      _ProfileDetail(
        label: 'Life event',
        value: '"Just moved" — signals you\'re alone and new to the area',
        icon: '📦',
        isDangerous: true,
        explanation: 'Announcing you just moved tells bad actors you\'re isolated and unfamiliar with your surroundings.',
      ),
      _ProfileDetail(
        label: 'Profile photo',
        value: 'Selfie outside new apartment building',
        icon: '📸',
        isDangerous: true,
        explanation: 'Apartment building exterior in photos can be reverse-image-searched to find the exact building.',
      ),
    ],
    combinedRisks: [
      '🏠 Street address posted openly in bio',
      '☕ Workplace name = daily location and schedule',
      '📦 "Just moved" = isolated and unfamiliar',
      '📸 Building photo = address confirmable via reverse image search',
    ],
    verdict: 'CRITICAL RISK — Home address and workplace are both public. Remove immediately. Never post your address or exact workplace publicly.',
  ),
];

class OsintScannerGame extends StatefulWidget {
  final Mission mission;
  final void Function(int score) onComplete;

  const OsintScannerGame({
    super.key,
    required this.mission,
    required this.onComplete,
  });

  @override
  State<OsintScannerGame> createState() => _OsintScannerGameState();
}

class _OsintScannerGameState extends State<OsintScannerGame> {
  int _currentIndex = 0;
  int _score = 0;
  int _correct = 0;
  Set<int> _tappedDetails = {};
  bool _showCombinedRisks = false;
  bool _verdictSubmitted = false;
  bool? _lastCorrect;
  int _timeLeft = 120;
  Timer? _timer;
  int _step = 0;

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
            if (mounted) widget.onComplete(_score.clamp(0, 100));
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

  void _tapDetail(int index) {
    if (_verdictSubmitted) return;
    setState(() => _tappedDetails.add(index));
    // Show combined risks panel once 2+ dangerous ones are tapped
    final profile = _profiles[_currentIndex];
    final dangerousTapped = _tappedDetails
        .where((i) => profile.details[i].isDangerous)
        .length;
    if (dangerousTapped >= 2 && !_showCombinedRisks) {
      setState(() => _showCombinedRisks = true);
    }
  }

  void _submitRiskLevel(bool markedHighRisk) {
    if (_verdictSubmitted) return;
    final profile = _profiles[_currentIndex];
    final actuallyHighRisk =
        profile.details.where((d) => d.isDangerous).length >= 2;
    final isCorrect = actuallyHighRisk == markedHighRisk;

    // Bonus for tapping dangerous details
    final dangerousTapped = _tappedDetails
        .where((i) => profile.details[i].isDangerous)
        .length;
    final bonus = dangerousTapped * 4;

    setState(() {
      _verdictSubmitted = true;
      _lastCorrect = isCorrect;
      if (isCorrect) {
        _score = (_score + 25 + bonus).clamp(0, 100);
        _correct++;
      }
      _step++;
    });

    Future.delayed(const Duration(milliseconds: 2800), _next);
  }

  void _next() {
    if (!mounted) return;
    setState(() {
      _verdictSubmitted = false;
      _tappedDetails = {};
      _showCombinedRisks = false;
      _lastCorrect = null;
      if (_currentIndex < _profiles.length - 1) {
        _currentIndex++;
      } else {
        _timer?.cancel();
        widget.onComplete(_score.clamp(0, 100));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AgeTierTheme.forTier(AgeTier.teens15_18);
    final profile = _profiles[_currentIndex];

    return GameScaffold(
      mission: widget.mission,
      ageTier: AgeTier.teens15_18,
      score: _score,
      totalQuestions: _profiles.length,
      answeredQuestions: _step,
      timeLeft: _timeLeft,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🕵️ OSINT EXPOSURE SCANNER',
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap dangerous info pieces, then rate the risk level.',
              style: TextStyle(color: theme.subtextColor, fontSize: 12),
            ),
            const SizedBox(height: 14),

            // Profile card
            _buildProfileCard(profile, theme),
            const SizedBox(height: 12),

            // Detail chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile.details.asMap().entries.map((entry) {
                final i = entry.key;
                final detail = entry.value;
                final tapped = _tappedDetails.contains(i);
                Color chipColor = tapped
                    ? (detail.isDangerous
                        ? const Color(0xFFFF4444)
                        : const Color(0xFF43E97B))
                    : theme.primaryColor.withValues(alpha: 0.5);
                return GestureDetector(
                  onTap: _verdictSubmitted ? null : () => _tapDetail(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: chipColor.withValues(alpha: 0.12),
                      border: Border.all(color: chipColor, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(detail.icon,
                            style: const TextStyle(fontSize: 13)),
                        const SizedBox(width: 5),
                        Text(
                          detail.label,
                          style: TextStyle(
                            color: tapped ? chipColor : theme.textColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (tapped) ...[
                          const SizedBox(width: 4),
                          Text(
                            detail.isDangerous ? '⚠️' : '✅',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            // Explanation for tapped detail
            if (_tappedDetails.isNotEmpty && !_verdictSubmitted) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: theme.cardColor,
                  border: Border.all(
                      color: theme.primaryColor.withValues(alpha: 0.2)),
                ),
                child: Text(
                  profile.details[_tappedDetails.last].explanation,
                  style: TextStyle(
                      color: theme.subtextColor,
                      fontSize: 11,
                      height: 1.5),
                ),
              ),
            ],

            // Combined risks panel
            if (_showCombinedRisks) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFFF4444).withValues(alpha: 0.07),
                  border: Border.all(
                      color: const Color(0xFFFF4444).withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🔗 COMBINED EXPOSURE RISKS',
                      style: TextStyle(
                        color: Color(0xFFFF4444),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...profile.combinedRisks.map((risk) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            risk,
                            style: TextStyle(
                                color: theme.textColor,
                                fontSize: 11,
                                height: 1.4),
                          ),
                        )),
                  ],
                ),
              ),
            ],

            // Verdict feedback
            if (_verdictSubmitted) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _lastCorrect == true
                      ? const Color(0xFF00D4FF).withValues(alpha: 0.1)
                      : const Color(0xFFFF4444).withValues(alpha: 0.1),
                  border: Border.all(
                    color: _lastCorrect == true
                        ? const Color(0xFF00D4FF)
                        : const Color(0xFFFF4444),
                  ),
                ),
                child: Text(
                  profile.verdict,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _lastCorrect == true
                        ? const Color(0xFF00D4FF)
                        : const Color(0xFFFF4444),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Risk level buttons
            if (!_verdictSubmitted)
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _submitRiskLevel(false),
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: const Color(0xFF43E97B).withValues(alpha: 0.12),
                          border: Border.all(
                              color: const Color(0xFF43E97B), width: 2),
                        ),
                        child: const Center(
                          child: Text('🟢 LOW RISK',
                              style: TextStyle(
                                  color: Color(0xFF43E97B),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _submitRiskLevel(true),
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: const Color(0xFFFF4444).withValues(alpha: 0.12),
                          border: Border.all(
                              color: const Color(0xFFFF4444), width: 2),
                        ),
                        child: const Center(
                          child: Text('🔴 HIGH RISK',
                              style: TextStyle(
                                  color: Color(0xFFFF4444),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(_OsintProfile profile, AgeTierTheme theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.cardColor,
        border: Border.all(
            color: theme.primaryColor.withValues(alpha: 0.2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [theme.primaryColor, theme.secondaryColor],
                  ),
                ),
                child: Center(
                  child:
                      Text(profile.avatar, style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: TextStyle(
                        color: theme.textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      profile.handle,
                      style:
                          TextStyle(color: theme.subtextColor, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: theme.primaryColor.withValues(alpha: 0.1),
                ),
                child: Text(
                  'PUBLIC',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: theme.backgroundColor.withValues(alpha: 0.5),
            ),
            child: Text(
              profile.bio,
              style: TextStyle(
                  color: theme.textColor, fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}