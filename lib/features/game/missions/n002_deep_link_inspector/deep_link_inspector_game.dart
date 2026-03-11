import 'package:flutter/material.dart';
import '../../../../core/models/mission.dart';
import '../../../../core/models/user_session.dart';
import '../../../../core/theme/age_tier_theme.dart';
import '../../game_scaffold.dart';

class _UrlChallenge {
  final String displayUrl;
  final List<_UrlSegment> segments;
  final bool isMalicious;
  final String explanation;
  final String scenario;

  const _UrlChallenge({
    required this.displayUrl,
    required this.segments,
    required this.isMalicious,
    required this.explanation,
    required this.scenario,
  });
}

class _UrlSegment {
  final String text;
  final bool isDangerous;
  final String? tooltip;

  const _UrlSegment({
    required this.text,
    required this.isDangerous,
    this.tooltip,
  });
}

const List<_UrlChallenge> _challenges = [
  _UrlChallenge(
    displayUrl: 'paypa1.com/login?secure=true',
    scenario: 'You received an urgent email: "Your PayPal account is suspended!"',
    segments: [
      _UrlSegment(text: 'paypa', isDangerous: false),
      _UrlSegment(
        text: '1',
        isDangerous: true,
        tooltip: '⚠️ "1" not "l"! This is paypa1.com, NOT paypal.com',
      ),
      _UrlSegment(text: '.com/login?secure=true', isDangerous: false),
    ],
    isMalicious: true,
    explanation:
        'Classic typosquatting! The "l" in PayPal was replaced with "1". Always check domain spelling character by character.',
  ),
  _UrlChallenge(
    displayUrl: 'https://github.com/flutter/flutter',
    scenario: 'A developer friend shared this link to Flutter source code.',
    segments: [
      _UrlSegment(text: 'https://', isDangerous: false),
      _UrlSegment(text: 'github.com', isDangerous: false),
      _UrlSegment(text: '/flutter/flutter', isDangerous: false),
    ],
    isMalicious: false,
    explanation:
        'Safe! HTTPS, legitimate domain (github.com), clean path structure. No red flags.',
  ),
  _UrlChallenge(
    displayUrl: 'amazon.com.deals-today.ru/checkout',
    scenario: 'An SMS says "Your Amazon order needs verification — click now!"',
    segments: [
      _UrlSegment(text: 'amazon.com', isDangerous: false),
      _UrlSegment(
        text: '.deals-today',
        isDangerous: true,
        tooltip: '🚨 This is a SUBDOMAIN trick! The real domain is deals-today.ru',
      ),
      _UrlSegment(
        text: '.ru',
        isDangerous: true,
        tooltip: '🚨 .ru = Russia TLD. Amazon uses .com only.',
      ),
      _UrlSegment(text: '/checkout', isDangerous: false),
    ],
    isMalicious: true,
    explanation:
        'Subdomain spoofing! "amazon.com" is just a subdomain of deals-today.ru. The actual domain is the last one before the path.',
  ),
  _UrlChallenge(
    displayUrl: 'https://accounts.google.com/signin/v2/identifier',
    scenario: 'You need to sign in to your Google account.',
    segments: [
      _UrlSegment(text: 'https://', isDangerous: false),
      _UrlSegment(text: 'accounts.google.com', isDangerous: false),
      _UrlSegment(text: '/signin/v2/identifier', isDangerous: false),
    ],
    isMalicious: false,
    explanation:
        'Legitimate! accounts.google.com is an official Google subdomain. HTTPS is present. Path is standard.',
  ),
  _UrlChallenge(
    displayUrl: 'http://secure-banking-login.tk/chase/verify',
    scenario: 'An email says your Chase bank account requires immediate verification.',
    segments: [
      _UrlSegment(
        text: 'http://',
        isDangerous: true,
        tooltip: '⚠️ No HTTPS! Banks always use HTTPS.',
      ),
      _UrlSegment(
        text: 'secure-banking-login',
        isDangerous: true,
        tooltip: '🚨 Fake trust words in domain. Real domains are simple.',
      ),
      _UrlSegment(
        text: '.tk',
        isDangerous: true,
        tooltip: '🚨 .tk is a free domain — used by scammers constantly.',
      ),
      _UrlSegment(text: '/chase/verify', isDangerous: false),
    ],
    isMalicious: true,
    explanation:
        'Three red flags: HTTP (not HTTPS), fake "secure" keywords in domain, and .tk free TLD. Chase.com is the only real domain.',
  ),
];

class DeepLinkInspectorGame extends StatefulWidget {
  final Mission mission;
  final void Function(int score) onComplete;

  const DeepLinkInspectorGame({
    super.key,
    required this.mission,
    required this.onComplete,
  });

  @override
  State<DeepLinkInspectorGame> createState() =>
      _DeepLinkInspectorGameState();
}

class _DeepLinkInspectorGameState extends State<DeepLinkInspectorGame> {
  int _currentIndex = 0;
  int _score = 0;
  int _correct = 0;
  bool _showFeedback = false;
  bool? _lastCorrect;
  String? _selectedTooltip;
  bool _zoomed = false;

  void _answer(bool isMalicious) {
    if (_showFeedback) return;
    final challenge = _challenges[_currentIndex];
    final correct = challenge.isMalicious == isMalicious;
    setState(() {
      _lastCorrect = correct;
      _showFeedback = true;
      _zoomed = false;
      _selectedTooltip = null;
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
      if (_currentIndex < _challenges.length - 1) {
        _currentIndex++;
      } else {
        final finalScore = (_correct / _challenges.length * 100).round();
        widget.onComplete(finalScore);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AgeTierTheme.forTier(AgeTier.teens15_18);
    final challenge = _challenges[_currentIndex];

    return GameScaffold(
      mission: widget.mission,
      ageTier: AgeTier.teens15_18,
      score: _score,
      totalQuestions: _challenges.length,
      answeredQuestions: _currentIndex,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🔍 URL Inspector',
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            // Scenario
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: theme.cardColor,
                border: Border.all(
                    color: theme.primaryColor.withValues(alpha: 0.15), width: 1),
              ),
              child: Row(
                children: [
                  const Text('📧', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      challenge.scenario,
                      style: TextStyle(
                          color: theme.textColor, fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'INSPECT THE URL (tap segments to analyze):',
              style: TextStyle(
                color: theme.subtextColor,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            // URL display
            GestureDetector(
              onDoubleTap: () => setState(() => _zoomed = !_zoomed),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF050A14),
                  border: Border.all(
                    color: _zoomed
                        ? theme.primaryColor
                        : theme.primaryColor.withValues(alpha: 0.3),
                    width: _zoomed ? 2 : 1,
                  ),
                ),
                child: Wrap(
                  children: challenge.segments.map((seg) {
                    return GestureDetector(
                      onTap: seg.tooltip != null
                          ? () => setState(() =>
                              _selectedTooltip = _selectedTooltip == seg.tooltip
                                  ? null
                                  : seg.tooltip)
                          : null,
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: _zoomed ? 18 : 14,
                          fontWeight: FontWeight.w700,
                          color: seg.isDangerous
                              ? const Color(0xFFFF4444)
                              : const Color(0xFF00D4FF),
                          decoration: seg.isDangerous
                              ? TextDecoration.underline
                              : null,
                          decorationColor: const Color(0xFFFF4444),
                        ),
                        child: Text(seg.text),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Double-tap to zoom • Tap red segments for hints',
              style: TextStyle(color: theme.subtextColor, fontSize: 10),
            ),
            // Tooltip
            if (_selectedTooltip != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFFF4444).withValues(alpha: 0.1),
                    border: Border.all(
                        color: const Color(0xFFFF4444).withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    _selectedTooltip!,
                    style: const TextStyle(
                        color: Color(0xFFFF8080), fontSize: 13),
                  ),
                ),
              ),
            const Spacer(),
            // Feedback
            if (_showFeedback)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 12),
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
                  challenge.explanation,
                  style: TextStyle(
                    color: _lastCorrect == true
                        ? const Color(0xFF00D4FF)
                        : const Color(0xFFFF4444),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            // Action buttons
            Row(children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _answer(false),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: const Color(0xFF00D4FF).withValues(alpha: 0.10),
                      border: Border.all(color: const Color(0xFF00D4FF), width: 2),
                    ),
                    child: const Center(
                      child: Text('✅ Safe to Click',
                          style: TextStyle(
                              color: Color(0xFF00D4FF),
                              fontWeight: FontWeight.w700,
                              fontSize: 14)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => _answer(true),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: const Color(0xFFFF4444).withValues(alpha: 0.10),
                      border: Border.all(color: const Color(0xFFFF4444), width: 2),
                    ),
                    child: const Center(
                      child: Text('🚨 Malicious!',
                          style: TextStyle(
                              color: Color(0xFFFF4444),
                              fontWeight: FontWeight.w700,
                              fontSize: 14)),
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
}
