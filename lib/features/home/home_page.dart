import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/bloc/session_bloc.dart';
import '../../core/bloc/session_event.dart';
import '../../core/models/user_session.dart';
import '../../core/constants/app_constants.dart';
import '../dashboard/dashboard_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  AgeTier? _selectedTier;
  String? _usernameError;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic);
    _animController.forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _animController.dispose();
    super.dispose();
  }

  bool get _canStart =>
      _usernameError == null &&
      _usernameController.text.length >= AppConstants.usernameMinLength &&
      _selectedTier != null;

  void _validateUsername(String value) {
    final regex = RegExp(AppConstants.usernamePattern);
    setState(() {
      if (value.length < AppConstants.usernameMinLength) {
        _usernameError =
            'At least ${AppConstants.usernameMinLength} characters required';
      } else if (value.length > AppConstants.usernameMaxLength) {
        _usernameError =
            'Max ${AppConstants.usernameMaxLength} characters allowed';
      } else if (!regex.hasMatch(value)) {
        _usernameError = 'Only letters, numbers and underscore allowed';
      } else {
        _usernameError = null;
      }
    });
  }

  void _startAdventure() {
    if (!_canStart) return;
    context.read<SessionBloc>().add(SetUserEvent(
          username: _usernameController.text.trim(),
          ageTier: _selectedTier!,
        ));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const DashboardPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D1B2A), Color(0xFF1B2838), Color(0xFF0D2137)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildUsernameField(),
                  const SizedBox(height: 32),
                  _buildAgeTierSection(),
                  const SizedBox(height: 40),
                  _buildStartButton(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF00D4FF), Color(0xFF0066FF)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00D4FF).withValues(alpha: 0.4),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Center(
            child: Text('🛡️', style: TextStyle(fontSize: 50)),
          ),
        ),
        const SizedBox(height: 20),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF00D4FF), Color(0xFF6C63FF)],
          ).createShader(bounds),
          child: const Text(
            'CyberSafe 2D',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Age-Based Cybersecurity Awareness',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF6A8FAF),
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CHOOSE YOUR HERO NAME',
          style: TextStyle(
            color: Color(0xFF00D4FF),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _usernameController,
          onChanged: _validateUsername,
          maxLength: AppConstants.usernameMaxLength,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Enter your cool username...',
            hintStyle: const TextStyle(color: Color(0xFF3A5570)),
            counterText: '',
            errorText: _usernameError,
            errorStyle: const TextStyle(color: Color(0xFFFF4444)),
            prefixIcon:
                const Icon(Icons.person_outline, color: Color(0xFF00D4FF)),
            filled: true,
            fillColor: const Color(0xFF0D1B2A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: Color(0xFF1E3A5F), width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: Color(0xFF1E3A5F), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: Color(0xFF00D4FF), width: 2.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: Color(0xFFFF4444), width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: Color(0xFFFF4444), width: 2.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgeTierSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SELECT YOUR AGE TIER',
          style: TextStyle(
            color: Color(0xFF00D4FF),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 14),
        ...AgeTier.values.map((tier) => _buildTierCard(tier)),
      ],
    );
  }

  Widget _buildTierCard(AgeTier tier) {
    final isSelected = _selectedTier == tier;
    final colors = _tierColors(tier);

    return GestureDetector(
      onTap: () => setState(() => _selectedTier = tier),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? colors[0].withValues(alpha: 0.15)
              : const Color(0xFF0D1B2A),
          border: Border.all(
            color: isSelected ? colors[0] : const Color(0xFF1E3A5F),
            width: isSelected ? 2.0 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 16,
                    spreadRadius: 1,
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: colors),
              ),
              child: Center(
                child: Text(tier.emoji, style: const TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tier.label,
                    style: TextStyle(
                      color: isSelected ? colors[0] : Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tier.description,
                    style: const TextStyle(
                      color: Color(0xFF6A8FAF),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: colors[0], size: 24),
          ],
        ),
      ),
    );
  }

  List<Color> _tierColors(AgeTier tier) {
    switch (tier) {
      case AgeTier.kids7_10:
        return [const Color(0xFFFF6B35), const Color(0xFFFFD166)];
      case AgeTier.tweens11_14:
        return [const Color(0xFF6C63FF), const Color(0xFFFF6584)];
      case AgeTier.teens15_18:
        return [const Color(0xFF00D4FF), const Color(0xFF0066FF)];
    }
  }

  Widget _buildStartButton() {
    return AnimatedOpacity(
      opacity: _canStart ? 1.0 : 0.4,
      duration: const Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: _canStart ? _startAdventure : null,
        child: Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: _canStart
                ? const LinearGradient(
                    colors: [Color(0xFF00D4FF), Color(0xFF0066FF)],
                  )
                : const LinearGradient(
                    colors: [Color(0xFF2A3A4A), Color(0xFF1E2A3A)],
                  ),
            boxShadow: _canStart
                ? [
                    BoxShadow(
                      color: const Color(0xFF00D4FF).withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 1,
                    )
                  ]
                : [],
          ),
          child: const Center(
            child: Text(
              '🚀  Start My Cyber Adventure',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
