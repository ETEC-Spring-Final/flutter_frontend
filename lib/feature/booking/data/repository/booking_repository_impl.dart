import 'package:fpdart/fpdart.dart';
import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/booking/data/datasource/booking_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/booking/data/mapper/additional_service_mapper.dart';
import 'package:vehicle_rental_system/feature/booking/data/mapper/booking_mapper.dart';
import 'package:vehicle_rental_system/feature/booking/domain/entity/additional_service.dart';
import 'package:vehicle_rental_system/feature/booking/domain/entity/booking.dart';
import 'package:vehicle_rental_system/feature/booking/domain/entity/new_booking_request.dart';
import 'package:vehicle_rental_system/feature/booking/domain/repository/booking_repository.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/rental_location.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remote;

  BookingRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, List<Booking>>> getBookings() async {
    try {
      final models = await remote.getBookings();

      final bookings = models.map(BookingMapper.toEntity).toList();

      return Right(bookings);
    } catch (e) {
      return Left(ServiceFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Booking>> createBooking(
    NewBookingRequest request,
  ) async {
    try {
      final model = await remote.createBooking(request.toJson());

      return Right(BookingMapper.toEntity(model));
    } catch (e) {
      return Left(ServiceFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Booking>> cancelBooking(int id) async {
    try {
      final model = await remote.cancelBooking(id);

      return Right(BookingMapper.toEntity(model));
    } catch (e) {
      return Left(ServiceFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RentalLocation>>> getLocations() async {
    try {
      final locations = await remote.getLocations();

      return Right(locations);
    } catch (e) {
      return Left(ServiceFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AdditionalService>>> getAdditionalServices() async {
    try {
      final models = await remote.getAdditionalServices();

      final services = models.map(AdditionalServiceMapper.toEntity).toList();

      return Right(services);
    } catch (e) {
      return Left(ServiceFailure(e.toString()));
    }
  }
}
