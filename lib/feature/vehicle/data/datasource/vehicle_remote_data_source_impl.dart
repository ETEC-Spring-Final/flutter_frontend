import 'package:dio/dio.dart';
import 'package:vehicle_rental_system/core/constants/api_constants.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/datasource/vehicle_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/model/vehicle_model.dart';

class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  final Dio dio;

  VehicleRemoteDataSourceImpl(this.dio);

  @override
  Future<List<VehicleModel>> getVehicles() async {
    // get data from api
    final response = await dio.get(
      '/vehicles',
      //ApiConstants.vehicles
    );

    // convert data to list or json
    final data = response.data['data'] as List;

    // map data to model
    final vehicles = data
        .map((json) => VehicleModel.fromJson(json as Map<String, dynamic>))
        .toList();

    return vehicles;
  }

  @override
  Future<VehicleModel> getVehicleById(int id) async {
    // get data from api
    final response = await dio.get(
      '/vehicles/$id',
      //ApiConstants.vehicleById(id)
    );
    // convert data to json
    final data = response.data['data'];
    // map json to model
    final vehicle = VehicleModel.fromJson(data as Map<String, dynamic>);

    return vehicle;
  }
}
