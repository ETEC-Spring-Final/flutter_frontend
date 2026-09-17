import 'package:vehicle_rental_system/core/network/api_client.dart';
import 'package:vehicle_rental_system/feature/rental/data/model/rental_model.dart';

abstract class RentalRemoteDataSource {
  Future<List<RentalModel>> getMyRentals();

  Future<RentalModel> getRentalById(int id);
}

class RentalRemoteDataSourceImpl implements RentalRemoteDataSource {
  final ApiClient apiClient;

  RentalRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<RentalModel>> getMyRentals() async {
    // Spring Boot returns a raw JSON list (not wrapped in { data: ... }).
    final response = await apiClient.get<List<dynamic>>('/rentals/my-rentals');

    final data = response.data ?? const [];

    return data
        .map((json) => RentalModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<RentalModel> getRentalById(int id) async {
    final response = await apiClient.get<Map<String, dynamic>>('/rentals/$id');

    return RentalModel.fromJson(response.data ?? {});
  }
}