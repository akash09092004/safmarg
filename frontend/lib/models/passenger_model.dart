class PassengerModel {
  final int? id;
  final int? bookingId;

  final String fullName;
  final String? gender;

  final DateTime? dateOfBirth;
  final String? nationality;
  final String? passportNumber;

  final String? email;
  final String? phone;

  final String? seatNumber;
  final int? providedAge;

  String get name => fullName;
  int get age {
    if (providedAge != null) return providedAge!;
    if (dateOfBirth == null) return 0;
    final now = DateTime.now();
    var years = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      years--;
    }
    return years;
  }

  const PassengerModel({
    this.id,
    this.bookingId,
    String? fullName,
    String? name,
    int? age,
    this.gender,
    this.dateOfBirth,
    this.nationality,
    this.passportNumber,
    this.email,
    this.phone,
    this.seatNumber,
  }) : fullName = fullName ?? name ?? '',
       providedAge = age;

  factory PassengerModel.fromJson(Map<String, dynamic> json) {
    return PassengerModel(
      id: _nullableInt(json['id']),
      bookingId: _nullableInt(json['booking_id']),
      fullName:
          json['full_name']?.toString() ??
          _joinedName(json) ??
          json['name']?.toString() ??
          '',
      gender: json['gender']?.toString(),
      dateOfBirth: _parseDate(json['date_of_birth']),
      nationality: json['nationality']?.toString(),
      passportNumber: json['passport_number']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      seatNumber: json['seat_number']?.toString(),
      age: _nullableInt(json['age']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (bookingId != null) 'booking_id': bookingId,
      'full_name': fullName,
      'gender': gender,
      'date_of_birth': dateOfBirth == null ? null : _dateOnly(dateOfBirth!),
      'nationality': nationality,
      'passport_number': passportNumber,
      'email': email,
      'phone': phone,
      'seat_number': seatNumber,
      if (providedAge != null) 'age': providedAge,
    };
  }

  static int? _nullableInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString());
  }

  static String? _joinedName(Map<String, dynamic> json) {
    final first = json['first_name']?.toString().trim() ?? '';
    final last = json['last_name']?.toString().trim() ?? '';
    final result = [first, last].where((part) => part.isNotEmpty).join(' ');
    return result.isEmpty ? null : result;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) {
      return null;
    }

    return DateTime.tryParse(value.toString().replaceFirst(' ', 'T'));
  }

  static String _dateOnly(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');

    final month = date.month.toString().padLeft(2, '0');

    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}
