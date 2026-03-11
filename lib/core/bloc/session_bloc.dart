import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_session.dart';
import 'session_event.dart';
import 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc() : super(const SessionInitial()) {
    on<SetUserEvent>(_onSetUser);
    on<CompleteMissionEvent>(_onCompleteMission);
    on<ResetSessionEvent>(_onResetSession);
  }

  void _onSetUser(SetUserEvent event, Emitter<SessionState> emit) {
    emit(SessionActive(UserSession(
      username: event.username,
      ageTier: event.ageTier,
      missionProgress: const {},
    )));
  }

  void _onCompleteMission(
      CompleteMissionEvent event, Emitter<SessionState> emit) {
    if (state is SessionActive) {
      final current = (state as SessionActive).session;
      final newProgress = Map<String, int>.from(current.missionProgress);
      newProgress[event.missionId] = event.score;
      emit(SessionActive(current.copyWith(missionProgress: newProgress)));
    }
  }

  void _onResetSession(ResetSessionEvent event, Emitter<SessionState> emit) {
    emit(const SessionInitial());
  }
}
