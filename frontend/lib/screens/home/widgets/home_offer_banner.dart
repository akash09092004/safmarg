import 'package:flutter/material.dart';

class HomeOfferBanner extends StatelessWidget {
  const HomeOfferBanner({super.key, required this.onBookNow});

  final VoidCallback onBookNow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(17, 14, 12, 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF2F7FF), Color(0xFFE8F3FF)],
          ),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Get Up to 20% OFF',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'On your first flight booking',
                    style: TextStyle(fontSize: 11, color: Color(0xFF4E586A)),
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: onBookNow,
                      iconAlignment: IconAlignment.end,
                      icon: const Icon(Icons.arrow_forward_rounded, size: 15),
                      label: const Text('BOOK NOW'),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 28),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 66,
              height: 76,
              decoration: BoxDecoration(
                color: Color(0xFFD5EBFF),
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              child: const Icon(Icons.luggage_rounded, size: 51, color: Color(0xFF0866E5)),
            ),
          ],
        ),
      ),
    );
  }
}
