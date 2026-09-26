part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

class HomeLoaded extends HomeState {
  /// Vehicles of the pages loaded so far, already narrowed to [selectedBrand].
  final List<Vehicle> vehicles;

  /// Brands of the pages loaded so far.
  final List<Brand> brands;

  /// Name of the active brand chip, or null for "All".
  final String? selectedBrand;

  final bool hasMoreVehicles;
  final bool hasMoreBrands;

  /// True while page zero of the vehicle list is in flight, either on the
  /// first load or after the brand filter changed.
  final bool isLoadingVehicles;

  /// True while a "load more" page is in flight, so the section can show a
  /// spinner instead of the section being empty.
  final bool isLoadingMoreVehicles;
  final bool isLoadingMoreBrands;

  /// Totals across every page, used for the "no cars" check and the counter.
  final int totalVehicles;
  final int totalBrands;

  const HomeLoaded({
    required this.vehicles,
    required this.brands,
    this.selectedBrand,
    required this.hasMoreVehicles,
    required this.hasMoreBrands,
    this.isLoadingVehicles = false,
    this.isLoadingMoreVehicles = false,
    this.isLoadingMoreBrands = false,
    required this.totalVehicles,
    required this.totalBrands,
  });

  /// True when the API has no vehicle for the active brand at all, which is
  /// different from "the loaded pages happen to be empty".
  bool get hasNoVehicles => !isLoadingVehicles && totalVehicles == 0;

  HomeLoaded copyWith({
    List<Vehicle>? vehicles,
    List<Brand>? brands,
    String? selectedBrand,
    bool clearSelectedBrand = false,
    bool? hasMoreVehicles,
    bool? hasMoreBrands,
    bool? isLoadingVehicles,
    bool? isLoadingMoreVehicles,
    bool? isLoadingMoreBrands,
    int? totalVehicles,
    int? totalBrands,
  }) {
    return HomeLoaded(
      vehicles: vehicles ?? this.vehicles,
      brands: brands ?? this.brands,
      selectedBrand: clearSelectedBrand
          ? null
          : selectedBrand ?? this.selectedBrand,
      hasMoreVehicles: hasMoreVehicles ?? this.hasMoreVehicles,
      hasMoreBrands: hasMoreBrands ?? this.hasMoreBrands,
      isLoadingVehicles: isLoadingVehicles ?? this.isLoadingVehicles,
      isLoadingMoreVehicles: isLoadingMoreVehicles ?? this.isLoadingMoreVehicles,
      isLoadingMoreBrands: isLoadingMoreBrands ?? this.isLoadingMoreBrands,
      totalVehicles: totalVehicles ?? this.totalVehicles,
      totalBrands: totalBrands ?? this.totalBrands,
    );
  }

  @override
  List<Object?> get props => [
    vehicles,
    brands,
    selectedBrand,
    hasMoreVehicles,
    hasMoreBrands,
    isLoadingVehicles,
    isLoadingMoreVehicles,
    isLoadingMoreBrands,
    totalVehicles,
    totalBrands,
  ];
}
