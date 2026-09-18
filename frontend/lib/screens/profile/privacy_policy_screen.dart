import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../widgets/custom_app_bar.dart';

class PrivacyPolicyScreen
    extends StatelessWidget {
  const PrivacyPolicyScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: const CustomAppBar(
        title: 'Privacy Policy',
      ),

      body: ListView(
        padding:
            const EdgeInsets.all(18),
        children: [
          _header(
            Icons.privacy_tip_outlined,
            'Privacy Policy',
            'How SafMarg handles information',
          ),

          const SizedBox(
            height: 20,
          ),

          _section(
            '1. Information We Collect',
            '''
Depending on the features you use, SafMarg may collect information such as your name, email address, phone number, passenger details, booking information and information required to provide requested services.

Payment-related information may be processed by the applicable payment service provider.
''',
          ),

          _section(
            '2. How We Use Information',
            '''
Information may be used to provide app functionality, process bookings, manage accounts, provide customer support, communicate service-related updates, prevent misuse and improve the service.
''',
          ),

          _section(
            '3. Booking Information',
            '''
Passenger and booking information may be processed as necessary to provide flight search, reservation, ticket, cancellation and refund functionality.
''',
          ),

          _section(
            '4. Data Sharing',
            '''
Information may be shared with service providers or other parties when needed to provide requested services, comply with applicable law, protect rights and security, or when otherwise permitted with appropriate authorization.
''',
          ),

          _section(
            '5. Data Security',
            '''
SafMarg should use reasonable technical and organizational measures designed to protect information. No electronic storage or transmission method can guarantee absolute security.
''',
          ),

          _section(
            '6. Data Retention',
            '''
Information should be retained only for as long as reasonably necessary for service, legal, accounting, security and other legitimate purposes, subject to applicable requirements.
''',
          ),

          _section(
            '7. Your Choices',
            '''
Available choices may include reviewing or updating profile information and making privacy-related requests, subject to applicable law and technical or legal requirements.
''',
          ),

          _section(
            '8. Changes to this Policy',
            '''
This Privacy Policy may be updated as the service changes. The current version should be made available within the application.
''',
          ),

          _section(
            '9. Contact',
            '''
For privacy questions, use the official support contact details published by SafMarg.
''',
          ),

          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _header(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:
            AppColors.primaryLight,
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color:
                AppColors.primary,
            size: 45,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style:
                const TextStyle(
              fontSize: 21,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            subtitle,
            textAlign:
                TextAlign.center,
            style:
                const TextStyle(
              color: AppColors
                  .textSecondary,
              fontSize: 12,
            ),
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

