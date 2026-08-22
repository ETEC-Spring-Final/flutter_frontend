import '../../domain/repository/location_repository.dart';
import '../datasource/location_remote_data_source.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;

  LocationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> getLocationName({
    required double latitude,
    required double longitude,
  }) {
    return remoteDataSource.getLocationName(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
