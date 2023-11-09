part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  const SignInState();
  @override
  List<Object> get props => [];
}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {}

class SignInFailure extends SignInState {
  const SignInFailure({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
  @override
  String toString() => 'SignInFailure { message: $message }';
}
