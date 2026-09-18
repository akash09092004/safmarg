import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/route_names.dart';
import '../../providers/auth_provider.dart';
import '../home/home_screen.dart';
import '../home/widgets/bottom_nav_bar.dart';
import '../bookings/my_bookings_screen.dart';
import '../offers/offers_screen.dart';
import '../refund/refund_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  final Set<int> _loadedTabs = {0};

  Future<void> _selectTab(int index) async {
    if ((index == 1 || index == 2) &&
        !context.read<AuthProvider>().isLoggedIn) {
      await Navigator.pushNamed(context, RouteNames.login);
      return;
    }

    if (!mounted) return;

    setState(() {
      currentIndex = index;
      _loadedTabs.add(index);
    });
  }

  Widget _page(int index, Widget page) {
    return _loadedTabs.contains(index) ? page : const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      body: IndexedStack(
        index: currentIndex,
        children: [
          _page(0, const HomeScreen()),
          _page(1, const MyBookingsScreen()),
          _page(2, const RefundScreen()),
          _page(3, const OffersScreen()),
        ],
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: BottomNavBar(currentIndex: currentIndex, onTap: _selectTab),
          ),
        ),
      ),
    );
  }
}
