/// Raw model for `FavoriteResponseDTO`:
///
/// ```json
/// { "id": 1, "vehicle": { ...VehicleResponseDTO }, "createdAt": "..." }
/// ```
///
/// Only the favorite id and the nested vehicle id are needed by the domain,
/// since [FavoriteBloc] works with a set of vehicle ids.
class FavoriteResponseModel {
  final int id;
  final int vehicleId;

  const FavoriteResponseModel({required this.id, required this.vehicleId});

  factory FavoriteResponseModel.fromJson(Map<String, dynamic> json) {
    final vehicle = json['vehicle'];
    return FavoriteResponseModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      vehicleId: _extractVehicleId(vehicle),
    );
  }

  static int _extractVehicleId(dynamic vehicle) {
    if (vehicle is Map<String, dynamic>) {
      return (vehicle['id'] as num?)?.toInt() ?? 0;
    }
    if (vehicle is Map) {
      final id = vehicle['id'];
      return (id as num?)?.toInt() ?? 0;
    }
    return 0;
  }
}
