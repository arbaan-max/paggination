part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();
  @override
  List<Object> get props => [];
}

class SignIn extends SignInEvent {
  final String phone;
  final String password;
  const SignIn({required this.phone, required this.password});
  @override
  List<Object> get props => [phone, password];
  @override
  String toString() => 'SignIn { email: $phone, password: $password }';
}

class SignOut extends SignInEvent {
  const SignOut();
  @override
  List<Object> get props => [];
  @override
  String toString() => 'SignOut';
}
