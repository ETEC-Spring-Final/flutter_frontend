part of 'auth_bloc.dart';

abstract class AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  LoginSubmitted({required this.email, required this.password});
}

class RegisterSubmitted extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  //final String confirmPassword;
  final String phone;
  final String gender;

  RegisterSubmitted({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    //required this.confirmPassword,
    required this.phone,
    required this.gender,
  });
}
