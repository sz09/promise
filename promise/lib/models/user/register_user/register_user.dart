import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register_user.g.dart';

@JsonSerializable()
@immutable
class RegisterUser extends Equatable {
  @JsonKey(name: 'uuid')
  final String id;
  final String email;
  final String username;
  final String password;

  const RegisterUser({required this.id, required this.email, required this.username, required this.password});

  factory RegisterUser.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [id, email];

  @override
  String toString() {
    return 'User{'
        'id: $id, '
        'email: $email'
        'username: $username'
        'password: $password'
        '}';
  }
}
