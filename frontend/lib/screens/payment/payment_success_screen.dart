import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/route_names.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/price_formatter.dart';
import '../../models/booking_model.dart';
import '../../models/flight_model.dart';
import '../../models/passenger_model.dart';
import '../../models/payment_model.dart';
import '../../models/seat_model.dart';
import '../../widgets/custom_button.dart';

class PaymentSuccessScreen
    extends StatelessWidget {
  final BookingModel booking;
  final PaymentModel? payment;

  final FlightModel flight;

  final List<PassengerModel>
      passengers;

  final List<SeatModel>
      selectedSeats;

  final double totalAmount;

  const PaymentSuccessScreen({
    super.key,
    required this.booking,
    required this.payment,
    required this.flight,
    required this.passengers,
    required this.selectedSeats,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor:
            AppColors.background,

        body: SafeArea(
          child:
              SingleChildScrollView(
            padding:
                const EdgeInsets.fromLTRB(
              20,
              35,
              20,
              30,
            ),
            child: Column(
              children: [
                _buildSuccessIcon(),

                const SizedBox(
                  height: 24,
                ),

                const Text(
                  'Booking Confirmed!',
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight:
                        FontWeight.w800,
                    color:
                        AppColors.success,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                const Text(
                  'Your flight booking has been confirmed.',
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                _buildBookingCard(),

                const SizedBox(
                  height: 18,
                ),

                _buildPaymentCard(),

                const SizedBox(
                  height: 18,
                ),

                _buildPassengerInfo(),

                const SizedBox(
                  height: 30,
                ),

                CustomButton(
                  text:
                      'View Booking',
                  icon: Icons
                      .confirmation_num_outlined,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      RouteNames
                          .bookingDetails,
                      arguments:
                          booking.id,
                    );
                  },
                ),

                const SizedBox(height: 12),
                CustomButton(
                  text: 'Track Flight',
                  icon: Icons.route_outlined,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    RouteNames.orderTracking,
                    arguments: booking.id,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                CustomButton(
                  text: 'Go to Home',
                  outlined: true,
                  icon:
                      Icons.home_outlined,
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
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color:
            AppColors.success.withValues(alpha: 
          .12,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 78,
          height: 78,
          decoration:
              const BoxDecoration(
            color:
                AppColors.success,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 50,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ====================================
  // BOOKING
  // ====================================

  Widget _buildBookingCard() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),
      decoration:
          _cardDecoration(),
      child: Column(
        children: [
          _row(
            'PNR',
            booking.pnr,
            highlight: true,
          ),

          const Divider(
            height: 25,
          ),

          _row(
            'Flight',
            '${flight.airline} ${flight.flightNumber}',
          ),

          if (flight.departureTime != null) ...[
            const SizedBox(height: 12),
            _row('Departure',
                DateFormat('dd MMM yyyy, HH:mm').format(flight.departureTime!)),
          ],

          if (flight.arrivalTime != null) ...[
            const SizedBox(height: 12),
            _row('Arrival', DateFormat('HH:mm').format(flight.arrivalTime!)),
          ],

          const SizedBox(
            height: 12,
          ),

          _row(
            'Route',
            '${flight.originCode} → ${flight.destinationCode}',
          ),

          const SizedBox(
            height: 12,
          ),

          _row(
            'Seats',
            selectedSeats
                .map(
                  (seat) =>
                      seat.seatNumber,
                )
                .join(', '),
          ),

          const SizedBox(
            height: 12,
          ),

          _row(
            'Passengers',
            '${passengers.length}',
          ),

          const SizedBox(
            height: 12,
          ),

          _row(
            'Booking Status',
            'CONFIRMED',
            success: true,
          ),
        ],
      ),
    );
  }

  // ====================================
  // PAYMENT
  // ====================================

  Widget _buildPaymentCard() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),
      decoration:
          _cardDecoration(),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Details',
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
            'Amount Paid',
            PriceFormatter.inr(
              totalAmount,
            ),
          ),

          if (payment != null) ...[
            const SizedBox(
              height: 12,
            ),

            _row(
              'Transaction ID',
              payment!.transactionId ??
                  'N/A',
            ),

            const SizedBox(
              height: 12,
            ),

            _row(
              'Payment Method',
              payment!.method
                  .toUpperCase(),
            ),
          ],

          const SizedBox(
            height: 12,
          ),

          _row(
            'Payment Status',
            'SUCCESSFUL',
            success: true,
          ),
        ],
      ),
    );
  }

  // ====================================
  // PASSENGERS
  // ====================================

  Widget _buildPassengerInfo() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),
      decoration:
          _cardDecoration(),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Traveller Details',
            style: TextStyle(
              fontSize: 17,
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 15,
          ),

          ...List.generate(
            passengers.length,
            (index) {
              final passenger =
                  passengers[index];

              return Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 12,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor:
                          AppColors
                              .primaryLight,
                      child: Text(
                        '${index + 1}',
                        style:
                            const TextStyle(
                          color:
                              AppColors.primary,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    Expanded(
                      child: Text(
                        passenger.name,
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),

                    Text(
                      passenger
                              .seatNumber ??
                          '--',
                      style:
                          const TextStyle(
                        color:
                            AppColors.primary,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _row(
    String title,
    String value, {
    bool highlight = false,
    bool success = false,
  }) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style:
                const TextStyle(
              color:
                  AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),

        const SizedBox(
          width: 10,
        ),

        Flexible(
          child: Text(
            value,
            textAlign:
                TextAlign.right,
            style: TextStyle(
              fontSize:
                  highlight ? 18 : 13,
              fontWeight:
                  highlight
                      ? FontWeight.w800
                      : FontWeight.w600,
              color: success
                  ? AppColors.success
                  : highlight
                      ? AppColors.primary
                      : AppColors
                          .textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(18),
      border: Border.all(
        color: AppColors.border,
      ),
    );
  }
}
