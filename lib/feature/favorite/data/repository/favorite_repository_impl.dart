import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/favorite/domain/repository/favorite_repository.dart';

/// Local [FavoriteRepository] backed by [SharedPreferences].
///
/// Favorites are persisted locally so they survive app restarts. This is the
/// default, offline-capable implementation. Swap this impl in DI once a remote
/// favorites API is available.
class FavoriteRepositoryImpl implements FavoriteRepository {
  FavoriteRepositoryImpl();

  static const String _prefsKey = 'favorite_vehicle_ids';

  @override
  Future<Either<Failure, Set<int>>> getFavoriteIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ids = (prefs.getStringList(_prefsKey) ?? const [])
          .map(int.parse)
          .toSet();
      return Right(ids);
    } catch (e) {
      return Left(ServiceFailure('Failed to load favorites: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addFavorite(int vehicleId) async {
    final result = await getFavoriteIds();
    final ids = result.fold((_) => <int>{}, (ids) => ids);
    ids.add(vehicleId);
    return _persist(ids);
  }

  @override
  Future<Either<Failure, void>> removeFavorite(int vehicleId) async {
    final result = await getFavoriteIds();
    final ids = result.fold((_) => <int>{}, (ids) => ids);
    ids.remove(vehicleId);
    return _persist(ids);
  }

  @override
  Future<Either<Failure, void>> setFavoriteIds(Set<int> ids) async {
    return _persist(ids);
  }

  Future<Either<Failure, void>> _persist(Set<int> ids) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        _prefsKey,
        ids.map((id) => id.toString()).toList(),
      );
      return const Right(null);
    } catch (e) {
      return Left(ServiceFailure('Failed to save favorites: $e'));
    }
  }
}
