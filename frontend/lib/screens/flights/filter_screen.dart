import 'package:flutter/material.dart';

enum DeparturePeriod { morning, afternoon, evening }

class FlightFilter {
  final String? airline;
  final double? maxPrice;
  final DeparturePeriod? departurePeriod;

  const FlightFilter({this.airline, this.maxPrice, this.departurePeriod});
}

class FilterScreen extends StatefulWidget {
  final List<Map<String, dynamic>> flights;

  final FlightFilter? initialFilter;

  const FilterScreen({super.key, required this.flights, this.initialFilter});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? selectedAirline;
  double maxPrice = 20000;

  DeparturePeriod? selectedPeriod;

  List<String> get airlines {
    return widget.flights
        .map((flight) => flight['airline']?.toString())
        .whereType<String>()
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();
  }

  @override
  void initState() {
    super.initState();

    selectedAirline = widget.initialFilter?.airline;

    maxPrice = widget.initialFilter?.maxPrice ?? 20000;

    selectedPeriod = widget.initialFilter?.departurePeriod;
  }

  void reset() {
    setState(() {
      selectedAirline = null;
      maxPrice = 20000;
      selectedPeriod = null;
    });
  }

  void apply() {
    Navigator.pop(
      context,
      FlightFilter(
        airline: selectedAirline,
        maxPrice: maxPrice,
        departurePeriod: selectedPeriod,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter'),
        centerTitle: true,
        actions: [TextButton(onPressed: reset, child: const Text('Reset'))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Airline',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: selectedAirline,
              decoration: InputDecoration(
                hintText: 'All Airlines',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              items: airlines
                  .map(
                    (name) => DropdownMenuItem(value: name, child: Text(name)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedAirline = value;
                });
              },
            ),
            const SizedBox(height: 30),
            const Text(
              'Maximum Price',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '\u20B9${maxPrice.toStringAsFixed(0)}',
              style: const TextStyle(
                color: Color(0xff0866e5),
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            Slider(
              value: maxPrice,
              min: 1000,
              max: 20000,
              divisions: 38,
              label: '\u20B9${maxPrice.toInt()}',
              onChanged: (value) {
                setState(() {
                  maxPrice = value;
                });
              },
            ),
            const SizedBox(height: 25),
            const Text(
              'Departure Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _periodTile(
              'Morning',
              'Before 12 PM',
              DeparturePeriod.morning,
              Icons.wb_sunny_outlined,
            ),
            _periodTile(
              'Afternoon',
              '12 PM - 6 PM',
              DeparturePeriod.afternoon,
              Icons.light_mode_outlined,
            ),
            _periodTile(
              'Evening',
              'After 6 PM',
              DeparturePeriod.evening,
              Icons.nightlight_outlined,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0866e5),
                  foregroundColor: Colors.white,
                ),
                onPressed: apply,
                child: const Text('Apply Filter'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _periodTile(
    String title,
    String subtitle,
    DeparturePeriod period,
    IconData icon,
  ) {
    return RadioListTile<DeparturePeriod>(
      value: period,
      // TODO: Migrate these tiles together to RadioGroup when the
      // project raises its minimum Flutter version.
      // ignore: deprecated_member_use
      groupValue: selectedPeriod,
      // ignore: deprecated_member_use
      onChanged: (value) {
        setState(() {
          selectedPeriod = value;
        });
      },
      secondary: Icon(icon, color: const Color(0xff0866e5)),
      title: Text(title),
      subtitle: Text(subtitle),
      contentPadding: EdgeInsets.zero,
    );
  }
}
