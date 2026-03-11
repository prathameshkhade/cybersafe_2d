import 'package:equatable/equatable.dart';

enum AgeTier { kids7_10, tweens11_14, teens15_18 }

extension AgeTierExtension on AgeTier {
  String get label {
    switch (this) {
      case AgeTier.kids7_10:
        return '7–10 Years';
      case AgeTier.tweens11_14:
        return '11–14 Years';
      case AgeTier.teens15_18:
        return '15–18 Years';
    }
  }

  String get emoji {
    switch (this) {
      case AgeTier.kids7_10:
        return '🌟';
      case AgeTier.tweens11_14:
        return '⚡';
      case AgeTier.teens15_18:
        return '🔐';
    }
  }

  String get description {
    switch (this) {
      case AgeTier.kids7_10:
        return 'Cartoon style, fun adventures!';
      case AgeTier.tweens11_14:
        return 'Social media & real-world challenges';
      case AgeTier.teens15_18:
        return 'Advanced cyber threats & tech deep-dives';
    }
  }
}

class UserSession extends Equatable {
  final String? username;
  final AgeTier? ageTier;
  final Map<String, int> missionProgress; // missionId -> score (0-100)

  const UserSession({
    this.username,
    this.ageTier,
    this.missionProgress = const {},
  });

  UserSession copyWith({
    String? username,
    AgeTier? ageTier,
    Map<String, int>? missionProgress,
  }) {
    return UserSession(
      username: username ?? this.username,
      ageTier: ageTier ?? this.ageTier,
      missionProgress: missionProgress ?? this.missionProgress,
    );
  }

  double get overallProgress {
    if (missionProgress.isEmpty) return 0.0;
    final total = missionProgress.values.fold(0, (a, b) => a + b);
    return total / (missionProgress.length * 100);
  }

  int get completedMissions =>
      missionProgress.values.where((s) => s > 0).length;

  @override
  List<Object?> get props => [username, ageTier, missionProgress];
}
