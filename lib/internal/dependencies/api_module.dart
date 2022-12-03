import 'package:dio/dio.dart';
import 'package:flutter_study/data/clients/auth_client.dart';

String baseUrl = "http://192.168.0.104:1000/";

class ApiModule {
  static AuthClient? _authClient;

  static AuthClient auth() =>
      _authClient ??
      AuthClient(
        Dio(),
        baseUrl: baseUrl,
      );
}
