import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle.dart';
import 'package:vehicle_rental_system/feature/vehicle/domain/entity/vehicle_image.dart';
import 'package:vehicle_rental_system/feature/vehicle/presentation/bloc/vehicle_bloc.dart';

class VehicleCrudScreen extends StatefulWidget {
  const VehicleCrudScreen({super.key});

  @override
  State<VehicleCrudScreen> createState() => _VehicleCrudScreenState();
}

class _VehicleCrudScreenState extends State<VehicleCrudScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VehicleBloc>().add(const GetVehicles());
  }

  Future<void> _refresh() async {
    context.read<VehicleBloc>().add(const GetVehicles());
  }

  Future<void> _openForm([Vehicle? vehicle]) async {
    final result = await Navigator.of(context).push<_VehicleFormResult>(
      MaterialPageRoute(builder: (_) => _VehicleFormScreen(vehicle: vehicle)),
    );

    if (result == null || !mounted) return;

    if (vehicle == null) {
      context.read<VehicleBloc>().add(
        CreateVehicleEvent(result.vehicle, result.newImages),
      );
    } else {
      context.read<VehicleBloc>().add(
        UpdateVehicleEvent(result.vehicle, result.newImages),
      );
    }
  }

  Future<void> _confirmDelete(Vehicle vehicle) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Vehicle'),
          content: Text(
            'Delete "${vehicle.brand} ${vehicle.model}" '
            '(ID: ${vehicle.id})? This cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(dialogContext).colorScheme.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    context.read<VehicleBloc>().add(DeleteVehicleEvent(vehicle.id));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<VehicleBloc, VehicleState>(
      listener: (context, state) {
        if (state is VehicleSuccess) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text(state.message)));

          context.read<VehicleBloc>().add(const GetVehicles());
        }

        if (state is VehicleError) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Vehicle CRUD (Test)')),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openForm(),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add Vehicle'),
        ),
        body: BlocBuilder<VehicleBloc, VehicleState>(
          builder: (context, state) {
            if (state is VehicleLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is VehicleError) {
              return _ErrorState(message: state.message, onRetry: _refresh);
            }

            if (state is! VehicleLoaded) {
              return _ErrorState(
                message: 'No vehicles loaded.',
                onRetry: _refresh,
              );
            }

            if (state.vehicles.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.directions_car_outlined,
                      size: 64.r,
                      color: theme.colorScheme.outline.withValues(alpha: 0.5),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No vehicles found',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Tap "Add Vehicle" to create one.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(AppDimensions.chipHorizontalPadding),
                itemCount: state.vehicles.length,
                separatorBuilder: (_, _) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final vehicle = state.vehicles[index];
                  return _VehicleCard(
                    vehicle: vehicle,
                    onEdit: () => _openForm(vehicle),
                    onDelete: () => _confirmDelete(vehicle),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

// =====================================================================
// ERROR STATE
// =====================================================================

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 56.r,
              color: theme.colorScheme.error,
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 16.h),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// VEHICLE CARD
// =====================================================================

class _VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _VehicleCard({
    required this.vehicle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        side: BorderSide(color: colorScheme.outline),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            _Thumbnail(vehicle: vehicle),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${vehicle.brand} ${vehicle.model}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${vehicle.yearOfManufacture} • ${vehicle.type} • '
                    '${vehicle.licensePlate}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 4.h,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        '\$${vehicle.pricePerDay.toStringAsFixed(0)}/day',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor(
                            context,
                            vehicle.status,
                          ).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          vehicle.status.isEmpty ? '-' : vehicle.status,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: _statusColor(context, vehicle.status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: onEdit,
                  tooltip: 'Edit',
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  onPressed: onDelete,
                  tooltip: 'Delete',
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: colorScheme.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(BuildContext context, String status) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'rented':
      case 'booked':
        return colorScheme.primary;
      case 'maintenance':
        return Colors.orange;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }
}

// =====================================================================
// THUMBNAIL
// =====================================================================

class _Thumbnail extends StatelessWidget {
  final Vehicle vehicle;

  const _Thumbnail({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final url = vehicle.images.isNotEmpty ? vehicle.images.first.fileUrl : null;

    return Container(
      width: 64.r,
      height: 64.r,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: (url == null || url.isEmpty)
          ? Icon(
              Icons.directions_car_outlined,
              size: 28.r,
              color: colorScheme.onSurfaceVariant,
            )
          : Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Icon(
                Icons.broken_image_outlined,
                size: 28.r,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
    );
  }
}

// =====================================================================
// FORM RESULT
// =====================================================================

class _VehicleFormResult {
  final Vehicle vehicle;
  final List<File> newImages;

  const _VehicleFormResult({required this.vehicle, required this.newImages});
}

// =====================================================================
// VEHICLE FORM (create / edit)
// =====================================================================

class _VehicleFormScreen extends StatefulWidget {
  final Vehicle? vehicle;

  const _VehicleFormScreen({this.vehicle});

  @override
  State<_VehicleFormScreen> createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends State<_VehicleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<File> _pickedImages = [];

  late final TextEditingController _brand;
  late final TextEditingController _model;
  late final TextEditingController _year;
  late final TextEditingController _licensePlate;
  late final TextEditingController _color;
  late final TextEditingController _seats;
  late final TextEditingController _doors;
  late final TextEditingController _luggages;
  late final TextEditingController _price;
  late final TextEditingController _mileAge;
  late final TextEditingController _description;

  late List<String> _types;
  late List<String> _transmissions;
  late List<String> _fuelTypes;
  late List<String> _statuses;

  late String _type;
  late String _transmission;
  late String _fuelType;
  late String _status;

  static const List<String> _defaultTypes = [
    'SUV',
    'SEDAN',
    'PICKUP',
    'VAN',
    'LUXURY',
    'ELECTRIC',
  ];

  static const List<String> _defaultTransmissions = ['AUTOMATIC', 'MANUAL'];

  static const List<String> _defaultFuelTypes = [
    'PETROL',
    'DIESEL',
    'ELECTRIC',
    'HYBRID',
  ];

  static const List<String> _defaultStatuses = [
    'AVAILABLE',
    'BOOKED',
    'RENTED',
    'MAINTENANCE',
  ];

  bool get _isEditing => widget.vehicle != null;

  @override
  void initState() {
    super.initState();

    final v = widget.vehicle;

    _brand = TextEditingController(text: v?.brand ?? '');
    _model = TextEditingController(text: v?.model ?? '');
    _year = TextEditingController(
      text: v != null ? v.yearOfManufacture.toString() : '',
    );
    _licensePlate = TextEditingController(text: v?.licensePlate ?? '');
    _color = TextEditingController(text: v?.color ?? '');
    _seats = TextEditingController(text: v != null ? v.seats.toString() : '');
    _doors = TextEditingController(text: v != null ? v.doors.toString() : '');
    _luggages = TextEditingController(
      text: v != null ? v.luggages.toString() : '',
    );
    _price = TextEditingController(
      text: v != null ? _dropTrailingZeros(v.pricePerDay) : '',
    );
    _mileAge = TextEditingController(
      text: v != null ? v.mileAge.toString() : '',
    );
    _description = TextEditingController(text: v?.description ?? '');

    _types = _withFallback(_defaultTypes, v?.type);
    _transmissions = _withFallback(_defaultTransmissions, v?.transmission);
    _fuelTypes = _withFallback(_defaultFuelTypes, v?.fuelType);
    _statuses = _withFallback(_defaultStatuses, v?.status);

    _type = _types.contains(v?.type) ? v!.type : _types.first;
    _transmission = _transmissions.contains(v?.transmission)
        ? v!.transmission
        : _transmissions.first;
    _fuelType = _fuelTypes.contains(v?.fuelType)
        ? v!.fuelType
        : _fuelTypes.first;
    _status = _statuses.contains(v?.status) ? v!.status : _statuses.first;
  }

  static List<String> _withFallback(List<String> options, String? value) {
    if (value == null || value.isEmpty) return options;
    if (options.contains(value)) return options;
    return [value, ...options];
  }

  static String _dropTrailingZeros(double value) {
    return value == value.roundToDouble()
        ? value.round().toString()
        : value.toString();
  }

  @override
  void dispose() {
    _brand.dispose();
    _model.dispose();
    _year.dispose();
    _licensePlate.dispose();
    _color.dispose();
    _seats.dispose();
    _doors.dispose();
    _luggages.dispose();
    _price.dispose();
    _mileAge.dispose();
    _description.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final current = widget.vehicle;

    final vehicle = Vehicle(
      id: current?.id ?? 0,
      brand: _brand.text.trim(),
      model: _model.text.trim(),
      yearOfManufacture: int.parse(_year.text.trim()),
      licensePlate: _licensePlate.text.trim(),
      color: _color.text.trim(),
      type: _type,
      transmission: _transmission,
      fuelType: _fuelType,
      seats: int.parse(_seats.text.trim()),
      doors: int.parse(_doors.text.trim()),
      luggages: int.parse(_luggages.text.trim()),
      pricePerDay: double.parse(_price.text.trim()),
      mileAge: int.parse(_mileAge.text.trim()),
      description: _description.text.trim(),
      status: _status,
      images: current?.images ?? const [],
      createdAt: current?.createdAt,
      updatedAt: current?.updatedAt,
    );

    Navigator.of(context).pop(
      _VehicleFormResult(
        vehicle: vehicle,
        newImages: List.unmodifiable(_pickedImages),
      ),
    );
  }

  Future<void> _pickImages() async {
    final picked = await ImagePicker().pickMultiImage();

    if (picked.isEmpty) return;
    if (!mounted) return;

    setState(() {
      _pickedImages.addAll(picked.map((image) => File(image.path)));
    });
  }

  void _removePickedImage(int index) {
    setState(() => _pickedImages.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Vehicle' : 'Add Vehicle')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(AppDimensions.chipHorizontalPadding),
          children: [
            Text(
              _isEditing
                  ? 'Updating vehicle ID ${widget.vehicle!.id}'
                  : 'Fill in the details below. A new vehicle will be '
                        'created via POST /vehicles.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 16.h),

            _TextForm(
              controller: _brand,
              label: 'Brand',
              hint: 'e.g. Toyota',
              validator: _required,
            ),
            SizedBox(height: 12.h),

            _TextForm(
              controller: _model,
              label: 'Model',
              hint: 'e.g. Camry',
              validator: _required,
            ),
            SizedBox(height: 12.h),

            Row(
              children: [
                Expanded(
                  child: _TextForm(
                    controller: _year,
                    label: 'Year',
                    keyboardType: TextInputType.number,
                    validator: (value) => _requiredNumber(value),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _TextForm(
                    controller: _licensePlate,
                    label: 'License Plate',
                    hint: 'e.g. 2A-5588',
                    validator: _required,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            Row(
              children: [
                Expanded(
                  child: _TextForm(
                    controller: _color,
                    label: 'Color',
                    hint: 'e.g. White',
                    validator: _required,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _DropdownForm<String>(
                    label: 'Type',
                    value: _type,
                    items: _types,
                    onChanged: (value) =>
                        setState(() => _type = value ?? _types.first),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            Row(
              children: [
                Expanded(
                  child: _DropdownForm<String>(
                    label: 'Transmission',
                    value: _transmission,
                    items: _transmissions,
                    onChanged: (value) => setState(
                      () => _transmission = value ?? _transmissions.first,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _DropdownForm<String>(
                    label: 'Fuel Type',
                    value: _fuelType,
                    items: _fuelTypes,
                    onChanged: (value) =>
                        setState(() => _fuelType = value ?? _fuelTypes.first),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            Row(
              children: [
                Expanded(
                  child: _TextForm(
                    controller: _seats,
                    label: 'Seats',
                    keyboardType: TextInputType.number,
                    validator: (value) => _requiredNumber(value),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _TextForm(
                    controller: _doors,
                    label: 'Doors',
                    keyboardType: TextInputType.number,
                    validator: (value) => _requiredNumber(value),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _TextForm(
                    controller: _luggages,
                    label: 'Luggages',
                    keyboardType: TextInputType.number,
                    validator: (value) => _requiredNumber(value),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            Row(
              children: [
                Expanded(
                  child: _TextForm(
                    controller: _price,
                    label: 'Price / Day',
                    hint: 'e.g. 60',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) => _requiredNumber(value, decimal: true),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _TextForm(
                    controller: _mileAge,
                    label: 'Mileage (km)',
                    keyboardType: TextInputType.number,
                    validator: (value) => _requiredNumber(value),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            _DropdownForm<String>(
              label: 'Status',
              value: _status,
              items: _statuses,
              onChanged: (value) =>
                  setState(() => _status = value ?? _statuses.first),
            ),
            SizedBox(height: 12.h),

            _TextForm(
              controller: _description,
              label: 'Description (optional)',
              hint: 'Short description shown on the detail screen.',
              maxLines: 4,
            ),
            SizedBox(height: 20.h),

            // =====================================================
            // IMAGES
            // =====================================================
            Text(
              'Images',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              _isEditing
                  ? 'Existing images stay attached. Uploaded images are '
                        'added to this vehicle.'
                  : 'Select one or more images. They are uploaded to the '
                        'vehicle right after creation.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 12.h),

            if (_isEditing && widget.vehicle!.images.isNotEmpty) ...[
              _ExistingImages(images: widget.vehicle!.images),
              SizedBox(height: 12.h),
            ],

            if (_pickedImages.isNotEmpty) ...[
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8.w,
                crossAxisSpacing: 8.w,
                children: [
                  for (var i = 0; i < _pickedImages.length; i++)
                    _PickedImageTile(
                      file: _pickedImages[i],
                      onRemove: () => _removePickedImage(i),
                    ),
                ],
              ),
              SizedBox(height: 12.h),
            ],

            OutlinedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.add_photo_alternate_outlined),
              label: Text(
                _pickedImages.isEmpty
                    ? 'Add Images (multi-select)'
                    : 'Add More Images',
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
            SizedBox(height: 8.h),

            Text(
              _pickedImages.isEmpty
                  ? 'No images selected.'
                  : '${_pickedImages.length} image(s) selected.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 16.h),

            FilledButton.icon(
              onPressed: _submit,
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              icon: Icon(_isEditing ? Icons.save_outlined : Icons.add_rounded),
              label: Text(
                _isEditing ? 'Save Changes' : 'Create Vehicle',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  String? _required(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Required';
    return null;
  }

  String? _requiredNumber(String? value, {bool decimal = false}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Required';

    final number = decimal ? double.tryParse(text) : int.tryParse(text);
    if (number == null) return 'Must be a number';
    if (number < 0) return 'Must be 0 or more';

    return null;
  }
}

// =====================================================================
// TEXT FORM FIELD
// =====================================================================

class _TextForm extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  const _TextForm({
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }
}

// =====================================================================
// DROPDOWN FORM FIELD
// =====================================================================

class _DropdownForm<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;

  const _DropdownForm({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(item.toString(), overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }
}

// =====================================================================
// EXISTING UPLOADED IMAGES (edit mode - read only)
// =====================================================================

class _ExistingImages extends StatelessWidget {
  final List<VehicleImage> images;

  const _ExistingImages({required this.images});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        for (final image in images)
          if (image.fileUrl.isNotEmpty)
            Container(
              width: 72.r,
              height: 72.r,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10.r),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                image.fileUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Icon(
                  Icons.broken_image_outlined,
                  size: 24.r,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
      ],
    );
  }
}

// =====================================================================
// PICKED IMAGE TILE (with remove)
// =====================================================================

class _PickedImageTile extends StatelessWidget {
  final File file;
  final VoidCallback onRemove;

  const _PickedImageTile({required this.file, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: Image.file(file, fit: BoxFit.cover),
        ),
        Positioned(
          top: 2,
          right: 2,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: colorScheme.error,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                size: 12.r,
                color: colorScheme.onError,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
