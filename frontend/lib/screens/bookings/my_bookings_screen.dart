import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/route_names.dart';
import '../../core/constants/app_colors.dart';
import '../../models/booking_model.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/booking_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_widget.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  String _filter = 'all';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBookings();
    });
  }

  Future<void> _loadBookings() async {
    await context.read<BookingProvider>().loadMyBookings();
  }

  List<BookingModel> _filteredBookings(List<BookingModel> bookings) {
    if (_filter == 'all') {
      return bookings;
    }

    return bookings.where((booking) {
      return booking.status.toLowerCase() == _filter.toLowerCase();
    }).toList();
  }

  void _openBooking(BookingModel booking) {
    Navigator.pushNamed(
      context,
      RouteNames.bookingDetails,
      arguments: booking.id,
    );
  }

  Future<void> _searchByPnr() async {
    final controller = TextEditingController();
    final pnr = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Search booking by PNR'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 6,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: '936478'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: const Text('Search'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (pnr == null || pnr.trim().length != 6 || !mounted) return;
    final provider = context.read<BookingProvider>();
    final booking = await provider.searchByPnr(pnr.trim());
    if (!mounted) return;

    if (booking != null) {
      _openBooking(booking);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? 'Booking nahi mili')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();

    final bookings = _filteredBookings(provider.bookings);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: 'Search by PNR',
            onPressed: _searchByPnr,
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),

          Expanded(
            child: provider.isLoading
                ? const LoadingWidget(message: 'Loading bookings...')
                : provider.errorMessage != null && provider.bookings.isEmpty
                ? EmptyState(
                    icon: Icons.error_outline,
                    title: 'Unable to load bookings',
                    message: provider.errorMessage ?? 'Something went wrong.',
                    buttonText: 'Retry',
                    onButtonPressed: _loadBookings,
                  )
                : bookings.isEmpty
                ? EmptyState(
                    icon: Icons.flight_takeoff_outlined,
                    title: 'No Bookings Found',
                    message: _filter == 'all'
                        ? 'Aapne abhi koi flight book nahi ki hai.'
                        : '$_filter booking nahi mili.',
                    buttonText: 'Book a Flight',
                    onButtonPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RouteNames.main,
                        (route) => false,
                      );
                    },
                  )
                : RefreshIndicator(
                    onRefresh: _loadBookings,
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                      itemCount: bookings.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final booking = bookings[index];

                        return BookingCard(
                          booking: booking,
                          onTap: () {
                            _openBooking(booking);
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    const filters = ['all', 'confirmed', 'pending', 'cancelled'];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: filters.map((filter) {
            final selected = _filter == filter;

            return Padding(
              padding: const EdgeInsets.only(right: 9),
              child: ChoiceChip(
                label: Text(_title(filter)),
                selected: selected,
                onSelected: (_) {
                  setState(() {
                    _filter = filter;
                  });
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _title(String value) {
    if (value.isEmpty) {
      return value;
    }

    return value[0].toUpperCase() + value.substring(1);
  }
}
