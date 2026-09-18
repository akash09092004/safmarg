import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/route_names.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/price_formatter.dart';
import '../../models/booking_model.dart';
import '../../models/flight_model.dart';
import '../../models/passenger_model.dart';
import '../../models/payment_model.dart';
import '../../models/seat_model.dart';
import '../../providers/booking_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/payment_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';

class PaymentScreen extends StatefulWidget {
  final FlightModel flight;
  final List<SeatModel> selectedSeats;
  final List<PassengerModel> passengers;
  final double totalAmount;

  const PaymentScreen({
    super.key,
    required this.flight,
    required this.selectedSeats,
    required this.passengers,
    required this.totalAmount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMethod = 'mock';

  bool processing = false;

  final List<_PaymentMethod> methods = const [
    _PaymentMethod(
      value: 'mock',
      title: 'Test Payment',
      subtitle: 'Use for development/testing',
      icon: Icons.developer_mode_outlined,
    ),
    _PaymentMethod(
      value: 'upi',
      title: 'UPI',
      subtitle: 'Google Pay, PhonePe, Paytm',
      icon: Icons.qr_code_2_outlined,
    ),
    _PaymentMethod(
      value: 'card',
      title: 'Credit / Debit Card',
      subtitle: 'Visa, Mastercard, RuPay',
      icon: Icons.credit_card_outlined,
    ),
    _PaymentMethod(
      value: 'netbanking',
      title: 'Net Banking',
      subtitle: 'Pay through your bank',
      icon: Icons.account_balance_outlined,
    ),
    _PaymentMethod(
      value: 'wallet',
      title: 'Wallet',
      subtitle: 'Use a digital wallet',
      icon: Icons.account_balance_wallet_outlined,
    ),
  ];

  // ====================================
  // PAY
  // ====================================

  Future<void> _pay() async {
    if (processing) {
      return;
    }

    setState(() {
      processing = true;
    });

    final bookingProvider = context.read<BookingProvider>();

    final paymentProvider = context.read<PaymentProvider>();
    final user = context.read<AuthProvider>().user;

    if (user == null) {
      setState(() => processing = false);
      _showError(
        'Booking ke liye pehle login karein.',
      );
      return;
    }

    final contactEmail = widget.passengers.first.email?.trim().isNotEmpty == true
        ? widget.passengers.first.email!.trim()
        : user.email;
    final contactPhone = widget.passengers.first.phone?.trim().isNotEmpty == true
        ? widget.passengers.first.phone!.trim()
        : user.phone ?? '';

    // STEP 1:
    // Create booking
    final BookingModel? booking = await bookingProvider.createBooking(
      flightId: widget.flight.id,
      contactEmail: contactEmail,
      contactPhone: contactPhone,
      passengers: widget.passengers,
      seats: widget.selectedSeats,
    );

    if (!mounted) {
      return;
    }

    if (booking == null) {
      setState(() {
        processing = false;
      });

      _showError(
        bookingProvider.errorMessage ?? 'Booking create nahi ho payi.',
      );

      return;
    }

    // STEP 2:
    // Create payment
    final PaymentModel? payment = await paymentProvider.createOrder(
      bookingId: booking.id,
      method: selectedMethod,
    );

    if (!mounted) {
      return;
    }

    if (payment == null) {
      setState(() {
        processing = false;
      });

      _showError(
        paymentProvider.errorMessage ?? 'Payment order create nahi hua.',
      );

      return;
    }

    setState(() {
      processing = false;
    });

    if (!payment.isSuccessful) {
      _showError(paymentProvider.errorMessage ?? 'Payment failed.');

      return;
    }

    // STEP 4:
    // Success screen
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.paymentSuccess,
      (route) => route.isFirst,
      arguments: {
        'booking': booking,
        'payment': paymentProvider.payment,
        'flight': widget.flight,
        'passengers': widget.passengers,
        'selectedSeats': widget.selectedSeats,
        'totalAmount': widget.totalAmount,
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: const CustomAppBar(title: 'Payment'),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAmountCard(),

            const SizedBox(height: 24),

            const Text(
              'Choose Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 14),

            ...methods.map(_buildPaymentMethod),

            const SizedBox(height: 20),

            _buildSecurityInfo(),

            const SizedBox(height: 110),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildAmountCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff0866e5), Color(0xff4599f8)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            'Amount to Pay',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),

          const SizedBox(height: 8),

          Text(
            PriceFormatter.inr(widget.totalAmount),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${widget.flight.originCode} → ${widget.flight.destinationCode} • ${widget.passengers.length} Passenger(s)',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(_PaymentMethod method) {
    final selected = selectedMethod == method.value;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: processing
            ? null
            : () {
                setState(() {
                  selectedMethod = method.value;
                });
              },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primaryLight
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  method.icon,
                  color: selected ? AppColors.primary : AppColors.textSecondary,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      method.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              Radio<String>(
                value: method.value,
                // TODO: Migrate the payment options to RadioGroup when
                // the project raises its minimum Flutter version.
                // ignore: deprecated_member_use
                groupValue: selectedMethod,
                // ignore: deprecated_member_use
                onChanged: processing
                    ? null
                    : (value) {
                        if (value == null) {
                          return;
                        }

                        setState(() {
                          selectedMethod = value;
                        });
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityInfo() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.lock_outline, color: AppColors.primary),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Demo checkout: no real money will be charged.',
              style: TextStyle(color: AppColors.primary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .08),
              blurRadius: 18,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: CustomButton(
          text: 'Pay ${PriceFormatter.inr(widget.totalAmount)}',
          icon: Icons.lock_outline,
          isLoading: processing,
          onPressed: processing ? null : _pay,
        ),
      ),
    );
  }
}

class _PaymentMethod {
  final String value;
  final String title;
  final String subtitle;
  final IconData icon;

  const _PaymentMethod({
    required this.value,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
