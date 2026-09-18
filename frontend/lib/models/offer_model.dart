class OfferModel {
  final int id;

  final String title;
  final String description;

  final String code;

  final String discountType;

  final double discountValue;

  final double? maxDiscount;

  final double minimumAmount;

  final DateTime? startsAt;
  final DateTime? endsAt;

  final bool isActive;

  final DateTime? createdAt;

  const OfferModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.code,
    required this.discountType,
    required this.discountValue,
    this.maxDiscount,
    required this.minimumAmount,
    this.startsAt,
    this.endsAt,
    required this.isActive,
    this.createdAt,
  });

  factory OfferModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OfferModel(
      id: _toInt(json['id']),
      title:
          json['title']?.toString() ??
          '',
      description:
          json['description']?.toString() ?? '',
      code:
          json['code']?.toString() ??
          '',
      discountType:
          json['discount_type']
              ?.toString() ??
          '',
      discountValue:
          _toDouble(
        json['discount_value'],
      ),
      maxDiscount:
          json['max_discount'] == null
              ? null
              : _toDouble(
                  json['max_discount'],
                ),
      minimumAmount:
          _toDouble(
        json['min_booking_amount'] ?? json['minimum_amount'],
      ),
      startsAt: _parseDate(
        json['valid_from'] ?? json['starts_at'],
      ),
      endsAt: _parseDate(
        json['valid_until'] ?? json['ends_at'],
      ),
      isActive:
          _toBool(
        json['is_active'],
      ),
      createdAt: _parseDate(
        json['created_at'],
      ),
    );
  }

  double get minBookingAmount => minimumAmount;
  DateTime? get validFrom => startsAt;
  DateTime? get validUntil => endsAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'code': code,
      'discount_type':
          discountType,
      'discount_value':
          discountValue,
      'max_discount':
          maxDiscount,
      'minimum_amount':
          minimumAmount,
      'starts_at':
          startsAt?.toIso8601String(),
      'ends_at':
          endsAt?.toIso8601String(),
      'is_active':
          isActive ? 1 : 0,
      'created_at':
          createdAt?.toIso8601String(),
    };
  }

  double calculateDiscount(
    double amount,
  ) {
    if (!isActive) {
      return 0;
    }

    if (amount < minimumAmount) {
      return 0;
    }

    double discount = 0;

    if (discountType ==
        'percentage') {
      discount =
          amount *
              (discountValue / 100);
    } else {
      discount =
          discountValue;
    }

    if (maxDiscount != null &&
        discount > maxDiscount!) {
      discount =
          maxDiscount!;
    }

    if (discount > amount) {
      discount = amount;
    }

    return discount;
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

    return value
            ?.toString()
            .toLowerCase() ==
        'true';
  }

  static DateTime? _parseDate(
    dynamic value,
  ) {
    if (value == null) {
      return null;
    }

    return DateTime.tryParse(
      value
          .toString()
          .replaceFirst(' ', 'T'),
    );
  }
}
