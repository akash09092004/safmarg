import 'package:flutter/material.dart';

import '../../app/route_names.dart';
import '../../core/constants/app_colors.dart';
import '../../models/flight_model.dart';
import '../../models/passenger_model.dart';
import '../../models/seat_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class PassengerDetailsScreen extends StatefulWidget {
  final FlightModel flight;
  final List<SeatModel> selectedSeats;

  const PassengerDetailsScreen({
    super.key,
    required this.flight,
    required this.selectedSeats,
  });

  @override
  State<PassengerDetailsScreen> createState() =>
      _PassengerDetailsScreenState();
}

class _PassengerDetailsScreenState
    extends State<PassengerDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<_PassengerFormData> _passengers = [];

  @override
  void initState() {
    super.initState();

    // Jitni seats select hui hain,
    // utne passenger forms banenge.
    for (int i = 0;
        i < widget.selectedSeats.length;
        i++) {
      _passengers.add(
        _PassengerFormData(),
      );
    }
  }

  @override
  void dispose() {
    for (final passenger in _passengers) {
      passenger.dispose();
    }

    super.dispose();
  }

  // =====================================
  // SAVED TRAVELLERS SCREEN
  // =====================================

  Future<void> _selectSavedTraveller(
    int passengerIndex,
  ) async {
    final result =
        await Navigator.pushNamed(
      context,
      RouteNames.savedTravellers,
      arguments: {
        'selectionMode': true,
      },
    );

    if (!mounted) {
      return;
    }

    if (result is PassengerModel) {
      setState(() {
        _passengers[passengerIndex]
            .fillFromTraveller(result);
      });
    }
  }

  // =====================================
  // CONTINUE
  // =====================================

  void _continue() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final passengers =
        <PassengerModel>[];

    for (int i = 0;
        i < _passengers.length;
        i++) {
      final form =
          _passengers[i];

      final seat =
          widget.selectedSeats[i];

      passengers.add(
        PassengerModel(
          name: form.nameController.text.trim(),
          age: int.parse(
            form.ageController.text.trim(),
          ),
          dateOfBirth: form.dateOfBirth,
          email: form.emailController.text.trim(),
          nationality: form.nationalityController.text.trim(),
          gender: form.gender,
          phone:
              form.phoneController.text.trim(),
          seatNumber: seat.seatNumber,
        ),
      );
    }

    Navigator.pushNamed(
      context,
      RouteNames.payment,
      arguments: {
        'flight': widget.flight,
        'selectedSeats':
            widget.selectedSeats,
        'passengers': passengers,
        'totalAmount': widget.selectedSeats.fold<double>(
          0,
          (total, seat) => total + seat.finalPrice(widget.flight.basePrice),
        ),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: const CustomAppBar(
        title: 'Passenger Details',
      ),

      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child:
                  SingleChildScrollView(
                padding:
                    const EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  30,
                ),
                child: Center(child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: Column(
                  children: [
                    _buildFlightInfo(),

                    const SizedBox(
                      height: 16,
                    ),

                    _buildInfoMessage(),

                    const SizedBox(
                      height: 20,
                    ),

                    ...List.generate(
                      _passengers.length,
                      (index) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(
                            bottom: 18,
                          ),
                          child:
                              _buildPassengerCard(
                            index,
                          ),
                        );
                      },
                    ),
                  ],
                ))),
              ),
            ),

            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // =====================================
  // FLIGHT INFO
  // =====================================

  Widget _buildFlightInfo() {
    return Container(
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color:
                  AppColors.primaryLight,
              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),
            child: const Icon(
              Icons.flight,
              color:
                  AppColors.primary,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  widget.flight.airline,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.w700,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(
                  '${widget.flight.originCode} → ${widget.flight.destinationCode}',
                  style:
                      const TextStyle(
                    color: AppColors
                        .textSecondary,
                  ),
                ),
              ],
            ),
          ),

          Text(
            widget.flight.flightNumber,
            style:
                const TextStyle(
              color:
                  AppColors.primary,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================
  // INFORMATION
  // =====================================

  Widget _buildInfoMessage() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:
            AppColors.primaryLight,
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            color:
                AppColors.primary,
            size: 20,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              '${widget.selectedSeats.length} seat(s) selected. '
              'Please enter details for every passenger.',
              style:
                  const TextStyle(
                color:
                    AppColors.primary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================
  // PASSENGER CARD
  // =====================================

  Widget _buildPassengerCard(
    int index,
  ) {
    final passenger =
        _passengers[index];

    final seat =
        widget.selectedSeats[index];

    return Container(
      padding:
          const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment:
                    Alignment.center,
                decoration:
                    const BoxDecoration(
                  color:
                      AppColors.primaryLight,
                  shape:
                      BoxShape.circle,
                ),
                child: Text(
                  '${index + 1}',
                  style:
                      const TextStyle(
                    color:
                        AppColors.primary,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Passenger ${index + 1}',
                      style:
                          const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),

                    Text(
                      'Seat ${seat.seatNumber}',
                      style:
                          const TextStyle(
                        color: AppColors
                            .textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              TextButton.icon(
                onPressed: () {
                  _selectSavedTraveller(
                    index,
                  );
                },
                icon: const Icon(
                  Icons
                      .person_search_outlined,
                  size: 18,
                ),
                label: const Text(
                  'Saved',
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          CustomTextField(
            controller:
                passenger.nameController,
            label: 'Full Name',
            hint:
                'Enter passenger name',
            prefixIcon:
                Icons.person_outline,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Passenger name is required';
              }

              if (value.trim().length <
                  2) {
                return 'Enter valid name';
              }

              return null;
            },
          ),

          const SizedBox(
            height: 15,
          ),

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextField(
                  controller:
                      passenger
                          .ageController,
                  label: 'Age',
                  hint: 'Age',
                  prefixIcon:
                      Icons
                          .calendar_today_outlined,
                  keyboardType:
                      TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value
                            .trim()
                            .isEmpty) {
                      return 'Required';
                    }

                    final age =
                        int.tryParse(
                      value.trim(),
                    );

                    if (age == null ||
                        age <= 0 ||
                        age > 120) {
                      return 'Invalid age';
                    }

                    return null;
                  },
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child:
                    DropdownButtonFormField<
                        String>(
                  initialValue:
                      passenger.gender,
                  decoration:
                      const InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(
                      Icons
                          .wc_outlined,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'male',
                      child:
                          Text('Male'),
                    ),
                    DropdownMenuItem(
                      value: 'female',
                      child:
                          Text('Female'),
                    ),
                    DropdownMenuItem(
                      value: 'other',
                      child:
                          Text('Other'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    setState(() {
                      passenger.gender =
                          value;
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 15,
          ),

          FormField<DateTime>(
            initialValue: passenger.dateOfBirth,
            validator: (value) => value == null ? 'Date of birth is required' : null,
            builder: (field) => InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: passenger.dateOfBirth ?? DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() {
                    passenger.dateOfBirth = picked;
                    passenger.ageController.text =
                        (DateTime.now().year - picked.year).toString();
                  });
                  field.didChange(picked);
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  prefixIcon: const Icon(Icons.calendar_month_outlined),
                  errorText: field.errorText,
                ),
                child: Text(passenger.dateOfBirth == null
                    ? 'Select date'
                    : '${passenger.dateOfBirth!.day}/${passenger.dateOfBirth!.month}/${passenger.dateOfBirth!.year}'),
              ),
            ),
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: passenger.emailController,
            label: 'Email',
            hint: 'name@example.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) => value == null ||
                    !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())
                ? 'Enter a valid email'
                : null,
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: passenger.nationalityController,
            label: 'Nationality',
            hint: 'Indian',
            prefixIcon: Icons.public_outlined,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Nationality is required'
                : null,
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller:
                passenger.phoneController,
            label: 'Phone Number',
            hint: '9876543210',
            prefixIcon:
                Icons.phone_outlined,
            keyboardType:
                TextInputType.phone,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Phone number is required';
              }

              final phone =
                  value
                      .replaceAll(
                        RegExp(r'\D'),
                        '',
                      );

              if (phone.length < 10) {
                return 'Enter valid phone number';
              }

              return null;
            },
          ),

          const SizedBox(
            height: 14,
          ),

          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 11,
            ),
            decoration:
                BoxDecoration(
              color:
                  AppColors.background,
              borderRadius:
                  BorderRadius.circular(
                10,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons
                      .event_seat_outlined,
                  color:
                      AppColors.primary,
                  size: 20,
                ),

                const SizedBox(
                  width: 8,
                ),

                const Text(
                  'Assigned Seat',
                  style:
                      TextStyle(
                    color: AppColors
                        .textSecondary,
                  ),
                ),

                const Spacer(),

                Text(
                  seat.seatNumber,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.w700,
                    color:
                        AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================
  // BOTTOM BUTTON
  // =====================================

  Widget _buildBottomBar() {
    return SafeArea(
      child: Container(
        padding:
            const EdgeInsets.fromLTRB(
          18,
          13,
          18,
          13,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(alpha: 
                .07,
              ),
              blurRadius: 18,
              offset:
                  const Offset(0, -5),
            ),
          ],
        ),
        child: CustomButton(
          text:
              'Continue to Payment',
          icon:
              Icons.arrow_forward,
          onPressed: _continue,
        ),
      ),
    );
  }
}

// =======================================
// INTERNAL FORM DATA
// =======================================

class _PassengerFormData {
  final TextEditingController
      nameController =
      TextEditingController();

  final TextEditingController
      ageController =
      TextEditingController();

  final TextEditingController
      phoneController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nationalityController =
      TextEditingController(text: 'Indian');
  DateTime? dateOfBirth;

  String gender = 'male';

  void fillFromTraveller(
    PassengerModel traveller,
  ) {
    nameController.text =
        traveller.name;

    ageController.text =
        traveller.age.toString();

    phoneController.text =
        traveller.phone ?? '';
    emailController.text = traveller.email ?? '';
    nationalityController.text = traveller.nationality ?? 'Indian';
    dateOfBirth = traveller.dateOfBirth;

    gender =
        traveller.gender ?? 'male';
  }

  void dispose() {
    nameController.dispose();
    ageController.dispose();
    phoneController.dispose();
    emailController.dispose();
    nationalityController.dispose();
  }
}
