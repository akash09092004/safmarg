import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/route_names.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/price_formatter.dart';
import '../../models/offer_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';

class OfferDetailsScreen extends StatelessWidget {
  final OfferModel offer;

  const OfferDetailsScreen({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: const CustomAppBar(
        title: 'Offer Details',
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          16,
          18,
          16,
          35,
        ),
        child: Column(
          children: [
            _buildOfferHeader(),

            const SizedBox(height: 16),

            _buildCouponCard(context),

            const SizedBox(height: 16),

            _buildDescription(),

            const SizedBox(height: 16),

            _buildOfferInformation(),

            const SizedBox(height: 16),

            _buildTerms(),

            const SizedBox(height: 28),

            CustomButton(
              text: 'Book Flight Now',
              icon: Icons.flight_takeoff,
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
    );
  }

  Widget _buildOfferHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xff0866e5),
            Color(0xff4a9bf5),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_offer,
              color: Colors.white,
              size: 38,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            _discountText(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 31,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            offer.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponCard(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'COUPON CODE',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    AppColors.primary.withValues(alpha: .25),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    offer.code,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                ),

                IconButton(
                  tooltip: 'Copy',
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(
                        text: offer.code,
                      ),
                    );

                    if (!context.mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(context)
                        .hideCurrentSnackBar();

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                          '${offer.code} copied',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.copy_outlined,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Copy this code and apply it during booking.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return _card(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'About this Offer',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            offer.description,
            style: const TextStyle(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferInformation() {
    return _card(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Offer Information',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 18),

          _informationRow(
            icon: Icons.discount_outlined,
            title: 'Discount',
            value: _discountText(),
          ),

          const Divider(height: 25),

          _informationRow(
            icon: Icons
                .account_balance_wallet_outlined,
            title: 'Minimum Booking',
            value: offer.minBookingAmount > 0
                ? PriceFormatter.inr(
                    offer.minBookingAmount,
                  )
                : 'No minimum',
          ),

          if (offer.maxDiscount != null &&
              offer.maxDiscount! > 0) ...[
            const Divider(height: 25),

            _informationRow(
              icon:
                  Icons.currency_rupee_outlined,
              title: 'Maximum Discount',
              value: PriceFormatter.inr(
                offer.maxDiscount!,
              ),
            ),
          ],

          if (offer.validFrom != null) ...[
            const Divider(height: 25),

            _informationRow(
              icon: Icons.calendar_today_outlined,
              title: 'Valid From',
              value: _formatDate(
                offer.validFrom!,
              ),
            ),
          ],

          if (offer.validUntil != null) ...[
            const Divider(height: 25),

            _informationRow(
              icon: Icons.event_busy_outlined,
              title: 'Valid Until',
              value: _formatDate(
                offer.validUntil!,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTerms() {
    return _card(
      child: const Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Terms & Conditions',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 14),

          _TermItem(
            text:
                'Offer can be used only on eligible flight bookings.',
          ),

          _TermItem(
            text:
                'Coupon code must be applied before making payment.',
          ),

          _TermItem(
            text:
                'Only one coupon can be applied to one booking.',
          ),

          _TermItem(
            text:
                'Discount is subject to the minimum booking amount.',
          ),

          _TermItem(
            text:
                'The offer cannot be exchanged for cash.',
          ),

          _TermItem(
            text:
                'SafMarg may modify or withdraw the offer according to applicable offer rules.',
          ),
        ],
      ),
    );
  }

  Widget _informationRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 21,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ),

        const SizedBox(width: 10),

        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _card({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: child,
    );
  }

  String _discountText() {
    if (offer.discountType.toLowerCase() ==
        'percentage') {
      return '${offer.discountValue.toStringAsFixed(0)}% OFF';
    }

    return '${PriceFormatter.inr(offer.discountValue)} OFF';
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _TermItem extends StatelessWidget {
  final String text;

  const _TermItem({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 11,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              top: 5,
            ),
            child: Icon(
              Icons.circle,
              size: 6,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

