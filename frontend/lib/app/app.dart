import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import '../providers/flight_provider.dart';
import '../providers/payment_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/refund_provider.dart';

import 'route_names.dart';
import 'routes.dart';

class SafMargApp extends StatelessWidget {
  const SafMargApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => FlightProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => RefundProvider()),
      ],
      child: MaterialApp(
        // =========================
        // APP NAME
        // =========================

        title: 'SafMarg',

        // =========================
        // DEBUG BANNER
        // =========================
        debugShowCheckedModeBanner: false,

        // =========================
        // THEME
        // =========================
        theme: ThemeData(
          useMaterial3: true,

          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff0866e5),
            brightness: Brightness.light,
          ),

          scaffoldBackgroundColor: const Color(0xfff8faff),

          fontFamily: 'Roboto',

          // =========================
          // APP BAR
          // =========================
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xff111827),
            centerTitle: true,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            titleTextStyle: TextStyle(
              color: Color(0xff111827),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          // =========================
          // ELEVATED BUTTON
          // =========================
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff0866e5),
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size(0, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // =========================
          // OUTLINED BUTTON
          // =========================
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xff0866e5),
              minimumSize: const Size(0, 50),
              side: const BorderSide(color: Color(0xffd9e2f1)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),

          // =========================
          // INPUT / TEXTFIELD
          // =========================
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xff0866e5),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),

          // =========================
          // CARD
          // =========================
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),

          // =========================
          // DIVIDER
          // =========================
          dividerTheme: DividerThemeData(
            color: Colors.grey.shade200,
            thickness: 1,
          ),

          // =========================
          // SNACKBAR
          // =========================
          snackBarTheme: SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xff1f2937),
            contentTextStyle: const TextStyle(color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          // =========================
          // PROGRESS INDICATOR
          // =========================
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Color(0xff0866e5),
          ),
        ),

        // =========================
        // INITIAL SCREEN
        // =========================
        initialRoute: RouteNames.login,

        // =========================
        // ROUTING
        // =========================
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
