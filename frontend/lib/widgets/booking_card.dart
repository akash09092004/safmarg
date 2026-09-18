import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/utils/date_formatter.dart';
import '../core/utils/price_formatter.dart';
import '../models/booking_model.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;

  final VoidCallback? onTap;

  const BookingCard({
    super.key,
    required this.booking,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final flight = booking.flight;

    return InkWell(
      borderRadius:
          BorderRadius.circular(18),
      onTap: onTap,
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
                const Icon(
                  Icons
                      .confirmation_num_outlined,
                  color:
                      AppColors.primary,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    'PNR: ${booking.pnr}',
                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),

                _statusChip(
                  booking.status,
                ),
              ],
            ),

            const SizedBox(height: 18),

            if (flight != null)
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        flight.originCode,
                        style:
                            const TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      Text(
                        flight.originCity,
                        style:
                            const TextStyle(
                          color:
                              AppColors
                                  .textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const Icon(
                    Icons
                        .flight_takeoff,
                    color:
                        AppColors.primary,
                  ),

                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.end,
                    children: [
                      Text(
                        flight.destinationCode,
                        style:
                            const TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      Text(
                        flight.destinationCity,
                        style:
                            const TextStyle(
                          color:
                              AppColors
                                  .textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            const SizedBox(height: 16),

            const Divider(),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _info(
                    'Date',
                    flight == null
                        ? '--'
                        : DateFormatter
                            .shortDate(
                            flight
                                .departureTime,
                          ),
                  ),
                ),

                Expanded(
                  child: _info(
                    'Passengers',
                    '${booking.passengers.length}',
                  ),
                ),

                Expanded(
                  child: _info(
                    'Amount',
                    PriceFormatter.inr(
                      booking.totalAmount,
                    ),
                    end: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(
    String title,
    String value, {
    bool end = false,
  }) {
    return Column(
      crossAxisAlignment: end
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color:
                AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _statusChip(
    String status,
  ) {
    Color color;

    switch (
        status.toLowerCase()) {
      case 'confirmed':
        color = AppColors.success;
        break;

      case 'cancelled':
        color = AppColors.error;
        break;

      case 'completed':
        color = AppColors.primary;
        break;

      default:
        color = AppColors.warning;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius:
            BorderRadius.circular(30),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight:
              FontWeight.w700,
        ),
      ),
    );
  }
}

