import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vehicle_rental_system/feature/auth/domain/entity/login_request.dart';
import 'package:vehicle_rental_system/feature/auth/domain/entity/register_request.dart';
import 'package:vehicle_rental_system/feature/auth/domain/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  final FlutterSecureStorage secureStorage;
  AuthBloc(this.repository, this.secureStorage) : super(AuthInitial()) {
    on<LoginSubmitted>(_onLogin);
    on<RegisterSubmitted>(_onRegister);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LogoutRequested>(_onLogout);
    //on<AuthEvent>((event, emit) {});
  }

  final String key = 'jwt_token';

  String _getErrorMessage(Object error) {
    final message = error.toString();

    if (message.startsWith('Exception: ')) {
      return message.replaceFirst('Exception: ', '').trim();
    }

    return 'Something went wrong. Please try again.';
  }

  Future<void> _onLogin(LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final request = LoginRequest(
        email: event.email,
        password: event.password,
      );
      // get JWT token from repository
      final resopnse = await repository.login(request);

      log("JWT Token: ${resopnse.token}");

      emit(AuthSuccess());
    } catch (e, stackTrace) {
      final message = _getErrorMessage(e);

      log("Login failed: $message", error: e, stackTrace: stackTrace);
      emit(AuthFailure(message));

      // emit(AuthFailure("Login failed: $e"));
      // log("Login failed: $e");
    }
  }

  Future<void> _onRegister(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final request = RegisterRequest(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
        //confirmPassword: event.confirmPassword,
        phone: event.phone,
        gender: event.gender,
      );
      await repository.register(request);
      emit(AuthSuccess());
    } catch (e, stackTrace) {
      final message = _getErrorMessage(e);

      log("Registration failed: $message", error: e, stackTrace: stackTrace);

      emit(AuthFailure(message));
      //emit(AuthFailure());
      //log("Registration failed: $e");
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final token = await secureStorage.read(key: 'jwt_token');
      if (token != null && token.isNotEmpty) {
        log('Existing JWT token found');
        log('User is already authenticated');

        emit(AuthAuthenticated());
      } else {
        log('No JWT token found');
        log('User is not authenticated');

        emit(AuthUnauthenticated());
      }
    } catch (e, stackTrace) {
      final message = _getErrorMessage(e);

      log("Registration failed: $message", error: e, stackTrace: stackTrace);

      emit(AuthFailure(message));
    }
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      await secureStorage.delete(key: key);

      log('JWT token deleted');
      log('Logout successful');

      emit(AuthUnauthenticated());
      ;
    } catch (e, stackTrace) {
      log('Logout failed', error: e, stackTrace: stackTrace);

      emit(AuthFailure('Unable to logout. Please try again.'));
      // final message = _getErrorMessage(e);

      // log("Registration failed: $message", error: e, stackTrace: stackTrace);

      // emit(AuthFailure(message));
    }
  }
}
