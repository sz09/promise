// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IdentityUser _$UserFromJson(Map<String, dynamic> json) =>
    IdentityUser(id: json['id'] as String, username: json['email'] as String);

Map<String, dynamic> _$UserToJson(IdentityUser instance) =>
    <String, dynamic>{'id': instance.id, 'email': instance.username};
