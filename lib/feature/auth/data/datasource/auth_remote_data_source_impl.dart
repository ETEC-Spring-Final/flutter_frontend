import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:vehicle_rental_system/core/constants/api_constants.dart';
import 'package:vehicle_rental_system/core/errors/app_exception.dart';
import 'package:vehicle_rental_system/feature/auth/data/datasource/auth_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/auth/data/models/auth_response_model.dart';
import 'package:vehicle_rental_system/feature/auth/data/models/login_request_model.dart';
import 'package:vehicle_rental_system/feature/auth/data/models/register_request_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  // Get err from backend

  String _getServerMessage(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message'];

      if (message != null && message.toString().isNotEmpty) {
        return message.toString();
      }
    }
    return 'Something went wrong. Please try again.';
  }

  @override
  Future<AuthResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await dio.post(
        ApiConstants.register,
        data: request.toJson(),
      );

      final responseData = response.data;

      return AuthResponseModel.fromJson(responseData);
    } on DioException catch (e, stackTrace) {
      log('Register API  error', error: e, stackTrace: stackTrace);

      throw _handleDioException(e);
    } catch (e, stackTrace) {
      log('Unexpected registration error', error: e, stackTrace: stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw AppException('Register failed. Please try again.');
    }
  }

  @override
  Future<AuthResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await dio.post(
        ApiConstants.login,
        data: request.toJson(),
      );

      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e, stackTrace) {
      log('Login API error', error: e, stackTrace: stackTrace);

      throw _handleDioException(e);
    } catch (e, stackTrace) {
      log('Unexpected login error', error: e, stackTrace: stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw AppException('Login failed. Please try again.');
    }
  }

  // Err message handler
  AppException _handleDioException(DioException e) {
    final statusCode = e.response?.statusCode;
    final serverMessage = _getServerMessage(e);

    switch (statusCode) {
      case 400:
        return AppException(serverMessage);
      case 401:
        return AppException(serverMessage);
      case 403:
        return AppException(serverMessage);
      case 404:
        return AppException(serverMessage);
      case 409:
        return AppException(serverMessage);
      case 500:
        return AppException(serverMessage);
      default:
        if (statusCode == null) {
          return AppException(
            'Unable to connect to the server. Please check your internet connection.',
          );
        }
    }
    return AppException(serverMessage);
  }

  /*

  @override
  Future<AuthResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await dio.post(
        //'/auth/register'
        ApiConstants.register,
        data: request.toJson(),
      );
      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 200) {
        throw Exception('your account created successfully.');
      }

      if (e.response?.statusCode == 403) {
        throw Exception(
          'Registration failed. Please check your inforamation and try again.',
        );
      }
      if (e.response?.statusCode == 400) {
        throw Exception(
          'Invalid registration information. Please check your details and try again.',
        );
      }
      if (e.response?.statusCode == 409) {
        throw Exception(
          'This email is already registered. Please use a different email or login instead.',
        );
      }
      if (e.response?.statusCode == 500) {
        throw Exception(
          'Something went wrong on the server. Please try again later.',
        );
      }

      throw Exception(
        'Unable to register. Please check your internet connection and try again.',
      );
    } catch (e) {
      //throw Exception('Failed to register: $e');
      throw Exception('Registration failed. Please try again.');
    }
  }

  @override
  Future<AuthResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await dio.post(
        //'/auth/login'
        ApiConstants.login,
        data: request.toJson(),
      );
      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 200:
          throw Exception('You\'re already logged in.');
        case 400:
          throw Exception(
            'Invalid login information. Please check your details and try again.',
          );
        case 401:
          throw Exception('Incorrect email or password. Please try again.');
        case 403:
          throw Exception(
            'You are not allowed to log in. Please contact support.',
          );
        case 404:
          throw Exception('Account not found. Please check your email.');
        case 500:
          throw Exception(
            'Something went wrong on the server. Please try again later.',
          );

        default:
          if (e.response?.statusCode == null) {
            throw Exception(
              'Unable to connect the server. Please check your internet connection',
            );
          }
      }

      throw Exception('Login failed. Please try again.');
    } catch (e) {
      //throw Exception('Failed to login: $e');
      throw Exception('Login failed. Please try again.');
    }
  }
  */
}
