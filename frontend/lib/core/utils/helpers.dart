import 'package:flutter/material.dart';

class Helpers {
  Helpers._();

  // =========================
  // SAFE INTEGER
  // =========================

  static int toInt(
    dynamic value,
  ) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value.toString(),
        ) ??
        0;
  }

  // =========================
  // SAFE DOUBLE
  // =========================

  static double toDouble(
    dynamic value,
  ) {
    if (value == null) {
      return 0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value.toString(),
        ) ??
        0;
  }

  // =========================
  // SAFE STRING
  // =========================

  static String toStringValue(
    dynamic value, {
    String defaultValue = '',
  }) {
    if (value == null) {
      return defaultValue;
    }

    return value.toString();
  }

  // =========================
  // BOOL
  //
  // API:
  // 1 => true
  // 0 => false
  // =========================

  static bool toBool(
    dynamic value,
  ) {
    if (value is bool) {
      return value;
    }

    if (value is int) {
      return value == 1;
    }

    if (value is num) {
      return value.toInt() == 1;
    }

    final text = value
        ?.toString()
        .toLowerCase();

    return text == 'true' ||
        text == '1' ||
        text == 'yes';
  }

  // =========================
  // CAPITALIZE
  // =========================

  static String capitalize(
    String value,
  ) {
    if (value.isEmpty) {
      return value;
    }

    return value[0]
            .toUpperCase() +
        value.substring(1);
  }

  // =========================
  // PREMIUM_ECONOMY
  // =>
  // Premium Economy
  // =========================

  static String readableText(
    String value,
  ) {
    if (value.isEmpty) {
      return '';
    }

    return value
        .replaceAll('_', ' ')
        .split(' ')
        .where(
          (word) => word.isNotEmpty,
        )
        .map(capitalize)
        .join(' ');
  }

  // =========================
  // AIRPORT CODE
  // =========================

  static String airportCode(
    String value,
  ) {
    return value
        .trim()
        .toUpperCase();
  }

  // =========================
  // INITIALS
  //
  // Aman Sharma => AS
  // =========================

  static String initials(
    String name,
  ) {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where(
          (word) => word.isNotEmpty,
        )
        .toList();

    if (words.isEmpty) {
      return '';
    }

    if (words.length == 1) {
      return words.first[0]
          .toUpperCase();
    }

    return '${words.first[0]}${words.last[0]}'
        .toUpperCase();
  }

  // =========================
  // HIDE PHONE
  //
  // 9876543210
  // => ******3210
  // =========================

  static String maskPhone(
    String phone,
  ) {
    if (phone.length <= 4) {
      return phone;
    }

    final lastFour =
        phone.substring(
      phone.length - 4,
    );

    return '${'*' * (phone.length - 4)}$lastFour';
  }

  // =========================
  // HIDE EMAIL
  //
  // aman@gmail.com
  // => a***@gmail.com
  // =========================

  static String maskEmail(
    String email,
  ) {
    if (!email.contains('@')) {
      return email;
    }

    final parts =
        email.split('@');

    final name = parts[0];
    final domain = parts[1];

    if (name.isEmpty) {
      return email;
    }

    return '${name[0]}***@$domain';
  }

  // =========================
  // SNACKBAR
  // =========================

  static void showSnackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor:
              backgroundColor,
        ),
      );
  }

  // =========================
  // SUCCESS SNACKBAR
  // =========================

  static void showSuccess(
    BuildContext context,
    String message,
  ) {
    showSnackBar(
      context,
      message,
      backgroundColor:
          const Color(0xff16A34A),
    );
  }

  // =========================
  // ERROR SNACKBAR
  // =========================

  static void showError(
    BuildContext context,
    String message,
  ) {
    showSnackBar(
      context,
      message,
      backgroundColor:
          const Color(0xffDC2626),
    );
  }

  // =========================
  // CONFIRMATION DIALOG
  // =========================

  static Future<bool>
      showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Yes',
    String cancelText = 'No',
  }) async {
    final result =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: Text(
                cancelText,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: Text(
                confirmText,
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  // =========================
  // KEYBOARD CLOSE
  // =========================

  static void hideKeyboard(
    BuildContext context,
  ) {
    FocusScope.of(context)
        .unfocus();
  }
}

