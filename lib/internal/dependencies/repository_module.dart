import 'package:dio/dio.dart';
import 'package:flutter_study/data/clients/auth_client.dart';

import '../../data/repository/api_data_repository.dart';
import '../../domain/repository/api_repository.dart';
import 'api_module.dart';

String baseUrl = "http://192.168.0.104:1000";

class RepositoryModule {
  static ApiRepository? _apiRepository;
  static ApiRepository apiRepository() {
    return _apiRepository ??
        ApiDataRepository(
          ApiModule.auth(),
          ApiModule.api(),
        );
  }
}
