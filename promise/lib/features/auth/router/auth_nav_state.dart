import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class AuthNavState extends Equatable {
  const AuthNavState._(this.prevState);

  const factory AuthNavState.login() = LoginNavState;

  const factory AuthNavState.signupUsername(AuthNavState prevState) =
      SignupUsernameNavState;

  const factory AuthNavState.signupPassword(AuthNavState prevState) =
      SignupPasswordNavState;

  final AuthNavState? prevState;

  @override
  List<Object?> get props => [];

  @override
  String toString() {
    return '$runtimeType(prevState: $prevState)';
  }
}

@immutable
class LoginNavState extends AuthNavState {
  const LoginNavState() : super._(null);
}

@immutable
class SignupUsernameNavState extends AuthNavState {
  const SignupUsernameNavState(AuthNavState super.prevState) : super._();
}

@immutable
class SignupPasswordNavState extends AuthNavState {
  const SignupPasswordNavState(AuthNavState super.prevState) : super._();
}
