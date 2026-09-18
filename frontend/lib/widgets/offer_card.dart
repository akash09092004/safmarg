import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/utils/price_formatter.dart';
import '../models/offer_model.dart';

class OfferCard extends StatelessWidget {
  final OfferModel offer;

  final VoidCallback? onTap;

  final VoidCallback? onApply;

  const OfferCard({
    super.key,
    required this.offer,
    this.onTap,
    this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final discountText =
        offer.discountType ==
                'percentage'
            ? '${offer.discountValue.toStringAsFixed(0)}% OFF'
            : '${PriceFormatter.inr(offer.discountValue)} OFF';

    return InkWell(
      borderRadius:
          BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient:
              const LinearGradient(
            colors: [
              Color(0xff0866e5),
              Color(0xff4da8ff),
            ],
          ),
          borderRadius:
              BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    discountText,
                    style:
                        const TextStyle(
                      fontSize: 23,
                      fontWeight:
                          FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Icon(
                  Icons.local_offer,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              offer.title,
              style:
                  const TextStyle(
                fontSize: 17,
                fontWeight:
                    FontWeight.w700,
                color: Colors.white,
              ),
            ),

            ...[
            const SizedBox(height: 5),
            Text(
              offer.description,
              style:
                  const TextStyle(
                color:
                    Colors.white70,
                fontSize: 13,
              ),
            ),
          ],

            const SizedBox(height: 16),

            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration:
                      BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(
                      8,
                    ),
                  ),
                  child: Text(
                    offer.code,
                    style:
                        const TextStyle(
                      color:
                          AppColors.primary,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),

                const Spacer(),

                TextButton(
                  onPressed: onApply,
                  style:
                      TextButton.styleFrom(
                    foregroundColor:
                        Colors.white,
                  ),
                  child:
                      const Text(
                    'Apply',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

