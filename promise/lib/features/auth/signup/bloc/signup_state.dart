import 'package:equatable/equatable.dart';

abstract class SignupState extends Equatable {
  @override
  List<Object> get props => [Object()];

  @override
  String toString() {
    return runtimeType.toString();
  }
}

abstract class AwaitUserInput extends SignupState {
  final String username;
  final String email;
  

  AwaitUserInput(this.username, this.email);
}

class AwaitUsernameInput extends AwaitUserInput {
  AwaitUsernameInput(super.username, super.email);
}

class AwaitPasswordInput extends AwaitUserInput {
  AwaitPasswordInput(super.username, super.email);
}

class SignupInProgress extends SignupState {}

class SignupSuccess extends SignupState {}

class SignupFailure extends SignupState {
  final dynamic error;

  SignupFailure({this.error});

  @override
  String toString() {
    return 'SignUpFailure {error: $error}';
  }
}
