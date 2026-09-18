import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/route_names.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/price_formatter.dart';
import '../../models/refund_model.dart';
import '../../providers/refund_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_widget.dart';

class RefundDetailsScreen
    extends StatefulWidget {
  final int refundId;

  const RefundDetailsScreen({
    super.key,
    required this.refundId,
  });

  @override
  State<RefundDetailsScreen>
      createState() =>
          _RefundDetailsScreenState();
}

class _RefundDetailsScreenState
    extends State<RefundDetailsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _loadDetails();
      },
    );
  }

  Future<void> _loadDetails() async {
    await context
        .read<RefundProvider>()
        .loadRefundDetails(
          widget.refundId,
        );
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        context.watch<RefundProvider>();

    final refund =
        provider.selectedRefund;

    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: const CustomAppBar(
        title: 'Refund Details',
      ),

      body: provider.isLoading
          ? const LoadingWidget(
              message:
                  'Loading refund details...',
            )
          : refund == null
              ? EmptyState(
                  icon:
                      Icons.currency_exchange,
                  title:
                      'Refund Not Found',
                  message:
                      provider.errorMessage ??
                          'Refund details nahi mili.',
                  buttonText:
                      'Retry',
                  onButtonPressed:
                      _loadDetails,
                )
              : RefreshIndicator(
                  onRefresh:
                      _loadDetails,
                  child:
                      SingleChildScrollView(
                    physics:
                        const AlwaysScrollableScrollPhysics(),
                    padding:
                        const EdgeInsets.all(
                      18,
                    ),
                    child: Column(
                      children: [
                        _buildStatus(
                          refund,
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        _buildAmount(
                          refund,
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        _buildDetails(
                          refund,
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        _buildTimeline(
                          refund,
                        ),

                        const SizedBox(
                          height: 25,
                        ),

                        CustomButton(
                          text:
                              'Track Refund Status',
                          icon:
                              Icons.track_changes,
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames
                                  .refundStatus,
                              arguments:
                                  refund,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildStatus(
    RefundModel refund,
  ) {
    final color =
        _statusColor(
      refund.status,
    );

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color:
            color.withValues(alpha: .08),
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color:
              color.withValues(alpha: .25),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration:
                BoxDecoration(
              color:
                  color.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _statusIcon(
                refund.status,
              ),
              color: color,
            ),
          ),
          const SizedBox(
            width: 14,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Refund Status',
                  style: TextStyle(
                    color: AppColors
                        .textSecondary,
                    fontSize: 12,
                  ),
                ),
                Text(
                  refund.status
                      .toUpperCase(),
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmount(
    RefundModel refund,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(0xff0866e5),
            Color(0xff4a9bf5),
          ],
        ),
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Text(
            'Refund Amount',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            PriceFormatter.inr(
              refund.amount,
            ),
            style:
                const TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(
    RefundModel refund,
  ) {
    return _card(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Refund Information',
            style: TextStyle(
              fontSize: 17,
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 18,
          ),

          _row(
            'Refund ID',
            '#${refund.id}',
          ),

          const SizedBox(
            height: 13,
          ),

          _row(
            'Booking ID',
            '#${refund.bookingId}',
          ),

          const SizedBox(
            height: 13,
          ),

          _row(
            'Reason',
            refund.reason,
          ),

          const SizedBox(
            height: 13,
          ),

          _row(
            'Status',
            refund.status,
          ),

          if (refund.processedAt !=
              null) ...[
            const SizedBox(
              height: 13,
            ),
            _row(
              'Processed',
              refund.processedAt!
                  .toLocal()
                  .toString()
                  .split('.')
                  .first,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeline(
    RefundModel refund,
  ) {
    return _card(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Refund Progress',
            style: TextStyle(
              fontSize: 17,
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          _timelineItem(
            title:
                'Refund Requested',
            done: true,
            last: false,
          ),

          _timelineItem(
            title:
                'Under Review',
            done:
                _reached(
              refund.status,
              'under_review',
            ),
            last: false,
          ),

          _timelineItem(
            title:
                'Refund Approved',
            done:
                _reached(
              refund.status,
              'approved',
            ),
            last: false,
          ),

          _timelineItem(
            title:
                'Processing',
            done:
                _reached(
              refund.status,
              'processing',
            ),
            last: false,
          ),

          _timelineItem(
            title:
                refund.status ==
                        'rejected'
                    ? 'Rejected'
                    : 'Completed',
            done:
                refund.status ==
                        'completed' ||
                    refund.status ==
                        'rejected',
            last: true,
          ),
        ],
      ),
    );
  }

  Widget _timelineItem({
    required String title,
    required bool done,
    required bool last,
  }) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 25,
              height: 25,
              decoration:
                  BoxDecoration(
                color: done
                    ? AppColors.success
                    : AppColors.border,
                shape: BoxShape.circle,
              ),
              child: done
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color:
                          Colors.white,
                    )
                  : null,
            ),

            if (!last)
              Container(
                width: 2,
                height: 38,
                color: done
                    ? AppColors.success
                    : AppColors.border,
              ),
          ],
        ),

        const SizedBox(
          width: 12,
        ),

        Padding(
          padding:
              const EdgeInsets.only(
            top: 3,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: done
                  ? FontWeight.w600
                  : FontWeight.w400,
              color: done
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  bool _reached(
    String current,
    String target,
  ) {
    const levels = {
      'requested': 1,
      'under_review': 2,
      'approved': 3,
      'processing': 4,
      'completed': 5,
    };

    return (levels[current] ?? 0) >=
        (levels[target] ?? 0);
  }

  Widget _row(
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color:
                  AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Flexible(
          child: Text(
            value,
            textAlign:
                TextAlign.right,
            style: const TextStyle(
              fontWeight:
                  FontWeight.w600,
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
      child: child,
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

  IconData _statusIcon(
    String status,
  ) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons
            .check_circle_outline;

      case 'rejected':
        return Icons
            .cancel_outlined;

      case 'processing':
        return Icons
            .sync_outlined;

      default:
        return Icons
            .schedule_outlined;
    }
  }
}

