import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/utils/date_formatter.dart';
import '../core/utils/price_formatter.dart';
import '../models/flight_model.dart';

class FlightCard extends StatelessWidget {
  final FlightModel flight;

  final VoidCallback? onTap;

  final VoidCallback? onBook;

  final bool showBookButton;

  const FlightCard({
    super.key,
    required this.flight,
    this.onTap,
    this.onBook,
    this.showBookButton = false,
  });

  @override
  Widget build(BuildContext context) {
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
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(alpha: .05),
              blurRadius: 18,
              offset:
                  const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 46,
                  width: 46,
                  decoration:
                      BoxDecoration(
                    color:
                        AppColors.primaryLight,
                    borderRadius:
                        BorderRadius.circular(
                      13,
                    ),
                  ),
                  child: const Icon(
                    Icons.flight,
                    color:
                        AppColors.primary,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        flight.airline,
                        style:
                            const TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        flight.flightNumber,
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
                ),

                Text(
                  PriceFormatter.inr(
                    flight.basePrice,
                  ),
                  style:
                      const TextStyle(
                    fontSize: 19,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            Row(
              children: [
                Expanded(
                  child: _timePlace(
                    time:
                        DateFormatter.time24(
                      flight.departureTime,
                    ),
                    code:
                        flight.originCode,
                    city:
                        flight.originCity,
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        flight
                            .durationText,
                        style:
                            const TextStyle(
                          fontSize: 12,
                          color:
                              AppColors
                                  .textSecondary,
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child:
                                Container(
                              height: 1,
                              color:
                                  AppColors.border,
                            ),
                          ),
                          const Padding(
                            padding:
                                EdgeInsets
                                    .symmetric(
                              horizontal: 6,
                            ),
                            child: Icon(
                              Icons.flight,
                              size: 18,
                              color:
                                  AppColors
                                      .primary,
                            ),
                          ),
                          Expanded(
                            child:
                                Container(
                              height: 1,
                              color:
                                  AppColors.border,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      const Text(
                        'Non Stop',
                        style:
                            TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: _timePlace(
                    time:
                        DateFormatter.time24(
                      flight.arrivalTime,
                    ),
                    code:
                        flight.destinationCode,
                    city:
                        flight.destinationCity,
                    end: true,
                  ),
                ),
              ],
            ),

            if (showBookButton) ...[
              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 46,
                child:
                    ElevatedButton(
                  onPressed: onBook,
                  child:
                      const Text(
                    'View Flight',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _timePlace({
    required String time,
    required String code,
    required String city,
    bool end = false,
  }) {
    return Column(
      crossAxisAlignment: end
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: const TextStyle(
            fontSize: 20,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          code,
          style: const TextStyle(
            fontWeight:
                FontWeight.w600,
          ),
        ),

        Text(
          city,
          maxLines: 1,
          overflow:
              TextOverflow.ellipsis,
          style: const TextStyle(
            color:
                AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

