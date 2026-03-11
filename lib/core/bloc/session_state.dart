import 'package:equatable/equatable.dart';
import '../models/user_session.dart';

abstract class SessionState extends Equatable {
  const SessionState();
  @override
  List<Object?> get props => [];
}

class SessionInitial extends SessionState {
  const SessionInitial();
}

class SessionActive extends SessionState {
  final UserSession session;
  const SessionActive(this.session);
  @override
  List<Object?> get props => [session];
}
