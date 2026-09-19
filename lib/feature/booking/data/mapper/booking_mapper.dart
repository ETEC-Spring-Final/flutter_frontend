import 'package:vehicle_rental_system/feature/booking/data/model/booking_model.dart';
import 'package:vehicle_rental_system/feature/booking/domain/entity/booking.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/mapper/vehicle_mapper.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/model/vehicle_model.dart';

/// Converts between the [Booking] domain entity and [BookingModel] data model.
class BookingMapper {
  const BookingMapper._();

  // Data Model -> Domain Entity
  static Booking toEntity(BookingModel model) {
    final days = model.endDate.difference(model.startDate).inDays;
    final totalDays = days <= 0 ? 1 : days;

    final vehicleModel = model.vehicle ?? VehicleModel.placeholder(model.vehicleId);

    final pricePerDay = model.vehicle != null && model.vehicle!.pricePerDay > 0
        ? model.vehicle!.pricePerDay
        : model.totalPrice / totalDays;

    return Booking(
      id: model.id,
      bookingNumber: 'BK-${model.id.toString().padLeft(6, '0')}',
      vehicle: VehicleMapper.toEntity(vehicleModel),
      startDate: model.startDate,
      endDate: model.endDate,
      totalDays: totalDays,
      pricePerDay: pricePerDay,
      totalPrice: model.totalPrice,
      pickupLocation: model.pickupLocation,
      returnLocation: model.returnLocation,
      status: model.status,
    );
  }

  // Domain Entity -> Data Model
  static BookingModel toModel(Booking entity) {
    return BookingModel(
      id: entity.id,
      vehicleId: entity.vehicle.id,
      pickUpLocationId: 0,
      returnLocationId: 0,
      startDate: entity.startDate,
      endDate: entity.endDate,
      totalPrice: entity.totalPrice,
      status: entity.status,
      vehicle: VehicleMapper.toModel(entity.vehicle),
      pickupLocation: entity.pickupLocation,
      returnLocation: entity.returnLocation,
    );
  }
}
