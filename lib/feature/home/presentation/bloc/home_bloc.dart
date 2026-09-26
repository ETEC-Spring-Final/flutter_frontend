import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/brand.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/repository/vehicle_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

/// Owns the home screen's paginated data.
///
/// It is deliberately separate from the app wide `VehicleBloc`: that bloc
/// still serves the whole list to the explore, favorite and CRUD screens,
/// which filter and search it locally, while the home sections page through
/// the API. Sharing one bloc would let a "load page 2" from home and a
/// "reload everything" from explore fight over the same list.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final VehicleRepository repository;

  /// How many items each page holds.
  static const int pageSize = 8;

  /// The next page to ask for on each list.
  int _vehiclePage = 0;
  int _brandPage = 0;

  /// Incremented by every restart (first load, refresh, brand change) so a
  /// page that is already in flight is discarded once its results no longer
  /// match what the screen is showing.
  int _generation = 0;

  /// True once a page has been shown, so a failed refresh keeps the content
  /// instead of replacing it with an error screen.
  bool _hasLoaded = false;

  HomeBloc(this.repository) : super(const HomeInitial()) {
    on<HomeStarted>(_onHomeStarted);
    on<HomeRefreshed>(_onHomeRefreshed);
    on<HomeLoadMoreVehicles>(_onLoadMoreVehicles);
    on<HomeLoadMoreBrands>(_onLoadMoreBrands);
    on<HomeBrandSelected>(_onBrandSelected);
  }

  // ============================================================
  // FIRST LOAD
  // ============================================================

  Future<void> _onHomeStarted(
    HomeStarted event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    await _loadFirstPage(emit);
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> _onHomeRefreshed(
    HomeRefreshed event,
    Emitter<HomeState> emit,
  ) async {
    // No loading state here: the pull to refresh indicator is the feedback and
    // the screen keeps showing the pages it already has.
    await _loadFirstPage(emit);
  }

  /// Restarts both lists at page zero, keeping the active brand filter.
  ///
  /// Page zero is always re-read from the API: it is the call a real paged
  /// endpoint would make on open and on pull to refresh, so it must not be
  /// served from a snapshot.
  Future<void> _loadFirstPage(Emitter<HomeState> emit) async {
    final generation = ++_generation;

    final current = state;
    final selectedBrand = current is HomeLoaded ? current.selectedBrand : null;

    // Vehicles and brands are independent, so ask for them at the same time.
    final (vehicles, brands) = await (
      repository.getVehiclePage(
        page: 0,
        size: pageSize,
        brand: selectedBrand,
        forceRefresh: true,
      ),
      repository.getBrandPage(page: 0, size: pageSize, forceRefresh: true),
    ).wait;

    // A newer request took over while these were in flight.
    if (generation != _generation) return;

    if (vehicles.isLeft() || brands.isLeft()) {
      if (!_hasLoaded) {
        final failure = (vehicles.isLeft() ? vehicles : brands)
            .getLeft()
            .toNullable()!;

        emit(HomeError(failure.message));
      }

      return;
    }

    final vehiclePage = vehicles.getRight().toNullable()!;
    final brandPage = brands.getRight().toNullable()!;

    _hasLoaded = true;
    _vehiclePage = 1;
    _brandPage = 1;

    emit(
      HomeLoaded(
        vehicles: vehiclePage.items,
        brands: brandPage.items,
        selectedBrand: selectedBrand,
        hasMoreVehicles: vehiclePage.hasMore,
        hasMoreBrands: brandPage.hasMore,
        totalVehicles: vehiclePage.totalItems,
        totalBrands: brandPage.totalItems,
      ),
    );
  }

  // ============================================================
  // LOAD MORE
  // ============================================================

  Future<void> _onLoadMoreVehicles(
    HomeLoadMoreVehicles event,
    Emitter<HomeState> emit,
  ) async {
    final current = state;

    // Nothing to do before the first page, once the end is reached, or while
    // a page is already on its way.
    if (current is! HomeLoaded) return;
    if (!current.hasMoreVehicles || current.isLoadingMoreVehicles) return;

    final generation = _generation;

    emit(current.copyWith(isLoadingMoreVehicles: true));

    final result = await repository.getVehiclePage(
      page: _vehiclePage,
      size: pageSize,
      brand: current.selectedBrand,
    );

    if (generation != _generation) return;

    result.fold(
      (failure) => emit(current.copyWith(isLoadingMoreVehicles: false)),
      (page) {
        _vehiclePage++;

        emit(
          current.copyWith(
            vehicles: [...current.vehicles, ...page.items],
            hasMoreVehicles: page.hasMore,
            isLoadingMoreVehicles: false,
            totalVehicles: page.totalItems,
          ),
        );
      },
    );
  }

  Future<void> _onLoadMoreBrands(
    HomeLoadMoreBrands event,
    Emitter<HomeState> emit,
  ) async {
    final current = state;

    if (current is! HomeLoaded) return;
    if (!current.hasMoreBrands || current.isLoadingMoreBrands) return;

    final generation = _generation;

    emit(current.copyWith(isLoadingMoreBrands: true));

    final result = await repository.getBrandPage(
      page: _brandPage,
      size: pageSize,
    );

    if (generation != _generation) return;

    result.fold(
      (failure) => emit(current.copyWith(isLoadingMoreBrands: false)),
      (page) {
        _brandPage++;

        emit(
          current.copyWith(
            brands: [...current.brands, ...page.items],
            hasMoreBrands: page.hasMore,
            isLoadingMoreBrands: false,
            totalBrands: page.totalItems,
          ),
        );
      },
    );
  }

  // ============================================================
  // BRAND FILTER
  // ============================================================

  Future<void> _onBrandSelected(
    HomeBrandSelected event,
    Emitter<HomeState> emit,
  ) async {
    final current = state;

    // Tapping the chip that is already active is not a filter change.
    if (current is HomeLoaded && current.selectedBrand == event.brand) return;

    final brands = current is HomeLoaded ? current.brands : const <Brand>[];

    // Keep the brand chips on screen and empty the cars, so the section shows
    // its skeleton rather than the "no cars" message.
    emit(
      HomeLoaded(
        vehicles: const [],
        brands: brands,
        selectedBrand: event.brand,
        hasMoreVehicles: false,
        hasMoreBrands: current is HomeLoaded ? current.hasMoreBrands : false,
        isLoadingVehicles: true,
        totalVehicles: 0,
        totalBrands: current is HomeLoaded ? current.totalBrands : 0,
      ),
    );

    final generation = ++_generation;

    final result = await repository.getVehiclePage(
      page: 0,
      size: pageSize,
      brand: event.brand,
    );

    if (generation != _generation) return;

    final base = state;

    if (base is! HomeLoaded) return;

    result.fold(
      (failure) => emit(base.copyWith(isLoadingVehicles: false)),
      (page) {
        _vehiclePage = 1;

        emit(
          base.copyWith(
            vehicles: page.items,
            hasMoreVehicles: page.hasMore,
            isLoadingVehicles: false,
            totalVehicles: page.totalItems,
          ),
        );
      },
    );
  }
}
