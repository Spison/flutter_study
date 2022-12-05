// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      birthDate: json['birthDate'] as String,
      avatarLink: json['avatarLink'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'birthDate': instance.birthDate,
      'avatarLink': instance.avatarLink,
    };

UserFull _$UserFullFromJson(Map<String, dynamic> json) => UserFull(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      birthDate: json['birthDate'] as String,
      avatarLink: json['avatarLink'] as String?,
      postsCount: json['postsCount'] as String?,
    );

Map<String, dynamic> _$UserFullToJson(UserFull instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'birthDate': instance.birthDate,
      'avatarLink': instance.avatarLink,
      'postsCount': instance.postsCount,
    };
