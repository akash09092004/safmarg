class SeatModel {
  final int id;
  final int flightId;

  final String seatNumber;
  final String seatClass;

  final double priceModifier;

  final bool isAvailable;

  bool isSelected;

  SeatModel({
    required this.id,
    required this.flightId,
    required this.seatNumber,
    required this.seatClass,
    required this.priceModifier,
    required this.isAvailable,
    this.isSelected = false,
  });

  factory SeatModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SeatModel(
      id: _toInt(json['id']),
      flightId:
          _toInt(json['flight_id']),
      seatNumber:
          json['seat_number']
              ?.toString() ??
          '',
      seatClass:
          json['seat_class']
              ?.toString() ??
          'economy',
      priceModifier:
          _toDouble(
        json['price_modifier'],
      ),
      isAvailable:
          _toBool(
        json['is_available'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'flight_id': flightId,
      'seat_number': seatNumber,
      'seat_class': seatClass,
      'price_modifier':
          priceModifier,
      'is_available':
          isAvailable ? 1 : 0,
    };
  }

  double finalPrice(
    double basePrice,
  ) {
    return basePrice +
        priceModifier;
  }

  bool get isBusiness {
    return seatClass ==
        'business';
  }

  bool get isPremiumEconomy {
    return seatClass ==
        'premium_economy';
  }

  bool get isEconomy {
    return seatClass ==
        'economy';
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  static double _toDouble(
    dynamic value,
  ) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  static bool _toBool(
    dynamic value,
  ) {
    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value.toInt() == 1;
    }

    final text =
        value?.toString().toLowerCase();

    return text == '1' ||
        text == 'true' ||
        text == 'available';
  }
}

