import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
@immutable
class IdentityUser extends Equatable {
  final String userId;
  final String username;

  const IdentityUser({required this.userId, required this.username});

  factory IdentityUser.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [userId, username];

  @override
  String toString() {
    return 'User{'
        'userId: $userId, '
        'username: $username'
        '}';
  }
}
