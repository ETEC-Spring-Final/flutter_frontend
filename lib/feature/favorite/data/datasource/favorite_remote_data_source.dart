import 'package:vehicle_rental_system/feature/favorite/data/model/favorite_response_model.dart';

/// Remote contract for the Spring Boot `/favorites` API.
///
/// All methods require a valid JWT; [AuthInterceptor] attaches the bearer
/// token automatically (paths outside `/auth/*`).
abstract class FavoriteRemoteDataSource {
  /// Fetches the current user's favorites ->
  /// `GET /api/favorites`.
  Future<List<FavoriteResponseModel>> getFavorites();

  /// Adds [vehicleId] to the current user's favorites ->
  /// `POST /api/favorites/{vehicleId}`.
  Future<FavoriteResponseModel> addFavorite(int vehicleId);

  /// Removes [vehicleId] from the current user's favorites ->
  /// `DELETE /api/favorites/{vehicleId}`.
  Future<void> removeFavorite(int vehicleId);
}
