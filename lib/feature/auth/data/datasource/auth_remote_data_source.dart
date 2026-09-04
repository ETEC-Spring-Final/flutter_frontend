import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:vehicle_rental_system/feature/auth/data/models/auth_response_model.dart';
import 'package:vehicle_rental_system/feature/auth/data/models/login_request_model.dart';
import 'package:vehicle_rental_system/feature/auth/data/models/register_request_model.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<AuthResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await dio.post('/auth/register', data: request.toJson());
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

  Future<AuthResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await dio.post('/auth/login', data: request.toJson());
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
}
