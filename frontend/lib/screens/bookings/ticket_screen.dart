import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/price_formatter.dart';
import '../../models/booking_model.dart';
import '../../widgets/custom_app_bar.dart';

class TicketScreen
    extends StatelessWidget {
  final BookingModel booking;

  const TicketScreen({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final flight = booking.flight;

    return Scaffold(
      backgroundColor:
          AppColors.background,
      appBar: const CustomAppBar(
        title: 'E-Ticket',
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.fromLTRB(
          18,
          20,
          18,
          35,
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                  24,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withValues(alpha: .06),
                    blurRadius: 20,
                    offset:
                        const Offset(0, 7),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // ======================
                  // HEADER
                  // ======================

                  Container(
                    width:
                        double.infinity,
                    padding:
                        const EdgeInsets.all(
                      20,
                    ),
                    decoration:
                        const BoxDecoration(
                      color:
                          AppColors.primary,
                      borderRadius:
                          BorderRadius.vertical(
                        top:
                            Radius.circular(
                          24,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.flight,
                          color:
                              Colors.white,
                          size: 32,
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
                                flight?.airline ??
                                    'SafMarg Air',
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight
                                          .w700,
                                ),
                              ),
                              Text(
                                flight?.flightNumber ??
                                    '',
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          'E-TICKET',
                          style: TextStyle(
                            color:
                                Colors.white,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ======================
                  // ROUTE
                  // ======================

                  Padding(
                    padding:
                        const EdgeInsets.all(
                      22,
                    ),
                    child: Column(
                      children: [
                        if (flight !=
                            null)
                          Row(
                            children: [
                              Expanded(
                                child:
                                    _airport(
                                  flight
                                      .originCode,
                                  flight
                                      .originCity,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons
                                          .flight_takeoff,
                                      color:
                                          AppColors
                                              .primary,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      flight
                                          .durationText,
                                      style:
                                          const TextStyle(
                                        color: AppColors
                                            .textSecondary,
                                        fontSize:
                                            10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child:
                                    _airport(
                                  flight
                                      .destinationCode,
                                  flight
                                      .destinationCity,
                                  right:
                                      true,
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(
                          height: 25,
                        ),

                        _dashedDivider(),

                        const SizedBox(
                          height: 20,
                        ),

                        Row(
                          children: [
                            Expanded(
                              child:
                                  _ticketInfo(
                                'PNR',
                                booking.pnr,
                              ),
                            ),
                            Expanded(
                              child:
                                  _ticketInfo(
                                'CLASS',
                                booking
                                    .travelClass
                                    .toUpperCase(),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        Row(
                          children: [
                            Expanded(
                              child:
                                  _ticketInfo(
                                'STATUS',
                                booking.status
                                    .toUpperCase(),
                              ),
                            ),
                            Expanded(
                              child:
                                  _ticketInfo(
                                'FARE',
                                PriceFormatter
                                    .inr(
                                  booking
                                      .totalAmount,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 25,
                        ),

                        _dashedDivider(),

                        const SizedBox(
                          height: 20,
                        ),

                        Align(
                          alignment:
                              Alignment
                                  .centerLeft,
                          child: Text(
                            'PASSENGERS (${booking.passengers.length})',
                            style:
                                const TextStyle(
                              color: AppColors
                                  .textSecondary,
                              fontSize: 11,
                              fontWeight:
                                  FontWeight
                                      .w700,
                              letterSpacing:
                                  .8,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 14,
                        ),

                        ...List.generate(
                          booking.passengers
                              .length,
                          (index) {
                            final passenger =
                                booking
                                        .passengers[
                                    index];

                            return Container(
                              margin:
                                  const EdgeInsets.only(
                                bottom: 10,
                              ),
                              padding:
                                  const EdgeInsets.all(
                                12,
                              ),
                              decoration:
                                  BoxDecoration(
                                color: AppColors
                                    .background,
                                borderRadius:
                                    BorderRadius.circular(
                                  10,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons
                                        .person_outline,
                                    color:
                                        AppColors.primary,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        Text(
                                          passenger
                                              .name,
                                          style:
                                              const TextStyle(
                                            fontWeight:
                                                FontWeight
                                                    .w600,
                                          ),
                                        ),
                                        Text(
                                          '${passenger.age} yrs â€¢ ${passenger.gender}',
                                          style:
                                              const TextStyle(
                                            color: AppColors
                                                .textSecondary,
                                            fontSize:
                                                11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        'SEAT',
                                        style:
                                            TextStyle(
                                          color: AppColors
                                              .textSecondary,
                                          fontSize:
                                              9,
                                        ),
                                      ),
                                      Text(
                                        passenger
                                                .seatNumber ??
                                            '--',
                                        style:
                                            const TextStyle(
                                          color:
                                              AppColors
                                                  .primary,
                                          fontWeight:
                                              FontWeight
                                                  .w800,
                                          fontSize:
                                              16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        // QR-style placeholder.
                        // Real QR ke liye qr_flutter
                        // package baad me use kar sakte ho.
                        Container(
                          width: 115,
                          height: 115,
                          decoration:
                              BoxDecoration(
                            border:
                                Border.all(
                              color:
                                  AppColors.border,
                            ),
                            borderRadius:
                                BorderRadius.circular(
                              10,
                            ),
                          ),
                          child: const Icon(
                            Icons.qr_code_2,
                            size: 95,
                            color:
                                AppColors.textPrimary,
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Text(
                          booking.pnr,
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            Container(
              padding:
                  const EdgeInsets.all(
                14,
              ),
              decoration:
                  BoxDecoration(
                color:
                    AppColors.primaryLight,
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
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
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Please carry a valid government-issued photo ID and arrive at the airport before departure.',
                      style: TextStyle(
                        color:
                            AppColors.primary,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _airport(
    String code,
    String city, {
    bool right = false,
  }) {
    return Column(
      crossAxisAlignment: right
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          code,
          style: const TextStyle(
            fontSize: 27,
            fontWeight:
                FontWeight.w800,
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

  Widget _ticketInfo(
    String label,
    String value,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color:
                AppColors.textSecondary,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight:
                FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _dashedDivider() {
    return Row(
      children: List.generate(
        30,
        (index) => Expanded(
          child: Container(
            height: 1,
            margin:
                const EdgeInsets.symmetric(
              horizontal: 2,
            ),
            color: index.isEven
                ? AppColors.border
                : Colors.transparent,
          ),
        ),
      ),
    );
  }
}

