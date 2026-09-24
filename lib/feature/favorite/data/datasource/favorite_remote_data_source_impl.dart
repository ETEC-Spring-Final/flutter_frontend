import 'package:dio/dio.dart';
import 'package:vehicle_rental_system/core/constants/api_constants.dart';
import 'package:vehicle_rental_system/feature/favorite/data/datasource/favorite_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/favorite/data/model/favorite_response_model.dart';

class FavoriteRemoteDataSourceImpl implements FavoriteRemoteDataSource {
  final Dio dio;

  FavoriteRemoteDataSourceImpl(this.dio);

  @override
  Future<List<FavoriteResponseModel>> getFavorites() async {
    // Spring Boot returns a raw JSON list (not wrapped in { data: ... }).
    final response = await dio.get<List<dynamic>>(ApiConstants.favorite);

    final data = response.data ?? const <dynamic>[];

    return data
        .whereType<Map<String, dynamic>>()
        .map(FavoriteResponseModel.fromJson)
        .toList();
  }

  @override
  Future<FavoriteResponseModel> addFavorite(int vehicleId) async {
    final response = await dio.post<Map<String, dynamic>>(
      ApiConstants.favoriteById(vehicleId),
    );

    return FavoriteResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> removeFavorite(int vehicleId) async {
    await dio.delete(ApiConstants.deleteFavorite(vehicleId));
  }
}
