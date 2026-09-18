import 'package:flutter/material.dart';

import '../../app/route_names.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/price_formatter.dart';
import '../../models/booking_model.dart';
import '../../widgets/custom_button.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final BookingModel booking;

  const BookingConfirmationScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 30),

                Container(
                  width: 105,
                  height: 105,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: .12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 70,
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'Booking Confirmed!',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Your flight has been booked successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),

                const SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'PNR NUMBER',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          letterSpacing: 1,
                        ),
                      ),

                      const SizedBox(height: 5),

                      SelectableText(
                        booking.pnr,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                        ),
                      ),

                      const Divider(height: 35),

                      _row('Booking ID', '#${booking.id}'),

                      const SizedBox(height: 13),

                      _row('Status', booking.status.toUpperCase()),

                      const SizedBox(height: 13),

                      _row('Travel Class', booking.travelClass),

                      const SizedBox(height: 13),

                      _row('Passengers', '${booking.passengers.length}'),

                      const SizedBox(height: 13),

                      _row(
                        'Total Fare',
                        PriceFormatter.inr(booking.totalAmount),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                CustomButton(
                  text: 'View Ticket',
                  icon: Icons.confirmation_num_outlined,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      RouteNames.ticket,
                      arguments: booking,
                    );
                  },
                ),

                const SizedBox(height: 12),

                CustomButton(
                  text: 'My Bookings',
                  outlined: true,
                  icon: Icons.luggage_outlined,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RouteNames.main,
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
