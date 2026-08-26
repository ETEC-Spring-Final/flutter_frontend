import 'package:vehicle_rental_system/feature/vehicle/data/model/vehicle_model.dart';

abstract class VehicleRemoteDataSource {
  Future<List<VehicleModel>> getVehicles();
  Future<VehicleModel> getVehicleById(int id);
}
