import 'dart:io';

import 'package:flutter_study/data/clients/api_client.dart';
import 'package:flutter_study/data/clients/auth_client.dart';
import 'package:flutter_study/domain/models/post.dart';
import 'package:flutter_study/domain/models/register_request.dart';
import 'package:flutter_study/domain/models/token_response.dart';
import 'package:flutter_study/domain/models/user.dart';
import 'package:flutter_study/domain/repository/api_repository.dart';
import 'package:flutter_study/domain/models/token_request.dart';

import '../../domain/models/attach_meta.dart';
import '../../domain/models/post_model.dart';
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
  Future<String> registerUser(
      {required String name,
      required String email,
      required String password,
      required String retryPassword,
      required DateTime birthDate}) async {
    return await _auth.registerUser(RegisterRequest(
        name: name,
        email: email,
        password: password,
        retryPassword: retryPassword,
        birthDate: birthDate));
  }

  @override
  Future<TokenResponse?> refreshToken(String refreshToken) async =>
      await _auth.refreshToken(RefreshTokenRequest(
        refreshToken: refreshToken,
      ));

  @override
  Future<User?> getUser() => _api.getUser();

  @override
  Future<List<PostModel>> getPosts(int skip, int take) =>
      _api.getPosts(skip, take);

  @override
  Future<List<AttachMeta>> uploadTemp({required List<File> files}) =>
      _api.uploadTemp(files: files);

  @override
  Future addAvatarToUser(AttachMeta model) => _api.addAvatarToUser(model);

  @override
  Future createPost(PostModelCreate model) => _api.createPost(model);
}
