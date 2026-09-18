import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safmarg/screens/main/main_screen.dart';
import 'package:safmarg/screens/flights/flight_details_screen.dart';
import 'package:safmarg/screens/flights/available_flights_screen.dart';
import 'package:safmarg/models/flight_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  testWidgets('main screen lays out at desktop width', (tester) async {
    tester.view.physicalSize = const Size(1920, 880);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: MainScreen()));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('Search Flights'), findsOneWidget);
  });

  for (final width in [360.0, 1090.0]) {
  testWidgets('flight details renders at ${width.toInt()}px', (tester) async {
    tester.view.physicalSize = Size(width, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final flight = FlightModel(
      id: 1,
      flightNumber: 'SM12M',
      airline: 'IndiGo',
      originCode: 'DEL',
      originCity: 'New Delhi',
      destinationCode: 'BOM',
      destinationCity: 'Mumbai',
      departureTime: DateTime(2026, 9, 18, 6),
      arrivalTime: DateTime(2026, 9, 18, 8),
      basePrice: 3450,
      totalSeats: 36,
      status: 'scheduled',
      durationMinutes: 120,
    );
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
          ),
        ),
      ),
      home: FlightDetailsScreen(flightId: 1, initialFlight: flight),
    ));
    expect(tester.takeException(), isNull);
    expect(find.text('IndiGo  SM12M'), findsOneWidget);
    expect(find.text('Select Seats'), findsOneWidget);
  });
  }

  testWidgets('flight details renders after API response at 360px', (tester) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final client = MockClient((_) async => http.Response(
          '{"success":true,"data":{"id":1,"airline":"IndiGo","flight_number":"SM12M","origin_code":"DEL","origin_city":"New Delhi","destination_code":"BOM","destination_city":"Mumbai","departure_time":"2026-09-18 06:00:00","arrival_time":"2026-09-18 08:00:00","base_price":3450,"total_seats":36,"status":"scheduled","duration_minutes":120}}',
          200,
          headers: {'content-type': 'application/json'},
        ));
    addTearDown(client.close);
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
          ),
        ),
      ),
      home: FlightDetailsScreen(flightId: 1, client: client),
    ));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('IndiGo  SM12M'), findsOneWidget);
    expect(find.text('Select Seats'), findsOneWidget);
  });

  for (final width in [390.0, 1090.0, 1920.0]) {
    testWidgets('available flights lays out at ${width.toInt()}px', (tester) async {
      tester.view.physicalSize = Size(width, 880);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(MaterialApp(
        home: AvailableFlightsScreen(
          origin: 'DEL',
          destination: 'BOM',
          date: '2026-09-18',
          initialFlights: [
            {
              'id': 1,
              'airline': 'SafMarg Demo',
              'flight_number': 'SM12M',
              'origin_code': 'DEL',
              'destination_code': 'BOM',
              'departure_time': '2026-09-18 06:00:00',
              'arrival_time': '2026-09-18 08:00:00',
              'duration_minutes': 120,
              'base_price': 3450,
            },
          ],
        ),
      ));
      expect(tester.takeException(), isNull);
      expect(find.textContaining('SM12M'), findsOneWidget);
    });
  }
}
