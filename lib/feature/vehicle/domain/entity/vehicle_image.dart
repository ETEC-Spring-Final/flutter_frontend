class VehicleImage {
  final int id;
  final String fileUrl;
  final bool isPrimary;
  final int displayOrder;

  const VehicleImage({
    required this.id,
    required this.fileUrl,
    required this.isPrimary,
    required this.displayOrder,
  });
}
