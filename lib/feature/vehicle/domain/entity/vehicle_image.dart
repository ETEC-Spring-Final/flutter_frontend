class VehicleImage {
  final int id;
  final int vehicleId;
  final int attachmentId;
  final String fileUrl;
  final bool isPrimary;
  final int displayOrder;

  const VehicleImage({
    required this.id,
    this.vehicleId = 0,
    this.attachmentId = 0,
    required this.fileUrl,
    required this.isPrimary,
    required this.displayOrder,
  });
}
