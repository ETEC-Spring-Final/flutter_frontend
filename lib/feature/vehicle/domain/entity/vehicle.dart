class Vehicle {
  final int id;
  final List<String> images;
  final String brand;
  final String model;
  final String type;
  final double pricePerDay;
  final String description;
  final double rating;

  // Features
  final List<String> feature;

  // Map
  final double latitude;
  final double longitude;

  // Specifications
  final String transmission;
  final String fuelType;
  final int seats;
  final int doors;
  final int luggage;
  final double kilometer;

  // User-specific
  final bool isFavorite;

  const Vehicle({
    required this.id,
    required this.images,
    required this.brand,
    required this.model,
    required this.type,
    required this.pricePerDay,
    required this.description,
    required this.rating,
    required this.feature,
    required this.latitude,
    required this.longitude,
    required this.transmission,
    required this.fuelType,
    required this.seats,
    required this.doors,
    required this.luggage,
    required this.kilometer,
    required this.isFavorite,
  });

  Vehicle copyWith({
    int? id,
    List<String>? images,
    String? brand,
    String? model,
    String? type,
    double? pricePerDay,
    String? description,
    double? rating,
    List<String>? feature,
    double? latitude,
    double? longitude,
    String? transmission,
    String? fuelType,
    int? seats,
    int? doors,
    int? luggage,
    double? kilometer,
    bool? isFavorite,
  }) {
    return Vehicle(
      id: id ?? this.id,
      images: images ?? this.images,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      type: type ?? this.type,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      feature: feature ?? this.feature,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      transmission: transmission ?? this.transmission,
      fuelType: fuelType ?? this.fuelType,
      seats: seats ?? this.seats,
      doors: doors ?? this.doors,
      luggage: luggage ?? this.luggage,
      kilometer: kilometer ?? this.kilometer,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

final List<Vehicle> vehicles = [
  Vehicle(
    id: 1,
    images: const [
      'https://images.unsplash.com/photo-1553440569-bcc63803a83d?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1550355291-bbee04a92027?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=1200&q=80',
    ],
    brand: 'BMW',
    model: '5 Series',
    type: 'Sedan',
    pricePerDay: 85,
    description:
        'The BMW 5 Series is a premium executive sedan designed to provide an excellent balance between luxury, comfort, performance, and everyday practicality. Its elegant exterior design gives the vehicle a sophisticated appearance, while the spacious and carefully designed interior provides a comfortable environment for both drivers and passengers. The smooth automatic transmission makes driving effortless, especially in busy city traffic and during longer journeys. The vehicle is equipped with modern technology and convenient features including a premium interior, Apple CarPlay, Bluetooth connectivity, parking sensors, cruise control, and advanced safety systems. Whether you are traveling for business, exploring the city, attending an important event, or taking a weekend trip with family, the BMW 5 Series provides a refined and enjoyable driving experience.',
    rating: 4.8,
    feature: const [
      'Leather Seats',
      'Apple CarPlay',
      'Parking Sensors',
      'Bluetooth',
      'Cruise Control',
      'Premium Sound System',
      'Dual Zone Climate Control',
      'Keyless Entry',
    ],

    // Phnom Penh Center
    latitude: 11.5564,
    longitude: 104.9282,

    transmission: 'Automatic',
    fuelType: 'Petrol',
    seats: 5,
    doors: 4,
    luggage: 3,
    kilometer: 12000,
    isFavorite: false,
  ),

  Vehicle(
    id: 2,
    images: const [
      'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1504215680853-026ed2a45def?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1544829099-b9a0c07fad1a?auto=format&fit=crop&w=1200&q=80',
    ],
    brand: 'Porsche',
    model: '911 Carrera',
    type: 'Sports',
    pricePerDay: 150,
    description:
        'The Porsche 911 Carrera is an iconic sports car created for drivers who appreciate performance, precision, and exceptional design. From its distinctive exterior styling to its driver-focused interior, every part of the 911 Carrera is designed to deliver an engaging and memorable driving experience. The powerful petrol engine provides responsive acceleration and impressive performance, while the automatic transmission allows for smooth and convenient driving when needed. Inside, the cabin combines premium materials with modern technology, creating a comfortable environment for both short drives and longer journeys. Features such as sport driving modes, premium audio, Apple CarPlay, parking assistance, and a high-quality leather interior make this vehicle both exciting and practical. The Porsche 911 Carrera is an excellent choice for special occasions, weekend getaways, business events, or anyone looking to experience a premium performance vehicle.',
    rating: 4.9,
    feature: const [
      'Sport Mode',
      'Leather Interior',
      'Premium Sound System',
      'Apple CarPlay',
      'Parking Camera',
      'Bluetooth',
      'Keyless Entry',
      'Performance Brakes',
    ],

    // BKK1
    latitude: 11.5480,
    longitude: 104.9235,

    transmission: 'Automatic',
    fuelType: 'Petrol',
    seats: 2,
    doors: 2,
    luggage: 2,
    kilometer: 8500,
    isFavorite: false,
  ),

  Vehicle(
    id: 3,
    images: const [
      'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?auto=format&fit=crop&w=1200&q=80',
    ],
    brand: 'Toyota',
    model: 'Land Cruiser',
    type: 'SUV',
    pricePerDay: 120,
    description:
        'The Toyota Land Cruiser is a powerful and spacious SUV built for drivers who need comfort, reliability, and versatility. With its strong road presence and capable performance, it is well suited for both city driving and longer journeys outside the city. The spacious seven-seat interior provides plenty of room for families, friends, and passengers, while the large luggage area offers enough storage space for travel bags and personal belongings. Its automatic transmission provides a smooth driving experience, and the diesel engine offers strong performance for long-distance travel. The Land Cruiser also includes useful features such as four-wheel drive, leather seats, a parking camera, Bluetooth connectivity, cruise control, and modern safety technology. Whether you are planning a family vacation, traveling between cities, exploring rural areas, or simply need a comfortable vehicle with plenty of space, the Toyota Land Cruiser is a dependable and practical choice.',
    rating: 4.7,
    feature: const [
      '7 Seats',
      '4WD',
      'Leather Seats',
      'Parking Camera',
      'Cruise Control',
      'Bluetooth',
      'Large Luggage Space',
      'Dual Zone Climate Control',
    ],

    // Toul Kork
    latitude: 11.5850,
    longitude: 104.9000,

    transmission: 'Automatic',
    fuelType: 'Diesel',
    seats: 7,
    doors: 5,
    luggage: 5,
    kilometer: 25000,
    isFavorite: false,
  ),

  Vehicle(
    id: 4,
    images: const [
      'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1560958089-b8a1929cea89?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1536700503339-1e4b06520771?auto=format&fit=crop&w=1200&q=80',
    ],
    brand: 'Tesla',
    model: 'Model 3',
    type: 'Electric',
    pricePerDay: 95,
    description:
        'The Tesla Model 3 is a modern electric sedan designed for drivers who want a combination of technology, efficiency, comfort, and responsive performance. Its clean and minimalist exterior design is matched by a spacious and technology-focused interior featuring a large central touchscreen that provides access to many of the vehicle controls and entertainment functions. The electric powertrain delivers smooth and quiet acceleration without the vibration associated with traditional combustion engines. The Model 3 is also equipped with advanced driver assistance technology, a premium sound system, Bluetooth connectivity, a parking camera, fast-charging capability, and a comfortable interior suitable for everyday use. It is an excellent option for city driving, business trips, airport transfers, and longer journeys where you want a quiet and modern driving experience while reducing fuel consumption and emissions.',
    rating: 4.6,
    feature: const [
      'Autopilot',
      'Touchscreen Display',
      'Bluetooth',
      'Premium Sound System',
      'Fast Charging',
      'Parking Camera',
      'Keyless Entry',
      'Wireless Phone Charging',
    ],

    // Chroy Changvar
    latitude: 11.5905,
    longitude: 104.9250,

    transmission: 'Automatic',
    fuelType: 'Electric',
    seats: 5,
    doors: 4,
    luggage: 3,
    kilometer: 10000,
    isFavorite: false,
  ),
];
