import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/route_names.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/price_formatter.dart';
import '../../models/flight_model.dart';
import '../../models/seat_model.dart';
import '../../providers/flight_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/seat_widget.dart';

class SeatSelectionScreen extends StatefulWidget {
  final FlightModel flight;

  /// Kitne passengers ke liye seats select karni hain.
  final int passengerCount;

  const SeatSelectionScreen({
    super.key,
    required this.flight,
    this.passengerCount = 1,
  });

  @override
  State<SeatSelectionScreen> createState() =>
      _SeatSelectionScreenState();
}

class _SeatSelectionScreenState
    extends State<SeatSelectionScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _loadSeats();
      },
    );
  }

  Future<void> _loadSeats() async {
    final provider =
        context.read<FlightProvider>();

    provider.clearSeatSelection();

    await provider.loadSeats(
      widget.flight.id,
    );
  }

  // =====================================
  // SELECT / DESELECT SEAT
  // =====================================

  void _selectSeat(
    SeatModel seat,
  ) {
    if (!seat.isAvailable) {
      return;
    }

    final provider =
        context.read<FlightProvider>();

    final selectedSeats =
        provider.selectedSeats;

    // Agar seat already selected hai,
    // to deselect karne do.
    if (seat.isSelected) {
      provider.toggleSeatSelection(
        seat.id,
      );

      return;
    }

    // Passenger count se jyada
    // seats select nahi karne denge.
    if (selectedSeats.length >=
        widget.passengerCount) {
      ScaffoldMessenger.of(context)
          .hideCurrentSnackBar();

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            widget.passengerCount == 1
                ? 'Aap sirf 1 seat select kar sakte hain.'
                : 'Aap maximum ${widget.passengerCount} seats select kar sakte hain.',
          ),
        ),
      );

      return;
    }

    provider.toggleSeatSelection(
      seat.id,
    );
  }

  // =====================================
  // CONTINUE
  // =====================================

  void _continueBooking() {
    final provider =
        context.read<FlightProvider>();

    final selectedSeats =
        provider.selectedSeats;

    if (selectedSeats.isEmpty) {
      _showMessage(
        'Please select a seat.',
      );

      return;
    }

    if (selectedSeats.length !=
        widget.passengerCount) {
      _showMessage(
        'Please select ${widget.passengerCount} seat(s) for ${widget.passengerCount} passenger(s).',
      );

      return;
    }

    Navigator.pushNamed(
      context,
      RouteNames.passengerDetails,
      arguments: {
        'flight': widget.flight,
        'selectedSeats':
            List<SeatModel>.from(
          selectedSeats,
        ),
        'passengerCount':
            widget.passengerCount,
      },
    );
  }

  void _showMessage(
    String message,
  ) {
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // =====================================
  // PRICE
  // =====================================

  double _calculateTotal(
    List<SeatModel> selectedSeats,
  ) {
    double total = 0;

    for (final seat in selectedSeats) {
      total += seat.finalPrice(
        widget.flight.basePrice,
      );
    }

    return total;
  }

  double _calculateSeatCharges(
    List<SeatModel> selectedSeats,
  ) {
    double total = 0;

    for (final seat in selectedSeats) {
      total += seat.priceModifier;
    }

    return total;
  }

  // =====================================
  // GROUP SEATS BY CLASS
  // =====================================

  List<SeatModel> _getSeatsByClass(
    List<SeatModel> seats,
    String seatClass,
  ) {
    return seats
        .where(
          (seat) =>
              seat.seatClass
                  .toLowerCase() ==
              seatClass.toLowerCase(),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        context.watch<FlightProvider>();

    final selectedSeats =
        provider.selectedSeats;

    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: const CustomAppBar(
        title: 'Select Seats',
      ),

      body: provider.isSeatLoading
          ? const LoadingWidget(
              message:
                  'Loading available seats...',
            )
          : provider.errorMessage != null &&
                  provider.seats.isEmpty
              ? EmptyState(
                  icon:
                      Icons.event_seat_outlined,
                  title:
                      'Seats not available',
                  message:
                      provider.errorMessage ??
                          'Unable to load seats.',
                  buttonText: 'Retry',
                  onButtonPressed:
                      _loadSeats,
                )
              : provider.seats.isEmpty
                  ? EmptyState(
                      icon:
                          Icons.event_seat_outlined,
                      title:
                          'No Seats Found',
                      message:
                          'Is flight ke liye abhi koi seat available nahi hai.',
                      buttonText:
                          'Retry',
                      onButtonPressed:
                          _loadSeats,
                    )
                  : Column(
                      children: [
                        Expanded(
                          child:
                              RefreshIndicator(
                            onRefresh:
                                _loadSeats,
                            child:
                                SingleChildScrollView(
                              physics:
                                  const AlwaysScrollableScrollPhysics(),
                              padding:
                                  const EdgeInsets.fromLTRB(
                                16,
                                16,
                                16,
                                130,
                              ),
                              child: Center(child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 620),
                                child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  _buildFlightInfo(),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  _buildPassengerInfo(
                                    selectedSeats.length,
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  _buildLegend(),

                                  const SizedBox(
                                    height: 25,
                                  ),

                                  _buildAircraftFront(),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  _buildAllSeatSections(
                                    provider.seats,
                                  ),
                                ],
                              ))),
                            ),
                          ),
                        ),
                      ],
                    ),

      bottomNavigationBar:
          provider.isSeatLoading ||
                  provider.seats.isEmpty
              ? null
              : _buildBottomBar(
                  selectedSeats,
                ),
    );
  }

  // =====================================
  // FLIGHT INFO
  // =====================================

  Widget _buildFlightInfo() {
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
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration:
                    BoxDecoration(
                  color:
                      AppColors.primaryLight,
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
                child: const Icon(
                  Icons.flight,
                  color:
                      AppColors.primary,
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.flight.airline,
                      style:
                          const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                    Text(
                      widget
                          .flight.flightNumber,
                      style:
                          const TextStyle(
                        fontSize: 12,
                        color: AppColors
                            .textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                PriceFormatter.inr(
                  widget.flight.basePrice,
                ),
                style:
                    const TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.w700,
                  color:
                      AppColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 18,
          ),

          Row(
            children: [
              Expanded(
                child: _airport(
                  widget.flight.originCode,
                  widget.flight.originCity,
                ),
              ),

              Expanded(
                child: Column(
                  children: [
                    Text(
                      widget.flight
                          .durationText,
                      style:
                          const TextStyle(
                        fontSize: 11,
                        color: AppColors
                            .textSecondary,
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color:
                                AppColors.border,
                          ),
                        ),

                        const Padding(
                          padding:
                              EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          child: Icon(
                            Icons.flight,
                            size: 18,
                            color:
                                AppColors.primary,
                          ),
                        ),

                        Expanded(
                          child: Container(
                            height: 1,
                            color:
                                AppColors.border,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: _airport(
                  widget.flight
                      .destinationCode,
                  widget.flight
                      .destinationCity,
                  right: true,
                ),
              ),
            ],
          ),
        ],
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
            fontSize: 22,
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
            fontSize: 11,
            color:
                AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // =====================================
  // PASSENGER INFO
  // =====================================

  Widget _buildPassengerInfo(
    int selectedCount,
  ) {
    final complete =
        selectedCount ==
            widget.passengerCount;

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: complete
            ? AppColors.success
                .withValues(alpha: .08)
            : AppColors.primaryLight,
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            complete
                ? Icons
                    .check_circle_outline
                : Icons
                    .airline_seat_recline_normal,
            color: complete
                ? AppColors.success
                : AppColors.primary,
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
            child: Text(
              '$selectedCount of ${widget.passengerCount} seats selected',
              style: TextStyle(
                fontWeight:
                    FontWeight.w600,
                color: complete
                    ? AppColors.success
                    : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================
  // LEGEND
  // =====================================

  Widget _buildLegend() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(14),
      ),
      child: Wrap(
        alignment:
            WrapAlignment.spaceAround,
        runSpacing: 12,
        spacing: 15,
        children: [
          _legendItem(
            'Available',
            Colors.white,
            AppColors.primary,
          ),
          _legendItem(
            'Selected',
            AppColors.selectedSeat,
            AppColors.primary,
          ),
          _legendItem(
            'Booked',
            AppColors.bookedSeat,
            AppColors.bookedSeat,
          ),
        ],
      ),
    );
  }

  Widget _legendItem(
    String title,
    Color background,
    Color border,
  ) {
    return Row(
      mainAxisSize:
          MainAxisSize.min,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: background,
            borderRadius:
                BorderRadius.circular(5),
            border: Border.all(
              color: border,
            ),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color:
                AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // =====================================
  // AIRCRAFT FRONT
  // =====================================

  Widget _buildAircraftFront() {
    return Column(
      children: [
        const Icon(
          Icons.flight,
          size: 40,
          color: AppColors.primary,
        ),
        const SizedBox(height: 6),
        const Text(
          'FRONT',
          style: TextStyle(
            color:
                AppColors.textSecondary,
            fontSize: 11,
            fontWeight:
                FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 1,
          color: AppColors.border,
        ),
      ],
    );
  }

  // =====================================
  // ALL SEAT SECTIONS
  // =====================================

  Widget _buildAllSeatSections(
    List<SeatModel> seats,
  ) {
    final business =
        _getSeatsByClass(
      seats,
      'business',
    );

    final premiumEconomy =
        _getSeatsByClass(
      seats,
      'premium_economy',
    );

    final economy =
        _getSeatsByClass(
      seats,
      'economy',
    );

    return Column(
      children: [
        if (business.isNotEmpty)
          _buildSeatSection(
            title: 'Business Class',
            subtitle:
                'Premium comfort',
            seats: business,
          ),

        if (premiumEconomy.isNotEmpty)
          _buildSeatSection(
            title:
                'Premium Economy',
            subtitle:
                'Extra legroom',
            seats:
                premiumEconomy,
          ),

        if (economy.isNotEmpty)
          _buildSeatSection(
            title: 'Economy Class',
            subtitle:
                'Standard seating',
            seats: economy,
          ),
      ],
    );
  }

  // =====================================
  // CLASS SECTION
  // =====================================

  Widget _buildSeatSection({
    required String title,
    required String subtitle,
    required List<SeatModel> seats,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 22,
      ),
      padding:
          const EdgeInsets.all(16),
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
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          const TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      subtitle,
                      style:
                          const TextStyle(
                        fontSize: 11,
                        color: AppColors
                            .textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                '${seats.where((seat) => seat.isAvailable).length} available',
                style:
                    const TextStyle(
                  color:
                      AppColors.success,
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 22,
          ),

          _buildSeatGrid(
            seats,
          ),
        ],
      ),
    );
  }

  // =====================================
  // SEAT GRID
  // =====================================

  Widget _buildSeatGrid(
    List<SeatModel> seats,
  ) {
    final rows =
        <String, List<SeatModel>>{};

    for (final seat in seats) {
      final row =
          _seatRow(
        seat.seatNumber,
      );

      rows.putIfAbsent(
        row,
        () => [],
      );

      rows[row]!.add(seat);
    }

    for (final rowSeats
        in rows.values) {
      rowSeats.sort(
        (a, b) =>
            _seatColumn(
          a.seatNumber,
        ).compareTo(
          _seatColumn(
            b.seatNumber,
          ),
        ),
      );
    }

    return Column(
      children: [
        // Column labels
        const Row(
          children: [
            SizedBox(width: 28),
            Expanded(
              child: Center(
                child: Text(
                  'A',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'B',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'C',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 25),
            Expanded(
              child: Center(
                child: Text(
                  'D',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'E',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'F',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 10,
        ),

        ...rows.entries.map(
          (entry) {
            return _buildSeatRow(
              entry.key,
              entry.value,
            );
          },
        ),
      ],
    );
  }

  Widget _buildSeatRow(
    String row,
    List<SeatModel> seats,
  ) {
    final seatMap =
        <String, SeatModel>{};

    for (final seat in seats) {
      seatMap[
          _seatColumn(
        seat.seatNumber,
      )] = seat;
    }

    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              row,
              style:
                  const TextStyle(
                fontSize: 11,
                color: AppColors
                    .textSecondary,
              ),
            ),
          ),

          _seatCell(
            seatMap['A'],
          ),

          _seatCell(
            seatMap['B'],
          ),

          _seatCell(
            seatMap['C'],
          ),

          const SizedBox(
            width: 25,
            child: Center(
              child: Text(
                '',
              ),
            ),
          ),

          _seatCell(
            seatMap['D'],
          ),

          _seatCell(
            seatMap['E'],
          ),

          _seatCell(
            seatMap['F'],
          ),
        ],
      ),
    );
  }

  Widget _seatCell(
    SeatModel? seat,
  ) {
    return Expanded(
      child: Center(
        child: seat == null
            ? const SizedBox(
                width: 40,
                height: 40,
              )
            : SeatWidget(
                seat: seat,
                size: 40,
                onTap: () {
                  _selectSeat(
                    seat,
                  );
                },
              ),
      ),
    );
  }

  // =====================================
  // SEAT NUMBER HELPERS
  // =====================================

  String _seatRow(
    String seatNumber,
  ) {
    final match =
        RegExp(r'\d+')
            .firstMatch(
      seatNumber,
    );

    return match?.group(0) ?? '';
  }

  String _seatColumn(
    String seatNumber,
  ) {
    final match =
        RegExp(r'[A-Za-z]+')
            .firstMatch(
      seatNumber,
    );

    return match
            ?.group(0)
            ?.toUpperCase() ??
        '';
  }

  // =====================================
  // BOTTOM PRICE BAR
  // =====================================

  Widget _buildBottomBar(
    List<SeatModel> selectedSeats,
  ) {
    final seatCharges =
        _calculateSeatCharges(
      selectedSeats,
    );

    final total =
        _calculateTotal(
      selectedSeats,
    );

    return SafeArea(
      child: Container(
        padding:
            const EdgeInsets.fromLTRB(
          18,
          14,
          18,
          14,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(alpha: 
                .08,
              ),
              blurRadius: 18,
              offset:
                  const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            if (selectedSeats
                .isNotEmpty) ...[
              Row(
                children: [
                  const Text(
                    'Selected:',
                    style:
                        TextStyle(
                      color: AppColors
                          .textSecondary,
                    ),
                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  Expanded(
                    child: Text(
                      selectedSeats
                          .map(
                            (seat) =>
                                seat.seatNumber,
                          )
                          .join(', '),
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ),

                  if (seatCharges > 0)
                    Text(
                      '+ ${PriceFormatter.inr(seatCharges)}',
                      style:
                          const TextStyle(
                        color:
                            AppColors.primary,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                ],
              ),

              const SizedBox(
                height: 12,
              ),
            ],

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Fare',
                        style:
                            TextStyle(
                          fontSize: 12,
                          color: AppColors
                              .textSecondary,
                        ),
                      ),

                      const SizedBox(
                        height: 2,
                      ),

                      Text(
                        selectedSeats
                                .isEmpty
                            ? PriceFormatter
                                .inr(
                                widget
                                    .flight
                                    .basePrice,
                              )
                            : PriceFormatter
                                .inr(
                                total,
                              ),
                        style:
                            const TextStyle(
                          fontSize: 21,
                          fontWeight:
                              FontWeight.w800,
                          color:
                              AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  width: 170,
                  child: CustomButton(
                    text: 'Continue',
                    onPressed:
                        selectedSeats.length ==
                                widget
                                    .passengerCount
                            ? _continueBooking
                            : null,
                    icon: Icons
                        .arrow_forward,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
