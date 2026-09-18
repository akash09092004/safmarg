import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

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
      const _NavItem(
        icon: Icons.home_rounded,
        label: 'Home',
      ),
      const _NavItem(
        icon:
            Icons.confirmation_num_outlined,
        label: 'My Bookings',
      ),
      const _NavItem(
        icon: Icons.currency_exchange,
        label: 'Refund',
      ),
      const _NavItem(
        icon:
            Icons.local_offer_outlined,
        label: 'Offers',
      ),
    ];

    return SafeArea(
      minimum:
          const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        14,
      ),
      child: Container(
        height: 76,

        padding:
            const EdgeInsets.symmetric(
          horizontal: 8,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(28),

          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(alpha: .10),
              blurRadius: 24,
              offset:
                  const Offset(0, 8),
            ),
          ],
        ),

        child: Row(
          children: List.generate(
            items.length,
            (index) {
              final selected =
                  currentIndex == index;

              final item =
                  items[index];

              return Expanded(
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),

                  onTap: () {
                    onTap(index);
                  },

                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                    children: [
                      Icon(
                        item.icon,
                        size: 27,
                        color: selected
                            ? AppColors
                                .primary
                            : AppColors
                                .textSecondary,
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Text(
                        item.label,
                        maxLines: 1,
                        overflow:
                            TextOverflow
                                .ellipsis,
                        style: TextStyle(
                          color: selected
                              ? AppColors
                                  .primary
                              : AppColors
                                  .textSecondary,
                          fontSize: 11,
                          fontWeight: selected
                              ? FontWeight
                                  .w700
                              : FontWeight
                                  .w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.label,
  });
}

