import 'package:vehicle_rental_system/core/network/api_client.dart';
import 'package:vehicle_rental_system/core/network/api_endpoints.dart';
import 'package:vehicle_rental_system/feature/notification/data/datasource/notification_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/notification/data/model/notification_model.dart';

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient apiClient;

  NotificationRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final response = await apiClient.get<dynamic>(
      ApiEndpoints.notificationsInbox,
    );

    final data = _extractList(response.data);

    return data
        .whereType<Map>()
        .map((json) =>
            NotificationModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<NotificationModel> markAsRead(int id) async {
    final response = await apiClient.patch<dynamic>(
      ApiEndpoints.notificationRead(id),
    );

    final json = _extractMap(response.data);

    return NotificationModel.fromJson(json);
  }

  @override
  Future<void> markAllAsRead() async {
    await apiClient.patch<dynamic>(ApiEndpoints.notificationsReadAll);
  }

  List _extractList(dynamic body) {
    if (body is Map && body['data'] is List) {
      return body['data'] as List;
    }
    if (body is List) return body;
    return const [];
  }

  Map<String, dynamic> _extractMap(dynamic body) {
    if (body is Map && body['data'] is Map) {
      return Map<String, dynamic>.from(body['data'] as Map);
    }
    if (body is Map) return Map<String, dynamic>.from(body);
    return const {};
  }
}