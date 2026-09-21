class RegisterRequestModel {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  //final String confirmPassword;
  final String phone;
  final String gender;

  RegisterRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    //required this.confirmPassword,
    required this.phone,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      //'confirmPassword': confirmPassword,
      'phone': phone,
      'gender': gender,
    };
  }
}
