import 'package:flutter/material.dart';

class WhyChooseUs extends StatelessWidget {
  const WhyChooseUs({super.key});

  static const _items = [
    (Icons.verified_user_rounded, 'Secure Booking'),
    (Icons.local_offer_rounded, 'Best Prices'),
    (Icons.support_agent_rounded, '24/7 Support'),
    (Icons.currency_exchange_rounded, 'Easy Refunds'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Why Choose Safemarg?',
            style: TextStyle(
              color: Color(0xFF172033),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 13),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth < 330
                  ? (constraints.maxWidth - 10) / 2
                  : (constraints.maxWidth - 30) / 4;
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _items.map((item) {
                  return Container(
                    width: itemWidth,
                    height: 82,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0B4A9E).withValues(alpha: 0.07),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: const Color(0xFFEAF3FF),
                          child: Icon(item.$1, color: const Color(0xFF0866E5), size: 20),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.$2,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

