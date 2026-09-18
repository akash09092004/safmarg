import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../app/route_names.dart';
import '../../core/constants/api_constants.dart';
import '../../models/flight_model.dart';

class FlightDetailsScreen extends StatefulWidget {
  final int flightId;
  final int passengers;
  final String travelClass;
  final FlightModel? initialFlight;
  final http.Client? client;

  const FlightDetailsScreen({
    super.key,
    required this.flightId,
    this.passengers = 1,
    this.travelClass = 'economy',
    this.initialFlight,
    this.client,
  });

  @override
  State<FlightDetailsScreen> createState() => _FlightDetailsScreenState();
}

class _FlightDetailsScreenState extends State<FlightDetailsScreen> {
  FlightModel? flight;
  String? errorMessage;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    flight = widget.initialFlight;
    if (flight == null) loadFlight();
  }

  Future<void> loadFlight() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });
    try {
      final response = await (widget.client?.get ?? http.get)(
        Uri.parse(ApiConstants.flightDetails(widget.flightId)),
      ).timeout(const Duration(seconds: 20));
      final decoded = jsonDecode(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300 ||
          decoded is! Map || decoded['success'] != true || decoded['data'] is! Map) {
        throw Exception(decoded is Map ? decoded['message'] ?? 'Flight details load nahi hui' : 'Invalid server response');
      }
      final result = FlightModel.fromJson(
        Map<String, dynamic>.from(decoded['data'] as Map),
      );
      if (!mounted) return;
      setState(() {
        flight = result;
        loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        loading = false;
        errorMessage = error.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = flight;
    return Scaffold(
      backgroundColor: const Color(0xfff8faff),
      appBar: AppBar(title: const Text('Flight Details'), centerTitle: true),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : current == null
              ? _errorState()
              : _details(current),
      bottomNavigationBar: current == null ? null : _bottomBar(current),
    );
  }

  Widget _errorState() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 44, color: Color(0xffd94646)),
            const SizedBox(height: 12),
            Text(errorMessage ?? 'Flight details available nahi hain.'),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: loadFlight, child: const Text('Retry')),
          ],
        ),
      );

  Widget _details(FlightModel f) {
    return Center(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width.clamp(0.0, 680.0),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            _card(
              child: Column(
                children: [
                  Row(children: [
                    const Icon(Icons.flight, color: Color(0xff0866e5), size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text('${f.airline}  ${f.flightNumber}',
                          maxLines: 2,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  Row(children: [
                    Expanded(child: _time(f.departureTime, f.originCode)),
                    Column(children: [
                      Text(_duration(f.durationMinutes),
                          style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 4),
                      const Icon(Icons.flight_takeoff, color: Color(0xff0866e5), size: 20),
                      const Text('Non Stop', style: TextStyle(fontSize: 11)),
                    ]),
                    Expanded(child: _time(f.arrivalTime, f.destinationCode, end: true)),
                  ]),
                  const SizedBox(height: 10),
                  Text('${f.originCity}  →  ${f.destinationCity}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('About this flight',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  _info(Icons.luggage_outlined, 'Baggage', '15 kg Check-in, 7 kg Cabin'),
                  _info(Icons.currency_exchange, 'Refund', 'As per booking policy'),
                  _info(Icons.restaurant_outlined, 'Meal', 'Check with airline'),
                  _info(Icons.airline_seat_recline_normal, 'Seats', '${f.totalSeats} total seats'),
                  if (f.flightNumber.startsWith('SM'))
                    _info(Icons.info_outline, 'Demo flight', 'Schedule and fare are sample data'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 16,
            offset: const Offset(0, 5),
          )],
        ),
        child: child,
      );

  Widget _time(DateTime? value, String code, {bool end = false}) => Column(
        crossAxisAlignment: end ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(value == null ? '--:--' : DateFormat('HH:mm').format(value),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          Text(code, style: const TextStyle(color: Colors.grey)),
        ],
      );

  Widget _info(IconData icon, String title, String subtitle) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          Icon(icon, color: const Color(0xff0866e5), size: 22),
          const SizedBox(width: 14),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          )),
        ]),
      );

  Widget _bottomBar(FlightModel f) {
    final price = f.basePrice * widget.passengers;
    return SafeArea(
      top: false,
      child: Center(
        heightFactor: 1,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 680),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(children: [
            Expanded(child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('₹${NumberFormat('#,##0').format(price)}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                Text('Price for ${widget.passengers} passenger${widget.passengers == 1 ? '' : 's'}',
                    style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            )),
            const SizedBox(width: 10),
            SizedBox(
              width: 138,
              height: 48,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                onPressed: () => Navigator.pushNamed(
                  context,
                  RouteNames.seatSelection,
                  arguments: {'flight': f, 'passengerCount': widget.passengers},
                ),
                child: const Text('Select Seats'),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  static String _duration(int minutes) =>
      minutes <= 0 ? '--' : '${minutes ~/ 60}h ${minutes % 60}m';
}
