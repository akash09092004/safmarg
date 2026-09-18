class Validators {
  Validators._();

  // =========================
  // REQUIRED FIELD
  // =========================

  static String? required(
    String? value, {
    String fieldName = 'Field',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    return null;
  }

  // =========================
  // NAME
  // =========================

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }

    final name = value.trim();

    if (name.length < 2) {
      return 'Name must be at least 2 characters';
    }

    final regex = RegExp(
      r"^[a-zA-Z\s.'-]+$",
    );

    if (!regex.hasMatch(name)) {
      return 'Please enter a valid name';
    }

    return null;
  }

  // =========================
  // EMAIL
  // =========================

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final email = value.trim();

    final regex = RegExp(
      r'^[\w\.-]+@[\w\.-]+\.\w+$',
    );

    if (!regex.hasMatch(email)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  // =========================
  // PHONE
  // =========================

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    String phone = value
        .replaceAll(' ', '')
        .replaceAll('-', '');

    if (phone.startsWith('+91')) {
      phone = phone.substring(3);
    }

    if (phone.startsWith('91') &&
        phone.length == 12) {
      phone = phone.substring(2);
    }

    final regex = RegExp(
      r'^[6-9]\d{9}$',
    );

    if (!regex.hasMatch(phone)) {
      return 'Please enter a valid 10 digit phone number';
    }

    return null;
  }

  // =========================
  // PASSWORD
  // =========================

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }

  // =========================
  // STRONG PASSWORD
  // =========================

  static String? strongPassword(
    String? value,
  ) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain an uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain a lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain a number';
    }

    if (!RegExp(
      r'[!@#$%^&*(),.?":{}|<>]',
    ).hasMatch(value)) {
      return 'Password must contain a special character';
    }

    return null;
  }

  // =========================
  // CONFIRM PASSWORD
  // =========================

  static String? confirmPassword(
    String? value,
    String password,
  ) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  // =========================
  // AIRPORT CODE
  // DEL / BOM etc.
  // =========================

  static String? airportCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Airport code is required';
    }

    final code = value.trim().toUpperCase();

    if (!RegExp(r'^[A-Z]{3}$').hasMatch(code)) {
      return 'Airport code must be 3 letters';
    }

    return null;
  }

  // =========================
  // FROM / TO CHECK
  // =========================

  static String? route({
    required String origin,
    required String destination,
  }) {
    if (origin.trim().isEmpty ||
        destination.trim().isEmpty) {
      return 'Origin and destination are required';
    }

    if (origin.trim().toUpperCase() ==
        destination.trim().toUpperCase()) {
      return 'Origin and destination cannot be same';
    }

    return null;
  }

  // =========================
  // OTP
  // =========================

  static String? otp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'OTP is required';
    }

    if (!RegExp(r'^\d{4,6}$')
        .hasMatch(value.trim())) {
      return 'Please enter a valid OTP';
    }

    return null;
  }

  // =========================
  // PASSENGER AGE
  // =========================

  static String? age(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Age is required';
    }

    final age = int.tryParse(value);

    if (age == null) {
      return 'Enter valid age';
    }

    if (age <= 0 || age > 120) {
      return 'Enter valid age';
    }

    return null;
  }

  // =========================
  // POSITIVE AMOUNT
  // =========================

  static String? amount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required';
    }

    final amount = double.tryParse(value);

    if (amount == null || amount <= 0) {
      return 'Please enter valid amount';
    }

    return null;
  }
}
