import 'package:flutter/material.dart';

import '../../app/route_names.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/price_formatter.dart';
import '../../models/refund_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';

class RefundStatusScreen
    extends StatelessWidget {
  final RefundModel refund;

  const RefundStatusScreen({
    super.key,
    required this.refund,
  });

  @override
  Widget build(BuildContext context) {
    final rejected =
        refund.status.toLowerCase() ==
            'rejected';

    final completed =
        refund.status.toLowerCase() ==
            'completed';

    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: const CustomAppBar(
        title: 'Refund Status',
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),

            Container(
              width: 100,
              height: 100,
              decoration:
                  BoxDecoration(
                color: rejected
                    ? AppColors.error
                        .withValues(alpha: .12)
                    : completed
                        ? AppColors.success
                            .withValues(alpha: .12)
                        : AppColors.primary
                            .withValues(alpha: .12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                rejected
                    ? Icons
                        .cancel_outlined
                    : completed
                        ? Icons
                            .check_circle_outline
                        : Icons
                            .currency_exchange,
                size: 55,
                color: rejected
                    ? AppColors.error
                    : completed
                        ? AppColors.success
                        : AppColors.primary,
              ),
            ),

            const SizedBox(
              height: 22,
            ),

            Text(
              rejected
                  ? 'Refund Rejected'
                  : completed
                      ? 'Refund Completed'
                      : 'Refund Request Submitted',
              textAlign:
                  TextAlign.center,
              style:
                  const TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.w800,
              ),
            ),

            const SizedBox(
              height: 9,
            ),

            Text(
              _statusMessage(),
              textAlign:
                  TextAlign.center,
              style:
                  const TextStyle(
                color:
                    AppColors.textSecondary,
                height: 1.5,
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(
                20,
              ),
              decoration:
                  BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
                border: Border.all(
                  color:
                      AppColors.border,
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'REFUND ID',
                    style: TextStyle(
                      color: AppColors
                          .textSecondary,
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    '#${refund.id}',
                    style:
                        const TextStyle(
                      color:
                          AppColors.primary,
                      fontSize: 24,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),

                  const Divider(
                    height: 35,
                  ),

                  _row(
                    'Booking ID',
                    '#${refund.bookingId}',
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  _row(
                    'Amount',
                    PriceFormatter.inr(
                      refund.amount,
                    ),
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  _row(
                    'Status',
                    refund.status
                        .toUpperCase(),
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  _row(
                    'Reason',
                    refund.reason,
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            CustomButton(
              text:
                  'View Refund Details',
              icon:
                  Icons.description_outlined,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RouteNames.refundDetails,
                  arguments: refund.id,
                );
              },
            ),

            const SizedBox(
              height: 12,
            ),

            CustomButton(
              text: 'Go to Refunds',
              outlined: true,
              icon:
                  Icons.currency_exchange,
              onPressed: () {
                Navigator
                    .pushNamedAndRemoveUntil(
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

  String _statusMessage() {
    switch (
        refund.status.toLowerCase()) {
      case 'completed':
        return 'Your refund has been processed successfully.';

      case 'rejected':
        return 'Your refund request was not approved. Please check the refund details.';

      case 'approved':
        return 'Your refund has been approved and will be processed soon.';

      case 'processing':
        return 'Your refund is currently being processed.';

      case 'under_review':
        return 'Your refund request is currently under review.';

      default:
        return 'Your refund request has been received. You can track the progress here.';
    }
  }

  Widget _row(
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
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
}

