class Vehicle {
  final int id;
  final String image;
  final String brand;
  final String model;
  final String type;
  final String transmission;
  final String fuelType;
  final int seats;
  final double pricePerDay;

  final bool isFavorite;

  const Vehicle({
    required this.id,
    required this.image,
    required this.brand,
    required this.model,
    required this.type,
    required this.transmission,
    required this.fuelType,
    required this.seats,
    required this.pricePerDay,
    this.isFavorite = false,
  });

  Vehicle copyWith({
    int? id,
    String? image,
    String? brand,
    String? model,
    String? type,
    String? transmission,
    String? fuelType,
    int? seats,
    double? pricePerDay,
    bool? isFavorite,
  }) {
    return Vehicle(
      id: id ?? this.id,
      image: image ?? this.image,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      type: type ?? this.type,
      transmission: transmission ?? this.transmission,
      fuelType: fuelType ?? this.fuelType,
      seats: seats ?? this.seats,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

final List<Vehicle> vehicles = [
  const Vehicle(
    id: 1,
    image:
        'https://images.unsplash.com/photo-1553440569-bcc63803a83d?auto=format&fit=crop&w=1200&q=80',
    brand: 'BMW',
    model: 'BMW 5 Series',
    type: 'Sedan',
    transmission: 'Automatic',
    fuelType: 'Petrol',
    seats: 5,
    pricePerDay: 85,
  ),

  const Vehicle(
    id: 2,
    image:
        'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=1200&q=80',
    brand: 'Porsche',
    model: '911 Carrera',
    type: 'Sports',
    transmission: 'Automatic',
    fuelType: 'Petrol',
    seats: 2,
    pricePerDay: 150,
  ),

  const Vehicle(
    id: 3,
    image:
        'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?auto=format&fit=crop&w=1200&q=80',
    brand: 'Toyota',
    model: 'Land Cruiser',
    type: 'SUV',
    transmission: 'Automatic',
    fuelType: 'Diesel',
    seats: 7,
    pricePerDay: 120,
  ),

  const Vehicle(
    id: 4,
    image:
        'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?auto=format&fit=crop&w=1200&q=80',
    brand: 'Tesla',
    model: 'Model 3',
    type: 'Electric',
    transmission: 'Automatic',
    fuelType: 'Electric',
    seats: 5,
    pricePerDay: 95,
  ),
];
