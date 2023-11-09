import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

/// [AuthenticationBloc] is a [HydratedBloc] that manages the authentication state of the application.
/// It extends [ChangeNotifier] to notify the listeners when the state changes.
/// It also extends [HydratedBloc] to save the state of the bloc when the application is closed.
/// [AuthenticationBloc] has two states [AuthenticationState.authenticated] and [AuthenticationState.unauthenticated].
/// [AuthenticationBloc] has two events [AuthenticationAuthenticated] and [AuthenticationUnAuthenticated].
/// [AuthenticationBloc] is used in [SignInBloc] to change the state of the application when the user signs in or signs out.
/// [AuthenticationBloc] is used in [AppRouter] to navigate the user to the correct screen when the application starts.
class AuthenticationBloc
    extends HydratedBloc<AuthenticationEvent, AuthenticationState>
    with ChangeNotifier {
  AuthenticationBloc() : super(AuthenticationState.unauthenticated) {
    on<AuthenticationAuthenticated>(_onAuthenticationAuthenticated);
    on<AuthenticationUnAuthenticated>(_onAuthenticationUnAuthenticated);
  }

  FutureOr<void> _onAuthenticationAuthenticated(
      AuthenticationAuthenticated event, Emitter<AuthenticationState> emit) {
    emit(AuthenticationState.authenticated);
    notifyListeners();
  }

  FutureOr<void> _onAuthenticationUnAuthenticated(
      AuthenticationUnAuthenticated event,
      Emitter<AuthenticationState> emit) async {
    emit(AuthenticationState.unauthenticated);
    notifyListeners();
  }

  @override
  AuthenticationState? fromJson(Map<String, dynamic> json) {
    try {
      return AuthenticationState.values[json['AuthenticationState'] as int];
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthenticationState state) {
    try {
      return {'AuthenticationState': state.index};
    } catch (_) {
      return null;
    }
  }
}
