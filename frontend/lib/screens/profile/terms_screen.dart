import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../widgets/custom_app_bar.dart';

class TermsScreen
    extends StatelessWidget {
  const TermsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: const CustomAppBar(
        title:
            'Terms & Conditions',
      ),

      body: ListView(
        padding:
            const EdgeInsets.all(18),
        children: [
          Container(
            padding:
                const EdgeInsets.all(
              20,
            ),
            decoration:
                BoxDecoration(
              color: AppColors
                  .primaryLight,
              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),
            child:
                const Column(
              children: [
                Icon(
                  Icons
                      .description_outlined,
                  color:
                      AppColors.primary,
                  size: 45,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Terms & Conditions',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Please read these terms before using SafMarg.',
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    color: AppColors
                        .textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          _section(
            '1. Use of SafMarg',
            '''
By using SafMarg, you agree to use the application lawfully and provide accurate information when making bookings or using other services.
''',
          ),

          _section(
            '2. Account',
            '''
You are responsible for maintaining the confidentiality of your account credentials and for activity performed through your account, subject to applicable law.
''',
          ),

          _section(
            '3. Flight Information',
            '''
Flight schedules, fares, seat availability and other travel information may change. Information shown during booking should be confirmed against the final booking details provided for the transaction.
''',
          ),

          _section(
            '4. Booking',
            '''
A booking is subject to availability and applicable fare and booking rules. A booking should be treated as confirmed only when the service returns a confirmed booking status and the required payment process has completed successfully.
''',
          ),

          _section(
            '5. Payments',
            '''
Payments may be handled through applicable payment providers. Users should verify the final payable amount before authorizing payment.
''',
          ),

          _section(
            '6. Cancellation & Refund',
            '''
Cancellation eligibility, cancellation charges and refund amounts depend on the rules applicable to the booking. Any refund shown in the application should follow the applicable booking and refund rules.
''',
          ),

          _section(
            '7. Offers',
            '''
Coupons and promotional offers may have separate eligibility, minimum booking value, validity dates, discount limits and other conditions.
''',
          ),

          _section(
            '8. User Responsibilities',
            '''
Users should provide correct passenger and contact information and review important booking details before payment and travel.
''',
          ),

          _section(
            '9. Service Changes',
            '''
Features, policies and these terms may be updated when necessary. The current terms should be made available in the application.
''',
          ),

          _section(
            '10. Contact',
            '''
Questions about these terms should be directed to the official support contact details published by SafMarg.
''',
          ),
        ],
      ),
    );
  }

  Widget _section(
    String title,
    String text,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 13,
      ),
      padding:
          const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                const TextStyle(
              fontSize: 15,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 9,
          ),
          Text(
            text.trim(),
            style:
                const TextStyle(
              color: AppColors
                  .textSecondary,
              fontSize: 12,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

