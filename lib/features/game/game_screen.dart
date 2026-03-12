import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/bloc/session_bloc.dart';
import '../../core/bloc/session_event.dart';
import '../../core/models/mission.dart';
import '../results/mission_results_page.dart';
import 'missions/k001_hero_message_sort/hero_message_sort_game.dart';
import 'missions/k002_password_fortress/password_fortress_game.dart';
import 'missions/k003_privacy_shield/privacy_shield_game.dart';
import 'missions/k004_danger_detector/danger_detector_game.dart';
import 'missions/t001_dm_threat_buster/dm_threat_buster_game.dart';
import 'missions/t002_fake_friend_request/fake_friend_request_game.dart';
import 'missions/t003_phishing_spotter/phishing_spotter_game.dart';
import 'missions/t004_two_factor_hero/two_factor_hero_game.dart';
import 'missions/n001_social_engineering_escape/social_engineering_escape_game.dart';
import 'missions/n002_deep_link_inspector/deep_link_inspector_game.dart';
import 'missions/n003_osint_scanner/osint_scanner_game.dart';
import 'missions/n004_incident_response/incident_response_game.dart';



class GameScreen extends StatelessWidget {
  final Mission mission;

  const GameScreen({super.key, required this.mission});

  void _onMissionComplete(BuildContext context, int score) {
    context.read<SessionBloc>().add(CompleteMissionEvent(
          missionId: mission.id,
          score: score,
        ));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MissionResultsPage(mission: mission, score: score),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMissionGame(context);
  }

  Widget _buildMissionGame(BuildContext context) {
    switch (mission.id) {
      case 'k001':
        return HeroMessageSortGame(
          mission: mission,
          onComplete: (score) => _onMissionComplete(context, score),
        );
      case 'k002':
        return PasswordFortressGame(
          mission: mission,
          onComplete: (score) => _onMissionComplete(context, score),
        );
      case 'k003':
        return PrivacyShieldGame(
          mission: mission,
          onComplete: (score) => _onMissionComplete(context, score),
        );
      case 'k004':
        return DangerDetectorGame(
          mission: mission,
          onComplete: (score) => _onMissionComplete(context, score),
        );
      case 't001':
        return DmThreatBusterGame(
          mission: mission,
          onComplete: (score) => _onMissionComplete(context, score),
        );
      case 't002':
        return FakeFriendRequestGame(
          mission: mission,
          onComplete: (score) => _onMissionComplete(context, score),
        );
      case 't003':
        return PhishingSpotterGame(
          mission: mission,
          onComplete: (score) => _onMissionComplete(context, score),
        );
      case 't004':
        return TwoFactorHeroGame(
          mission: mission,
          onComplete: (score) => _onMissionComplete(context, score),
        );  
      case 'n001':
        return SocialEngineeringEscapeGame(
          mission: mission,
          onComplete: (score) => _onMissionComplete(context, score),
        );
      case 'n002':
        return DeepLinkInspectorGame(
          mission: mission,
          onComplete: (score) => _onMissionComplete(context, score),
        );
      case 'n003':
        return OsintScannerGame(
          mission: mission,
          onComplete: (score) => _onMissionComplete(context, score),
        );
      case 'n004':
        return IncidentResponseGame(
          mission: mission,
          onComplete: (score) => _onMissionComplete(context, score),
        );
      default:
        return _buildUnknownMission(context);
    }
  }

  Widget _buildUnknownMission(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Mission not found', style: TextStyle(fontSize: 20)),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
