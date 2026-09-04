# Car Rental API — Spring Boot Backend

## Overview

This is a **Spring Boot 4.0.8-SNAPSHOT REST API** for a car rental platform built with **Java 21**. It provides endpoints for managing vehicles, reservations, rentals, invoices, reviews, users, and more. The API uses **JWT-based stateless authentication** with role-based access control.

**Base Package:** `com.example.spring_boot_project_api`
**Base URL:** `http://localhost:8080`
**Swagger UI:** `http://localhost:8080/swagger-ui.html`

---

## Tech Stack

| Component | Details |
|---|---|
| Language | Java 21 |
| Framework | Spring Boot 4.0.8-SNAPSHOT |
| Build | Maven (wrapper: `./mvnw`) |
| Database | MySQL (`car_rental`), schema via Hibernate `ddl-auto=update` |
| ORM | Spring Data JPA + Hibernate |
| Security | Spring Security + JWT (jjwt 0.12.6) + BCrypt |
| Validation | Jakarta Bean Validation (`spring-boot-starter-validation`) |
| API Docs | springdoc-openapi 3.0.2 |
| Mail | Spring Boot Mail (Gmail SMTP, STARTTLS) |
| Env Vars | `java-dotenv` loading `.env` file |
| Boilerplate | Lombok |
| File Uploads | Stored in `uploads/` directory (10MB max) |

---

## Directory Structure

```
src/main/java/com/example/spring_boot_project_api/
├── SpringBootProjectApiApplication.java
├── config/
│   ├── SecurityConfig.java          # Security filter chain, BCrypt, role hierarchy
│   ├── JwtAuthFilter.java           # JWT validation filter (OncePerRequestFilter)
│   ├── JwtUtil.java                 # Token generation/validation (util/)
│   ├── CorsConfig.java              # CORS: allows all origins
│   ├── OpenApiConfig.java           # Swagger JWT bearer config
│   └── UploadConfig.java            # File upload directory config
├── controller/                       # 17 REST controllers
├── dto/
│   ├── request/                     # 14+ request DTOs (per-resource subfolders)
│   └── response/                    # 18 response DTOs (per-resource subfolders)
├── enums/                           # 14 enums
├── exception/
│   └── GlobalExceptionHandler.java  # @RestControllerAdvice, catches RuntimeException
├── mapper/                          # EMPTY (only .gitkeep)
├── model/                           # 18 JPA entities
├── repository/                      # 18 Spring Data JPA repositories
├── service/
│   ├── *Service.java                # 20 service interfaces
│   └── impl/
│       └── *ServiceImpl.java        # 18 service implementations
└── util/
    └── JwtUtil.java
```

---

## Authentication & Authorization

### How It Works

1. User registers via `POST /api/auth/register` (first user auto-becomes ADMIN)
2. User logs in via `POST /api/auth/login` → receives JWT token
3. Subsequent requests include `Authorization: Bearer <token>` header
4. `JwtAuthFilter` validates the token and loads user into `SecurityContext`

### Role Hierarchy

```
ROLE_ADMIN > ROLE_MANAGER > ROLE_STAFF > ROLE_CUSTOMER
```

Higher roles inherit permissions of lower roles.

### Role-Based Endpoint Access

| Access Level | Meaning |
|---|---|
| Public | No auth required |
| Authenticated | Any logged-in user (`@AuthenticationPrincipal CustomUserDetails`) |
| Staff | `@PreAuthorize("hasAnyRole('STAFF','MANAGER','ADMIN')")` |
| Admin | `@PreAuthorize("hasRole('ADMIN')")` |

**NOTE:** Some controllers (`ServiceController`, `DiscountController`) have **no** `@PreAuthorize` annotations — all authenticated users can manage those resources.

---

## Database Entities (18)

All tables use `tb_<name>` naming convention. IDs are auto-generated with `IDENTITY` strategy.

### User (`tb_users`)
- `id` (Long), `firstName`, `lastName`, `email` (unique), `password`, `phone`, `gender` (GenderEnum: MALE/FEMALE/OTHER), `role` (RoleEnum: CUSTOMER/MANAGER/STAFF/ADMIN, default CUSTOMER), `profilePicture`, `active` (default true), `createdAt`, `updatedAt`

### Vehicle (`tb_vehicles`)
- `id`, `brand`, `model`, `yearOfManufacture`, `licensePlate`, `color`, `type` (CarTypeEnum: SEDAN/SUV/HATCHBACK/MINIVAN/TRUCK/VAN/ELECTRIC/MOTORBIKE), `transmission` (TransmissionEnum: AUTOMATIC/MANUAL), `fuelType` (FuelTypeEnum: GASOLINE/DIESEL/ELECTRIC/HYBRID), `seats`, `pricePerDay` (BigDecimal 10,2), `mileAge` (default 0), `description`, `status` (StatusEnum: AVAILABLE/RENTED/MAINTENANCE/RESERVED/UNAVAILABLE), `createdAt`, `updatedAt`

### Attachment (`tb_attachments`)
- `id`, `fileUrl` (unique), `documentType` (DocumentTypeEnum: VEHICLE_IMAGE/IDENTITY_DOCUMENT/LICENSE/INSURANCE/CONTRACT/RECEIPT/OTHER), `isPrimary` (default false), `displayOrder` (default 0), `uploadedAt`

### VehicleImage (`tb_vehicle_image`)
- Join table linking Vehicle ↔ Attachment
- `id`, `vehicle` (@ManyToOne), `attachment` (@ManyToOne)

### Location (`tb_locations`)
- `id`, `name`, `address`, `city`, `phone`, `isActive`, `createdAt`

### Reservation (`tb_reservations`)
- `id`, `user` (@ManyToOne), `vehicle` (@ManyToOne), `pickUpLocation` (@ManyToOne → Location), `returnLocation` (@ManyToOne → Location), `pickUpDateTime`, `returnDateTime`, `status` (ReservationStatusEnum: PENDING/CONFIRMED/CANCELLED/COMPLETED/REJECTED), `totalPrice`, `depositAmount` (default 0), `discountAmount` (default 0), `additionalCharges` (default 0), `notes`, `createdAt`, `updatedAt`

### Services (`tb_services`)
- `id`, `name`, `description`, `price`, `isActive` (default true)

### ReservationServices (`tb_reservation_services`)
- Join table linking Reservation ↔ Services
- `id`, `reservation`, `service`, `quantity` (default 1, min 1), `priceAtBooking`

### Rental (`tb_rentals`)
- `id`, `reservation` (@OneToOne, unique), `vehicle`, `user` (customer_id), `pickUpLocation`, `returnLocation`, `pickUpDateTime`, `expectedReturnDateTime`, `actualReturnDateTime`, `status` (RentalStatusEnum: PENDING/IN_PROGRESS/COMPLETED/RETURNED), `basePrice`, `discountAmount`, `additionalCharges`, `lateFee`, `totalPrice`, `notes`, `createdAt`, `updatedAt`

### RentalDocument (`tb_rental_documents`)
- Join table linking Rental ↔ Attachment
- `id`, `rental`, `attachment`

### Invoice (`tb_invoices`)
- `id`, `rental` (@OneToOne), `invoiceNumber` (unique, format: `INV-YYYYMMDD-RANDOM`), `issueDate`, `dueDate`, `subtotal`, `discountAmount`, `taxAmount`, `lateFee`, `totalAmount`, `status` (InvoiceStatusEnum: UNPAID/PAID/OVERDUE/CANCELLED/REFUNDED), `createdAt`

### Review (`tb_reviews`)
- `id`, `rental` (@ManyToOne), `vehicle` (@ManyToOne), `user` (@ManyToOne), `rating` (1-5), `comment`, `isVisible` (default true), `createdAt`, `updatedAt`

### MaintenanceRecord (`tb_maintenance_records`)
- `id`, `vehicle`, `type` (MaintenanceTypeEnum: OIL_CHANGE/TIRE_ROTATION/BRAKE_SERVICE/ENGINE_TRANSMISSION/ELECTRICAL/GENERAL/DENT_SCRATCH/AC_HEATING/OTHER), `description`, `scheduledDate`, `completedDate`, `cost`, `status` (MaintenanceStatusEnum: SCHEDULED/IN_PROGRESS/COMPLETED/CANCELLED), `user` (created_by), `createdAt`, `updatedAt`

### Notification (`tb_notifications`)
- `id`, `user`, `type` (NotificationTypeEnum: RESERVATION/RENTAL/PAYMENT/SYSTEM/MAINTENANCE/PROMOTION/REMINDER), `title`, `message`, `isRead` (default false), `createdAt`

### PasswordResetToken (`tb_password_reset_tokens`)
- `id`, `user`, `token` (unique, UUID), `expiresAt`, `usedAt`, `createdAt`

### Discount (`tb_discounts`)
- `id`, `code` (unique), `description`, `type` (DiscountTypeEnum: PERCENTAGE/FIXED_AMOUNT), `value`, `validFrom`, `validTo`, `maxUses`, `usedCount` (default 0), `isActive` (default true)

### DiscountUsage (`tb_discount_usages`)
- `id`, `discount`, `user`, `reservation`, `usedAt`

### Favorite (`tb_favorites`)
- Unique constraint on `(user_id, vehicle_id)`
- `id`, `user`, `vehicle`, `createdAt`

---

## API Endpoints

### Auth (`/api/auth`)
| Method | Path | Access | Description |
|---|---|---|---|
| POST | `/register` | Public | Register user (first user = ADMIN) |
| POST | `/login` | Public | Login, returns JWT |
| POST | `/forgot-password` | Public | Sends reset link via email |
| POST | `/reset-password` | Public | Reset password with token |

### Vehicles (`/api/vehicles`)
| Method | Path | Access | Description |
|---|---|---|---|
| POST | `/` | Admin | Create vehicle |
| GET | `/{id}` | Authenticated | Get vehicle by ID |
| GET | `/` | Authenticated | Get all vehicles |
| PUT | `/{id}` | Admin | Update vehicle |
| DELETE | `/{id}` | Admin | Delete vehicle |

### Vehicle Images (`/api/vehicle-images`)
| Method | Path | Access | Description |
|---|---|---|---|
| POST | `/` | Staff+ | Create vehicle image link |
| POST | `/{id}/upload` | Staff+ | Upload image file (multipart) |
| GET | `/{id}` | Authenticated | Get images by vehicle ID |
| GET | `/` | Authenticated | Get all vehicle images |
| PUT | `/{id}` | Staff+ | Update vehicle image |
| DELETE | `/{id}` | Staff+ | Delete vehicle image |

### Reservations (`/api/reservations`)
| Method | Path | Access | Description |
|---|---|---|---|
| POST | `/` | Authenticated | Create reservation (calculates totalPrice) |
| GET | `/{id}` | Authenticated (owner) | Get reservation by ID |
| GET | `/` | Staff+ | Get all reservations |
| GET | `/my-reservations` | Authenticated | Get current user's reservations |
| PATCH | `/{id}/status?status=` | Staff+ | Change reservation status |
| PATCH | `/{id}/cancel` | Authenticated (owner) | Cancel reservation |
| PUT | `/{id}` | Staff+ | Update reservation |
| DELETE | `/{id}` | Staff+ | Delete reservation |

### Rentals (`/api/rentals`)
| Method | Path | Access | Description |
|---|---|---|---|
| POST | `/` | Staff+ | Create rental from CONFIRMED reservation |
| GET | `/{id}` | Authenticated | Get rental by ID |
| GET | `/my-rentals` | Authenticated | Get current user's rentals |
| GET | `/` | Staff+ | Get all rentals |
| PUT | `/{id}` | Staff+ | Update rental |
| PATCH | `/{id}/status?status=` | Staff+ | Change rental status |
| DELETE | `/{id}` | Staff+ | Delete rental |

### Invoices (`/api/invoices`)
| Method | Path | Access | Description |
|---|---|---|---|
| POST | `/` | Staff+ | Create invoice (auto-generates invoice number) |
| GET | `/{id}` | Authenticated | Get invoice by ID |
| GET | `/my-invoices` | Authenticated | Get current user's invoices |
| GET | `/` | Staff+ | Get all invoices |
| PUT | `/{id}` | Staff+ | Update invoice |
| DELETE | `/{id}` | Staff+ | Delete invoice |

### Reviews (`/api/reviews`)
| Method | Path | Access | Description |
|---|---|---|---|
| POST | `/` | Authenticated | Create review (after completed rental) |
| PUT | `/{id}` | Owner | Update review |
| DELETE | `/{id}` | Owner/Staff | Delete review |
| GET | `/{id}` | Authenticated | Get review by ID |
| GET | `/vehicle/{vehicleId}` | Authenticated | Paginated reviews for vehicle |
| GET | `/vehicle/{vehicleId}/count?rating=N` | Authenticated | Count reviews by rating |
| GET | `/my-reviews` | Authenticated | Paginated reviews by user |
| GET | `/` | Staff+ | Paginated all reviews |

### Services (`/api/services`)
| Method | Path | Access | Description |
|---|---|---|---|
| POST | `/` | **No restriction** | Create service |
| GET | `/{id}` | Authenticated | Get service by ID |
| GET | `/` | Authenticated | Get all services |
| PUT | `/{id}` | **No restriction** | Update service |
| DELETE | `/{id}` | **No restriction** | Delete service |

### Reservation Services (`/api/reservation-services`)
| Method | Path | Access | Description |
|---|---|---|---|
| POST | `/` | Authenticated | Add service to reservation |
| GET | `/{id}` | Authenticated | Get by ID |
| GET | `/my-reservation-services` | Authenticated | Get current user's |
| GET | `/` | Staff+ | Get all |
| PUT | `/{id}` | Authenticated | Update |
| DELETE | `/{id}` | Authenticated | Delete |

### Rental Documents (`/api/rental-documents`)
| Method | Path | Access | Description |
|---|---|---|---|
| POST | `/` | Staff+ | Create rental document |
| POST | `/{rentalId}/upload` | Owner/Staff | Upload document file |
| GET | `/my-rental-document` | Authenticated | Get current user's |
| GET | `/{id}` | Staff+ | Get by ID |
| GET | `/rental/{rentalId}` | Staff+ | Get by rental ID |
| GET | `/` | Staff+ | Get all |
| PATCH | `/{id}?documentType=` | Staff+ | Change document type |
| DELETE | `/{id}` | Staff+ | Delete |

### Favorites (`/api/favorites`)
| Method | Path | Access | Description |
|---|---|---|---|
| POST | `/{vehicleId}` | Authenticated | Add vehicle to favorites |
| GET | `/` | Authenticated | Get current user's favorites |
| DELETE | `/{vehicleId}` | Authenticated | Remove from favorites |

### Discounts (`/api/discounts`)
| Method | Path | Access | Description |
|---|---|---|---|
| POST | `/` | **No restriction** | Create discount |
| GET | `/{id}` | Authenticated | Get by ID |
| GET | `/` | Authenticated | Get all |
| PUT | `/{id}` | **No restriction** | Update discount |
| DELETE | `/{id}` | **No restriction** | Delete discount |

### Discount Usages (`/api/discount-usages`)
| Method | Path | Access | Description |
|---|---|---|---|
| POST | `/` | Authenticated | Apply discount |
| GET | `/{id}` | Authenticated | Get by ID |
| GET | `/my-discount-usages` | Authenticated | Get current user's |
| GET | `/` | Staff+ | Get all |
| PUT | `/{id}` | Staff+ | Update |
| DELETE | `/{id}` | Staff+ | Delete |

### Notifications (`/api/notifications`)
| Method | Path | Access | Description |
|---|---|---|---|
| POST | `/{userId}/notify` | Staff+ | Send notification to user |
| GET | `/me/inbox` | Authenticated | Get current user's notifications |

### Maintenance Records (`/api/maintenace-records`)
> **Note:** Typo in route — "maintenace" missing "n"

| Method | Path | Access | Description |
|---|---|---|---|
| POST | `/` | Staff+ | Create record |
| GET | `/{id}` | Authenticated | Get by ID |
| GET | `/` | Authenticated | Get all |
| PUT | `/{id}` | Staff+ | Update |
| DELETE | `/{id}` | Admin/Manager | Delete |

### Locations (`/api/locations`)
| Method | Path | Access | Description |
|---|---|---|---|
| POST | `/` | Staff+ | Create location (unique address) |
| GET | `/{id}` | Authenticated | Get by ID |
| GET | `/` | Authenticated | Get all |
| PUT | `/{id}` | Staff+ | Update |
| DELETE | `/{id}` | Staff+ | Delete |

### Attachments (`/api/attachments`)
| Method | Path | Access | Description |
|---|---|---|---|
| POST | `/` | Staff+ | Create attachment |
| POST | `/upload` | Staff+ | Upload file (multipart) |
| GET | `/{id}` | Staff+ | Get by ID |
| GET | `/` | Staff+ | Get all |
| PUT | `/{id}` | Staff+ | Update |
| DELETE | `/{id}` | Staff+ | Delete |

### Test (`/api/test`) — Authorization testing
| Method | Path | Access |
|---|---|---|
| GET | `/customer` | CUSTOMER only |
| GET | `/admin` | ADMIN only |
| GET | `/manager` | MANAGER only |
| GET | `/staff` | STAFF only |
| GET | `/any` | Any authenticated |

---

## Key Business Logic

1. **User Registration:** First registered user automatically gets ADMIN role
2. **Reservation Pricing:** `totalPrice = vehicle.pricePerDay × number_of_days`
3. **Invoice Number:** Auto-generated as `INV-YYYYMMDD-RANDOM` (unique)
4. **Invoice Total:** `totalAmount = subtotal − discountAmount + taxAmount + lateFee`
5. **Rental Creation:** Only from CONFIRMED reservation; prevents duplicate rentals
6. **Review Creation:** Only after COMPLETED or RETURNED rental; one review per rental per user
7. **Password Reset:** UUID token with 15-minute expiry, sent via email
8. **Discount Usage:** Tracks per-user usage, respects `maxUses` limit, increments `usedCount`
9. **File Uploads:** Validates file extensions (jpg/jpeg/png/webp), stored in `uploads/`

---

## Error Handling

- `GlobalExceptionHandler` (`@RestControllerAdvice`) catches `RuntimeException` → returns HTTP 400 with error message
- No custom exception classes exist
- No granular 404/403 handling

---

## Environment Variables (`.env`)

```
DB_HOST=jdbc:mysql://localhost:3308/car_rental
DB_USER=root
DB_PASS=<password>
JWT_SECRET=<secret>
JWT_EXPIRE=86400000
MAIL_USERNAME=<gmail>
MAIL_PASSWORD=<app-password>
```

---

## Build & Run

```bash
./mvnw clean compile    # Compile
./mvnw spring-boot:run  # Run (http://localhost:8080)
./mvnw test             # Run tests (currently none exist)
./mvnw clean package    # Build JAR
```

**Prerequisites:** JDK 21, MySQL running, `.env` configured.

---

## Known Issues

1. **Empty mapper package** — DTO conversion is done inline in services via `toResponse()` methods instead of using a dedicated mapper layer
2. **No `@PreAuthorize`** on `ServiceController` and `DiscountController`
3. **Typo:** `/api/maintenace-records` (missing "n" in "maintenance")
4. **No double-booking prevention** — overlapping reservations on same vehicle not checked
5. **CORS allows all origins** (`*`)
6. **No tests** exist despite test dependencies being declared
7. **Inconsistent DI style** — mix of `@Autowired` field injection and `@RequiredArgsConstructor` constructor injection
