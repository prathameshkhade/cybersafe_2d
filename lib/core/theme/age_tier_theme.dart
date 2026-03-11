import 'package:flutter/material.dart';
import '../models/user_session.dart';

class AgeTierTheme {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color cardColor;
  final Color textColor;
  final Color subtextColor;
  final String fontFamily;
  final String backgroundEmoji;
  final List<Color> gradientColors;

  const AgeTierTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.cardColor,
    required this.textColor,
    required this.subtextColor,
    required this.fontFamily,
    required this.backgroundEmoji,
    required this.gradientColors,
  });

  static AgeTierTheme forTier(AgeTier tier) {
    switch (tier) {
      case AgeTier.kids7_10:
        return const AgeTierTheme(
          primaryColor: Color(0xFFFF6B35),
          secondaryColor: Color(0xFFFFD166),
          accentColor: Color(0xFF06D6A0),
          backgroundColor: Color(0xFFFFF8F0),
          cardColor: Color(0xFFFFFFFF),
          textColor: Color(0xFF2D3436),
          subtextColor: Color(0xFF636E72),
          fontFamily: 'Nunito',
          backgroundEmoji: '🌟',
          gradientColors: [Color(0xFFFF6B35), Color(0xFFFFD166)],
        );
      case AgeTier.tweens11_14:
        return const AgeTierTheme(
          primaryColor: Color(0xFF6C63FF),
          secondaryColor: Color(0xFFFF6584),
          accentColor: Color(0xFF43E97B),
          backgroundColor: Color(0xFF0F0F1A),
          cardColor: Color(0xFF1A1A2E),
          textColor: Color(0xFFE8E8FF),
          subtextColor: Color(0xFF9090C0),
          fontFamily: 'Rajdhani',
          backgroundEmoji: '⚡',
          gradientColors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
        );
      case AgeTier.teens15_18:
        return const AgeTierTheme(
          primaryColor: Color(0xFF00D4FF),
          secondaryColor: Color(0xFF0066FF),
          accentColor: Color(0xFFFF4444),
          backgroundColor: Color(0xFF050A14),
          cardColor: Color(0xFF0D1B2A),
          textColor: Color(0xFFE0F4FF),
          subtextColor: Color(0xFF6A8FAF),
          fontFamily: 'Share Tech Mono',
          backgroundEmoji: '🔐',
          gradientColors: [Color(0xFF00D4FF), Color(0xFF0066FF)],
        );
    }
  }

  ThemeData toThemeData() {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: cardColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
      ),
    );
  }
}
