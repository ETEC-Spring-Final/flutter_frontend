import 'package:fpdart/fpdart.dart';
import 'package:vehicle_rental_system/core/errors/failure.dart';

/// Contract for persisting/managing favorite vehicle ids.
///
/// The local implementation keeps an in-memory set and persists it, while a
/// future remote implementation can back these calls with a Spring Boot API
/// (`/favorites` endpoints) without touching the UI or the BLoC.
abstract class FavoriteRepository {
  /// Load the persisted set of favorite vehicle ids.
  Future<Either<Failure, Set<int>>> getFavoriteIds();

  /// Add [vehicleId] to the favorites.
  Future<Either<Failure, void>> addFavorite(int vehicleId);

  /// Remove [vehicleId] from the favorites.
  Future<Either<Failure, void>> removeFavorite(int vehicleId);

  /// Replace the whole set (used to sync favorites locally).
  Future<Either<Failure, void>> setFavoriteIds(Set<int> ids);
}
