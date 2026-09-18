import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safmarg/models/booking_model.dart';
import 'package:safmarg/models/flight_model.dart';
import 'package:safmarg/screens/bookings/order_tracking_screen.dart';

void main() {
  for (final width in [360.0, 720.0]) {
    testWidgets('tracking timeline fits ${width.toInt()}px', (tester) async {
      tester.view.physicalSize = Size(width, 740);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final departure = DateTime.now().add(const Duration(days: 1));
      final flight = FlightModel(
        id: 4,
        flightNumber: 'SM12M',
        airline: 'IndiGo',
        originCode: 'DEL',
        originCity: 'New Delhi',
        destinationCode: 'BOM',
        destinationCity: 'Mumbai',
        departureTime: departure,
        arrivalTime: departure.add(const Duration(hours: 2)),
        basePrice: 3450,
        totalSeats: 36,
        status: 'scheduled',
        durationMinutes: 120,
      );
      final booking = BookingModel(
        id: 7,
        pnr: 'ABC123',
        totalAmount: 3450,
        status: 'confirmed',
        paymentStatus: 'successful',
        flight: flight,
        createdAt: DateTime.now(),
      );
      await tester.pumpWidget(MaterialApp(
        home: OrderTrackingScreen(bookingId: 7, initialBooking: booking),
      ));
      expect(tester.takeException(), isNull);
      expect(find.text('PNR: ABC123'), findsOneWidget);
      expect(find.text('Scheduled departure'), findsOneWidget);
      expect(find.text('Refresh Status'), findsOneWidget);
    });
  }
}
