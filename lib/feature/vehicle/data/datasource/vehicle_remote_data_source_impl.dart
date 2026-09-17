import 'dart:io';

import 'package:dio/dio.dart';
import 'package:vehicle_rental_system/core/constants/api_constants.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/datasource/vehicle_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/model/vehicle_image_model.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/model/vehicle_model.dart';

class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  final Dio dio;

  VehicleRemoteDataSourceImpl(this.dio);

  @override
  Future<List<VehicleModel>> getVehicles() async {
    // Spring Boot returns a raw JSON list (not wrapped in { data: ... }).
    final response = await dio.get(ApiConstants.vehicles);

    final data = response.data as List;

    final vehicles = data
        .map((json) => VehicleModel.fromJson(json as Map<String, dynamic>))
        .toList();

    for (final vehicle in vehicles) {
      final images = await _fetchImages(vehicle.id);
      if (images.isNotEmpty) {
        vehicle.images
          ..clear()
          ..addAll(images);
      }
    }

    return vehicles;
  }

  @override
  Future<VehicleModel> getVehicleById(int id) async {
    final response = await dio.get(ApiConstants.vehicleById(id));

    final vehicle = VehicleModel.fromJson(response.data as Map<String, dynamic>);

    final images = await _fetchImages(id);
    if (images.isNotEmpty) {
      vehicle.images
        ..clear()
        ..addAll(images);
    }

    return vehicle;
  }

  @override
  Future<VehicleModel> createVehicle(VehicleModel vehicle) async {
    final response = await dio.post(
      ApiConstants.vehicles,
      data: vehicle.toCreateRequest(),
    );

    final created = VehicleModel.fromJson(response.data as Map<String, dynamic>);

    await _attachImages(created);

    return created;
  }

  @override
  Future<VehicleModel> updateVehicle(VehicleModel vehicle) async {
    final response = await dio.put(
      ApiConstants.updateVehicle(vehicle.id),
      data: vehicle.toUpdateRequest(),
    );

    final updated = VehicleModel.fromJson(response.data as Map<String, dynamic>);

    await _attachImages(updated);

    return updated;
  }

  @override
  Future<void> deleteVehicle(int id) async {
    await dio.delete(ApiConstants.deleteVehicle(id));
  }

  @override
  Future<void> uploadVehicleImages(int vehicleId, List<File> images) async {
    for (final image in images) {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(image.path),
      });

      await dio.post(
        ApiConstants.uploadVehicleImages(vehicleId),
        data: formData,
      );
    }
  }

  Future<void> _attachImages(VehicleModel vehicle) async {
    final images = await _fetchImages(vehicle.id);
    if (images.isNotEmpty) {
      vehicle.images
        ..clear()
        ..addAll(images);
    }
  }

  /// Fetches `GET /vehicle-images/{vehicleId}` and maps the attachments.
  Future<List<VehicleImageModel>> _fetchImages(int vehicleId) async {
    try {
      final response = await dio.get('${ApiConstants.vehicleImages}/$vehicleId');

      final data = response.data as List;

      return data.map((json) {
        final map = json as Map<String, dynamic>;
        final attachment = map['attachment'] as Map<String, dynamic>?;

        return VehicleImageModel(
          id: map['id'] ?? 0,
          fileUrl: attachment?['fileUrl'] ?? '',
          isPrimary: false,
          displayOrder: 0,
        );
      }).toList();
    } catch (_) {
      return const [];
    }
  }
}