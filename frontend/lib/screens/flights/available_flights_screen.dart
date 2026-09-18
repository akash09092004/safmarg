import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../core/constants/api_constants.dart';
import '../../models/flight_model.dart';
import 'flight_details_screen.dart';
import 'filter_screen.dart';
import 'sort_screen.dart';

class AvailableFlightsScreen extends StatefulWidget {
  final String origin;
  final String destination;
  final String date;
  final int passengers;
  final String travelClass;
  final List<Map<String, dynamic>>? initialFlights;

  const AvailableFlightsScreen({
    super.key,
    required this.origin,
    required this.destination,
    required this.date,
    this.passengers = 1,
    this.travelClass = 'economy',
    this.initialFlights,
  });

  @override
  State<AvailableFlightsScreen> createState() => _AvailableFlightsScreenState();
}

class _AvailableFlightsScreenState extends State<AvailableFlightsScreen> {
  bool loading = true;
  String? errorMessage;
  bool showingNearbyDates = false;

  List<Map<String, dynamic>> originalFlights = [];

  List<Map<String, dynamic>> displayedFlights = [];

  FlightFilter? selectedFilter;
  FlightSortType selectedSort = FlightSortType.none;

  @override
  void initState() {
    super.initState();
    if (widget.initialFlights != null) {
      originalFlights = List<Map<String, dynamic>>.from(widget.initialFlights!);
      applyFilterAndSort();
      loading = false;
    } else {
      fetchFlights();
    }
  }

  Future<void> fetchFlights() async {
    setState(() {
      loading = true;
      errorMessage = null;
      showingNearbyDates = false;
    });

    try {
      final originCode = _airportCode(widget.origin);
      final destinationCode = _airportCode(widget.destination);
      if (!RegExp(r'^[A-Z]{3}$').hasMatch(originCode) ||
          !RegExp(r'^[A-Z]{3}$').hasMatch(destinationCode)) {
        throw Exception(
          'Please use a valid 3-letter airport code, jaise DEL, BOM ya PNQ.',
        );
      }

      final apiBaseUrl = kIsWeb
          ? 'http://localhost:5000/api/v1'
          : ApiConstants.baseUrl;
      final uri = Uri.parse('$apiBaseUrl/flights').replace(
        queryParameters: {
          'origin': originCode,
          'destination': destinationCode,
          'date': widget.date,
        },
      );

      debugPrint('Flight API => $uri');

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint('Status => ${response.statusCode}');

      debugPrint('Response => ${response.body}');

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Server error: ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map) {
        throw Exception('Invalid server response');
      }

      final success = decoded['success'] == true;

      if (!success) {
        throw Exception(decoded['message'] ?? 'Flights load nahi hui');
      }

      final dynamic data = decoded['data'];

      List<dynamic> list = data is List ? data : [];

      if (list.isEmpty) {
        final nearbyUri = Uri.parse('$apiBaseUrl/flights').replace(
          queryParameters: {
            'origin': originCode,
            'destination': destinationCode,
          },
        );
        final nearbyResponse = await http.get(
          nearbyUri,
          headers: {'Content-Type': 'application/json'},
        );
        if (nearbyResponse.statusCode >= 200 &&
            nearbyResponse.statusCode < 300) {
          final nearbyDecoded = jsonDecode(nearbyResponse.body);
          final nearbyData = nearbyDecoded is Map
              ? nearbyDecoded['data']
              : null;
          if (nearbyData is List && nearbyData.isNotEmpty) {
            list = nearbyData;
            showingNearbyDates = true;
          }
        }
      }

      if (!mounted) return;
      originalFlights = list
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      applyFilterAndSort();

      setState(() {
        loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        loading = false;
        errorMessage = error.toString();
      });
    }
  }

  String _airportCode(String value) {
    final input = value.trim().toUpperCase();
    if (RegExp(r'^[A-Z]{3}$').hasMatch(input)) return input;

    const codes = <String, String>{
      'DELHI': 'DEL',
      'NEW DELHI': 'DEL',
      'MUMBAI': 'BOM',
      'BOMBAY': 'BOM',
      'BENGALURU': 'BLR',
      'BANGALORE': 'BLR',
      'PUNE': 'PNQ',
      'CHENNAI': 'MAA',
      'KOLKATA': 'CCU',
      'HYDERABAD': 'HYD',
      'GOA': 'GOI',
      'AHMEDABAD': 'AMD',
    };

    final parenthesized = RegExp(r'\(([A-Z]{3})\)').firstMatch(input);
    return parenthesized?.group(1) ?? codes[input] ?? input;
  }

  void applyFilterAndSort() {
    List<Map<String, dynamic>> result = List.from(originalFlights);

    final filter = selectedFilter;

    if (filter != null) {
      if (filter.airline != null && filter.airline!.isNotEmpty) {
        result = result.where((flight) {
          return flight['airline']?.toString().toLowerCase() ==
              filter.airline!.toLowerCase();
        }).toList();
      }

      if (filter.maxPrice != null) {
        result = result.where((flight) {
          final price = _toDouble(flight['base_price']);

          return price <= filter.maxPrice!;
        }).toList();
      }

      if (filter.departurePeriod != null) {
        result = result.where((flight) {
          final date = _parseDate(flight['departure_time']);

          if (date == null) {
            return false;
          }

          switch (filter.departurePeriod!) {
            case DeparturePeriod.morning:
              return date.hour < 12;

            case DeparturePeriod.afternoon:
              return date.hour >= 12 && date.hour < 18;

            case DeparturePeriod.evening:
              return date.hour >= 18;
          }
        }).toList();
      }
    }

    switch (selectedSort) {
      case FlightSortType.priceLowToHigh:
        result.sort(
          (a, b) =>
              _toDouble(a['base_price']).compareTo(_toDouble(b['base_price'])),
        );
        break;

      case FlightSortType.priceHighToLow:
        result.sort(
          (a, b) =>
              _toDouble(b['base_price']).compareTo(_toDouble(a['base_price'])),
        );
        break;

      case FlightSortType.duration:
        result.sort(
          (a, b) =>
              _toInt(a['duration_minutes'])
                  .compareTo(_toInt(b['duration_minutes'])),
        );
        break;

      case FlightSortType.departureEarly:
        result.sort((a, b) {
          final aDate = _parseDate(a['departure_time']) ?? DateTime(2100);

          final bDate = _parseDate(b['departure_time']) ?? DateTime(2100);

          return aDate.compareTo(bDate);
        });
        break;

      case FlightSortType.none:
        break;
    }

    displayedFlights = result;
  }

  Future<void> openFilter() async {
    final result = await Navigator.push<FlightFilter>(
      context,
      MaterialPageRoute(
        builder: (_) => FilterScreen(
          flights: originalFlights,
          initialFilter: selectedFilter,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        selectedFilter = result;
        applyFilterAndSort();
      });
    }
  }

  Future<void> openSort() async {
    final result = await Navigator.push<FlightSortType>(
      context,
      MaterialPageRoute(builder: (_) => SortScreen(selectedSort: selectedSort)),
    );

    if (result != null) {
      setState(() {
        selectedSort = result;
        applyFilterAndSort();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f9fc),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Column(
          children: [
            const Text(
              'Available Flights',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            Text(
              '${widget.origin} → ${widget.destination} • ${widget.date}',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: openFilter,
                    icon: const Icon(Icons.filter_alt_outlined),
                    label: const Text('Filter'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: openSort,
                    icon: const Icon(Icons.sort),
                    label: const Text('Sort'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _body()),
        ],
      ),
    );
  }

  Widget _body() {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 60,
                color: Colors.red,
              ),
              const SizedBox(height: 14),
              Text(errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: fetchFlights,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (displayedFlights.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.flight_takeoff_outlined,
                size: 70,
                color: Color(0xff0866e5),
              ),
              const SizedBox(height: 15),
              const Text(
                'No Flights Found',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.origin} se ${widget.destination} ke liye ${widget.date} ko koi flight nahi mili.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: fetchFlights,
                child: const Text('Refresh'),
              ),
            ],
          ),
        ),
      );
    }

    return Center(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 720),
      child: RefreshIndicator(
      onRefresh: fetchFlights,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
        itemCount: displayedFlights.length + (showingNearbyDates ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          if (showingNearbyDates && index == 0) {
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xfffff7e6),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xffffd58a)),
              ),
              child: Text(
                '${widget.date} ko flight nahi mili. Neeche isi route ki nearest available flights hain.',
                style: const TextStyle(
                  color: Color(0xff8a5700),
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }
          final flightIndex = showingNearbyDates ? index - 1 : index;
          return _flightCard(displayedFlights[flightIndex]);
        },
      ),
    )));
  }

  Widget _flightCard(Map<String, dynamic> flight) {
    final departure = _parseDate(flight['departure_time']);

    final arrival = _parseDate(flight['arrival_time']);

    final price = _toDouble(flight['base_price']);

    final duration = _toInt(flight['duration_minutes']);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FlightDetailsScreen(
              flightId: _toInt(flight['id']),
              passengers: widget.passengers,
              travelClass: widget.travelClass,
              initialFlight: FlightModel.fromJson(flight),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 16,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xffeaf3ff),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.flight, color: Color(0xff0866e5)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        flight['airline']?.toString() ?? 'Airline',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${flight['flight_number'] ?? ''}  •  ${_dayPeriod(departure)}${flight['flight_number']?.toString().startsWith('SM') == true ? '  •  Demo' : ''}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '₹${NumberFormat('#,##0').format(price)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _timeColumn(
                    time: departure == null
                        ? '--:--'
                        : DateFormat('HH:mm').format(departure),
                    code: flight['origin_code']?.toString() ?? '',
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        _formatDuration(duration),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Icon(
                              Icons.flight,
                              size: 17,
                              color: Color(0xff0866e5),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text('Non Stop', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
                Expanded(
                  child: _timeColumn(
                    time: arrival == null
                        ? '--:--'
                        : DateFormat('HH:mm').format(arrival),
                    code: flight['destination_code']?.toString() ?? '',
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

  Widget _timeColumn({
    required String time,
    required String code,
    bool end = false,
  }) {
    return Column(
      crossAxisAlignment: end
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(code, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().replaceFirst(' ', 'T');

    return DateTime.tryParse(text);
  }

  String _formatDuration(int minutes) {
    if (minutes <= 0) {
      return '--';
    }

    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    return '${hours}h ${mins}m';
  }

  static String _dayPeriod(DateTime? departure) {
    if (departure == null) return '';
    if (departure.hour < 12) return 'Morning';
    if (departure.hour < 17) return 'Afternoon';
    return 'Evening';
  }
}
