import 'package:flutter_study/data/clients/api_client.dart';
import 'package:flutter_study/data/clients/auth_client.dart';
import 'package:flutter_study/domain/models/token_response.dart';
import 'package:flutter_study/domain/models/user.dart';
import 'package:flutter_study/domain/repository/api_repository.dart';
import 'package:flutter_study/domain/models/token_request.dart';

import '../../domain/models/refresh_token_request.dart';

class ApiDataRepository extends ApiRepository {
  final AuthClient _auth;
  final ApiClient _api;
  ApiDataRepository(this._auth, this._api);

  @override
  Future<TokenResponse?> getToken({
    required String login,
    required String password,
  }) async {
    return await _auth.getToken(TokenRequest(
      login: login,
      pass: password,
    ));
  }

  @override
  Future<TokenResponse?> refreshToken(String refreshToken) async =>
      await _auth.refreshToken(RefreshTokenRequest(
        refreshToken: refreshToken,
      ));
  @override
  Future<User?> getUser() => _api.getUser();
  @override
  Future<UserFull?> getUserFull() => _api.getUserFull();
}
