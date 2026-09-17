import 'dart:io';

import 'package:vehicle_rental_system/feature/vehicle/data/model/vehicle_model.dart';

abstract class VehicleRemoteDataSource {
  Future<List<VehicleModel>> getVehicles();
  Future<VehicleModel> getVehicleById(int id);
  Future<VehicleModel> createVehicle(VehicleModel vehicle);
  Future<VehicleModel> updateVehicle(VehicleModel vehicle);
  Future<void> deleteVehicle(int id);
  Future<void> uploadVehicleImages(int vehicleId, List<File> images);
}
