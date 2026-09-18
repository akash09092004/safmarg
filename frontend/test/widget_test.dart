// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:safmarg/main.dart';
import 'package:safmarg/screens/home/widgets/flight_search_box.dart';

void main() {
  testWidgets('Safmarg home screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Safemarg'), findsOneWidget);
    expect(find.text('Search Flights'), findsOneWidget);

    await tester.tap(find.text('Round Trip'));
    await tester.pump();

    expect(find.text('Round Trip selected'), findsOneWidget);
  });

  testWidgets('flight search box fits on a narrow screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 200,
              child: FlightSearchBox(
                fromCity: 'New Delhi',
                fromCode: 'DEL',
                toCity: 'Mumbai',
                toCode: 'BOM',
                departureDate: DateTime(2026, 8, 25),
                passengers: 2,
                travelClass: 'Economy',
                onSwap: () {},
                onFromTap: () {},
                onToTap: () {},
                onDepartureTap: () {},
                onPassengersTap: () {},
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
