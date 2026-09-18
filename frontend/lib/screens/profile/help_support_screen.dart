import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../widgets/custom_app_bar.dart';

class HelpSupportScreen
    extends StatelessWidget {
  const HelpSupportScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: const CustomAppBar(
        title: 'Help & Support',
      ),

      body: ListView(
        padding:
            const EdgeInsets.all(16),
        children: [
          _header(),

          const SizedBox(
            height: 20,
          ),

          const Text(
            'How can we help?',
            style: TextStyle(
              fontSize: 19,
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          _supportItem(
            context,
            icon: Icons
                .flight_outlined,
            title:
                'Flight Booking',
            subtitle:
                'Help with searching and booking flights',
            message:
                'Search your route, select a flight, choose seats, add passengers and complete payment.',
          ),

          _supportItem(
            context,
            icon: Icons
                .confirmation_num_outlined,
            title:
                'Booking & Ticket',
            subtitle:
                'PNR, booking status and e-ticket',
            message:
                'Open My Bookings to view your booking details, PNR and e-ticket.',
          ),

          _supportItem(
            context,
            icon: Icons
                .currency_exchange,
            title:
                'Cancellation & Refund',
            subtitle:
                'Get help with cancellations and refunds',
            message:
                'Open your booking and use the cancellation/refund option if the booking is eligible.',
          ),

          _supportItem(
            context,
            icon: Icons
                .payments_outlined,
            title:
                'Payment',
            subtitle:
                'Payment failed or amount related issues',
            message:
                'Check your booking status before attempting payment again. A failed payment should not create duplicate bookings.',
          ),

          const SizedBox(
            height: 22,
          ),

          _faqSection(),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      padding:
          const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(0xff0866e5),
            Color(0xff4a9bf5),
          ],
        ),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.support_agent,
            color: Colors.white,
            size: 50,
          ),
          SizedBox(height: 12),
          Text(
            'SafMarg Support',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Find answers to common questions',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _supportItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String message,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 43,
          height: 43,
          decoration:
              BoxDecoration(
            color:
                AppColors.primaryLight,
            borderRadius:
                BorderRadius.circular(
              10,
            ),
          ),
          child: Icon(
            icon,
            color:
                AppColors.primary,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight:
                FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 11,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
              title: Text(title),
              content:
                  Text(message),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.pop(
                    context,
                  ),
                  child:
                      const Text('OK'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _faqSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: const Column(
        children: [
          ExpansionTile(
            title: Text(
              'Where can I find my PNR?',
            ),
            childrenPadding:
                EdgeInsets.fromLTRB(
              16,
              0,
              16,
              15,
            ),
            children: [
              Text(
                'Open My Bookings and select your booking. Your PNR will be displayed in Booking Details and E-Ticket.',
              ),
            ],
          ),
          Divider(height: 1),
          ExpansionTile(
            title: Text(
              'How can I cancel my booking?',
            ),
            childrenPadding:
                EdgeInsets.fromLTRB(
              16,
              0,
              16,
              15,
            ),
            children: [
              Text(
                'Open My Bookings, select the booking and use Cancel Booking if cancellation is available.',
              ),
            ],
          ),
          Divider(height: 1),
          ExpansionTile(
            title: Text(
              'How can I track my refund?',
            ),
            childrenPadding:
                EdgeInsets.fromLTRB(
              16,
              0,
              16,
              15,
            ),
            children: [
              Text(
                'Open the Refund section and select your refund request to view its current status.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

