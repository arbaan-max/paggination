part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
  @override
  List<Object> get props => [];
}

// class AuthenticationStarted extends AuthenticationEvent {}

class AuthenticationAuthenticated extends AuthenticationEvent {}

class AuthenticationUnAuthenticated extends AuthenticationEvent {}
