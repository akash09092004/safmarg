import 'flight_model.dart';
import 'passenger_model.dart';
import 'seat_model.dart';

class BookingModel {
  final int id;

  final int? userId;
  final int? flightId;

  final String pnr;

  final String travelClass;

  final double totalAmount;

  final String status;
  final String paymentStatus;

  final FlightModel? flight;

  final List<PassengerModel> passengers;

  final List<SeatModel> seats;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BookingModel({
    required this.id,
    this.userId,
    this.flightId,
    required this.pnr,
    this.travelClass = 'economy',
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    this.flight,
    this.passengers = const [],
    this.seats = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final passengerData = json['passengers'];

    final seatsData = json['seats'];

    return BookingModel(
      id: _toInt(json['id']),
      userId: _nullableInt(json['user_id']),
      flightId: _nullableInt(json['flight_id']),
      pnr: json['pnr']?.toString() ?? '',
      travelClass: json['travel_class']?.toString() ?? 'economy',
      totalAmount: _toDouble(json['total_amount']),
      status: json['status']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? '',
      flight: json['flight'] is Map
          ? FlightModel.fromJson(Map<String, dynamic>.from(json['flight']))
          : json['flight_number'] != null
          ? FlightModel.fromJson({
              'id': json['flight_id'],
              'flight_number': json['flight_number'],
              'airline': json['airline'],
              'origin_code': json['origin_code'],
              'origin_city': json['origin_city'],
              'destination_code': json['destination_code'],
              'destination_city': json['destination_city'],
              'departure_time': json['departure_time'],
              'arrival_time': json['arrival_time'],
              'base_price': json['base_price'] ?? 0,
              'total_seats': json['total_seats'] ?? 0,
              'status': json['flight_status'] ?? 'scheduled',
            })
          : null,
      passengers: passengerData is List
          ? passengerData
                .whereType<Map>()
                .map(
                  (item) =>
                      PassengerModel.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList()
          : const [],
      seats: seatsData is List
          ? seatsData
                .whereType<Map>()
                .map(
                  (item) => SeatModel.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList()
          : const [],
      createdAt: _parseDate(json['created_at'] ?? json['booked_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'flight_id': flightId,
      'pnr': pnr,
      'travel_class': travelClass,
      'total_amount': totalAmount,
      'status': status,
      'payment_status': paymentStatus,
      'flight': flight?.toJson(),
      'passengers': passengers.map((item) => item.toJson()).toList(),
      'seats': seats.map((item) => item.toJson()).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  BookingModel copyWith({
    String? status,
    String? paymentStatus,
    List<PassengerModel>? passengers,
  }) {
    return BookingModel(
      id: id,
      userId: userId,
      flightId: flightId,
      pnr: pnr,
      travelClass: travelClass,
      totalAmount: totalAmount,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      flight: flight,
      passengers: passengers ?? this.passengers,
      seats: seats,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  bool get isConfirmed {
    return status == 'confirmed';
  }

  bool get isCancelled {
    return status == 'cancelled';
  }

  bool get isPaid {
    return paymentStatus == 'successful';
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int? _nullableInt(dynamic value) {
    if (value == null) {
      return null;
    }

    return _toInt(value);
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) {
      return null;
    }

    return DateTime.tryParse(value.toString().replaceFirst(' ', 'T'));
  }
}
