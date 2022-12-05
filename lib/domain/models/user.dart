import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String name;
  final String email;
  final String birthDate;
  final String? avatarLink;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.birthDate,
    required this.avatarLink,
  });
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class UserFull {
  final String id;
  final String name;
  final String email;
  final String birthDate;
  final String? avatarLink;
  final String? postsCount;
  UserFull({
    required this.id,
    required this.name,
    required this.email,
    required this.birthDate,
    required this.avatarLink,
    required this.postsCount,
  });
  factory UserFull.fromJson(Map<String, dynamic> json) =>
      _$UserFullFromJson(json);
  Map<String, dynamic> toJson() => _$UserFullToJson(this);
}
