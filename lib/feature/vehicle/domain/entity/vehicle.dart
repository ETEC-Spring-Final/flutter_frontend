class Vehicle {
  final int id;
  final List<String> images;
  final String brand;
  final String model;
  final int year;
  final String licensePlate;
  final String color;

  // Basic Information
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

  // Vehicle Status
  final String status;

  const Vehicle({
    required this.id,
    required this.images,
    required this.brand,
    required this.model,
    required this.year,
    required this.licensePlate,
    required this.color,
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
    required this.status,
  });

  Vehicle copyWith({
    int? id,
    List<String>? images,
    String? brand,
    String? model,
    int? year,
    String? licensePlate,
    String? color,
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
    String? status,
  }) {
    return Vehicle(
      id: id ?? this.id,
      images: images ?? this.images,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      licensePlate: licensePlate ?? this.licensePlate,
      color: color ?? this.color,
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
      status: status ?? this.status,
    );
  }
}

final List<Vehicle> vehicles = [
  // ============================================================
  // MG D60
  // ============================================================
  Vehicle(
    id: 11,
    images: const [
      'https://i.pinimg.com/736x/59/ff/4e/59ff4ef36150760fb98823423cb63ae6.jpg',
      'https://i.pinimg.com/736x/4b/61/f8/4b61f865ea2a959daeb8947413aa9e34.jpg',
      'https://i.pinimg.com/736x/e5/f2/ff/e5f2ff1c9a87548034c51fc86493895b.jpg',
      'https://i.pinimg.com/736x/ef/08/86/ef08864b16f09a9b3d3a9601893aab2f.jpg',
    ],
    brand: 'MG',
    model: 'D60',
    year: 2026,
    licensePlate: '2L-6060',
    color: 'Black',
    type: 'SUV',
    pricePerDay: 60,
    description:
        'The MG D60 is a modern SUV designed for comfortable everyday driving and longer journeys in Cambodia. Its spacious cabin, comfortable seating, strong air conditioning, and practical luggage capacity make it suitable for families, tourists, and business travelers. The 2026 model combines a modern exterior design with useful technology and a smooth automatic transmission, providing a comfortable driving experience around Phnom Penh and on trips to other provinces.',
    rating: 4.7,
    feature: const [
      '5 Seats',
      'Leather Seats',
      'Apple CarPlay',
      'Large Touchscreen Display',
      'Parking Camera',
      'Bluetooth',
      'Cruise Control',
      'Keyless Entry',
    ],
    // Toul Kork
    latitude: 11.5850,
    longitude: 104.9000,
    transmission: 'Automatic',
    fuelType: 'Petrol',
    seats: 5,
    doors: 5,
    luggage: 4,
    kilometer: 5000,
    isFavorite: false,
    status: 'Available',
  ),
  // ============================================================
  // FORD TERRITORY
  // ============================================================
  Vehicle(
    id: 9,
    images: const [
      'https://i.pinimg.com/736x/c5/82/de/c582de5f981a5d25d5e61ce4fc8aa435.jpg',
      'https://i.pinimg.com/736x/8e/c4/e8/8ec4e879a523691392e9cc9a5f8cb150.jpg',
      'https://i.pinimg.com/736x/e6/6c/e0/e66ce088c331a4b2eefe7d84287daf19.jpg',
      'https://i.pinimg.com/736x/16/c6/35/16c63596c71e242e3d9e0d50b7856fda.jpg',
      'https://i.pinimg.com/736x/1a/20/02/1a2002e6c9fdfb5307148132aa266fb1.jpg',
    ],
    brand: 'Ford',
    model: 'Territory',
    year: 2024,
    licensePlate: '2J-6868',
    color: 'White',
    type: 'SUV',
    pricePerDay: 65,
    description:
        'The Ford Territory is a modern compact SUV that provides a comfortable and practical driving experience for customers in Cambodia. Its spacious cabin, comfortable seats, strong air conditioning, and smooth automatic transmission make it suitable for daily driving in Phnom Penh and longer trips to destinations across the country. The Territory combines modern technology with a stylish exterior and practical interior space, making it a good choice for families, tourists, and business travelers. Features such as a large touchscreen display, Apple CarPlay, Bluetooth, parking camera, cruise control, and keyless entry provide additional convenience for everyday driving.',
    rating: 4.7,
    feature: const [
      '5 Seats',
      'Apple CarPlay',
      'Large Touchscreen Display',
      'Parking Camera',
      'Bluetooth',
      'Cruise Control',
      'Keyless Entry',
      'Dual Zone Climate Control',
    ],
    // Sen Sok
    latitude: 11.5750,
    longitude: 104.8900,
    transmission: 'Automatic',
    fuelType: 'Petrol',
    seats: 5,
    doors: 5,
    luggage: 4,
    kilometer: 18000,
    isFavorite: false,
    status: 'Available',
  ),
  // ============================================================
  // TOYOTA CAMRY
  // ============================================================
  Vehicle(
    id: 1,
    images: const [
      'https://i.pinimg.com/736x/c4/16/4f/c4164fc1e651a0b706ca37020941c44c.jpg',
      'https://i.pinimg.com/736x/75/f1/8a/75f18ad4ff629dee5d0a3711d12a924c.jpg',
      'https://i.pinimg.com/736x/00/24/5c/00245c53776334188c01c70bbea134dc.jpg',
      'https://i.pinimg.com/736x/5e/7d/b5/5e7db55e9315d6662821885dad66558a.jpg',
      'https://i.pinimg.com/736x/2c/42/62/2c426276343a92d711055493bfc65d44.jpg',
      'https://i.pinimg.com/736x/3d/73/22/3d732281e089f473548349b237339ce0.jpg',
      'https://i.pinimg.com/736x/0e/13/23/0e132360c48328566491f6bf70d7d0cf.jpg',
      'https://i.pinimg.com/736x/6b/35/39/6b35399c33e6bce7dfac420db5903d60.jpg',
    ],
    brand: 'Toyota',
    model: 'Camry',
    year: 2022,
    licensePlate: '2A-5588',
    color: 'White',
    type: 'Sedan',
    pricePerDay: 55,
    description:
        'The Toyota Camry is one of the most practical and comfortable sedans for driving in Cambodia. It offers a smooth ride, comfortable seating, excellent air conditioning, and good fuel efficiency for daily travel around Phnom Penh and longer trips between provinces. The spacious interior makes it suitable for families, business travelers, airport transfers, and city driving. Its automatic transmission makes driving easy in Phnom Penh traffic, while modern safety and convenience features provide a comfortable and reliable rental experience.',
    rating: 4.7,
    feature: const [
      'Leather Seats',
      'Apple CarPlay',
      'Bluetooth',
      'Parking Camera',
      'Cruise Control',
      'Keyless Entry',
      'Dual Zone Climate Control',
      'USB Charging',
    ],
    // Phnom Penh Center
    latitude: 11.5564,
    longitude: 104.9282,
    transmission: 'Automatic',
    fuelType: 'Petrol',
    seats: 5,
    doors: 4,
    luggage: 3,
    kilometer: 42000,
    isFavorite: false,
    status: 'Available',
  ),

  // ============================================================
  // TOYOTA FORTUNER
  // ============================================================
  Vehicle(
    id: 2,
    images: const [
      'https://i.pinimg.com/736x/c5/35/d0/c535d0ce3a4b29811e7ea6e852bffc05.jpg',
      'https://i.pinimg.com/736x/17/0a/eb/170aeb25d8bd5f8a982549a5bdb8fb79.jpg',
      'https://i.pinimg.com/736x/67/66/13/676613b90102cc7cf63f5f859b09d368.jpg',
      'https://i.pinimg.com/736x/36/d7/66/36d7666ef56e4222228c1e2b4e6de5a4.jpg',
      'https://i.pinimg.com/736x/8d/b1/9e/8db19e885d5f3069923db571f9d2afba.jpg',
      'https://i.pinimg.com/736x/52/f9/6a/52f96a1ddcea255d43a2848d103101c3.jpg',
      'https://i.pinimg.com/736x/b6/96/dc/b696dc644b55ce633e4d67d9201c6362.jpg',
      'https://i.pinimg.com/736x/2e/81/4f/2e814f8a43634c38680967a17cd3b043.jpg',
      'https://i.pinimg.com/736x/ec/69/28/ec6928759fe268b4b70ef87795a6e15f.jpg',
      'https://i.pinimg.com/736x/29/0c/f4/290cf4eefe4fa5ac5d89af782972349c.jpg',
    ],
    brand: 'Toyota',
    model: 'Fortuner',
    year: 2023,
    licensePlate: '2B-7788',
    color: 'Black',
    type: 'SUV',
    pricePerDay: 75,
    description:
        'The Toyota Fortuner is a popular SUV choice for Cambodian roads because of its spacious interior, high driving position, strong performance, and excellent practicality. It is ideal for families and groups traveling around Phnom Penh or taking longer trips to Siem Reap, Kampot, Battambang, and other provinces. With seven seats, generous luggage space, strong air conditioning, and a comfortable automatic transmission, the Fortuner is well suited for both city driving and longer journeys.',
    rating: 4.8,
    feature: const [
      '7 Seats',
      '4WD',
      'Leather Seats',
      'Parking Camera',
      'Bluetooth',
      'Cruise Control',
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
    kilometer: 38000,
    isFavorite: false,
    status: 'Available',
  ),

  // ============================================================
  // HONDA CR-V
  // ============================================================
  Vehicle(
    id: 3,
    images: const [
      'https://i.pinimg.com/736x/44/75/95/447595020930784f37d6fcb6ca763720.jpg',
      'https://i.pinimg.com/736x/ad/8e/b9/ad8eb9042fa65718cdf5b285c6f74022.jpg',
      'https://i.pinimg.com/736x/cb/84/9d/cb849d64939d72a43553f3d5700510da.jpg',
      'https://i.pinimg.com/736x/5c/5e/ce/5c5ece072c3b5fab6d587b4ad18b8272.jpg',
      'https://i.pinimg.com/736x/d6/5d/52/d65d52a3859aeaff6d234685d7c99939.jpg',
      'https://i.pinimg.com/736x/00/0c/37/000c37494517b0e3b510650f34b709ab.jpg',
      'https://i.pinimg.com/736x/eb/72/fb/eb72fb7909662371418eeaaaa3b1176e.jpg',
      'https://i.pinimg.com/736x/2e/8d/7b/2e8d7b4b67e702e660134694f42f3f3c.jpg',
    ],
    brand: 'Honda',
    model: 'CR-V',
    year: 2023,
    licensePlate: '2C-2468',
    color: 'Silver',
    type: 'SUV',
    pricePerDay: 65,
    description:
        'The Honda CR-V is a comfortable and practical SUV for everyday driving in Cambodia. Its compact size makes it easier to drive and park in busy Phnom Penh streets while still providing plenty of space for passengers and luggage. The CR-V offers good fuel efficiency, comfortable seating, strong air conditioning, and a smooth automatic transmission. It is an excellent choice for families, tourists, business travelers, and customers planning trips outside Phnom Penh.',
    rating: 4.7,
    feature: const [
      '5 Seats',
      'Apple CarPlay',
      'Parking Camera',
      'Honda Sensing',
      'Bluetooth',
      'Cruise Control',
      'Keyless Entry',
      'USB Charging',
    ],
    // BKK1
    latitude: 11.5480,
    longitude: 104.9235,
    transmission: 'Automatic',
    fuelType: 'Petrol',
    seats: 5,
    doors: 5,
    luggage: 4,
    kilometer: 31000,
    isFavorite: false,
    status: 'Available',
  ),

  // ============================================================
  // LEXUS RX
  // ============================================================
  Vehicle(
    id: 4,
    images: const [
      'https://i.pinimg.com/736x/a5/06/c2/a506c276fd00fb1308262b1585708fb2.jpg',
      'https://i.pinimg.com/736x/2f/89/69/2f8969c92d7ef2f30ef39e8dce6550ac.jpg',
      'https://i.pinimg.com/736x/d4/b7/40/d4b740f9dde1240ec3288f4721bfe25d.jpg',
      'https://i.pinimg.com/736x/09/d6/53/09d653a2d3389abf1dacf3ccd2cbf797.jpg',
      'https://i.pinimg.com/736x/15/a6/97/15a69789795739e3ea6c14820aabbab7.jpg',
      'https://i.pinimg.com/736x/fb/54/72/fb547258c972fcb6cd7649e12ea242dc.jpg',
      'https://i.pinimg.com/736x/11/49/4e/11494e8e9e002b10ce990b1a22795265.jpg',
      'https://i.pinimg.com/736x/6c/5e/92/6c5e92a3f7f6805c791192b30b27a901.jpg',
      'https://i.pinimg.com/736x/e6/3b/5a/e63b5abe72b8b3825b181025c4b4a93f.jpg',
    ],
    brand: 'Lexus',
    model: 'RX 350',
    year: 2022,
    licensePlate: '2D-8888',
    color: 'Black',
    type: 'Luxury',
    pricePerDay: 110,
    description:
        'The Lexus RX 350 is a premium SUV designed for customers who want extra comfort, luxury, and a smooth driving experience. It is particularly suitable for business trips, weddings, airport transfers, family travel, and special occasions in Cambodia. The spacious cabin, premium leather interior, excellent air conditioning, quiet ride, and advanced safety features provide a high level of comfort for both driver and passengers. Its elevated driving position also makes it practical for navigating busy Phnom Penh roads.',
    rating: 4.9,
    feature: const [
      'Premium Leather Seats',
      'Premium Sound System',
      'Apple CarPlay',
      'Parking Camera',
      'Parking Sensors',
      'Cruise Control',
      'Keyless Entry',
      'Dual Zone Climate Control',
    ],
    // Daun Penh
    latitude: 11.5680,
    longitude: 104.9210,
    transmission: 'Automatic',
    fuelType: 'Petrol',
    seats: 5,
    doors: 5,
    luggage: 4,
    kilometer: 28000,
    isFavorite: false,
    status: 'Available',
  ),

  // ============================================================
  // FORD RANGER
  // ============================================================
  Vehicle(
    id: 5,
    images: const [
      'https://i.pinimg.com/736x/52/e4/dc/52e4dc1f99f3c79112c800e06bb57028.jpg',
      'https://i.pinimg.com/736x/99/e3/37/99e337b201a46cac40984fb9329528d8.jpg',
      'https://i.pinimg.com/736x/a3/3d/5c/a33d5c0643fda25deca8f435db68de0d.jpg',
      'https://i.pinimg.com/736x/67/4c/c4/674cc42ea8555a753f1768e96c41a82a.jpg',
    ],
    brand: 'Ford',
    model: 'Ranger',
    year: 2023,
    licensePlate: '2E-4567',
    color: 'Blue',
    type: 'Pickup',
    pricePerDay: 70,
    description:
        'The Ford Ranger is a versatile pickup truck suitable for both city driving and travel throughout Cambodia. Its strong engine, high ground clearance, and large cargo area make it useful for customers who need additional carrying capacity or plan to travel on less developed roads. The Ranger provides a comfortable modern cabin with strong air conditioning, Bluetooth connectivity, parking assistance, and a smooth automatic transmission. It is a practical option for business trips, outdoor activities, construction-related travel, and provincial journeys.',
    rating: 4.6,
    feature: const [
      'Large Cargo Bed',
      '4WD',
      'Parking Camera',
      'Bluetooth',
      'Apple CarPlay',
      'Cruise Control',
      'Keyless Entry',
      'Hill Descent Control',
    ],
    // Sen Sok
    latitude: 11.5750,
    longitude: 104.8900,
    transmission: 'Automatic',
    fuelType: 'Diesel',
    seats: 5,
    doors: 4,
    luggage: 3,
    kilometer: 45000,
    isFavorite: false,
    status: 'Available',
  ),

  // ============================================================
  // HYUNDAI STARIA
  // ============================================================
  Vehicle(
    id: 6,
    images: const [
      'https://i.pinimg.com/736x/6e/4a/b8/6e4ab84cce98bcb94e95bde4958c4f52.jpg',
      'https://i.pinimg.com/736x/b7/b7/76/b7b776e94f30aa6c896cd4156eebbd01.jpg',
      'https://i.pinimg.com/736x/59/7b/af/597bafdedc784adefdfeaa529c4c2c1e.jpg',
      'https://i.pinimg.com/736x/69/1c/ca/691ccaa5d88ee3f48e6f8cffebac141a.jpg',
      'https://i.pinimg.com/736x/f5/d3/0f/f5d30f280f93aded55cece12911ac022.jpg',
      'https://i.pinimg.com/736x/8e/8e/81/8e8e814a3c45ba08a09396ddd030118d.jpg',
    ],
    brand: 'Hyundai',
    model: 'Staria',
    year: 2023,
    licensePlate: '2F-7777',
    color: 'White',
    type: 'Van',
    pricePerDay: 85,
    description:
        'The Hyundai Staria is a spacious modern van designed for families, tour groups, airport transfers, and business travel in Cambodia. Its large interior provides comfortable seating for passengers and plenty of room for luggage, making it ideal for group trips to destinations such as Siem Reap, Kampot, Kep, Battambang, and Sihanoukville. The vehicle provides strong air conditioning, comfortable seats, modern entertainment technology, and a smooth automatic transmission for comfortable long-distance travel.',
    rating: 4.7,
    feature: const [
      '9 Seats',
      'Large Luggage Space',
      'Rear Air Conditioning',
      'Bluetooth',
      'Apple CarPlay',
      'Parking Camera',
      'Cruise Control',
      'USB Charging',
    ],
    // Chroy Changvar
    latitude: 11.5905,
    longitude: 104.9250,
    transmission: 'Automatic',
    fuelType: 'Diesel',
    seats: 9,
    doors: 5,
    luggage: 6,
    kilometer: 35000,
    isFavorite: false,
    status: 'Available',
  ),

  // ============================================================
  // TOYOTA RAV4
  // ============================================================
  Vehicle(
    id: 7,
    images: const [
      'https://i.pinimg.com/736x/e2/70/bd/e270bd99e4e40bf43792aaf6332167eb.jpg',
      'https://i.pinimg.com/736x/ed/ef/25/edef2592ef0d708a5588ca2e787dc945.jpg',
      'https://i.pinimg.com/736x/85/d1/37/85d1376a5cb760b9599d4e5869bead01.jpg',
      'https://i.pinimg.com/736x/29/3d/31/293d31be7eb56cfc87b4d1e73f1684ef.jpg',
      'https://i.pinimg.com/736x/19/c0/7e/19c07e17b676cf80848f0cd9d2c15d91.jpg',
      'https://i.pinimg.com/736x/39/f1/44/39f144c20a7e036fc0f3699b5f131d50.jpg',
      'https://i.pinimg.com/736x/1d/66/39/1d6639d530b2bfadf01ac0469f729aa1.jpg',
      'https://i.pinimg.com/736x/22/45/b6/2245b602c7bee2c12592454f12210bdb.jpg',
      'https://i.pinimg.com/736x/52/69/72/52697201d897a6a3091fdb05c6d7327b.jpg',
      'https://i.pinimg.com/736x/29/de/a7/29dea7216e6540df74ec0dc0b1b86dc0.jpg',
    ],
    brand: 'Toyota',
    model: 'RAV4',
    year: 2022,
    licensePlate: '2G-3333',
    color: 'Gray',
    type: 'SUV',
    pricePerDay: 60,
    description:
        'The Toyota RAV4 is a practical compact SUV for customers who want a comfortable vehicle that is easy to drive around Phnom Penh while also being suitable for longer trips. It offers good fuel efficiency, comfortable seating, useful luggage capacity, and a smooth automatic transmission. The RAV4 is a good choice for couples, small families, tourists, and business travelers who want a reliable vehicle for exploring Cambodia.',
    rating: 4.6,
    feature: const [
      '5 Seats',
      'Apple CarPlay',
      'Parking Camera',
      'Bluetooth',
      'Cruise Control',
      'Keyless Entry',
      'USB Charging',
      'Safety Assist',
    ],
    // Mean Chey
    latitude: 11.5350,
    longitude: 104.9100,
    transmission: 'Automatic',
    fuelType: 'Petrol',
    seats: 5,
    doors: 5,
    luggage: 4,
    kilometer: 33000,
    isFavorite: false,
    status: 'Available',
  ),

  // ============================================================
  // TESLA MODEL 3
  // ============================================================
  Vehicle(
    id: 8,
    images: const [
      'https://i.pinimg.com/736x/6f/7d/45/6f7d453c5a327f783e5391bcaf9805ae.jpg',
      'https://i.pinimg.com/736x/e2/bf/55/e2bf55ab899257ecf3f7ca069f5d3e23.jpg',
      'https://i.pinimg.com/736x/e9/ba/de/e9bade618d6d908d00384de5fcfb31aa.jpg',
      'https://i.pinimg.com/736x/60/de/3c/60de3cd2352a7386c92a89ac94289b3e.jpg',
      'https://i.pinimg.com/736x/db/e7/1a/dbe71a4c9df5c64c7dc799ee915d7649.jpg',
      'https://i.pinimg.com/736x/32/21/3d/32213d4db52bcf12b230e34dbe9a745d.jpg',
      'https://i.pinimg.com/736x/61/b3/c1/61b3c1ab5564d61a8bc0505c06253258.jpg',
      'https://i.pinimg.com/736x/41/55/fb/4155fb75cfb8d00cc41c9c7192ef236b.jpg',
      'https://i.pinimg.com/736x/80/e7/12/80e712147067d70df3890df76d42f2c9.jpg',
      'https://i.pinimg.com/736x/32/36/4c/32364cc4ee18480cba194fb1fd227e1d.jpg',
    ],
    brand: 'Tesla',
    model: 'Model 3',
    year: 2024,
    licensePlate: '2H-9999',
    color: 'Red',
    type: 'Electric',
    pricePerDay: 95,
    description:
        'The Tesla Model 3 is a modern electric sedan for customers who want a quiet, technology-focused driving experience in Cambodia. Its electric powertrain provides smooth acceleration and eliminates the need for traditional petrol or diesel fuel. The minimalist interior features a large touchscreen, Bluetooth connectivity, premium audio, and advanced driver assistance technology. It is particularly suitable for city driving, business trips, airport transfers, and customers interested in experiencing an electric vehicle in Phnom Penh.',
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
    status: 'Available',
  ),

  // add new

  // ============================================================
  // TOYOTA COROLLA
  // ============================================================
  Vehicle(
    id: 12,
    images: const [
      'https://i.pinimg.com/736x/68/fd/65/68fd6521db1c9ef2ffd4eb0f901fa067.jpg',
      'https://i.pinimg.com/736x/5e/f7/a2/5ef7a2cc7110bf605388558bca415e9a.jpg',
      'https://i.pinimg.com/736x/69/2c/2c/692c2cfd95acbbd955095c8b27c60ffa.jpg',
      'https://i.pinimg.com/736x/40/b7/34/40b734da575b6441d8ee7ed91d2fb117.jpg',
    ],
    brand: 'Toyota',
    model: 'Corolla',
    year: 2023,
    licensePlate: '2J-1212',
    color: 'Silver',
    type: 'Sedan',
    pricePerDay: 45,
    description:
        'The Toyota Corolla is a reliable and economical sedan suitable for city driving, business trips, and everyday travel around Cambodia. Its comfortable interior, excellent air conditioning, and fuel-efficient engine make it a practical rental choice.',
    rating: 4.6,
    feature: const [
      '5 Seats',
      'Bluetooth',
      'Parking Camera',
      'Apple CarPlay',
      'USB Charging',
      'Keyless Entry',
    ],
    latitude: 11.5600,
    longitude: 104.9150,
    transmission: 'Automatic',
    fuelType: 'Petrol',
    seats: 5,
    doors: 4,
    luggage: 3,
    kilometer: 25000,
    isFavorite: false,
    status: 'Available',
  ),

  // ============================================================
  // HONDA CIVIC
  // ============================================================
  Vehicle(
    id: 13,
    images: const [
      'https://i.pinimg.com/1200x/ab/d6/d1/abd6d12171dc9f62be05ee088a2ce90a.jpg',
    ],
    brand: 'Honda',
    model: 'Civic',
    year: 2024,
    licensePlate: '2K-3434',
    color: 'Black',
    type: 'Sedan',
    pricePerDay: 58,
    description:
        'The Honda Civic is a stylish and comfortable sedan with excellent handling, modern technology, and efficient fuel consumption. It is ideal for city driving and longer journeys throughout Cambodia.',
    rating: 4.8,
    feature: const [
      '5 Seats',
      'Apple CarPlay',
      'Honda Sensing',
      'Parking Camera',
      'Bluetooth',
      'Cruise Control',
      'Keyless Entry',
    ],
    latitude: 11.5500,
    longitude: 104.9250,
    transmission: 'Automatic',
    fuelType: 'Petrol',
    seats: 5,
    doors: 4,
    luggage: 3,
    kilometer: 15000,
    isFavorite: false,
    status: 'Available',
  ),

  // ============================================================
  // MERCEDES-BENZ E-CLASS
  // ============================================================
  Vehicle(
    id: 14,
    images: const [
      'https://i.pinimg.com/736x/98/15/19/981519ccbdf7807f5d2283c367398b75.jpg',
    ],
    brand: 'Mercedes-Benz',
    model: 'E-Class',
    year: 2024,
    licensePlate: '2L-4545',
    color: 'Black',
    type: 'Luxury',
    pricePerDay: 150,
    description:
        'The Mercedes-Benz E-Class provides a premium driving experience with a luxurious interior, advanced technology, excellent comfort, and smooth performance. It is ideal for business trips, weddings, airport transfers, and special occasions.',
    rating: 4.9,
    feature: const [
      '5 Seats',
      'Premium Leather Seats',
      'Premium Sound System',
      'Apple CarPlay',
      'Parking Camera',
      'Parking Sensors',
      'Cruise Control',
      'Wireless Charging',
    ],
    latitude: 11.5700,
    longitude: 104.9200,
    transmission: 'Automatic',
    fuelType: 'Petrol',
    seats: 5,
    doors: 4,
    luggage: 4,
    kilometer: 12000,
    isFavorite: false,
    status: 'Available',
  ),

  // ============================================================
  // BMW X5
  // ============================================================
  Vehicle(
    id: 15,
    images: const [
      'https://i.pinimg.com/1200x/f6/98/29/f69829f29b6fa6e7267dcffb612d9e42.jpg',
    ],
    brand: 'BMW',
    model: 'X5',
    year: 2023,
    licensePlate: '2M-5656',
    color: 'White',
    type: 'Luxury',
    pricePerDay: 140,
    description:
        'The BMW X5 is a premium SUV combining luxury, comfort, powerful performance, and advanced technology. It is suitable for business travelers, families, airport transfers, and long-distance journeys.',
    rating: 4.8,
    feature: const [
      '5 Seats',
      'Premium Leather Seats',
      'Panoramic Roof',
      'Apple CarPlay',
      'Parking Camera',
      'Parking Sensors',
      'Cruise Control',
      'Premium Sound System',
    ],
    latitude: 11.5650,
    longitude: 104.9180,
    transmission: 'Automatic',
    fuelType: 'Petrol',
    seats: 5,
    doors: 5,
    luggage: 4,
    kilometer: 22000,
    isFavorite: false,
    status: 'Available',
  ),

  // ============================================================
  // TOYOTA HILUX
  // ============================================================
  Vehicle(
    id: 16,
    images: const [
      'https://i.pinimg.com/736x/f9/c3/9b/f9c39ba3a3d040bc3433e849984fbed4.jpg',
      'https://i.pinimg.com/736x/45/d1/3d/45d13d20b47acdc995518fa4e469f18e.jpg',
      'https://i.pinimg.com/736x/8a/dd/2b/8add2b656baace1298dda11f3eb4d5d5.jpg',
      'https://i.pinimg.com/736x/2c/ea/bc/2ceabcc50e4bccde5ce9a8d2029f8404.jpg',
    ],
    brand: 'Toyota',
    model: 'Hilux',
    year: 2024,
    licensePlate: '2N-6767',
    color: 'White',
    type: 'Pickup',
    pricePerDay: 72,
    description:
        'The Toyota Hilux is a durable and practical pickup truck suitable for city driving, business activities, outdoor trips, and travel throughout Cambodia. Its high ground clearance and large cargo bed make it useful for longer journeys and carrying equipment.',
    rating: 4.7,
    feature: const [
      '5 Seats',
      '4WD',
      'Large Cargo Bed',
      'Parking Camera',
      'Bluetooth',
      'Apple CarPlay',
      'Cruise Control',
      'Hill Descent Control',
    ],
    latitude: 11.5800,
    longitude: 104.9000,
    transmission: 'Automatic',
    fuelType: 'Diesel',
    seats: 5,
    doors: 4,
    luggage: 3,
    kilometer: 28000,
    isFavorite: false,
    status: 'Available',
  ),

  // ============================================================
  // MITSUBISHI TRITON
  // ============================================================
  Vehicle(
    id: 17,
    images: const [
      'https://i.pinimg.com/1200x/25/bf/c6/25bfc6f6d24d6adec450064a2eb4544a.jpg',
    ],
    brand: 'Mitsubishi',
    model: 'Triton',
    year: 2023,
    licensePlate: '2P-7878',
    color: 'Gray',
    type: 'Pickup',
    pricePerDay: 68,
    description:
        'The Mitsubishi Triton is a practical pickup truck designed for both urban driving and provincial travel. It provides good ground clearance, useful cargo capacity, and strong performance for customers who need a versatile rental vehicle.',
    rating: 4.6,
    feature: const [
      '5 Seats',
      '4WD',
      'Large Cargo Bed',
      'Parking Camera',
      'Bluetooth',
      'Cruise Control',
      'Keyless Entry',
    ],
    latitude: 11.5750,
    longitude: 104.8900,
    transmission: 'Automatic',
    fuelType: 'Diesel',
    seats: 5,
    doors: 4,
    luggage: 3,
    kilometer: 35000,
    isFavorite: false,
    status: 'Available',
  ),

  // ============================================================
  // TOYOTA HIACE
  // ============================================================
  Vehicle(
    id: 18,
    images: const [
      'https://i.pinimg.com/736x/fb/b8/ec/fbb8ecc369bd2da430271398e27fc03b.jpg',
      'https://i.pinimg.com/736x/8c/df/ac/8cdfac0aeaea961f142079d34fb98b05.jpg',
      'https://i.pinimg.com/736x/91/08/2a/91082a3722c167591c29f735382cb8e1.jpg',
      'https://i.pinimg.com/736x/d0/04/2b/d0042bf82b2578e9621e696abb6c7053.jpg',
    ],
    brand: 'Toyota',
    model: 'Hiace',
    year: 2023,
    licensePlate: '2Q-8989',
    color: 'White',
    type: 'Van',
    pricePerDay: 90,
    description:
        'The Toyota Hiace is a spacious passenger van suitable for families, tour groups, airport transfers, and business travel. Its large cabin and luggage capacity make it ideal for group trips around Cambodia.',
    rating: 4.7,
    feature: const [
      '12 Seats',
      'Large Luggage Space',
      'Rear Air Conditioning',
      'Bluetooth',
      'Parking Camera',
      'USB Charging',
      'Cruise Control',
    ],
    latitude: 11.5900,
    longitude: 104.9250,
    transmission: 'Automatic',
    fuelType: 'Diesel',
    seats: 12,
    doors: 4,
    luggage: 8,
    kilometer: 40000,
    isFavorite: false,
    status: 'Available',
  ),

  // ============================================================
  // KIA CARNIVAL
  // ============================================================
  Vehicle(
    id: 19,
    images: const [
      'https://i.pinimg.com/736x/78/74/49/787449a9a98f6b597c7a12a30e6692bf.jpg',
      'https://i.pinimg.com/736x/1e/5d/5a/1e5d5aaf87b59c0bb24a3a68a7a23d86.jpg',
      'https://i.pinimg.com/736x/5d/8e/62/5d8e62320ecdffb81020f11afaa80b9a.jpg',
      'https://i.pinimg.com/736x/21/d7/4c/21d74c8f5af2dbcb251b5b9d1d6263a4.jpg',
    ],
    brand: 'Kia',
    model: 'Carnival',
    year: 2024,
    licensePlate: '2R-9090',
    color: 'Black',
    type: 'Van',
    pricePerDay: 100,
    description:
        'The Kia Carnival is a premium family van with a spacious interior, comfortable seating, modern technology, and excellent luggage capacity. It is ideal for families, tourists, business groups, and airport transfers.',
    rating: 4.8,
    feature: const [
      '8 Seats',
      'Leather Seats',
      'Large Luggage Space',
      'Rear Air Conditioning',
      'Apple CarPlay',
      'Parking Camera',
      'Cruise Control',
      'Wireless Charging',
    ],
    latitude: 11.5650,
    longitude: 104.9300,
    transmission: 'Automatic',
    fuelType: 'Diesel',
    seats: 8,
    doors: 5,
    luggage: 6,
    kilometer: 18000,
    isFavorite: false,
    status: 'Available',
  ),

  // ============================================================
  // TESLA MODEL Y
  // ============================================================
  Vehicle(
    id: 20,
    images: const [
      'https://i.pinimg.com/1200x/01/e9/2c/01e92c7aae127cb3a051c0ee167e7238.jpg',
    ],
    brand: 'Tesla',
    model: 'Model Y',
    year: 2024,
    licensePlate: '2S-1111',
    color: 'White',
    type: 'Electric',
    pricePerDay: 105,
    description:
        'The Tesla Model Y is a modern electric SUV offering a quiet and technology-focused driving experience. It provides excellent interior space, fast charging, advanced driver assistance, and comfortable city driving.',
    rating: 4.8,
    feature: const [
      '5 Seats',
      'Autopilot',
      'Touchscreen Display',
      'Fast Charging',
      'Parking Camera',
      'Bluetooth',
      'Wireless Charging',
      'Keyless Entry',
    ],
    latitude: 11.5905,
    longitude: 104.9250,
    transmission: 'Automatic',
    fuelType: 'Electric',
    seats: 5,
    doors: 5,
    luggage: 4,
    kilometer: 8000,
    isFavorite: false,
    status: 'Available',
  ),
];
