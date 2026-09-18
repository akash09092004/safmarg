import 'package:flutter/material.dart';

import '../../app/route_names.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/price_formatter.dart';
import '../../models/flight_model.dart';
import '../../models/passenger_model.dart';
import '../../models/seat_model.dart';
import '../../services/offer_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';

class FareSummaryScreen extends StatelessWidget {
  final FlightModel flight;
  final List<SeatModel> selectedSeats;
  final List<PassengerModel> passengers;

  const FareSummaryScreen({
    super.key,
    required this.flight,
    required this.selectedSeats,
    required this.passengers,
  });

  double get baseFare {
    return flight.basePrice * passengers.length;
  }

  double get seatCharges {
    double total = 0;

    for (final seat in selectedSeats) {
      total += seat.priceModifier;
    }

    return total;
  }

  double get totalAmount {
    return baseFare + seatCharges;
  }

  void _continueToPayment(BuildContext context) {
    Navigator.pushNamed(
      context,
      RouteNames.payment,
      arguments: {
        'flight': flight,
        'selectedSeats': selectedSeats,
        'passengers': passengers,
        'baseFare': baseFare,
        'seatCharges': seatCharges,
        'totalAmount': totalAmount,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: const CustomAppBar(title: 'Fare Summary'),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildFlightCard(),

                  const SizedBox(height: 16),

                  _buildPassengerCard(),

                  const SizedBox(height: 16),

                  _buildSeatCard(),

                  const SizedBox(height: 16),

                  _buildFareCard(),

                  const SizedBox(height: 20),

                  _buildOfferCard(context),

                  const SizedBox(height: 16),

                  _buildNotice(),
                ],
              ),
            ),
          ),

          _buildBottomBar(context),
        ],
      ),
    );
  }

  // ====================================
  // FLIGHT
  // ====================================

  Widget _buildFlightCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.flight, color: AppColors.primary),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flight.airline,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      flight.flightNumber,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(child: _airport(flight.originCode, flight.originCity)),

              const Expanded(
                child: Column(
                  children: [
                    Icon(Icons.flight_takeoff, color: AppColors.primary),
                    Text(
                      'Non Stop',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: _airport(
                  flight.destinationCode,
                  flight.destinationCity,
                  right: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _airport(String code, String city, {bool right = false}) {
    return Column(
      crossAxisAlignment: right
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          code,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        Text(
          city,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  // ====================================
  // PASSENGERS
  // ====================================

  Widget _buildPassengerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Passengers',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 14),

          ...List.generate(passengers.length, (index) {
            final passenger = passengers[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.primaryLight,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          passenger.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${passenger.age} years â€¢ ${passenger.gender}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    passenger.seatNumber ?? '--',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ====================================
  // SEATS
  // ====================================

  Widget _buildSeatCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          const Icon(Icons.event_seat_outlined, color: AppColors.primary),

          const SizedBox(width: 12),

          const Text(
            'Selected Seats',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),

          const Spacer(),

          Text(
            selectedSeats.map((seat) => seat.seatNumber).join(', '),
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ====================================
  // FARE BREAKDOWN
  // ====================================

  Widget _buildFareCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fare Breakdown',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 20),

          _priceRow('Base Fare Ã— ${passengers.length}', baseFare),

          _priceRow('Seat Charges', seatCharges),


          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Total Amount',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),

              Text(
                PriceFormatter.inr(totalAmount),
                style: const TextStyle(
                  fontSize: 22,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String title, double amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),

          Text(
            PriceFormatter.inr(amount),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildNotice() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.verified_user_outlined,
            color: AppColors.primary,
            size: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Your payment information will be processed securely.',
              style: TextStyle(color: AppColors.primary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          const Icon(Icons.local_offer_outlined, color: AppColors.primary),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Have an offer code?',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  'Check discount before payment',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _checkOffer(context),
            child: const Text('Check'),
          ),
        ],
      ),
    );
  }

  Future<void> _checkOffer(BuildContext context) async {
    final controller = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Offer code'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(hintText: 'WELCOME10'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: const Text('Validate'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (code == null || code.trim().isEmpty || !context.mounted) return;
    final response = await OfferService().validateOffer(
      code: code,
      amount: totalAmount,
    );
    if (!context.mounted) return;

    final data = response.data;
    final message = response.success && data != null
        ? 'Discount: ${PriceFormatter.inr(_number(data['discount']))}\n'
              'Offer price: ${PriceFormatter.inr(_number(data['final_amount']))}'
        : response.message;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: response.success ? AppColors.success : AppColors.error,
      ),
    );
  }

  double _number(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  Widget _buildBottomBar(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .07),
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    PriceFormatter.inr(totalAmount),
                    style: const TextStyle(
                      fontSize: 21,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              width: 175,
              child: CustomButton(
                text: 'Proceed to Pay',
                icon: Icons.arrow_forward,
                onPressed: () {
                  _continueToPayment(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppColors.border),
    );
  }
}
