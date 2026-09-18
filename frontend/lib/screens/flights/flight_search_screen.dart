import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'available_flights_screen.dart';

class FlightSearchScreen extends StatefulWidget {
  final String initialOrigin;
  final String initialDestination;
  final DateTime? initialDate;

  const FlightSearchScreen({
    super.key,
    this.initialOrigin = 'DEL',
    this.initialDestination = 'BOM',
    this.initialDate,
  });

  @override
  State<FlightSearchScreen> createState() =>
      _FlightSearchScreenState();
}

class _FlightSearchScreenState extends State<FlightSearchScreen> {
  late TextEditingController originController;
  late TextEditingController destinationController;

  late DateTime selectedDate;

  int passengers = 1;
  String travelClass = 'economy';
  int tripType = 0;

  final List<String> travelClasses = [
    'economy',
    'premium_economy',
    'business',
  ];

  @override
  void initState() {
    super.initState();

    originController = TextEditingController(
      text: widget.initialOrigin,
    );

    destinationController = TextEditingController(
      text: widget.initialDestination,
    );

    selectedDate =
        widget.initialDate ?? DateTime(2026, 9, 10);
  }

  @override
  void dispose() {
    originController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  void swapLocations() {
    final oldOrigin = originController.text;

    originController.text =
        destinationController.text;

    destinationController.text =
        oldOrigin;

    setState(() {});
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  void openPassengerSheet() {
    int tempPassengers = passengers;
    String tempClass = travelClass;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, updateSheet) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                24,
                24,
                34,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Passengers & Class',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Passengers',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Age 12+',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed:
                                tempPassengers > 1
                                    ? () {
                                        updateSheet(() {
                                          tempPassengers--;
                                        });
                                      }
                                    : null,
                            icon: const Icon(
                              Icons
                                  .remove_circle_outline,
                            ),
                          ),
                          Text(
                            '$tempPassengers',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              updateSheet(() {
                                tempPassengers++;
                              });
                            },
                            icon: const Icon(
                              Icons.add_circle_outline,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    initialValue: tempClass,
                    decoration: InputDecoration(
                      labelText: 'Travel Class',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'economy',
                        child: Text('Economy'),
                      ),
                      DropdownMenuItem(
                        value: 'premium_economy',
                        child:
                            Text('Premium Economy'),
                      ),
                      DropdownMenuItem(
                        value: 'business',
                        child: Text('Business'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        updateSheet(() {
                          tempClass = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xff0866e5),
                        foregroundColor:
                            Colors.white,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            14,
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          passengers =
                              tempPassengers;
                          travelClass =
                              tempClass;
                        });

                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.w600,
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
    final origin =
        originController.text.trim().toUpperCase();

    final destination =
        destinationController.text
            .trim()
            .toUpperCase();

    if (origin.isEmpty ||
        destination.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text('Origin aur destination dalein'),
        ),
      );
      return;
    }

    if (origin == destination) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Origin aur destination same nahi ho sakte',
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            AvailableFlightsScreen(
          origin: origin,
          destination: destination,
          date: DateFormat('yyyy-MM-dd')
              .format(selectedDate),
          passengers: passengers,
          travelClass: travelClass,
        ),
      ),
    );
  }

  String get displayClass {
    switch (travelClass) {
      case 'premium_economy':
        return 'Premium Economy';
      case 'business':
        return 'Business';
      default:
        return 'Economy';
    }
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xff0866e5);

    return Scaffold(
      backgroundColor:
          const Color(0xfff8faff),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Search Flights',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color:
                    const Color(0xfff0f3f8),
                borderRadius:
                    BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  _tripButton(
                    title: 'One Way',
                    index: 0,
                  ),
                  _tripButton(
                    title: 'Round Trip',
                    index: 1,
                  ),
                  _tripButton(
                    title: 'Multi City',
                    index: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(22),
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
                  Stack(
                    alignment:
                        Alignment.centerRight,
                    children: [
                      Column(
                        children: [
                          _locationField(
                            label: 'From',
                            controller:
                                originController,
                            icon: Icons
                                .flight_takeoff,
                          ),
                          const Divider(
                            height: 1,
                            indent: 65,
                          ),
                          _locationField(
                            label: 'To',
                            controller:
                                destinationController,
                            icon: Icons
                                .location_on_outlined,
                          ),
                        ],
                      ),
                      Positioned(
                        right: 15,
                        child:
                            GestureDetector(
                          onTap:
                              swapLocations,
                          child: Container(
                            height: 48,
                            width: 48,
                            decoration:
                                const BoxDecoration(
                              color: blue,
                              shape:
                                  BoxShape.circle,
                            ),
                            child:
                                const Icon(
                              Icons.swap_vert,
                              color:
                                  Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 1),
                  InkWell(
                    onTap: pickDate,
                    child: Padding(
                      padding:
                          const EdgeInsets.all(
                        20,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons
                                .calendar_month_outlined,
                            color: blue,
                            size: 30,
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              const Text(
                                'Departure',
                                style: TextStyle(
                                  color:
                                      Colors.grey,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                DateFormat(
                                  'dd MMM, yyyy',
                                ).format(
                                  selectedDate,
                                ),
                                style:
                                    const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  InkWell(
                    onTap:
                        openPassengerSheet,
                    child: Padding(
                      padding:
                          const EdgeInsets.all(
                        20,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons
                                .person_outline,
                            color: blue,
                            size: 30,
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                const Text(
                                  'Passengers',
                                  style: TextStyle(
                                    color:
                                        Colors.grey,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  '$passengers Passenger, $displayClass',
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons
                                .keyboard_arrow_down,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor: blue,
                  foregroundColor:
                      Colors.white,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      15,
                    ),
                  ),
                ),
                onPressed: searchFlights,
                child: const Text(
                  'Search Flights',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tripButton({
    required String title,
    required int index,
  }) {
    final selected =
        tripType == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            tripType = index;
          });
        },
        child: Container(
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xff0866e5)
                : Colors.transparent,
            borderRadius:
                BorderRadius.circular(11),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: selected
                  ? Colors.white
                  : Colors.black54,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _locationField({
    required String label,
    required TextEditingController
        controller,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        14,
        70,
        14,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color:
                const Color(0xff0866e5),
            size: 30,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller,
              textCapitalization:
                  TextCapitalization
                      .characters,
              decoration:
                  InputDecoration(
                labelText: label,
                hintText: 'DEL',
                border: InputBorder.none,
              ),
              style: const TextStyle(
                fontSize: 17,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
