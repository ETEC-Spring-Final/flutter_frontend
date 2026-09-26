part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// First load: page zero of the vehicles and of the brands.
class HomeStarted extends HomeEvent {
  const HomeStarted();
}

/// Pull to refresh: page zero again, keeping the active brand filter.
class HomeRefreshed extends HomeEvent {
  const HomeRefreshed();
}

/// Append the next page of vehicles.
class HomeLoadMoreVehicles extends HomeEvent {
  const HomeLoadMoreVehicles();
}

/// Append the next page of brands.
class HomeLoadMoreBrands extends HomeEvent {
  const HomeLoadMoreBrands();
}

/// Taps a brand chip, or the "All" chip when [brand] is null.
///
/// Restarts the vehicles at page zero with the new filter.
class HomeBrandSelected extends HomeEvent {
  final String? brand;

  const HomeBrandSelected(this.brand);

  @override
  List<Object?> get props => [brand];
}
