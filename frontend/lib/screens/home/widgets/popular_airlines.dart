import 'package:flutter/material.dart';

class PopularAirlines extends StatelessWidget {
  const PopularAirlines({super.key});

  static const _airlines = [
    ('IndiGo', Color(0xFF2446A8), '6E'),
    ('Air India', Color(0xFFE32636), 'AI'),
    ('Vistara', Color(0xFF55134E), 'UK'),
    ('SpiceJet', Color(0xFFF05A28), 'SG'),
    ('Akasa Air', Color(0xFFF58220), 'QP'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Popular Airlines',
                style: TextStyle(
                  color: Color(0xFF172033),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text('View All', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth < 330
                  ? 76.0
                  : (constraints.maxWidth - 32) / 5;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_airlines.length, (index) {
                    final airline = _airlines[index];
                    return Padding(
                      padding: EdgeInsets.only(right: index == _airlines.length - 1 ? 0 : 8),
                      child: Container(
                        width: cardWidth,
                        height: 86,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0B4A9E).withValues(alpha: 0.07),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 39,
                              height: 39,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: airline.$2.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Text(
                                airline.$3,
                                style: TextStyle(
                                  color: airline.$2,
                                  fontWeight: FontWeight.w900,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              airline.$1,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

