import 'dart:developer';

import 'package:vehicle_rental_system/core/storage/secure_storage_service.dart';
import 'package:vehicle_rental_system/feature/auth/data/datasource/auth_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/auth/data/mapper/auth_mapper.dart';
import 'package:vehicle_rental_system/feature/auth/domain/entity/auth_response.dart';
import 'package:vehicle_rental_system/feature/auth/domain/entity/login_request.dart';
import 'package:vehicle_rental_system/feature/auth/domain/entity/register_request.dart';
import 'package:vehicle_rental_system/feature/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final SecureStorageService storage;

  AuthRepositoryImpl(this.remote, this.storage);

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    final model = AuthMapper.registerToModel(request);
    final responseModel = await remote.register(model);
    await storage.saveToken(responseModel.token);

    final storedToken = await storage.getToken();

    log("JWT from API: $responseModel.token");
    log("JWT from storage: $storedToken");

    return AuthMapper.modelToEntity(responseModel);
  }

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    final model = AuthMapper.loginToModel(request);
    final responseModel = await remote.login(model);

    // save token
    await storage.saveToken(responseModel.token);

    final storedToken = await storage.getToken();

    log("JWT from API: $responseModel.token");
    log("JWT from storage: $storedToken");

    return AuthMapper.modelToEntity(responseModel);
  }
}
