import 'package:get_it/get_it.dart';
import 'package:vehicle_rental_system/injection/auth_injection.dart';
import 'package:vehicle_rental_system/injection/bloc_injection.dart';
import 'package:vehicle_rental_system/injection/datasource_injection.dart';
import 'package:vehicle_rental_system/injection/network_injection.dart';
import 'package:vehicle_rental_system/injection/repository_injection.dart';
import 'package:vehicle_rental_system/injection/service_injection.dart';
import 'package:vehicle_rental_system/injection/use_case_injection.dart';

final getit = GetIt.instance;

Future<void> configureDependencies() async {
  // auth
  registerAuth();
  // Network
  registerNetwork(); // registerLazySingleton
  // Data Source
  registerDataSource();
  // Services
  registerServices(); // // registerLazySingleton
  // Repositories
  registerRepositories(); // registerLazySingleton
  // Use Cases
  registerUseCases(); // Register Factory
  // BLoCs
  registerBlocs(); // Register Factory
}
