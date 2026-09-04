import 'package:fpdart/fpdart.dart';
import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/booking/data/datasource/booking_local_data_source.dart';
import 'package:vehicle_rental_system/feature/booking/data/datasource/booking_remote_data_source.dart';
import 'package:vehicle_rental_system/feature/booking/data/mapper/booking_mapper.dart';
import 'package:vehicle_rental_system/feature/booking/domain/entity/booking.dart';
import 'package:vehicle_rental_system/feature/booking/domain/entity/new_booking_request.dart';
import 'package:vehicle_rental_system/feature/booking/domain/repository/booking_repository.dart';

/// [BookingRepository] backed by the remote `/bookings` API.
///
/// If the API is unreachable (e.g. backend offline during development) it
/// gracefully falls back to the hardcoded [mockBookings] so the UI keeps
/// working. Once the backend is live, remove the fallback (or keep it as
/// offline cache).
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
      // Offline fallback to the mock catalog.
      return Right(List.unmodifiable(mockBookings));
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
}
