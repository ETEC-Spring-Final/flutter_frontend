abstract class LocationRepository {
  Future<String> getLocationName({
    required double latitude,
    required double longitude,
  });
}
