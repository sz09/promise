// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IdentityUser _$UserFromJson(Map<String, dynamic> json) =>
    IdentityUser(userId: json["UserId"], username: json['email'] as String);

Map<String, dynamic> _$UserToJson(IdentityUser instance) =>
    <String, dynamic>{"UserId": instance.userId, 'email': instance.username};
