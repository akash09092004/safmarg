import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/route_names.dart';
import '../../providers/auth_provider.dart';
import '../flights/available_flights_screen.dart';

import 'widgets/home_header.dart';
import 'widgets/trip_type_tabs.dart';
import 'widgets/flight_search_box.dart';
import 'widgets/popular_airlines.dart';
import 'widgets/why_choose_us.dart';
import 'widgets/home_offer_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _airports = <(String, String)>[
    ('New Delhi', 'DEL'),
    ('Mumbai', 'BOM'),
    ('Bengaluru', 'BLR'),
    ('Chennai', 'MAA'),
    ('Kolkata', 'CCU'),
    ('Hyderabad', 'HYD'),
    ('Goa', 'GOI'),
    ('Ahmedabad', 'AMD'),
  ];

  int selectedTripType = 0;

  String fromCity = "New Delhi";
  String fromCode = "DEL";

  String toCity = "Mumbai";
  String toCode = "BOM";

  DateTime departureDate = DateTime.now().add(const Duration(days: 1));

  int passengers = 1;

  String travelClass = "Economy";

  void changeTripType(int index) {
    setState(() => selectedTripType = index);
    const messages = [
      'One Way selected',
      'Round Trip selected',
      'Multi City selected',
    ];
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(messages[index]),
          duration: const Duration(milliseconds: 900),
        ),
      );
  }

  Future<void> selectAirport({required bool isOrigin}) async {
    final selected = await showModalBottomSheet<(String, String)>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (context) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.72,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isOrigin
                    ? 'Select departure airport'
                    : 'Select arrival airport',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                  itemCount: _airports.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final airport = _airports[index];
                    return ListTile(
                      leading: const Icon(
                        Icons.flight_takeoff,
                        color: Color(0xff0866e5),
                      ),
                      title: Text(airport.$1),
                      trailing: Text(
                        airport.$2,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      onTap: () => Navigator.pop(context, airport),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (selected == null || !mounted) return;

    final otherCode = isOrigin ? toCode : fromCode;
    if (selected.$2 == otherCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('From aur To airport same nahi ho sakte.'),
        ),
      );
      return;
    }

    setState(() {
      if (isOrigin) {
        fromCity = selected.$1;
        fromCode = selected.$2;
      } else {
        toCity = selected.$1;
        toCode = selected.$2;
      }
    });
  }

  void swapCities() {
    setState(() {
      final oldFromCity = fromCity;
      final oldFromCode = fromCode;

      fromCity = toCity;
      fromCode = toCode;

      toCity = oldFromCity;
      toCode = oldFromCode;
    });
  }

  Future<void> selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: departureDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      setState(() {
        departureDate = selectedDate;
      });
    }
  }

  void selectPassengers() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        int temporaryPassengers = passengers;
        String temporaryClass = travelClass;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Passengers & Class",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(height: 28),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Passengers",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: temporaryPassengers > 1
                                ? () {
                                    setModalState(() {
                                      temporaryPassengers--;
                                    });
                                  }
                                : null,
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text(
                            "$temporaryPassengers",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setModalState(() {
                                temporaryPassengers++;
                              });
                            },
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Divider(height: 32),

                  DropdownButtonFormField<String>(
                    initialValue: temporaryClass,
                    decoration: InputDecoration(
                      labelText: "Travel Class",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "Economy",
                        child: Text("Economy"),
                      ),
                      DropdownMenuItem(
                        value: "Premium Economy",
                        child: Text("Premium Economy"),
                      ),
                      DropdownMenuItem(
                        value: "Business",
                        child: Text("Business"),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setModalState(() {
                          temporaryClass = value;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0866e5),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          passengers = temporaryPassengers;
                          travelClass = temporaryClass;
                        });

                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Done",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void searchFlights() {
    final date =
        '${departureDate.year.toString().padLeft(4, '0')}-'
        '${departureDate.month.toString().padLeft(2, '0')}-'
        '${departureDate.day.toString().padLeft(2, '0')}';
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AvailableFlightsScreen(
          origin: fromCode,
          destination: toCode,
          date: date,
          passengers: passengers,
          travelClass: travelClass.toLowerCase().replaceAll(' ', '_'),
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "$fromCode â†’ $toCode | "
          "$passengers Passenger | $travelClass",
        ),
      ),
    );

    // Backend integration ke baad yahan navigate karna:
    //
    // Navigator.pushNamed(
    //   context,
    //   '/available-flights',
    // );
  }

  void openProfile() {
    final route = context.read<AuthProvider>().isLoggedIn
        ? RouteNames.profile
        : RouteNames.login;
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8faff),

      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: 650,
                    child: Stack(
                      children: [
                        HomeHeader(onProfileTap: openProfile),

                        Positioned(
                          left: 16,
                          right: 16,
                          top: 180,
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 28,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                TripTypeTabs(
                                  selectedIndex: selectedTripType,
                                  onChanged: changeTripType,
                                ),

                                const SizedBox(height: 16),

                                FlightSearchBox(
                                  fromCity: fromCity,
                                  fromCode: fromCode,
                                  toCity: toCity,
                                  toCode: toCode,
                                  departureDate: departureDate,
                                  passengers: passengers,
                                  travelClass: travelClass,
                                  onSwap: swapCities,
                                  onFromTap: () =>
                                      selectAirport(isOrigin: true),
                                  onToTap: () => selectAirport(isOrigin: false),
                                  onDepartureTap: selectDate,
                                  onPassengersTap: selectPassengers,
                                ),

                                const SizedBox(height: 18),

                                SizedBox(
                                  height: 56,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: searchFlights,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff0866e5),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: const Text(
                                      "Search Flights",
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const PopularAirlines(),

                  const SizedBox(height: 30),

                  const WhyChooseUs(),

                  const SizedBox(height: 28),

                  HomeOfferBanner(onBookNow: searchFlights),

                  const SizedBox(height: 135),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
