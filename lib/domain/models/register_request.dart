import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final String retryPassword;
  final DateTime birthDate;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.retryPassword,
    required this.birthDate,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
