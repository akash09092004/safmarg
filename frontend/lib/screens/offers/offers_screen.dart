import 'package:flutter/material.dart';

import '../../app/route_names.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/price_formatter.dart';
import '../../models/offer_model.dart';
import '../../services/offer_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_widget.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final OfferService _offerService = OfferService();

  bool isLoading = false;
  String? errorMessage;

  List<OfferModel> offers = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOffers();
    });
  }

  Future<void> _loadOffers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await _offerService.getOffers();

      if (!mounted) return;

      setState(() {
        offers = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  void _openOffer(OfferModel offer) {
    Navigator.pushNamed(
      context,
      RouteNames.offerDetails,
      arguments: offer,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: const CustomAppBar(
        title: 'Offers',
      ),

      body: RefreshIndicator(
        onRefresh: _loadOffers,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const LoadingWidget(
        message: 'Loading offers...',
      );
    }

    if (errorMessage != null && offers.isEmpty) {
      return EmptyState(
        icon: Icons.error_outline,
        title: 'Unable to Load Offers',
        message: errorMessage!,
        buttonText: 'Retry',
        onButtonPressed: _loadOffers,
      );
    }

    if (offers.isEmpty) {
      return EmptyState(
        icon: Icons.local_offer_outlined,
        title: 'No Offers Available',
        message:
            'Abhi koi active offer available nahi hai.',
        buttonText: 'Refresh',
        onButtonPressed: _loadOffers,
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        16,
        18,
        16,
        35,
      ),
      children: [
        _buildHeader(),

        const SizedBox(height: 20),

        Text(
          '${offers.length} Offers Available',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 14),

        ...offers.map(
          (offer) => Padding(
            padding: const EdgeInsets.only(
              bottom: 14,
            ),
            child: _offerCard(offer),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xff0866e5),
            Color(0xff4a9bf5),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Save More on Flights',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'Use SafMarg offers and save on your next booking.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 15),
          Icon(
            Icons.local_offer,
            color: Colors.white,
            size: 55,
          ),
        ],
      ),
    );
  }

  Widget _offerCard(OfferModel offer) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _openOffer(offer),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.percent,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          _discountText(offer),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          offer.title,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      const Text(
                        'Coupon:',
                        style: TextStyle(
                          color:
                              AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                        child: Text(
                          offer.code,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                      ),

                      const Spacer(),

                      if (offer.validUntil != null)
                        Text(
                          'Valid till ${_formatDate(offer.validUntil!)}',
                          style: const TextStyle(
                            color:
                                AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),

                  if (offer.minBookingAmount > 0) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Minimum booking: ${PriceFormatter.inr(offer.minBookingAmount)}',
                      style: const TextStyle(
                        color:
                            AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _discountText(OfferModel offer) {
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

