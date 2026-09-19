class VehicleImageModel {
  final int id;
  final int vehicleId;
  final int attachmentId;
  final String fileUrl;
  final bool isPrimary;
  final int displayOrder;

  const VehicleImageModel({
    required this.id,
    this.vehicleId = 0,
    this.attachmentId = 0,
    required this.fileUrl,
    required this.isPrimary,
    required this.displayOrder,
  });

  factory VehicleImageModel.fromJson(Map<String, dynamic> json) {
    final attachment = json['attachment'];

    if (attachment is Map<String, dynamic>) {
      return VehicleImageModel(
        id: json['id'] ?? 0,
        vehicleId: (json['vehicleId'] as num?)?.toInt() ?? 0,
        attachmentId: attachment['id'] ?? 0,
        fileUrl: attachment['fileUrl'] ?? '',
        isPrimary: attachment['isPrimary'] ?? false,
        displayOrder: attachment['displayOrder'] ?? 0,
      );
    }

    return VehicleImageModel(
      id: json['id'] ?? 0,
      vehicleId: (json['vehicleId'] as num?)?.toInt() ?? 0,
      attachmentId: (json['attachmentId'] as num?)?.toInt() ?? 0,
      fileUrl: json['fileUrl'] ?? '',
      isPrimary: json['isPrimary'] ?? false,
      displayOrder: json['displayOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'attachmentId': attachmentId,
      'fileUrl': fileUrl,
      'isPrimary': isPrimary,
      'displayOrder': displayOrder,
    };
  }
}
