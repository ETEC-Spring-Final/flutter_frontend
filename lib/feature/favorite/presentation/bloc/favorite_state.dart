part of 'favorite_bloc.dart';

sealed class FavoriteState {
  const FavoriteState();
}

final class FavoriteInitial extends FavoriteState {
  const FavoriteInitial();
}

final class FavoriteLoading extends FavoriteState {
  const FavoriteLoading();
}

final class FavoriteLoaded extends FavoriteState {
  final Set<int> favoriteIds;

  const FavoriteLoaded(this.favoriteIds);

  bool contains(int vehicleId) => favoriteIds.contains(vehicleId);
}

final class FavoriteError extends FavoriteState {
  final Failure failure;

  const FavoriteError(this.failure);
}
