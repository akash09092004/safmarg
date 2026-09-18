import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/route_names.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/price_formatter.dart';
import '../../models/refund_model.dart';
import '../../providers/refund_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_widget.dart';

class RefundScreen extends StatefulWidget {
  const RefundScreen({
    super.key,
  });

  @override
  State<RefundScreen> createState() =>
      _RefundScreenState();
}

class _RefundScreenState
    extends State<RefundScreen> {
  String selectedFilter = 'all';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _loadRefunds();
      },
    );
  }

  Future<void> _loadRefunds() async {
    await context
        .read<RefundProvider>()
        .loadMyRefunds();
  }

  List<RefundModel> _filterRefunds(
    List<RefundModel> refunds,
  ) {
    if (selectedFilter == 'all') {
      return refunds;
    }

    return refunds.where((refund) {
      return refund.status.toLowerCase() ==
          selectedFilter;
    }).toList();
  }

  void _openDetails(
    RefundModel refund,
  ) {
    Navigator.pushNamed(
      context,
      RouteNames.refundDetails,
      arguments: refund.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        context.watch<RefundProvider>();

    final refunds =
        _filterRefunds(
      provider.refunds,
    );

    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        title: const Text(
          'Refunds',
        ),
        actions: [
          IconButton(
            tooltip: 'Request Refund',
            onPressed: () {
              Navigator.pushNamed(
                context,
                RouteNames.refundRequest,
              );
            },
            icon: const Icon(
              Icons.add_circle_outline,
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          _buildHeader(),

          _buildFilter(),

          Expanded(
            child: provider.isLoading
                ? const LoadingWidget(
                    message:
                        'Loading refunds...',
                  )
                : provider.errorMessage != null &&
                        provider.refunds.isEmpty
                    ? EmptyState(
                        icon:
                            Icons.error_outline,
                        title:
                            'Unable to Load Refunds',
                        message:
                            provider.errorMessage ??
                                'Something went wrong.',
                        buttonText:
                            'Retry',
                        onButtonPressed:
                            _loadRefunds,
                      )
                    : refunds.isEmpty
                        ? EmptyState(
                            icon: Icons
                                .currency_exchange_outlined,
                            title:
                                'No Refunds Found',
                            message:
                                selectedFilter == 'all'
                                    ? 'Aapne abhi koi refund request nahi ki hai.'
                                    : '$selectedFilter status ka refund nahi mila.',
                            buttonText:
                                'Request Refund',
                            onButtonPressed:
                                () {
                              Navigator.pushNamed(
                                context,
                                RouteNames
                                    .refundRequest,
                              );
                            },
                          )
                        : RefreshIndicator(
                            onRefresh:
                                _loadRefunds,
                            child:
                                ListView.separated(
                              padding:
                                  const EdgeInsets.fromLTRB(
                                16,
                                15,
                                16,
                                30,
                              ),
                              itemCount:
                                  refunds.length,
                              separatorBuilder:
                                  (_, _) =>
                                      const SizedBox(
                                height: 12,
                              ),
                              itemBuilder:
                                  (context, index) {
                                return _refundCard(
                                  refunds[index],
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        18,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration:
                const BoxDecoration(
              color:
                  AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.currency_exchange,
              color:
                  AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Refund Center',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Track and manage your flight refunds',
                  style: TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilter() {
    const filters = [
      'all',
      'requested',
      'approved',
      'processing',
      'completed',
      'rejected',
    ];

    return Container(
      color: Colors.white,
      padding:
          const EdgeInsets.only(
        bottom: 12,
      ),
      child: SingleChildScrollView(
        scrollDirection:
            Axis.horizontal,
        padding:
            const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Row(
          children: filters.map(
            (filter) {
              return Padding(
                padding:
                    const EdgeInsets.only(
                  right: 8,
                ),
                child: ChoiceChip(
                  label: Text(
                    _capitalize(
                      filter,
                    ),
                  ),
                  selected:
                      selectedFilter ==
                          filter,
                  onSelected: (_) {
                    setState(() {
                      selectedFilter =
                          filter;
                    });
                  },
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  Widget _refundCard(
    RefundModel refund,
  ) {
    final color =
        _statusColor(
      refund.status,
    );

    return InkWell(
      borderRadius:
          BorderRadius.circular(18),
      onTap: () {
        _openDetails(refund);
      },
      child: Container(
        padding:
            const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 43,
                  height: 43,
                  decoration:
                      BoxDecoration(
                    color:
                        color.withValues(alpha: 
                      .10,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),
                  child: Icon(
                    Icons
                        .currency_exchange,
                    color: color,
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        'Refund #${refund.id}',
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        'Booking #${refund.bookingId}',
                        style:
                            const TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                _statusChip(
                  refund.status,
                ),
              ],
            ),

            const SizedBox(
              height: 17,
            ),

            const Divider(),

            const SizedBox(
              height: 13,
            ),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      const Text(
                        'Refund Amount',
                        style:
                            TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        PriceFormatter.inr(
                          refund.amount,
                        ),
                        style:
                            const TextStyle(
                          color:
                              AppColors.primary,
                          fontSize: 18,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons
                      .arrow_forward_ios,
                  size: 16,
                  color:
                      AppColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(
    String status,
  ) {
    final color =
        _statusColor(status);

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color:
            color.withValues(alpha: .10),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight:
              FontWeight.w700,
        ),
      ),
    );
  }

  Color _statusColor(
    String status,
  ) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.success;

      case 'approved':
        return Colors.teal;

      case 'processing':
        return AppColors.primary;

      case 'rejected':
        return AppColors.error;

      default:
        return AppColors.warning;
    }
  }

  String _capitalize(
    String text,
  ) {
    if (text.isEmpty) {
      return text;
    }

    return text[0].toUpperCase() +
        text.substring(1);
  }
}

