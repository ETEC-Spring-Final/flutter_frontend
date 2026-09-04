import 'package:vehicle_rental_system/feature/booking/data/model/booking_model.dart';
import 'package:vehicle_rental_system/feature/booking/domain/entity/booking.dart';
import 'package:vehicle_rental_system/feature/vehicle/data/mapper/vehicle_mapper.dart';

/// Converts between the [Booking] domain entity and [BookingModel] data model.
class BookingMapper {
  const BookingMapper._();

  // Data Model -> Domain Entity
  static Booking toEntity(BookingModel model) {
    return Booking(
      id: model.id,
      bookingNumber: model.bookingNumber,
      vehicle: VehicleMapper.toEntity(model.vehicle),
      startDate: model.startDate,
      endDate: model.endDate,
      totalDays: model.totalDays,
      pricePerDay: model.pricePerDay,
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
      bookingNumber: entity.bookingNumber,
      vehicle: VehicleMapper.toModel(entity.vehicle),
      startDate: entity.startDate,
      endDate: entity.endDate,
      totalDays: entity.totalDays,
      pricePerDay: entity.pricePerDay,
      totalPrice: entity.totalPrice,
      pickupLocation: entity.pickupLocation,
      returnLocation: entity.returnLocation,
      status: entity.status,
    );
  }
}
