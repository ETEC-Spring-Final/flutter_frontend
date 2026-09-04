import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/core/widgets/app_back_button.dart';
import 'package:vehicle_rental_system/core/widgets/app_booking_bottom_bar.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/view/additional_services_screen.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/widgets/rental_detail/rental_date_time_field.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/widgets/rental_detail/rental_days_summary.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/widgets/rental_detail/rental_header.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/widgets/rental_detail/rental_location_dropdown.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/widgets/rental_detail/rental_section_card.dart';

class RentalDetailsScreen extends StatefulWidget {
  const RentalDetailsScreen({super.key, required this.vehicle});

  final Vehicle vehicle;

  @override
  State<RentalDetailsScreen> createState() => _RentalDetailsScreenState();
}

class _RentalDetailsScreenState extends State<RentalDetailsScreen> {
  DateTime? _pickupDate;
  DateTime? _returnDate;

  TimeOfDay? _pickupTime;
  TimeOfDay? _returnTime;

  String _pickupLocation = 'Phnom Penh International Airport';
  String _returnLocation = 'Phnom Penh International Airport';

  // ===========================================================================
  // DATE
  // ===========================================================================

  Future<void> _selectDate({required bool isPickup}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final currentDate = isPickup
        ? _pickupDate ?? today
        : _returnDate ?? _pickupDate ?? today;

    final firstDate = isPickup ? today : _pickupDate ?? today;

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate.isBefore(firstDate) ? firstDate : currentDate,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 2),
    );

    if (selectedDate == null || !mounted) return;

    if (!isPickup &&
        _pickupDate != null &&
        _isSameDate(selectedDate, _pickupDate!)) {
      _showMessage(
        'Return date must be a different day from the pick-up date.',
      );
      return;
    }

    setState(() {
      if (isPickup) {
        _pickupDate = selectedDate;

        if (_returnDate != null && _returnDate!.isBefore(selectedDate)) {
          _returnDate = null;
          _returnTime = null;
        }
      } else {
        _returnDate = selectedDate;

        if (_pickupDate != null &&
            _pickupTime != null &&
            _isSameDate(selectedDate, _pickupDate!)) {
          if (_returnTime != null &&
              _isTimeBefore(_returnTime!, _pickupTime!)) {
            _returnTime = null;
          }
        }
      }
    });
  }

  // ===========================================================================
  // TIME
  // ===========================================================================

  Future<void> _selectTime({required bool isPickup}) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: isPickup
          ? _pickupTime ?? const TimeOfDay(hour: 9, minute: 0)
          : _returnTime ?? const TimeOfDay(hour: 9, minute: 0),
    );

    if (selectedTime == null || !mounted) return;

    if (!isPickup &&
        _pickupDate != null &&
        _returnDate != null &&
        _pickupTime != null &&
        _isSameDate(_pickupDate!, _returnDate!) &&
        _isTimeBefore(selectedTime, _pickupTime!)) {
      _showMessage('Return time must be after the pick-up time.');
      return;
    }

    setState(() {
      if (isPickup) {
        _pickupTime = selectedTime;
      } else {
        _returnTime = selectedTime;
      }
    });
  }

  // ===========================================================================
  // VALIDATION
  // ===========================================================================

  bool _isSameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  bool _isTimeBefore(TimeOfDay first, TimeOfDay second) {
    final firstMinutes = first.hour * 60 + first.minute;

    final secondMinutes = second.hour * 60 + second.minute;

    return firstMinutes < secondMinutes;
  }

  bool get _hasAllDetails {
    return _pickupDate != null &&
        _returnDate != null &&
        _pickupTime != null &&
        _returnTime != null;
  }

  DateTime _combine(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  int get _rentalDays {
    if (!_hasAllDetails) return 0;

    final pickup = _combine(_pickupDate!, _pickupTime!);

    final returnDate = _combine(_returnDate!, _returnTime!);

    final difference = returnDate.difference(pickup);

    if (difference <= Duration.zero) {
      return 0;
    }

    return (difference.inMinutes / (24 * 60)).ceil();
  }

  bool get _canContinue => _rentalDays > 0;

  // ===========================================================================
  // CONTINUE
  // ===========================================================================

  void _continue() {
    if (!_hasAllDetails) {
      _showMessage('Please complete your rental details.');
      return;
    }

    if (_rentalDays <= 0) {
      _showMessage('Return date/time must be after the pick-up date/time.');
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AdditionalServicesScreen(
          vehicle: widget.vehicle,
          pickupDate: _pickupDate!,
          returnDate: _returnDate!,
          pickupTime: _pickupTime!,
          returnTime: _returnTime!,
          pickupLocation: _pickupLocation,
          returnLocation: _returnLocation,
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // ===========================================================================
  // FORMATTERS
  // ===========================================================================

  String _formatDate(DateTime? date) {
    if (date == null) return 'mm/dd/yyyy';

    return '${date.month.toString().padLeft(2, '0')}/'
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '--:--';

    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;

    final minute = time.minute.toString().padLeft(2, '0');

    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,

      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),

          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.chipHorizontalPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 24.h),

                _buildRentalDetailsCard(),

                SizedBox(height: 14.h),
              ]),
            ),
          ),
        ],
      ),

      bottomNavigationBar: AppBookingBottomBar(
        label: 'Continue to Services',
        icon: Icons.arrow_forward_rounded,
        onPressed: _continue,
        enabled: _canContinue,
      ),
    );
  }

  // ===========================================================================
  // APP BAR
  // ===========================================================================

  Widget _buildAppBar() {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SliverAppBar(
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: colors.surface,
      expandedHeight: 340.h,
      leadingWidth: 60.w,

      leading: Padding(
        padding: EdgeInsets.all(12.w),
        child: const AppBackButton(),
      ),

      title: Text(
        'Rental Details',
        style: theme.textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),

      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: RentalHeader(vehicle: widget.vehicle),
      ),
    );
  }

  // ===========================================================================
  // RENTAL DETAILS
  // ===========================================================================

  Widget _buildRentalDetailsCard() {
    return RentalSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RentalSectionTitle(
            icon: Icons.calendar_month_rounded,
            title: 'Rental Dates',
          ),

          SizedBox(height: 20.h),

          const RentalFieldLabel(label: 'Pick-up Date & Time'),

          SizedBox(height: 8.h),

          RentalDateTimeField(
            value:
                '${_formatDate(_pickupDate)} • '
                '${_formatTime(_pickupTime)}',
            isSet: _pickupDate != null && _pickupTime != null,
            onTap: () async {
              await _selectDate(isPickup: true);

              if (_pickupDate != null && mounted) {
                await _selectTime(isPickup: true);
              }
            },
          ),

          SizedBox(height: 16.h),

          const RentalFieldLabel(label: 'Return Date & Time'),

          SizedBox(height: 8.h),

          RentalDateTimeField(
            value:
                '${_formatDate(_returnDate)} • '
                '${_formatTime(_returnTime)}',
            isSet: _returnDate != null && _returnTime != null,
            onTap: () async {
              if (_pickupDate == null) {
                _showMessage('Please select pick-up date first.');
                return;
              }

              await _selectDate(isPickup: false);

              if (_returnDate != null && mounted) {
                await _selectTime(isPickup: false);
              }
            },
          ),

          if (_rentalDays > 0) ...[
            SizedBox(height: 16.h),

            RentalDaysSummary(
              days: _rentalDays,
              pricePerDay: widget.vehicle.pricePerDay,
            ),
          ],

          SizedBox(height: 26.h),

          const RentalSectionTitle(
            icon: Icons.location_on_rounded,
            title: 'Location',
          ),

          SizedBox(height: 20.h),

          RentalLocationDropdown(
            label: 'Pick-up Location',
            value: _pickupLocation,
            onChanged: (value) {
              setState(() {
                _pickupLocation = value;
              });
            },
          ),

          SizedBox(height: 16.h),

          RentalLocationDropdown(
            label: 'Return Location',
            value: _returnLocation,
            onChanged: (value) {
              setState(() {
                _returnLocation = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
