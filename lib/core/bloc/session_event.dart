import 'package:equatable/equatable.dart';
import '../models/user_session.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();
  @override
  List<Object?> get props => [];
}

class SetUserEvent extends SessionEvent {
  final String username;
  final AgeTier ageTier;
  const SetUserEvent({required this.username, required this.ageTier});
  @override
  List<Object?> get props => [username, ageTier];
}

class CompleteMissionEvent extends SessionEvent {
  final String missionId;
  final int score;
  const CompleteMissionEvent({required this.missionId, required this.score});
  @override
  List<Object?> get props => [missionId, score];
}

class ResetSessionEvent extends SessionEvent {
  const ResetSessionEvent();
}
