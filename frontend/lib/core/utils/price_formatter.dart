import 'package:intl/intl.dart';

class PriceFormatter {
  PriceFormatter._();

  // =========================
  // NUMBER CONVERT
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
  // INR
  //
  // ₹5,500
  // =========================

  static String inr(
    dynamic value, {
    int decimalDigits = 0,
  }) {
    final amount =
        toDouble(value);

    final formatter =
        NumberFormat.currency(
      locale: 'en_IN',
      symbol: '\u20B9',
      decimalDigits:
          decimalDigits,
    );

    return formatter.format(
      amount,
    );
  }

  // =========================
  // WITHOUT SYMBOL
  //
  // 5,500
  // =========================

  static String number(
    dynamic value, {
    int decimalDigits = 0,
  }) {
    final amount =
        toDouble(value);

    if (decimalDigits <= 0) {
      return NumberFormat(
        '#,##0',
        'en_IN',
      ).format(amount);
    }

    return NumberFormat(
      '#,##0.${'0' * decimalDigits}',
      'en_IN',
    ).format(amount);
  }

  // =========================
  // ₹5.5K
  // ₹1.2L
  // =========================

  static String compact(
    dynamic value,
  ) {
    final amount =
        toDouble(value);

    if (amount >= 10000000) {
      return '\u20B9${(amount / 10000000).toStringAsFixed(1)}Cr';
    }

    if (amount >= 100000) {
      return '\u20B9${(amount / 100000).toStringAsFixed(1)}L';
    }

    if (amount >= 1000) {
      return '\u20B9${(amount / 1000).toStringAsFixed(1)}K';
    }

    return '\u20B9${amount.toStringAsFixed(0)}';
  }

  // =========================
  // DISCOUNT CALCULATION
  // =========================

  static double percentageDiscount({
    required dynamic amount,
    required dynamic percentage,
    dynamic maxDiscount,
  }) {
    final original =
        toDouble(amount);

    final percent =
        toDouble(percentage);

    double discount =
        original *
            (percent / 100);

    if (maxDiscount != null) {
      final maximum =
          toDouble(
        maxDiscount,
      );

      if (maximum > 0 &&
          discount > maximum) {
        discount = maximum;
      }
    }

    return discount;
  }

  // =========================
  // FINAL PRICE
  // =========================

  static double afterDiscount({
    required dynamic amount,
    required dynamic discount,
  }) {
    final original =
        toDouble(amount);

    final discountValue =
        toDouble(discount);

    final result =
        original -
            discountValue;

    return result < 0
        ? 0
        : result;
  }

  // =========================
  // FLIGHT FINAL SEAT PRICE
  //
  // basePrice + modifier
  // =========================

  static double seatPrice({
    required dynamic basePrice,
    required dynamic priceModifier,
  }) {
    return toDouble(basePrice) +
        toDouble(priceModifier);
  }
}
