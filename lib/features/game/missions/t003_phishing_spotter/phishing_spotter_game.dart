import 'package:flutter/material.dart';
import '../../../../core/models/mission.dart';
import '../../../../core/models/user_session.dart';
import '../../../../core/theme/age_tier_theme.dart';
import '../../game_scaffold.dart';

class _RedFlag {
  final String label;
  final Offset position; // relative 0.0–1.0 position on the email
  final String explanation;

  const _RedFlag({
    required this.label,
    required this.position,
    required this.explanation,
  });
}

class _PhishingEmail {
  final String fromName;
  final String fromAddress;
  final String subject;
  final String body;
  final bool isPhishing;
  final List<_RedFlag> redFlags;
  final String verdict;

  const _PhishingEmail({
    required this.fromName,
    required this.fromAddress,
    required this.subject,
    required this.body,
    required this.isPhishing,
    required this.redFlags,
    required this.verdict,
  });
}

const List<_PhishingEmail> _emails = [
  _PhishingEmail(
    fromName: 'PayPal Security',
    fromAddress: 'security@paypa1-alert.com',
    subject: '⚠️ URGENT: Your account will be suspended!',
    body:
        'Dear Valued Customer,\n\nWe have detected suspicious activity on your account. '
        'You must verify your details IMMEDIATELY or your account will be permanently closed within 24 hours.\n\n'
        'Click here to verify: http://paypa1-secure.xyz/verify\n\nPayPal Team',
    isPhishing: true,
    redFlags: [
      _RedFlag(
          label: 'Fake domain\n@paypa1-alert.com',
          position: Offset(0.5, 0.08),
          explanation: 'Real PayPal always sends from @paypal.com — the "1" instead of "l" is a trick!'),
      _RedFlag(
          label: 'Urgency tactics\n"IMMEDIATELY"',
          position: Offset(0.5, 0.42),
          explanation: 'Phishing emails create fake urgency to panic you into clicking without thinking!'),
      _RedFlag(
          label: 'Suspicious link\npaypa1-secure.xyz',
          position: Offset(0.5, 0.68),
          explanation: 'The link domain doesn\'t match PayPal at all — it\'s a fake site to steal your login!'),
    ],
    verdict: 'PHISHING! 3 red flags: fake sender, urgency language, and suspicious link.',
  ),
  _PhishingEmail(
    fromName: 'Spotify',
    fromAddress: 'no-reply@spotify.com',
    subject: 'Your January Wrapped is here! 🎵',
    body:
        'Hi there,\n\nYour 2024 Spotify Wrapped is ready! '
        'See your top songs, artists and podcasts from this year.\n\n'
        'Open Spotify to see your Wrapped →\n\nThe Spotify Team',
    isPhishing: false,
    redFlags: [],
    verdict: 'SAFE! Legit sender, no urgency, no suspicious links, no requests for personal info.',
  ),
  _PhishingEmail(
    fromName: 'School IT Support',
    fromAddress: 'it-support@sch00l-helpdesk.net',
    subject: 'Reset your school password NOW',
    body:
        'Hello Student,\n\nYour school account password expires today. '
        'You must reset it immediately using the link below or you will lose access to all school systems.\n\n'
        'Reset password: http://bit.ly/school-reset-2024\n\nIT Department',
    isPhishing: true,
    redFlags: [
      _RedFlag(
          label: 'Sketchy domain\n@sch00l-helpdesk.net',
          position: Offset(0.5, 0.08),
          explanation: 'Your school IT would use your actual school\'s domain, not a random .net address!'),
      _RedFlag(
          label: 'Shortened link\nbit.ly/...',
          position: Offset(0.5, 0.65),
          explanation: 'Shortened links hide the real destination — IT departments always use full, official URLs!'),
    ],
    verdict: 'PHISHING! Fake school domain and a suspicious shortened link are dead giveaways.',
  ),
  _PhishingEmail(
    fromName: 'YouTube',
    fromAddress: 'noreply@youtube.com',
    subject: 'New comment on your video',
    body:
        'Hi,\n\nSomeone commented on your video "My vlog #3":\n\n'
        '"Great video! Keep it up 🔥"\n\n'
        'Reply to this comment in YouTube Studio.\n\nThe YouTube Team',
    isPhishing: false,
    redFlags: [],
    verdict: 'SAFE! Official YouTube domain, no urgent demands, and a simple notification.',
  ),
  _PhishingEmail(
    fromName: 'Amazon Prize Team',
    fromAddress: 'winner@amazon-giveaway-2024.com',
    subject: 'You have been selected as our LUCKY WINNER 🎉',
    body:
        'Congratulations!\n\nYou have been randomly selected to receive a FREE Amazon Gift Card worth \$500! '
        'This is exclusively for loyal Amazon customers.\n\n'
        'To claim your prize, reply with your: Full name, Address, Date of birth, and Credit card number for verification.\n\n'
        'Offer expires in 2 hours!',
    isPhishing: true,
    redFlags: [
      _RedFlag(
          label: 'Not amazon.com\namazon-giveaway-2024.com',
          position: Offset(0.5, 0.08),
          explanation: 'Amazon only emails from amazon.com — any other domain is fake!'),
      _RedFlag(
          label: 'Asks for credit card\n"for verification"',
          position: Offset(0.5, 0.62),
          explanation: 'No legitimate prize requires your credit card number to "verify" — this is theft!'),
      _RedFlag(
          label: 'Fake deadline\n"expires in 2 hours"',
          position: Offset(0.5, 0.78),
          explanation: 'Fake deadlines are pressure tactics to stop you from thinking clearly!'),
    ],
    verdict: 'PHISHING! Fake domain, requests personal+financial data, and an artificial deadline.',
  ),
];

class PhishingSpotterGame extends StatefulWidget {
  final Mission mission;
  final void Function(int score) onComplete;

  const PhishingSpotterGame({
    super.key,
    required this.mission,
    required this.onComplete,
  });

  @override
  State<PhishingSpotterGame> createState() => _PhishingSpotterGameState();
}

class _PhishingSpotterGameState extends State<PhishingSpotterGame>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _score = 0;
  int _correct = 0;
  bool _showFeedback = false;
  bool? _lastCorrect;
  String? _feedbackText;
  Set<int> _tappedFlags = {};
  bool _verdictRevealed = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _pulseAnim = Tween(begin: 0.85, end: 1.0).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _tapFlag(int index) {
    if (_verdictRevealed) return;
    setState(() => _tappedFlags.add(index));
  }

  void _submitVerdict(bool markedPhishing) {
    if (_showFeedback) return;
    final email = _emails[_currentIndex];
    final isCorrect = email.isPhishing == markedPhishing;
    // Bonus points for tapping red flags on phishing emails
    int bonus = 0;
    if (email.isPhishing) {
      bonus = _tappedFlags.length * 3;
    }
    setState(() {
      _lastCorrect = isCorrect;
      _verdictRevealed = true;
      _feedbackText = isCorrect
          ? '✅ ${email.verdict}'
          : '❌ ${email.verdict}';
      _showFeedback = true;
      if (isCorrect) {
        _score += 10 + bonus;
        _correct++;
      }
    });
    Future.delayed(const Duration(milliseconds: 2200), _next);
  }

  void _next() {
    if (!mounted) return;
    setState(() {
      _showFeedback = false;
      _verdictRevealed = false;
      _tappedFlags = {};
      if (_currentIndex < _emails.length - 1) {
        _currentIndex++;
      } else {
        final finalScore = (_correct / _emails.length * 100).round();
        widget.onComplete(finalScore);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AgeTierTheme.forTier(AgeTier.tweens11_14);
    final email = _emails[_currentIndex];

    return GameScaffold(
      mission: widget.mission,
      ageTier: AgeTier.tweens11_14,
      score: _score,
      totalQuestions: _emails.length,
      answeredQuestions: _currentIndex,
      child: Column(
        children: [
          Padding(\
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                Text(
                  '📧 Phishing or Legit?',
                  style: TextStyle(
                    color: theme.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  email.isPhishing
                      ? '🔍 Tap the red flags you spot, then give your verdict!'
                      : '🔍 Read carefully, then give your verdict!',
                  style: TextStyle(color: theme.subtextColor, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Email card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildEmailCard(email, theme),
            ),
          ),

          // Feedback
          if (_showFeedback)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                  ),
                ),
              ),
            ),

          // Verdict buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _showFeedback ? null : () => _submitVerdict(true),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: const Color(0xFFFF4444).withValues(alpha: 0.15),
                        border: Border.all(
                            color: const Color(0xFFFF4444), width: 2),
                      ),
                      child: const Center(
                        child: Text('🎣 PHISHING',
                            style: TextStyle(
                                color: Color(0xFFFF4444),
                                fontWeight: FontWeight.w800,
                                fontSize: 15)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: _showFeedback ? null : () => _submitVerdict(false),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: const Color(0xFF43E97B).withValues(alpha: 0.15),
                        border: Border.all(
                            color: const Color(0xFF43E97B), width: 2),
                      ),
                      child: const Center(
                        child: Text('✅ LEGIT',
                            style: TextStyle(
                                color: Color(0xFF43E97B),
                                fontWeight: FontWeight.w800,
                                fontSize: 15)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailCard(_PhishingEmail email, AgeTierTheme theme) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.cardColor,
        border: Border.all(
            color: theme.primaryColor.withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: theme.backgroundColor.withValues(alpha: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _emailRow('From', '${email.fromName} <${email.fromAddress}>', theme),
                  const SizedBox(height: 6),
                  _emailRow('Subject', email.subject, theme),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Email body
            Text(
              email.body,
              style: TextStyle(
                color: theme.textColor,
                fontSize: 13,
                height: 1.6,
              ),
            ),
            // Red flag tap targets (only shown for phishing emails)
            if (email.isPhishing && !_verdictRevealed) ...[
              const SizedBox(height: 16),
              Text(
                '👆 Tap the suspicious parts above!',
                style: TextStyle(
                    color: theme.subtextColor,
                    fontSize: 11,
                    fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: email.redFlags.asMap().entries.map((entry) {
                  final i = entry.key;
                  final flag = entry.value;
                  final tapped = _tappedFlags.contains(i);
                  return GestureDetector(
                    onTap: () => _tapFlag(i),
                    child: AnimatedBuilder(
                      animation: _pulseAnim,
                      builder: (_, child) => Transform.scale(
                        scale: tapped ? 1.0 : _pulseAnim.value,
                        child: child,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: tapped
                              ? const Color(0xFFFF4444).withValues(alpha: 0.2)
                              : theme.primaryColor.withValues(alpha: 0.1),
                          border: Border.all(
                            color: tapped
                                ? const Color(0xFFFF4444)
                                : theme.primaryColor.withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(tapped ? '🚩' : '🔍',
                                style: const TextStyle(fontSize: 12)),
                            const SizedBox(width: 4),
                            Text(
                              flag.label.split('\n')[0],
                              style: TextStyle(
                                color: tapped
                                    ? const Color(0xFFFF4444)
                                    : theme.subtextColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            // Show explanations after verdict
            if (_verdictRevealed && email.isPhishing) ...[
              const SizedBox(height: 12),
              ...email.redFlags.map((flag) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFFF4444).withValues(alpha: 0.08),
                        border: Border.all(
                            color:
                                const Color(0xFFFF4444).withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('🚩 ', style: TextStyle(fontSize: 12)),
                          Expanded(
                            child: Text(
                              flag.explanation,
                              style: const TextStyle(
                                  color: Color(0xFFFF6584),
                                  fontSize: 11,
                                  height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _emailRow(String label, String value, AgeTierTheme theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 52,
          child: Text(
            '$label:',
            style: TextStyle(
              color: theme.subtextColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: theme.textColor,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}