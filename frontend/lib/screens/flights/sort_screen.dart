import 'package:flutter/material.dart';

enum FlightSortType {
  none,
  priceLowToHigh,
  priceHighToLow,
  duration,
  departureEarly,
}

class SortScreen extends StatefulWidget {
  final FlightSortType selectedSort;

  const SortScreen({super.key, this.selectedSort = FlightSortType.none});

  @override
  State<SortScreen> createState() => _SortScreenState();
}

class _SortScreenState extends State<SortScreen> {
  late FlightSortType selected;

  @override
  void initState() {
    super.initState();

    selected = widget.selectedSort;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sort Flights'), centerTitle: true),
      body: Column(
        children: [
          _tile(
            'Recommended',
            'Default result',
            FlightSortType.none,
            Icons.star_outline,
          ),
          _tile(
            'Price - Low to High',
            'Cheapest flights first',
            FlightSortType.priceLowToHigh,
            Icons.south_east_outlined,
          ),
          _tile(
            'Price - High to Low',
            'Costliest flights first',
            FlightSortType.priceHighToLow,
            Icons.north_east_outlined,
          ),
          _tile(
            'Shortest Duration',
            'Fastest flight first',
            FlightSortType.duration,
            Icons.timer_outlined,
          ),
          _tile(
            'Early Departure',
            'Earlier flight first',
            FlightSortType.departureEarly,
            Icons.flight_takeoff_outlined,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0866e5),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context, selected);
                },
                child: const Text('Apply Sort'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(
    String title,
    String subtitle,
    FlightSortType type,
    IconData icon,
  ) {
    return RadioListTile<FlightSortType>(
      value: type,
      // TODO: Migrate these tiles together to RadioGroup when the
      // project raises its minimum Flutter version.
      // ignore: deprecated_member_use
      groupValue: selected,
      // ignore: deprecated_member_use
      onChanged: (value) {
        if (value != null) {
          setState(() {
            selected = value;
          });
        }
      },
      secondary: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: const Color(0xffeaf3ff),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xff0866e5)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
    );
  }
}
