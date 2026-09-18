class RefundModel {
  final int id;

  final int bookingId;
  final int? paymentId;
  final int? userId;
  final String? pnr;

  final String reason;

  final double amount;

  final String status;

  final DateTime? processedAt;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RefundModel({
    required this.id,
    required this.bookingId,
    this.paymentId,
    this.userId,
    this.pnr,
    required this.reason,
    required this.amount,
    required this.status,
    this.processedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory RefundModel.fromJson(Map<String, dynamic> json) {
    return RefundModel(
      id: _toInt(json['id']),
      bookingId: _toInt(json['booking_id']),
      paymentId: _nullableInt(json['payment_id']),
      userId: _nullableInt(json['user_id']),
      pnr: json['pnr']?.toString(),
      reason: json['reason']?.toString() ?? '',
      amount: _toDouble(json['amount']),
      status: json['status']?.toString() ?? '',
      processedAt: _parseDate(json['processed_at']),
      createdAt: _parseDate(json['created_at'] ?? json['requested_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_id': bookingId,
      'payment_id': paymentId,
      'user_id': userId,
      'pnr': pnr,
      'reason': reason,
      'amount': amount,
      'status': status,
      'processed_at': processedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  bool get isCompleted {
    return status == 'completed' || status == 'processed';
  }

  bool get isRejected {
    return status == 'rejected';
  }

  bool get isPending {
    return [
      'requested',
      'under_review',
      'approved',
      'processing',
    ].contains(status);
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
