class PaymentModel {
  final int id;
  final int bookingId;

  final String? transactionId;

  final double amount;

  final String method;
  final String status;

  final DateTime? paidAt;
  final DateTime? createdAt;

  const PaymentModel({
    required this.id,
    required this.bookingId,
    this.transactionId,
    required this.amount,
    required this.method,
    required this.status,
    this.paidAt,
    this.createdAt,
  });

  factory PaymentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PaymentModel(
      id: _toInt(json['id']),
      bookingId:
          _toInt(
        json['booking_id'],
      ),
      transactionId:
          json['transaction_id']
              ?.toString(),
      amount:
          _toDouble(json['amount']),
      method:
          json['method']?.toString() ??
          '',
      status:
          json['status']?.toString() ??
          '',
      paidAt:
          _parseDate(json['paid_at']),
      createdAt: _parseDate(
        json['created_at'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_id': bookingId,
      'transaction_id':
          transactionId,
      'amount': amount,
      'method': method,
      'status': status,
      'paid_at':
          paidAt?.toIso8601String(),
      'created_at':
          createdAt?.toIso8601String(),
    };
  }

  bool get isSuccessful {
    return status ==
        'successful';
  }

  bool get isPending {
    return status ==
        'pending';
  }

  bool get isFailed {
    return status ==
        'failed';
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

