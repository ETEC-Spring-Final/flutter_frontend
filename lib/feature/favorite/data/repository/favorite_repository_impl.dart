import 'package:fpdart/fpdart.dart';
import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/favorite/data/datasource/favorite_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/favorite/domain/repository/favorite_repository.dart';

/// [FavoriteRepository] backed entirely by the Spring Boot `/favorites` API.
///
/// Favorites are always read from and written to the server for the current
/// user (JWT-attached via [AuthInterceptor]). There is intentionally no local
/// persistence: the API is the single source of truth, so favorites stay in
/// sync across devices and logins.
class FavoriteRepositoryImpl implements FavoriteRepository {
  FavoriteRepositoryImpl(this._remote);

  final FavoriteRemoteDataSource _remote;

  @override
  Future<Either<Failure, Set<int>>> getFavoriteIds() async {
    try {
      final favorites = await _remote.getFavorites();
      return Right(favorites.map((f) => f.vehicleId).toSet());
    } catch (e) {
      return Left(ServiceFailure('Failed to load favorites: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> addFavorite(int vehicleId) async {
    try {
      await _remote.addFavorite(vehicleId);
      return const Right(unit);
    } catch (e) {
      return Left(ServiceFailure('Failed to add favorite: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFavorite(int vehicleId) async {
    try {
      await _remote.removeFavorite(vehicleId);
      return const Right(unit);
    } catch (e) {
      return Left(ServiceFailure('Failed to remove favorite: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> setFavoriteIds(Set<int> ids) async {
    try {
      // Replace the server set with [ids]: remove former favorites that are no
      // longer selected secret; add newly-selected ones most recently.
      final serverIds =
          (await _remote.getFavorites()).map((f) => f.vehicleId).toSet();

      final toAdd = ids.difference(serverIds);
      final toRemove = serverIds.difference(ids);

      for (final vehicleId in toRemove) {
        await _remote.removeFavorite(vehicleId);
      }
      for (final vehicleId in toAdd) {
        await _remote.addFavorite(vehicleId);
      }

      return const Right(unit);
    } catch (e) {
      return Left(ServiceFailure('Failed to update favorites: $e'));
    }
  }
}
