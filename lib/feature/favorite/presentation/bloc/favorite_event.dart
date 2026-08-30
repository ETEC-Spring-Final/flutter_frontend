part of 'favorite_bloc.dart';

/// Base event for the [FavoriteBloc].
sealed class FavoriteEvent {
  const FavoriteEvent();
}

/// Loads the persisted favorite ids from the repository.
final class LoadFavoritesEvent extends FavoriteEvent {
  const LoadFavoritesEvent();
}

/// Adds or removes [vehicleId] from favorites depending on its current state.
final class ToggleFavoriteEvent extends FavoriteEvent {
  final int vehicleId;

  const ToggleFavoriteEvent(this.vehicleId);
}

/// Removes [vehicleId] from favorites.
final class RemoveFavoriteEvent extends FavoriteEvent {
  final int vehicleId;

  const RemoveFavoriteEvent(this.vehicleId);
}

/// Clears all favorites.
final class ClearFavoritesEvent extends FavoriteEvent {
  const ClearFavoritesEvent();
}
