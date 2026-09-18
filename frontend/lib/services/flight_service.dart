import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../core/network/api_response.dart';
import '../models/flight_model.dart';
import '../models/seat_model.dart';

class FlightService {
  FlightService._();

  static final FlightService instance =
      FlightService._();

  final ApiClient _api =
      ApiClient.instance;

  // =========================
  // ALL / SEARCH FLIGHTS
  // =========================

  Future<ApiResponse<List<FlightModel>>>
      getFlights({
    String? origin,
    String? destination,
    String? date,
  }) async {
    final query = <String, String>{};

    if (origin != null &&
        origin.trim().isNotEmpty) {
      query['origin'] =
          origin.trim().toUpperCase();
    }

    if (destination != null &&
        destination.trim().isNotEmpty) {
      query['destination'] =
          destination.trim().toUpperCase();
    }

    if (date != null &&
        date.trim().isNotEmpty) {
      query['date'] = date.trim();
    }

    final response = await _api.get(
      ApiConstants.flights,
      queryParameters:
          query.isEmpty ? null : query,
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

      final List<dynamic> list =
          data is List ? data : [];

      final flights = list
          .whereType<Map>()
          .map(
            (item) =>
                FlightModel.fromJson(
              Map<String, dynamic>.from(
                item,
              ),
            ),
          )
          .toList();

      return ApiResponse.success(
        data: flights,
        message: response.message,
        statusCode: response.statusCode,
      );
    } catch (error) {
      return ApiResponse.failure(
        message:
            'Flight data parse nahi hua',
        error: error,
      );
    }
  }

  // =========================
  // SEARCH
  // =========================

  Future<ApiResponse<List<FlightModel>>>
      searchFlights({
    required String origin,
    required String destination,
    required String date,
  }) {
    return getFlights(
      origin: origin,
      destination: destination,
      date: date,
    );
  }

  // =========================
  // FLIGHT DETAILS
  // =========================

  Future<ApiResponse<FlightModel>>
      getFlightDetails(
    int flightId,
  ) async {
    final response = await _api.get(
      ApiConstants.flightDetails(
        flightId,
      ),
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
        return ApiResponse.failure(
          message:
              'Flight details invalid hain',
        );
      }

      final flight =
          FlightModel.fromJson(
        Map<String, dynamic>.from(
          response.data,
        ),
      );

      return ApiResponse.success(
        data: flight,
        message: response.message,
        statusCode: response.statusCode,
      );
    } catch (error) {
      return ApiResponse.failure(
        message:
            'Flight details parse nahi hui',
        error: error,
      );
    }
  }

  // =========================
  // FLIGHT SEATS
  // =========================

  Future<ApiResponse<List<SeatModel>>>
      getFlightSeats(
    int flightId,
  ) async {
    final response = await _api.get(
      ApiConstants.flightSeats(
        flightId,
      ),
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

      final List<dynamic> list =
          data is List ? data : [];

      final seats = list
          .whereType<Map>()
          .map(
            (item) =>
                SeatModel.fromJson(
              Map<String, dynamic>.from(
                item,
              ),
            ),
          )
          .toList();

      return ApiResponse.success(
        data: seats,
        message: response.message,
        statusCode: response.statusCode,
      );
    } catch (error) {
      return ApiResponse.failure(
        message:
            'Seat data parse nahi hua',
        error: error,
      );
    }
  }
}

