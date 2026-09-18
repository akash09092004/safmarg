import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/route_names.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/price_formatter.dart';
import '../../models/booking_model.dart';
import '../../models/passenger_model.dart';
import '../../providers/booking_provider.dart';
import '../../providers/payment_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_widget.dart';

class BookingDetailsScreen extends StatefulWidget {
  final int bookingId;

  const BookingDetailsScreen({super.key, required this.bookingId});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBooking();
    });
  }

  Future<void> _loadBooking() async {
    final loaded = await context.read<BookingProvider>().loadBookingDetails(
      widget.bookingId,
    );
    if (loaded && mounted) {
      await context.read<PaymentProvider>().loadPayment(widget.bookingId);
    }
  }

  Future<void> _editPassenger(PassengerModel passenger) async {
    final name = TextEditingController(text: passenger.fullName);
    final dob = TextEditingController(
      text: passenger.dateOfBirth == null
          ? ''
          : passenger.dateOfBirth!.toIso8601String().split('T').first,
    );
    final passport = TextEditingController(
      text: passenger.passportNumber ?? '',
    );
    final nationality = TextEditingController(
      text: passenger.nationality ?? '',
    );
    var gender = passenger.gender ?? 'other';

    final updated = await showDialog<PassengerModel>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Passenger'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: dob,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    hintText: '1998-05-10',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: gender,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('Male')),
                    DropdownMenuItem(value: 'female', child: Text('Female')),
                    DropdownMenuItem(value: 'other', child: Text('Other')),
                  ],
                  onChanged: (value) {
                    if (value != null) setDialogState(() => gender = value);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passport,
                  decoration: const InputDecoration(
                    labelText: 'Passport Number',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nationality,
                  decoration: const InputDecoration(labelText: 'Nationality'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final parsedDob = DateTime.tryParse(dob.text.trim());
                if (name.text.trim().length < 2 || parsedDob == null) return;
                Navigator.pop(
                  dialogContext,
                  PassengerModel(
                    id: passenger.id,
                    bookingId: passenger.bookingId,
                    fullName: name.text.trim(),
                    gender: gender,
                    dateOfBirth: parsedDob,
                    passportNumber: passport.text.trim(),
                    nationality: nationality.text.trim(),
                    seatNumber: passenger.seatNumber,
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    name.dispose();
    dob.dispose();
    passport.dispose();
    nationality.dispose();

    if (updated == null || !mounted) return;
    final provider = context.read<BookingProvider>();
    final success = await provider.updatePassenger(updated);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Passenger updated successfully'
              : provider.errorMessage ?? 'Passenger update nahi hua',
        ),
      ),
    );
  }

  Future<void> _cancelBooking(BookingModel booking) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancel Booking?'),
          content: Text(
            'Kya aap PNR ${booking.pnr} ki booking cancel karna chahte hain?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                'Yes, Cancel',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true || !mounted) {
      return;
    }

    final provider = context.read<BookingProvider>();

    final success = await provider.cancelBooking(widget.bookingId);

    if (!mounted) {
      return;
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking cancelled successfully')),
      );

      await _loadBooking();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Booking cancel nahi hui.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();

    final booking = provider.selectedBooking;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Booking Details'),
      body: provider.isLoading
          ? const LoadingWidget(message: 'Loading booking details...')
          : booking == null
          ? EmptyState(
              icon: Icons.confirmation_num_outlined,
              title: 'Booking Not Found',
              message: provider.errorMessage ?? 'Booking details nahi mili.',
              buttonText: 'Retry',
              onButtonPressed: _loadBooking,
            )
          : RefreshIndicator(
              onRefresh: _loadBooking,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 35),
                child: Column(
                  children: [
                    _buildStatusCard(booking),

                    const SizedBox(height: 16),

                    _buildFlightCard(booking),

                    const SizedBox(height: 16),

                    _buildBookingInfo(booking),

                    const SizedBox(height: 16),

                    _buildPassengers(booking),

                    const SizedBox(height: 16),

                    _buildFareInfo(booking),

                    const SizedBox(height: 16),

                    _buildPaymentInfo(),

                    const SizedBox(height: 25),

                    CustomButton(
                      text: 'View Ticket',
                      icon: Icons.confirmation_num_outlined,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          RouteNames.ticket,
                          arguments: booking,
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

                    if (_canCancel(booking)) ...[
                      const SizedBox(height: 12),
                      CustomButton(
                        text: 'Cancel Booking',
                        outlined: true,
                        icon: Icons.cancel_outlined,
                        onPressed: () {
                          _cancelBooking(booking);
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatusCard(BookingModel booking) {
    final confirmed = booking.status.toLowerCase() == 'confirmed';

    final cancelled = booking.status.toLowerCase() == 'cancelled';

    final color = confirmed
        ? AppColors.success
        : cancelled
        ? AppColors.error
        : Colors.orange;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: .3)),
      ),
      child: Row(
        children: [
          Icon(
            confirmed
                ? Icons.check_circle_outline
                : cancelled
                ? Icons.cancel_outlined
                : Icons.schedule_outlined,
            color: color,
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Booking Status',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                Text(
                  booking.status.toUpperCase(),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'PNR',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
              Text(
                booking.pnr,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlightCard(BookingModel booking) {
    final flight = booking.flight;

    if (flight == null) {
      return const SizedBox.shrink();
    }

    return _card(
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
                      style: const TextStyle(color: AppColors.textSecondary),
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
                child: Icon(Icons.flight_takeoff, color: AppColors.primary),
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
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildBookingInfo(BookingModel booking) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Information',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 18),
          _row('Booking ID', '#${booking.id}'),
          const SizedBox(height: 12),
          _row('PNR', booking.pnr),
          const SizedBox(height: 12),
          _row('Travel Class', booking.travelClass),
          const SizedBox(height: 12),
          _row('Status', booking.status),
        ],
      ),
    );
  }

  Widget _buildPassengers(BookingModel booking) {
    if (booking.passengers.isEmpty) {
      return const SizedBox.shrink();
    }

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Passenger Details',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),

          ...List.generate(booking.passengers.length, (index) {
            final passenger = booking.passengers[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primaryLight,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 12),
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
                            color: AppColors.textSecondary,
                            fontSize: 12,
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
                  if (passenger.id != null)
                    IconButton(
                      tooltip: 'Edit passenger',
                      onPressed: () => _editPassenger(passenger),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFareInfo(BookingModel booking) {
    return _card(
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Total Fare',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            PriceFormatter.inr(booking.totalAmount),
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo() {
    final provider = context.watch<PaymentProvider>();
    final payment = provider.payment;
    return _card(
      child: Row(
        children: [
          Icon(
            payment?.isSuccessful == true
                ? Icons.verified_outlined
                : Icons.payment_outlined,
            color: payment?.isSuccessful == true
                ? AppColors.success
                : AppColors.textSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Payment Status',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  provider.isLoading
                      ? 'Checking...'
                      : payment?.status.toUpperCase() ?? 'NOT PAID',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          if (payment != null)
            Text(
              payment.method.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
        ],
      ),
    );
  }

  bool _canCancel(BookingModel booking) {
    final status = booking.status.toLowerCase();

    return status == 'confirmed' || status == 'pending';
  }

  Widget _row(String title, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}
