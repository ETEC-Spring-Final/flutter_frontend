import 'package:dio/dio.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/datasource/vehicle_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/model/vehicle_model.dart';

class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  final Dio dio;

  VehicleRemoteDataSourceImpl(this.dio);

  @override
  Future<List<VehicleModel>> getVehicles() async {
    // get data from api
    final response = await dio.get('/vehicles');

    // convert data to list or json
    final data = response.data['data'] as List;

    // put data to model
    final vehicles = data
        .map((json) => VehicleModel.fromJson(json as Map<String, dynamic>))
        .toList();

    return vehicles;
  }

  @override
  Future<VehicleModel> getVehicleById(int id) async {
    // get data from api
    final response = await dio.get('/vehicles/$id');
    // convert data to json
    final data = response.data['data'];
    // put json to model
    final vehicle = VehicleModel.fromJson(data as Map<String, dynamic>);

    return vehicle;
  }
}
