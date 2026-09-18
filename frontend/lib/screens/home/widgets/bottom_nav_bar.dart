import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        "icon": Icons.home_rounded,
        "label": "Home",
      },
      {
        "icon": Icons.confirmation_num_outlined,
        "label": "My Bookings",
      },
      {
        "icon": Icons.currency_exchange,
        "label": "Refund",
      },
      {
        "icon": Icons.card_giftcard_rounded,
        "label": "Offers",
      },
    ];

    return Container(
      height: 88,
      margin: const EdgeInsets.fromLTRB(
        18,
        0,
        18,
        18,
      ),
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(alpha: 0.10),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: List.generate(
          items.length,
          (index) {
            final selected =
                currentIndex == index;

            return Expanded(
              child: InkWell(
                borderRadius:
                    BorderRadius.circular(20),
                onTap: () => onTap(index),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      items[index]["icon"]
                          as IconData,
                      color: selected
                          ? const Color(
                              0xff0866e5,
                            )
                          : const Color(
                              0xff596274,
                            ),
                      size: 29,
                    ),

                    const SizedBox(height: 5),

                    Text(
                      items[index]["label"]
                          as String,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: selected
                            ? const Color(
                                0xff0866e5,
                              )
                            : const Color(
                                0xff596274,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
