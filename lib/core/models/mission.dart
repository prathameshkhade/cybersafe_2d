import 'package:equatable/equatable.dart';
import 'user_session.dart';

class Mission extends Equatable {
  final String id;
  final String title;
  final String description;
  final String flameMechanic;
  final String learningGoal;
  final AgeTier ageTier;
  final String emoji;

  const Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.flameMechanic,
    required this.learningGoal,
    required this.ageTier,
    required this.emoji,
  });

  @override
  List<Object?> get props =>
      [id, title, description, flameMechanic, learningGoal, ageTier, emoji];
}

class MissionRepository {
  static const List<Mission> allMissions = [
    Mission(
      id: 'k001',
      title: 'Hero Message Sort',
      description:
          'Sort messages from strangers into Safe or Danger bins. Be a cyber hero!',
      flameMechanic: 'Drag & drop messages',
      learningGoal: 'Spot strangers & unsafe messages',
      ageTier: AgeTier.kids7_10,
      emoji: '🦸',
    ),
    Mission(
      id: 'k002',
      title: 'Password Fortress',
      description:
          'Tap falling good password letters, avoid the bad ones. Build your fortress!',
      flameMechanic: 'Falling sprites tap game',
      learningGoal: 'Create strong passwords',
      ageTier: AgeTier.kids7_10,
      emoji: '🏰',
    ),
    Mission(
      id: 't001',
      title: 'DM Threat Buster',
      description:
          'Swipe left to block suspicious DMs, right to reply to safe ones. Be an Instagram hero!',
      flameMechanic: 'Swipe gesture cards',
      learningGoal: 'Identify phishing DMs',
      ageTier: AgeTier.tweens11_14,
      emoji: '📱',
    ),
    Mission(
      id: 't002',
      title: 'Fake Friend Request',
      description:
          'Analyze profiles and decide: Accept or Reject? Not everyone is who they say they are.',
      flameMechanic: 'Profile flip card mechanic',
      learningGoal: 'Detect catfishing attempts',
      ageTier: AgeTier.tweens11_14,
      emoji: '🎭',
    ),
    Mission(
      id: 'n001',
      title: 'Social Engineering Escape',
      description:
          'Navigate a branching dialogue tree. Make the right choices to escape manipulation!',
      flameMechanic: 'Branching dialogue + timer',
      learningGoal: 'Recognize manipulation tactics',
      ageTier: AgeTier.teens15_18,
      emoji: '🧠',
    ),
    Mission(
      id: 'n002',
      title: 'Deep Link Inspector',
      description:
          'Zoom in and inspect suspicious URLs. One wrong click can compromise everything.',
      flameMechanic: 'Zoom camera + URL inspection',
      learningGoal: 'Detect URL spoofing',
      ageTier: AgeTier.teens15_18,
      emoji: '🔍',
    ),
  ];

  static List<Mission> getMissionsForTier(AgeTier tier) =>
      allMissions.where((m) => m.ageTier == tier).toList();
}
