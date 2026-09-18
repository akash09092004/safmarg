import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/route_names.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/refund_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class RefundRequestScreen
    extends StatefulWidget {
  final int? bookingId;

  const RefundRequestScreen({
    super.key,
    this.bookingId,
  });

  @override
  State<RefundRequestScreen>
      createState() =>
          _RefundRequestScreenState();
}

class _RefundRequestScreenState
    extends State<RefundRequestScreen> {
  final _formKey =
      GlobalKey<FormState>();

  late TextEditingController
      bookingIdController;

  final reasonController =
      TextEditingController();

  String selectedReason =
      'Change in travel plan';

  final List<String> reasons = [
    'Change in travel plan',
    'Flight cancelled',
    'Flight rescheduled',
    'Medical emergency',
    'Duplicate booking',
    'Booked by mistake',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    bookingIdController =
        TextEditingController(
      text: widget.bookingId
              ?.toString() ??
          '',
    );
  }

  @override
  void dispose() {
    bookingIdController.dispose();
    reasonController.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    final bookingId =
        int.tryParse(
      bookingIdController.text.trim(),
    );

    if (bookingId == null) {
      return;
    }

    String reason =
        selectedReason;

    if (selectedReason ==
        'Other') {
      reason =
          reasonController.text.trim();

      if (reason.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Please enter refund reason.',
            ),
          ),
        );

        return;
      }
    }

    final provider =
        context.read<RefundProvider>();

    final refund =
        await provider.requestRefund(
      bookingId: bookingId,
      reason: reason,
    );

    if (!mounted) {
      return;
    }

    if (refund == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ??
                'Refund request failed.',
          ),
        ),
      );

      return;
    }

    Navigator.pushReplacementNamed(
      context,
      RouteNames.refundStatus,
      arguments: refund,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        context.watch<RefundProvider>();

    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: const CustomAppBar(
        title: 'Request Refund',
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _infoCard(),

              const SizedBox(
                height: 22,
              ),

              CustomTextField(
                controller:
                    bookingIdController,
                label: 'Booking ID',
                hint:
                    'Enter booking ID',
                prefixIcon:
                    Icons
                        .confirmation_num_outlined,
                keyboardType:
                    TextInputType.number,
                readOnly:
                    widget.bookingId !=
                        null,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Booking ID is required';
                  }

                  if (int.tryParse(
                        value.trim(),
                      ) ==
                      null) {
                    return 'Enter valid booking ID';
                  }

                  return null;
                },
              ),

              const SizedBox(
                height: 22,
              ),

              const Text(
                'Reason for Refund',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              DropdownButtonFormField<
                  String>(
                initialValue: selectedReason,
                decoration:
                    const InputDecoration(
                  prefixIcon: Icon(
                    Icons
                        .description_outlined,
                  ),
                ),
                items: reasons
                    .map(
                      (reason) =>
                          DropdownMenuItem(
                        value: reason,
                        child:
                            Text(reason),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }

                  setState(() {
                    selectedReason =
                        value;
                  });
                },
              ),

              if (selectedReason ==
                  'Other') ...[
                const SizedBox(
                  height: 16,
                ),

                CustomTextField(
                  controller:
                      reasonController,
                  label:
                      'Describe Reason',
                  hint:
                      'Why do you want a refund?',
                  prefixIcon:
                      Icons.edit_note,
                  maxLines: 4,
                  validator: (value) {
                    if (selectedReason ==
                            'Other' &&
                        (value == null ||
                            value
                                .trim()
                                .isEmpty)) {
                      return 'Reason is required';
                    }

                    return null;
                  },
                ),
              ],

              const SizedBox(
                height: 24,
              ),

              _policyCard(),

              const SizedBox(
                height: 28,
              ),

              CustomButton(
                text:
                    'Submit Refund Request',
                icon:
                    Icons.currency_exchange,
                isLoading:
                    provider.isLoading,
                onPressed:
                    provider.isLoading
                        ? null
                        : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            AppColors.primaryLight,
        borderRadius:
            BorderRadius.circular(15),
      ),
      child: const Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color:
                AppColors.primary,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Refund amount and eligibility will be calculated according to your booking and cancellation policy.',
              style: TextStyle(
                color:
                    AppColors.primary,
                height: 1.4,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _policyCard() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: const Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Before submitting',
            style: TextStyle(
              fontWeight:
                  FontWeight.w700,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'â€¢ Refund processing time may vary.\n'
            'â€¢ Cancellation charges may apply.\n'
            'â€¢ Approved amount will be returned to the eligible payment method.',
            style: TextStyle(
              color:
                  AppColors.textSecondary,
              fontSize: 12,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

