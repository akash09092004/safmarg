import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/booking_model.dart';
import '../../services/booking_service.dart';

class OrderTrackingScreen extends StatefulWidget {
  final int bookingId;
  final BookingModel? initialBooking;

  const OrderTrackingScreen({
    super.key,
    required this.bookingId,
    this.initialBooking,
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  static const _blue = Color(0xff0866e5);
  static const _green = Color(0xff21966b);

  BookingModel? booking;
  String? error;
  bool loading = false;
  bool _requestInProgress = false;

  @override
  void initState() {
    super.initState();
    booking = widget.initialBooking;
    loading = booking == null;
    if (booking == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
    }
  }

  Future<void> _refresh() async {
    if (_requestInProgress) return;
    _requestInProgress = true;
    setState(() {
      loading = true;
      error = null;
    });
    final response = await BookingService.instance.getBookingDetails(widget.bookingId);
    _requestInProgress = false;
    if (!mounted) return;
    setState(() {
      loading = false;
      if (response.success && response.data != null) {
        booking = response.data;
      } else {
        error = response.message;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final current = booking;
    return Scaffold(
      backgroundColor: const Color(0xfff8faff),
      appBar: AppBar(
        title: Column(children: [
          const Text('Order Tracking', style: TextStyle(fontSize: 18)),
          if (current != null)
            Text('PNR: ${current.pnr}',
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ]),
        centerTitle: true,
      ),
      body: current == null && loading
          ? const Center(child: CircularProgressIndicator())
          : current == null
              ? _failure()
              : _content(current),
      bottomNavigationBar: current == null ? null : SafeArea(
        top: false,
        child: Center(
          heightFactor: 1,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 560),
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            color: Colors.white,
            child: FilledButton.icon(
              onPressed: loading ? null : _refresh,
              icon: loading
                  ? const SizedBox(width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.refresh),
              label: const Text('Refresh Status'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _failure() => Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.cloud_off_outlined, size: 48, color: Colors.grey),
      const SizedBox(height: 12),
      Text(error ?? 'Tracking details load nahi hui.'),
      const SizedBox(height: 12),
      OutlinedButton(onPressed: _refresh, child: const Text('Retry')),
    ]),
  );

  Widget _content(BookingModel current) {
    final flight = current.flight;
    final departure = flight?.departureTime;
    final arrival = flight?.arrivalTime;
    final cancelled = current.isCancelled || flight?.status == 'cancelled';
    final completed = flight?.status == 'completed';
    final delayed = flight?.status == 'delayed';
    final now = DateTime.now();
    final milestones = <_Milestone>[
      _Milestone(
        current.isConfirmed ? 'Booking Confirmed' :
            current.isCancelled ? 'Booking Cancelled' : 'Booking Pending',
        current.createdAt,
        Icons.check,
      ),
      _Milestone('Check-in window',
          departure?.subtract(const Duration(hours: 2)), Icons.confirmation_num_outlined),
      _Milestone('Boarding window',
          departure?.subtract(const Duration(minutes: 45)), Icons.flight_takeoff),
      _Milestone('Scheduled departure', departure, Icons.flight_takeoff),
      _Milestone('Scheduled arrival', arrival, Icons.flight_land),
    ];
    var currentIndex = 0;
    if (!cancelled && departure != null) {
      for (var index = 1; index < milestones.length; index++) {
        final time = milestones[index].time;
        if (time != null && !now.isBefore(time)) currentIndex = index;
      }
    }

    return Center(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width.clamp(0.0, 560.0),
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            children: [
              if (flight != null) Container(
                padding: const EdgeInsets.all(16),
                decoration: _decoration(),
                child: Row(children: [
                  const Icon(Icons.flight, color: _blue, size: 28),
                  const SizedBox(width: 12),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${flight.airline} • ${flight.flightNumber}',
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text('${flight.originCode}  →  ${flight.destinationCode}',
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  )),
                ]),
              ),
              const SizedBox(height: 16),
              if (cancelled || delayed) _notice(
                cancelled ? 'This flight or booking has been cancelled.' :
                    'Flight is marked delayed. Updated departure time is not available.',
                cancelled ? const Color(0xffb42318) : const Color(0xff9a6700),
              ),
              if (error != null) _notice('Refresh failed: $error', const Color(0xffb42318)),
              Container(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
                decoration: _decoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(completed ? 'Flight completed' :
                        cancelled ? 'Tracking stopped' :
                        'Schedule progress: ${milestones[currentIndex].title}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    const Text('Milestones below are scheduled estimates. Check-in, boarding and aircraft position are not live verified.',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 22),
                    for (var index = 0; index < milestones.length; index++)
                      _timelineRow(
                        milestones[index],
                        index: index,
                        last: index == milestones.length - 1,
                        confirmed: index == 0 && current.isConfirmed ||
                            completed && index > 0,
                        active: !cancelled && !completed && index == currentIndex,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text('Live GPS location is not available for these demo flights.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timelineRow(_Milestone step, {
    required int index,
    required bool last,
    required bool confirmed,
    required bool active,
  }) {
    final color = confirmed ? _green : active ? _blue : const Color(0xffcbd5e1);
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 28, child: Column(children: [
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: confirmed || active ? color : Colors.white,
            border: Border.all(color: color, width: 1.5),
          ),
          child: Icon(confirmed ? Icons.check : step.icon,
              size: 15, color: confirmed || active ? Colors.white : color),
        ),
        if (!last) Container(width: 2, height: 56, color: color.withValues(alpha: .55)),
      ])),
      const SizedBox(width: 12),
      Expanded(child: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(step.title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(step.time == null ? 'Time unavailable' :
              DateFormat('dd MMM yyyy, hh:mm a').format(step.time!),
              style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ]),
      )),
    ]);
  }

  Widget _notice(String message, Color color) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(12)),
    child: Text(message, style: TextStyle(color: color)),
  );

  BoxDecoration _decoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: const Color(0xffe5eaf2)),
  );
}

class _Milestone {
  final String title;
  final DateTime? time;
  final IconData icon;

  const _Milestone(this.title, this.time, this.icon);
}
