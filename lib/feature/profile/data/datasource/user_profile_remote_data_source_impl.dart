import 'package:dio/dio.dart';
import 'package:vehicle_rental_system/core/network/api_client.dart';
import 'package:vehicle_rental_system/core/network/api_endpoints.dart';
import 'package:vehicle_rental_system/feature/profile/data/datasource/user_profile_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/profile/data/model/user_profile_model.dart';

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  final ApiClient apiClient;

  UserProfileRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserProfileModel> getMyProfile() async {
    final response = await apiClient.get<dynamic>(ApiEndpoints.myProfile);

    return UserProfileModel.fromJson(_extractMap(response.data));
  }

  @override
  Future<UserProfileModel> updateMyProfile({
    required String firstName,
    required String lastName,
    required String phone,
    String? profilePicture,
  }) async {
    final response = await apiClient.put<dynamic>(
      ApiEndpoints.myProfile,
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        if (profilePicture != null && profilePicture.isNotEmpty)
          'profilePicture': profilePicture,
      },
    );

    return UserProfileModel.fromJson(_extractMap(response.data));
  }

  @override
  Future<String> uploadImage(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        filename: 'profile_picture.jpg',
      ),
      'folder': 'user-profiles',
    });

    final response = await apiClient.post<dynamic>(
      ApiEndpoints.upload,
      data: formData,
    );

    final json = _extractMap(response.data);

    return json['url']?.toString() ?? '';
  }

  Map<String, dynamic> _extractMap(dynamic body) {
    if (body is Map && body['data'] is Map) {
      return Map<String, dynamic>.from(body['data'] as Map);
    }
    if (body is Map) return Map<String, dynamic>.from(body);
    return const {};
  }
}