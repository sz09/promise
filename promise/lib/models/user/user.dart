import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
@immutable
class IdentityUser extends Equatable {
  @JsonKey(name: 'uuid')
  final String id;
  final String username;

  const IdentityUser({required this.id, required this.username});

  factory IdentityUser.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [id, username];

  @override
  String toString() {
    return 'User{'
        'id: $id, '
        'username: $username'
        '}';
  }
}
