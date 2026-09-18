import 'package:flutter/material.dart';

class FlightSearchBox extends StatelessWidget {
  final String fromCity;
  final String fromCode;

  final String toCity;
  final String toCode;

  final DateTime departureDate;

  final int passengers;
  final String travelClass;

  final VoidCallback onSwap;
  final VoidCallback onFromTap;
  final VoidCallback onToTap;
  final VoidCallback onDepartureTap;
  final VoidCallback onPassengersTap;

  const FlightSearchBox({
    super.key,
    required this.fromCity,
    required this.fromCode,
    required this.toCity,
    required this.toCode,
    required this.departureDate,
    required this.passengers,
    required this.travelClass,
    required this.onSwap,
    required this.onFromTap,
    required this.onToTap,
    required this.onDepartureTap,
    required this.onPassengersTap,
  });

  String get formattedDate {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    return "${departureDate.day} "
        "${months[departureDate.month - 1]}, "
        "${departureDate.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xffe8edf5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Column(
                children: [
                  _LocationTile(
                    icon: Icons.flight_takeoff,
                    title: "From",
                    city: fromCity,
                    code: fromCode,
                    onTap: onFromTap,
                  ),

                  const Divider(height: 1, indent: 70),

                  _LocationTile(
                    icon: Icons.location_on_outlined,
                    title: "To",
                    city: toCity,
                    code: toCode,
                    onTap: onToTap,
                  ),
                ],
              ),

              Positioned(
                right: 14,
                child: GestureDetector(
                  onTap: onSwap,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xff0866e5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.swap_vert,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const Divider(height: 1),

          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 360;

              return Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: onDepartureTap,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: compact ? 8 : 20,
                          vertical: 20,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_month_outlined,
                              color: const Color(0xff0866e5),
                              size: compact ? 24 : 31,
                            ),
                            SizedBox(width: compact ? 6 : 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Departure",
                                    style: TextStyle(
                                      color: Color(0xff687086),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    formattedDate,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color(0xff161922),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    width: 1,
                    height: 55,
                    color: const Color(0xffe8edf5),
                  ),

                  Expanded(
                    child: InkWell(
                      onTap: onPassengersTap,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: compact ? 8 : 16,
                          vertical: 20,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              color: const Color(0xff0866e5),
                              size: compact ? 24 : 31,
                            ),
                            SizedBox(width: compact ? 6 : 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Passengers",
                                    style: TextStyle(
                                      color: Color(0xff687086),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "$passengers Passenger, "
                                    "$travelClass",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color(0xff161922),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: compact ? 20 : 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LocationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String city;
  final String code;
  final VoidCallback onTap;

  const _LocationTile({
    required this.icon,
    required this.title,
    required this.city,
    required this.code,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 70, 20),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xff0866e5), size: 32),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xff687086),
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "$city ($code)",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xff151820),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
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
}
