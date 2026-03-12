import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/models/mission.dart';
import '../../../../core/models/user_session.dart';
import '../../../../core/theme/age_tier_theme.dart';
import '../../game_scaffold.dart';

class _ResponseStep {
  final String id;
  final String action;
  final String icon;
  final bool isCorrect;
  final int orderRank; // correct order: 1 = do first, higher = later, 0 = never do
  final String explanation;

  const _ResponseStep({
    required this.id,
    required this.action,
    required this.icon,
    required this.isCorrect,
    required this.orderRank,
    required this.explanation,
  });
}

class _Incident {
  final String title;
  final String scenario;
  final String emoji;
  final List<_ResponseStep> steps;
  final String debrief;

  const _Incident({
    required this.title,
    required this.scenario,
    required this.emoji,
    required this.steps,
    required this.debrief,
  });
}

const List<_Incident> _incidents = [
  _Incident(
    title: 'Account Compromised',
    scenario:
        'You get an email: "Your Instagram login was detected from Lagos, Nigeria." You didn\'t log in from there. Your account is being accessed right now. What do you do — and in what order?',
    emoji: '🔓',
    steps: [
      _ResponseStep(
        id: 'post',
        action: 'Post about it on your story so followers know',
        icon: '📢',
        isCorrect: false,
        orderRank: 0,
        explanation: 'WRONG — posting warns the attacker and wastes critical response time.',
      ),
      _ResponseStep(
        id: 'password',
        action: 'Change your password immediately',
        icon: '🔑',
        isCorrect: true,
        orderRank: 1,
        explanation: 'FIRST — changing the password immediately kicks the attacker out of active sessions.',
      ),
      _ResponseStep(
        id: '2fa',
        action: 'Enable 2FA on the account',
        icon: '🔐',
        isCorrect: true,
        orderRank: 2,
        explanation: 'SECOND — 2FA prevents re-entry even if they still have your old password.',
      ),
      _ResponseStep(
        id: 'apps',
        action: 'Check and revoke connected third-party apps',
        icon: '🔗',
        isCorrect: true,
        orderRank: 3,
        explanation: 'THIRD — attackers often grant themselves app access that survives a password change.',
      ),
      _ResponseStep(
        id: 'wait',
        action: 'Wait and see if anything bad actually happens',
        icon: '⏳',
        isCorrect: false,
        orderRank: 0,
        explanation: 'WRONG — every second of delay gives the attacker more time to lock you out permanently.',
      ),
      _ResponseStep(
        id: 'email',
        action: 'Secure the email account linked to this account',
        icon: '📧',
        isCorrect: true,
        orderRank: 4,
        explanation: 'FOURTH — your email is the master key. If it\'s compromised, all accounts can be taken.',
      ),
    ],
    debrief:
        'Correct order: Change password → Enable 2FA → Revoke apps → Secure email. Speed is critical — every minute counts when an account is actively compromised.',
  ),
  _Incident(
    title: 'Ransomware Warning',
    scenario:
        'Your school laptop screen suddenly shows: "ALL YOUR FILES ARE ENCRYPTED. Pay \$500 in Bitcoin within 48 hours or your files will be deleted forever." What do you do?',
    emoji: '💀',
    steps: [
      _ResponseStep(
        id: 'pay',
        action: 'Pay the \$500 ransom immediately',
        icon: '💸',
        isCorrect: false,
        orderRank: 0,
        explanation: 'WRONG — paying ransoms funds criminal organisations and doesn\'t guarantee file recovery.',
      ),
      _ResponseStep(
        id: 'disconnect',
        action: 'Disconnect from WiFi and unplug ethernet immediately',
        icon: '🔌',
        isCorrect: true,
        orderRank: 1,
        explanation: 'FIRST — isolating the device stops ransomware from spreading to other devices on the network.',
      ),
      _ResponseStep(
        id: 'report',
        action: 'Report to your school IT department immediately',
        icon: '🏫',
        isCorrect: true,
        orderRank: 2,
        explanation: 'SECOND — IT can isolate the threat, check other devices, and may have decryption tools.',
      ),
      _ResponseStep(
        id: 'screenshot',
        action: 'Take a photo of the ransomware screen as evidence',
        icon: '📸',
        isCorrect: true,
        orderRank: 3,
        explanation: 'THIRD — documentation helps IT and law enforcement identify the ransomware strain.',
      ),
      _ResponseStep(
        id: 'reboot',
        action: 'Restart the laptop to try to fix it',
        icon: '🔄',
        isCorrect: false,
        orderRank: 0,
        explanation: 'WRONG — rebooting can trigger additional encryption phases in some ransomware variants.',
      ),
      _ResponseStep(
        id: 'backup',
        action: 'Check if files exist in cloud backup or USB',
        icon: '☁️',
        isCorrect: true,
        orderRank: 4,
        explanation: 'FOURTH — if backups exist from before infection, you may be able to fully restore without paying.',
      ),
    ],
    debrief:
        'Correct order: Disconnect network → Report to IT → Document → Check backups. NEVER pay ransoms — it funds crime and rarely recovers files.',
  ),
  _Incident(
    title: 'Data Breach Notification',
    scenario:
        'You get an email from HaveIBeenPwned saying your email and password were found in a data breach from a gaming site you used 2 years ago. What do you do?',
    emoji: '🗄️',
    steps: [
      _ResponseStep(
        id: 'ignore',
        action: 'Ignore it — it\'s an old account, doesn\'t matter',
        icon: '🙈',
        isCorrect: false,
        orderRank: 0,
        explanation: 'WRONG — attackers use old breached passwords in "credential stuffing" attacks on your current accounts.',
      ),
      _ResponseStep(
        id: 'check_reuse',
        action: 'Identify every account that uses the same password',
        icon: '🔍',
        isCorrect: true,
        orderRank: 1,
        explanation: 'FIRST — password reuse is the biggest risk. You need to know the blast radius.',
      ),
      _ResponseStep(
        id: 'change_all',
        action: 'Change the password on every account that reused it',
        icon: '🔑',
        isCorrect: true,
        orderRank: 2,
        explanation: 'SECOND — change every reused password to a unique one, starting with email and banking.',
      ),
      _ResponseStep(
        id: 'password_manager',
        action: 'Set up a password manager for future unique passwords',
        icon: '🔐',
        isCorrect: true,
        orderRank: 3,
        explanation: 'THIRD — a password manager prevents reuse entirely by generating and storing unique passwords.',
      ),
      _ResponseStep(
        id: 'old_account',
        action: 'Delete the old gaming account that was breached',
        icon: '🗑️',
        isCorrect: true,
        orderRank: 4,
        explanation: 'FOURTH — deleting dormant accounts reduces your future attack surface.',
      ),
      _ResponseStep(
        id: 'blame',
        action: 'Post angry comments blaming the gaming site',
        icon: '😤',
        isCorrect: false,
        orderRank: 0,
        explanation: 'WRONG — this wastes time and doesn\'t protect your accounts.',
      ),
    ],
    debrief:
        'Correct order: Find reused passwords → Change them all → Use a password manager → Delete old accounts. Breaches from years ago still cause damage today through credential stuffing.',
  ),
];

class IncidentResponseGame extends StatefulWidget {
  final Mission mission;
  final void Function(int score) onComplete;

  const IncidentResponseGame({
    super.key,
    required this.mission,
    required this.onComplete,
  });

  @override
  State<IncidentResponseGame> createState() => _IncidentResponseGameState();
}

class _IncidentResponseGameState extends State<IncidentResponseGame> {
  int _currentIndex = 0;
  int _score = 0;
  int _timeLeft = 120;
  Timer? _timer;
  int _step = 0;

  // Per-incident state
  List<String> _selectedOrder = [];
  bool _submitted = false;
  bool? _lastCorrect;

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

  void _toggleStep(String stepId) {
    if (_submitted) return;
    setState(() {
      if (_selectedOrder.contains(stepId)) {
        _selectedOrder.remove(stepId);
      } else {
        _selectedOrder.add(stepId);
      }
    });
  }

  void _submitResponse() {
    if (_submitted || _selectedOrder.isEmpty) return;
    final incident = _incidents[_currentIndex];
    final correctSteps = incident.steps
        .where((s) => s.isCorrect)
        .toList()
      ..sort((a, b) => a.orderRank.compareTo(b.orderRank));
    final correctIds = correctSteps.map((s) => s.id).toList();

    // Score: points for each correct step selected, deduct for wrong ones
    int points = 0;
    for (final id in _selectedOrder) {
      final step = incident.steps.firstWhere((s) => s.id == id);
      if (step.isCorrect) {
        points += 6;
      } else {
        points -= 4;
      }
    }
    // Bonus if order matches correct order for first 3
    final selectedCorrect =
        _selectedOrder.where((id) => correctIds.contains(id)).toList();
    bool orderBonus = selectedCorrect.length >= 3 &&
        selectedCorrect[0] == correctIds[0] &&
        selectedCorrect[1] == correctIds[1];
    if (orderBonus) points += 8;

    final isCorrect = points > 0;

    setState(() {
      _submitted = true;
      _lastCorrect = isCorrect;
      _score = (_score + points.clamp(0, 30)).clamp(0, 100);
      if (isCorrect) _correct++;
      _step++;
    });

    Future.delayed(const Duration(milliseconds: 2600), _next);
  }

  int _correct = 0;

  void _next() {
    if (!mounted) return;
    setState(() {
      _submitted = false;
      _selectedOrder = [];
      _lastCorrect = null;
      if (_currentIndex < _incidents.length - 1) {
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
    final incident = _incidents[_currentIndex];

    return GameScaffold(
      mission: widget.mission,
      ageTier: AgeTier.teens15_18,
      score: _score,
      totalQuestions: _incidents.length,
      answeredQuestions: _step,
      timeLeft: _timeLeft,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Text(incident.emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🛡️ INCIDENT RESPONSE',
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        incident.title,
                        style: TextStyle(
                          color: theme.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Scenario
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: theme.cardColor,
                border: Border.all(
                    color: const Color(0xFFFF4444).withValues(alpha: 0.35),
                    width: 1.5),
              ),
              child: Text(
                incident.scenario,
                style: TextStyle(
                    color: theme.textColor, fontSize: 13, height: 1.6),
              ),
            ),
            const SizedBox(height: 12),

            Text(
              _submitted
                  ? 'CORRECT ORDER:'
                  : 'TAP ACTIONS IN THE CORRECT ORDER:',
              style: TextStyle(
                color: theme.subtextColor,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),

            // Action steps
            ...incident.steps.map((step) {
              final selected = _selectedOrder.contains(step.id);
              final orderIndex = _selectedOrder.indexOf(step.id);
              Color borderColor = theme.primaryColor.withValues(alpha: 0.2);
              Color bgColor = theme.cardColor;
              String? badge;

              if (_submitted) {
                if (step.isCorrect) {
                  borderColor = const Color(0xFF43E97B);
                  bgColor = const Color(0xFF43E97B).withValues(alpha: 0.08);
                  badge = '✅';
                } else if (selected) {
                  borderColor = const Color(0xFFFF4444);
                  bgColor = const Color(0xFFFF4444).withValues(alpha: 0.08);
                  badge = '❌';
                }
              } else if (selected) {
                borderColor = theme.primaryColor;
                bgColor = theme.primaryColor.withValues(alpha: 0.1);
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: _submitted ? null : () => _toggleStep(step.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: bgColor,
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        // Order badge
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected && !_submitted
                                ? theme.primaryColor
                                : theme.primaryColor.withValues(alpha: 0.15),
                          ),
                          child: Center(
                            child: Text(
                              selected && !_submitted
                                  ? '${orderIndex + 1}'
                                  : step.icon,
                              style: TextStyle(
                                color: selected && !_submitted
                                    ? Colors.white
                                    : theme.textColor,
                                fontSize: selected && !_submitted ? 12 : 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step.action,
                                style: TextStyle(
                                  color: theme.textColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (_submitted)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    step.explanation,
                                    style: TextStyle(
                                      color: step.isCorrect
                                          ? const Color(0xFF43E97B)
                                          : const Color(0xFFFF6584),
                                      fontSize: 11,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (badge != null)
                          Text(badge, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 8),

            // Debrief after submit
            if (_submitted) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _lastCorrect == true
                      ? const Color(0xFF00D4FF).withValues(alpha: 0.08)
                      : const Color(0xFFFF4444).withValues(alpha: 0.08),
                  border: Border.all(
                    color: _lastCorrect == true
                        ? const Color(0xFF00D4FF)
                        : const Color(0xFFFF4444),
                  ),
                ),
                child: Text(
                  '💡 ${incident.debrief}',
                  style: TextStyle(
                    color: _lastCorrect == true
                        ? const Color(0xFF00D4FF)
                        : const Color(0xFFFF6584),
                    fontSize: 12,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Submit button
            if (!_submitted)
              GestureDetector(
                onTap: _selectedOrder.isEmpty ? null : _submitResponse,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: _selectedOrder.isEmpty
                        ? theme.primaryColor.withValues(alpha: 0.1)
                        : theme.primaryColor.withValues(alpha: 0.2),
                    border: Border.all(
                      color: _selectedOrder.isEmpty
                          ? theme.primaryColor.withValues(alpha: 0.3)
                          : theme.primaryColor,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _selectedOrder.isEmpty
                          ? 'Select your response steps above'
                          : '🛡️ SUBMIT RESPONSE (${_selectedOrder.length} selected)',
                      style: TextStyle(
                        color: _selectedOrder.isEmpty
                            ? theme.subtextColor
                            : theme.primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}