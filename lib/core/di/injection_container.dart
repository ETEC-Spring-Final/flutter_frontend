import 'package:get_it/get_it.dart';
import 'package:vehicle_rental_system/core/di/auth_injection.dart';
import 'package:vehicle_rental_system/core/di/bloc_injection.dart';
import 'package:vehicle_rental_system/core/di/datasource_injection.dart';
import 'package:vehicle_rental_system/core/di/network_injection.dart';
import 'package:vehicle_rental_system/core/di/repository_injection.dart';
import 'package:vehicle_rental_system/core/di/service_injection.dart';
import 'package:vehicle_rental_system/core/di/storage_injectIon.dart';
import 'package:vehicle_rental_system/core/di/use_case_injection.dart';
import 'package:vehicle_rental_system/core/di/vehicle_injection.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // Auth
  authInjection();
  // Vehicle
  vehiclInjection();
  // Storage
  //storageInjection();
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
