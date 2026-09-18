import 'seat_model.dart';

class FlightModel {
  final int id;

  final String flightNumber;
  final String airline;

  final String originCode;
  final String originCity;

  final String destinationCode;
  final String destinationCity;

  final DateTime? departureTime;
  final DateTime? arrivalTime;

  final double basePrice;

  final int totalSeats;
  final String status;

  final int durationMinutes;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final List<SeatModel> seats;

  const FlightModel({
    required this.id,
    required this.flightNumber,
    required this.airline,
    required this.originCode,
    required this.originCity,
    required this.destinationCode,
    required this.destinationCity,
    this.departureTime,
    this.arrivalTime,
    required this.basePrice,
    required this.totalSeats,
    required this.status,
    required this.durationMinutes,
    this.createdAt,
    this.updatedAt,
    this.seats = const [],
  });

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    final rawSeats = json['seats'];

    return FlightModel(
      id: _toInt(json['id']),
      flightNumber: json['flight_number']?.toString() ?? '',
      airline: json['airline']?.toString() ?? '',
      originCode: json['origin_code']?.toString() ?? '',
      originCity: json['origin_city']?.toString() ?? '',
      destinationCode: json['destination_code']?.toString() ?? '',
      destinationCity: json['destination_city']?.toString() ?? '',
      departureTime: _parseDate(json['departure_time']),
      arrivalTime: _parseDate(json['arrival_time']),
      basePrice: _toDouble(json['base_price']),
      totalSeats: _toInt(json['total_seats']),
      status: json['status']?.toString() ?? '',
      durationMinutes: _durationMinutes(json),
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
      seats: rawSeats is List
          ? rawSeats
                .whereType<Map>()
                .map(
                  (item) => SeatModel.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'flight_number': flightNumber,
      'airline': airline,
      'origin_code': originCode,
      'origin_city': originCity,
      'destination_code': destinationCode,
      'destination_city': destinationCity,
      'departure_time': departureTime?.toIso8601String(),
      'arrival_time': arrivalTime?.toIso8601String(),
      'base_price': basePrice,
      'total_seats': totalSeats,
      'status': status,
      'duration_minutes': durationMinutes,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'seats': seats.map((seat) => seat.toJson()).toList(),
    };
  }

  bool get isScheduled {
    return status.toLowerCase() == 'scheduled';
  }

  String get route {
    return '$originCode â†’ $destinationCode';
  }

  double get price {
    return basePrice;
  }

  String get durationText {
    if (durationMinutes <= 0) {
      return '--';
    }

    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;

    return '${hours}h ${minutes}m';
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

  static int _durationMinutes(Map<String, dynamic> json) {
    final supplied = _toInt(json['duration_minutes']);
    if (supplied > 0) return supplied;

    final departure = _parseDate(json['departure_time']);
    final arrival = _parseDate(json['arrival_time']);
    if (departure == null || arrival == null) return 0;
    return arrival.difference(departure).inMinutes;
  }
}
