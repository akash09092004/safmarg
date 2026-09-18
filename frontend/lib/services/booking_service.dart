import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../core/network/api_response.dart';
import '../models/booking_model.dart';
import '../models/passenger_model.dart';
import '../models/seat_model.dart';

class BookingService {
  BookingService._();

  static final BookingService instance = BookingService._();

  final ApiClient _api = ApiClient.instance;

  // =========================
  // CREATE BOOKING
  // =========================

  Future<ApiResponse<BookingModel>> createBooking({
    required int flightId,
    required String contactEmail,
    required String contactPhone,
    required List<PassengerModel> passengers,
    required List<SeatModel> seats,
  }) async {
    if (passengers.isEmpty || passengers.length != seats.length) {
      return ApiResponse.failure(
        message: 'Har passenger ke liye ek seat select karein',
      );
    }

    final response = await _api.post(
      ApiConstants.bookings,
      requiresAuth: true,
      body: {
        'flight_id': flightId,
        'contact_email': contactEmail.trim(),
        'contact_phone': _normalizePhone(contactPhone),
        'passengers': List.generate(passengers.length, (index) {
          final passenger = passengers[index];
          final nameParts = passenger.fullName.trim().split(RegExp(r'\s+'));
          final dateOfBirth =
              passenger.dateOfBirth ??
              DateTime(DateTime.now().year - passenger.age, 1, 1);

          return {
            'seat_id': seats[index].id,
            'first_name': nameParts.first,
            'last_name': nameParts.length > 1
                ? nameParts.sublist(1).join(' ')
                : '-',
            'gender': passenger.gender ?? 'other',
            'date_of_birth': _dateOnly(dateOfBirth),
            if (passenger.nationality != null &&
                passenger.nationality!.trim().isNotEmpty)
              'nationality': passenger.nationality!.trim(),
          };
        }).toList(),
      },
    );

    if (!response.success) {
      return ApiResponse.failure(
        message: response.message,
        statusCode: response.statusCode,
        error: response.error,
      );
    }

    try {
      if (response.data is! Map) {
        return ApiResponse.failure(message: 'Booking response invalid hai');
      }

      final booking = BookingModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );

      return ApiResponse.success(
        data: booking,
        message: response.message,
        statusCode: response.statusCode,
      );
    } catch (error) {
      return ApiResponse.failure(
        message: 'Booking data parse nahi hua',
        error: error,
      );
    }
  }

  String _normalizePhone(String value) {
    final phone = value.trim().replaceAll(RegExp(r'[\s-]'), '');
    if (phone.startsWith('+')) return phone;
    if (RegExp(r'^\d{10}$').hasMatch(phone)) return '+91$phone';
    return phone;
  }

  // =========================
  // MY BOOKINGS
  // =========================

  Future<ApiResponse<List<BookingModel>>> getMyBookings() async {
    final response = await _api.get(
      ApiConstants.myBookings,
      requiresAuth: true,
    );

    if (!response.success) {
      return ApiResponse.failure(
        message: response.message,
        statusCode: response.statusCode,
        error: response.error,
      );
    }

    try {
      final data = response.data;

      final List<dynamic> list = data is List ? data : [];

      final bookings = list
          .whereType<Map>()
          .map((item) => BookingModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      return ApiResponse.success(data: bookings, message: response.message);
    } catch (error) {
      return ApiResponse.failure(
        message: 'Bookings parse nahi hui',
        error: error,
      );
    }
  }

  // =========================
  // BOOKING DETAILS
  // =========================

  Future<ApiResponse<BookingModel>> getBookingDetails(int bookingId) async {
    final response = await _api.get(
      ApiConstants.bookingDetails(bookingId),
      requiresAuth: true,
    );

    if (!response.success) {
      return ApiResponse.failure(
        message: response.message,
        statusCode: response.statusCode,
        error: response.error,
      );
    }

    try {
      final booking = BookingModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );

      return ApiResponse.success(data: booking, message: response.message);
    } catch (error) {
      return ApiResponse.failure(
        message: 'Booking details parse nahi hui',
        error: error,
      );
    }
  }

  // =========================
  // PNR
  // =========================

  Future<ApiResponse<BookingModel>> getBookingByPnr(String pnr) async {
    final response = await _api.get(
      ApiConstants.bookingByPnr(pnr.trim()),
      requiresAuth: true,
    );

    if (!response.success) {
      return ApiResponse.failure(
        message: response.message,
        statusCode: response.statusCode,
        error: response.error,
      );
    }

    try {
      final booking = BookingModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );

      return ApiResponse.success(data: booking, message: response.message);
    } catch (error) {
      return ApiResponse.failure(
        message: 'PNR booking parse nahi hui',
        error: error,
      );
    }
  }

  Future<ApiResponse<List<PassengerModel>>> getBookingPassengers(
    int bookingId,
  ) async {
    final response = await _api.get(
      ApiConstants.bookingPassengers(bookingId),
      requiresAuth: true,
    );
    if (!response.success) {
      return ApiResponse.failure(
        message: response.message,
        statusCode: response.statusCode,
        error: response.error,
      );
    }

    try {
      final list = response.data is List ? response.data as List : const [];
      return ApiResponse.success(
        data: list
            .whereType<Map>()
            .map(
              (item) =>
                  PassengerModel.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList(),
        message: response.message,
      );
    } catch (error) {
      return ApiResponse.failure(
        message: 'Passenger list parse nahi hui',
        error: error,
      );
    }
  }

  Future<ApiResponse<PassengerModel>> updatePassenger(
    PassengerModel passenger,
  ) async {
    if (passenger.id == null) {
      return ApiResponse.failure(message: 'Passenger ID nahi mili');
    }

    final nameParts = passenger.fullName.trim().split(RegExp(r'\s+'));
    final response = await _api.put(
      '${ApiConstants.baseUrl}/passengers/${passenger.id}',
      requiresAuth: true,
      body: {
        'first_name': nameParts.first,
        'last_name': nameParts.length > 1
            ? nameParts.sublist(1).join(' ')
            : '-',
        'gender': passenger.gender,
        if (passenger.dateOfBirth != null)
          'date_of_birth': _dateOnly(passenger.dateOfBirth!),
        if (passenger.passportNumber != null)
          'passport_number': passenger.passportNumber,
        if (passenger.nationality != null) 'nationality': passenger.nationality,
      },
    );

    if (!response.success) {
      return ApiResponse.failure(
        message: response.message,
        statusCode: response.statusCode,
        error: response.error,
      );
    }

    try {
      return ApiResponse.success(
        data: PassengerModel.fromJson(Map<String, dynamic>.from(response.data)),
        message: response.message,
      );
    } catch (error) {
      return ApiResponse.failure(
        message: 'Passenger update parse nahi hua',
        error: error,
      );
    }
  }

  // =========================
  // CANCEL BOOKING
  // =========================

  Future<ApiResponse<BookingModel>> cancelBooking(int bookingId) async {
    final response = await _api.patch(
      ApiConstants.cancelBooking(bookingId),
      requiresAuth: true,
    );

    if (!response.success) {
      return ApiResponse.failure(
        message: response.message,
        statusCode: response.statusCode,
        error: response.error,
      );
    }

    try {
      final booking = BookingModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );

      return ApiResponse.success(data: booking, message: response.message);
    } catch (error) {
      return ApiResponse.failure(
        message: 'Cancelled booking parse nahi hui',
        error: error,
      );
    }
  }

  String _dateOnly(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');

    final m = date.month.toString().padLeft(2, '0');

    final d = date.day.toString().padLeft(2, '0');

    return '$y-$m-$d';
  }
}
