import 'package:flutter_study/data/clients/auth_client.dart';
import 'package:flutter_study/domain/models/token_response.dart';
import 'package:flutter_study/domain/repository/api_repository.dart';
import 'package:flutter_study/domain/models/token_request.dart';

class ApiDataRepository extends ApiRepository {
  final AuthClient _auth;
  ApiDataRepository(this._auth);

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
}
