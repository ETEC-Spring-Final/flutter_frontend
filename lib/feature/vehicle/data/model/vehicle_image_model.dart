class VehicleImageModel {
  final int id;
  final String fileUrl;
  final bool isPrimary;
  final int displayOrder;

  const VehicleImageModel({
    required this.id,
    required this.fileUrl,
    required this.isPrimary,
    required this.displayOrder,
  });

  factory VehicleImageModel.fromJson(Map<String, dynamic> json) {
    return VehicleImageModel(
      id: json['id'] ?? 0,
      fileUrl: json['fileUrl'] ?? '',
      isPrimary: json['isPrimary'] ?? false,
      displayOrder: json['displayOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileUrl': fileUrl,
      'isPrimary': isPrimary,
      'displayOrder': displayOrder,
    };
  }
}
