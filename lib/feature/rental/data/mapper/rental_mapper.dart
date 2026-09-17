import 'package:vehicle_rental_system/feature/rental/data/model/rental_model.dart';
import 'package:vehicle_rental_system/feature/rental/domain/entity/rental.dart';

class RentalMapper {
  const RentalMapper._();

  static Rental toEntity(RentalModel model) {
    return Rental(
      id: model.id,
      reservationId: model.reservationId,
      vehicleId: model.vehicleId,
      userId: model.userId,
      pickUpLocationId: model.pickUpLocationId,
      returnLocationId: model.returnLocationId,
      pickUpDateTime: model.pickUpDateTime,
      expectedReturnDateTime: model.expectedReturnDateTime,
      actualReturnDateTime: model.actualReturnDateTime,
      status: model.status,
      basePrice: model.basePrice,
      discountAmount: model.discountAmount,
      additionalCharges: model.additionalCharges,
      lateFee: model.lateFee,
      totalPrice: model.totalPrice,
      notes: model.notes,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}