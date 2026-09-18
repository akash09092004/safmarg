import 'package:flutter/material.dart';

import '../screens/flights/flight_search_screen.dart';
import '../screens/flights/available_flights_screen.dart';
import '../screens/flights/flight_details_screen.dart';
import '../screens/flights/filter_screen.dart';
import '../screens/flights/sort_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/otp_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/bookings/booking_confirmation_screen.dart';
import '../screens/bookings/booking_details_screen.dart';
import '../screens/bookings/order_tracking_screen.dart';
import '../screens/bookings/my_bookings_screen.dart';
import '../screens/bookings/ticket_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/main/main_screen.dart';
import '../screens/notifications/notification_screen.dart';
import '../screens/offers/offer_details_screen.dart';
import '../screens/offers/offers_screen.dart';
import '../screens/passengers/passenger_details_screen.dart';
import '../screens/passengers/saved_travellers_screen.dart';
import '../screens/payment/fare_summary_screen.dart';
import '../screens/payment/payment_screen.dart';
import '../screens/payment/payment_success_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/help_support_screen.dart';
import '../screens/profile/privacy_policy_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/terms_screen.dart';
import '../screens/refund/refund_details_screen.dart';
import '../screens/refund/refund_request_screen.dart';
import '../screens/refund/refund_screen.dart';
import '../screens/refund/refund_status_screen.dart';
import '../screens/seats/seat_selection_screen.dart';
import '../models/booking_model.dart';
import '../models/flight_model.dart';
import '../models/offer_model.dart';
import '../models/passenger_model.dart';
import '../models/payment_model.dart';
import '../models/refund_model.dart';
import '../models/seat_model.dart';

import 'route_names.dart';

class AppRoutes {
  AppRoutes._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ==========================================
      // INITIAL / FLIGHT SEARCH
      // ==========================================

      case RouteNames.initial:
      case RouteNames.flightSearch:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const FlightSearchScreen(),
        );

      // ==========================================
      // AVAILABLE FLIGHTS
      // ==========================================

      case RouteNames.availableFlights:
        final args = settings.arguments;

        if (args is! AvailableFlightsArguments) {
          return _errorRoute('Available Flights ke arguments nahi mile.');
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AvailableFlightsScreen(
            origin: args.origin,
            destination: args.destination,
            date: args.date,
            passengers: args.passengers,
            travelClass: args.travelClass,
          ),
        );

      // ==========================================
      // FLIGHT DETAILS
      // ==========================================

      case RouteNames.flightDetails:
        final args = settings.arguments;

        if (args is! FlightDetailsArguments) {
          return _errorRoute('Flight Details ke arguments nahi mile.');
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => FlightDetailsScreen(
            flightId: args.flightId,
            passengers: args.passengers,
            travelClass: args.travelClass,
          ),
        );

      // ==========================================
      // FILTER
      // ==========================================

      case RouteNames.flightFilter:
        final args = settings.arguments;

        if (args is! FilterArguments) {
          return _errorRoute('Filter ke arguments nahi mile.');
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => FilterScreen(
            flights: args.flights,
            initialFilter: args.initialFilter,
          ),
        );

      // ==========================================
      // SORT
      // ==========================================

      case RouteNames.flightSort:
        final args = settings.arguments;

        final selectedSort = args is FlightSortType
            ? args
            : FlightSortType.none;

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SortScreen(selectedSort: selectedSort),
        );

      // ==========================================
      // AUTH / MAIN
      // ==========================================

      case RouteNames.login:
        return _page(settings, const LoginScreen());
      case RouteNames.register:
      case RouteNames.signup:
        return _page(settings, const SignupScreen());
      case RouteNames.forgotPassword:
        return _page(settings, const ForgotPasswordScreen());
      case RouteNames.otp:
        final email = settings.arguments;
        if (email is! String) return _invalidArguments(settings.name);
        return _page(settings, OtpScreen(email: email));
      case RouteNames.home:
        return _page(settings, const HomeScreen());
      case RouteNames.main:
        return _page(settings, const MainScreen());
      case RouteNames.profile:
        return _page(settings, const ProfileScreen());

      // ==========================================
      // PROFILE
      // ==========================================

      case RouteNames.editProfile:
        return _page(settings, const EditProfileScreen());
      case RouteNames.profileNotifications:
        return _page(settings, const NotificationScreen());
      case RouteNames.helpSupport:
        return _page(settings, const HelpSupportScreen());
      case RouteNames.privacyPolicy:
        return _page(settings, const PrivacyPolicyScreen());
      case RouteNames.terms:
        return _page(settings, const TermsScreen());

      // ==========================================
      // BOOKINGS / OFFERS / REFUNDS
      // ==========================================

      case RouteNames.bookings:
      case RouteNames.myBookings:
        return _page(settings, const MyBookingsScreen());
      case RouteNames.bookingDetails:
        final id = settings.arguments;
        if (id is! int) return _invalidArguments(settings.name);
        return _page(settings, BookingDetailsScreen(bookingId: id));
      case RouteNames.orderTracking:
        final id = settings.arguments;
        if (id is! int) return _invalidArguments(settings.name);
        return _page(settings, OrderTrackingScreen(bookingId: id));
      case RouteNames.ticket:
        final booking = settings.arguments;
        if (booking is! BookingModel) return _invalidArguments(settings.name);
        return _page(settings, TicketScreen(booking: booking));
      case RouteNames.bookingSuccess:
        final booking = settings.arguments;
        if (booking is! BookingModel) return _invalidArguments(settings.name);
        return _page(settings, BookingConfirmationScreen(booking: booking));
      case RouteNames.offers:
        return _page(settings, const OffersScreen());
      case RouteNames.offerDetails:
        final offer = settings.arguments;
        if (offer is! OfferModel) return _invalidArguments(settings.name);
        return _page(settings, OfferDetailsScreen(offer: offer));
      case RouteNames.refund:
        return _page(settings, const RefundScreen());
      case RouteNames.refundRequest:
        final bookingId = settings.arguments;
        if (bookingId != null && bookingId is! int) {
          return _invalidArguments(settings.name);
        }
        return _page(
          settings,
          RefundRequestScreen(bookingId: bookingId as int?),
        );
      case RouteNames.refundDetails:
        final id = settings.arguments;
        if (id is! int) return _invalidArguments(settings.name);
        return _page(settings, RefundDetailsScreen(refundId: id));
      case RouteNames.refundStatus:
        final refund = settings.arguments;
        if (refund is! RefundModel) return _invalidArguments(settings.name);
        return _page(settings, RefundStatusScreen(refund: refund));

      // ==========================================
      // BOOKING FLOW
      // ==========================================

      case RouteNames.seatSelection:
        final args = _argumentsMap(settings.arguments);
        final flight = args?['flight'];
        final count = args?['passengerCount'];
        if (flight is! FlightModel || (count != null && count is! int)) {
          return _invalidArguments(settings.name);
        }
        return _page(
          settings,
          SeatSelectionScreen(
            flight: flight,
            passengerCount: count as int? ?? 1,
          ),
        );
      case RouteNames.passengerDetails:
        final args = _argumentsMap(settings.arguments);
        final flight = args?['flight'];
        final seats = args?['selectedSeats'];
        if (flight is! FlightModel || seats is! List<SeatModel>) {
          return _invalidArguments(settings.name);
        }
        return _page(
          settings,
          PassengerDetailsScreen(flight: flight, selectedSeats: seats),
        );
      case RouteNames.savedTravellers:
        final args = _argumentsMap(settings.arguments);
        final selectionMode = args?['selectionMode'];
        if (selectionMode != null && selectionMode is! bool) {
          return _invalidArguments(settings.name);
        }
        return _page(
          settings,
          SavedTravellersScreen(selectionMode: selectionMode as bool? ?? false),
        );
      case RouteNames.fareSummary:
        final args = _argumentsMap(settings.arguments);
        final flight = args?['flight'];
        final seats = args?['selectedSeats'];
        final passengers = args?['passengers'];
        if (flight is! FlightModel ||
            seats is! List<SeatModel> ||
            passengers is! List<PassengerModel>) {
          return _invalidArguments(settings.name);
        }
        return _page(
          settings,
          FareSummaryScreen(
            flight: flight,
            selectedSeats: seats,
            passengers: passengers,
          ),
        );
      case RouteNames.payment:
        final args = _argumentsMap(settings.arguments);
        final flight = args?['flight'];
        final seats = args?['selectedSeats'];
        final passengers = args?['passengers'];
        final amount = args?['totalAmount'];
        if (flight is! FlightModel ||
            seats is! List<SeatModel> ||
            passengers is! List<PassengerModel> ||
            amount is! num) {
          return _invalidArguments(settings.name);
        }
        return _page(
          settings,
          PaymentScreen(
            flight: flight,
            selectedSeats: seats,
            passengers: passengers,
            totalAmount: amount.toDouble(),
          ),
        );
      case RouteNames.paymentSuccess:
        final args = _argumentsMap(settings.arguments);
        final booking = args?['booking'];
        final payment = args?['payment'];
        final flight = args?['flight'];
        final passengers = args?['passengers'];
        final seats = args?['selectedSeats'];
        final amount = args?['totalAmount'];
        if (booking is! BookingModel ||
            (payment != null && payment is! PaymentModel) ||
            flight is! FlightModel ||
            passengers is! List<PassengerModel> ||
            seats is! List<SeatModel> ||
            amount is! num) {
          return _invalidArguments(settings.name);
        }
        return _page(
          settings,
          PaymentSuccessScreen(
            booking: booking,
            payment: payment as PaymentModel?,
            flight: flight,
            passengers: passengers,
            selectedSeats: seats,
            totalAmount: amount.toDouble(),
          ),
        );

      // ==========================================
      // UNKNOWN ROUTE
      // ==========================================

      default:
        return _errorRoute('Route nahi mila: ${settings.name}');
    }
  }

  // ==========================================
  // ERROR ROUTE
  // ==========================================

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        backgroundColor: const Color(0xfff8faff),
        appBar: AppBar(title: const Text('Page Not Found'), centerTitle: true),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 70, color: Colors.red),
                const SizedBox(height: 20),
                const Text(
                  'Oops!',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static MaterialPageRoute<dynamic> _page(
    RouteSettings settings,
    Widget child,
  ) {
    return MaterialPageRoute(settings: settings, builder: (_) => child);
  }

  static Route<dynamic> _invalidArguments(String? routeName) {
    return _errorRoute('Invalid arguments for route: $routeName');
  }

  static Map<String, dynamic>? _argumentsMap(Object? arguments) {
    return arguments is Map<String, dynamic> ? arguments : null;
  }
}

// ============================================================
// AVAILABLE FLIGHTS ARGUMENTS
// ============================================================

class AvailableFlightsArguments {
  final String origin;
  final String destination;
  final String date;
  final int passengers;
  final String travelClass;

  const AvailableFlightsArguments({
    required this.origin,
    required this.destination,
    required this.date,
    this.passengers = 1,
    this.travelClass = 'economy',
  });
}

// ============================================================
// FLIGHT DETAILS ARGUMENTS
// ============================================================

class FlightDetailsArguments {
  final int flightId;
  final int passengers;
  final String travelClass;

  const FlightDetailsArguments({
    required this.flightId,
    this.passengers = 1,
    this.travelClass = 'economy',
  });
}

// ============================================================
// FILTER ARGUMENTS
// ============================================================

class FilterArguments {
  final List<Map<String, dynamic>> flights;
  final FlightFilter? initialFilter;

  const FilterArguments({required this.flights, this.initialFilter});
}
