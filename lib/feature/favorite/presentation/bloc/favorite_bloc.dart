import 'package:bloc/bloc.dart';

import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/favorite/domain/repository/favorite_repository.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

/// Single source of truth for favorite vehicle ids.
///
/// All screens read toggle state from here and dispatch events to change it,
/// which guarantees the UI stays in sync (home, explore, detail, favorite).
class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository _repository;

  FavoriteBloc(this._repository) : super(FavoriteInitial()) {
    on<LoadFavoritesEvent>(_onLoad);
    on<ToggleFavoriteEvent>(_onToggle);
    on<RemoveFavoriteEvent>(_onRemove);
    on<ClearFavoritesEvent>(_onClear);

    add(const LoadFavoritesEvent());
  }

  Future<void> _onLoad(
    LoadFavoritesEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(FavoriteLoading());
    final result = await _repository.getFavoriteIds();
    result.fold(
      (failure) => emit(FavoriteError(failure)),
      (ids) => emit(FavoriteLoaded(ids)),
    );
  }

  Future<void> _onToggle(
    ToggleFavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    final current = state;
    if (current is! FavoriteLoaded) return;

    final ids = Set<int>.from(current.favoriteIds);
    if (ids.contains(event.vehicleId)) {
      ids.remove(event.vehicleId);
    } else {
      ids.add(event.vehicleId);
    }

    emit(FavoriteLoaded(ids));

    final result = ids.contains(event.vehicleId)
        ? await _repository.addFavorite(event.vehicleId)
        : await _repository.removeFavorite(event.vehicleId);

    result.fold((failure) {}, (_) {});
  }

  Future<void> _onRemove(
    RemoveFavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    final current = state;
    if (current is! FavoriteLoaded) return;

    final ids = Set<int>.from(current.favoriteIds)..remove(event.vehicleId);
    emit(FavoriteLoaded(ids));
    (await _repository.removeFavorite(event.vehicleId)).fold((_) {}, (_) {});
  }

  Future<void> _onClear(
    ClearFavoritesEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(FavoriteLoaded(const {}));
    (await _repository.setFavoriteIds(const {})).fold((_) {}, (_) {});
  }
}
