import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../models/passenger_model.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_widget.dart';

class SavedTravellersScreen extends StatefulWidget {
  final bool selectionMode;

  const SavedTravellersScreen({super.key, this.selectionMode = false});

  @override
  State<SavedTravellersScreen> createState() => _SavedTravellersScreenState();
}

class _SavedTravellersScreenState extends State<SavedTravellersScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadTravellers();
    });
  }

  // =====================================
  // SELECT
  // =====================================

  void _selectTraveller(PassengerModel traveller) {
    if (!widget.selectionMode) {
      return;
    }

    Navigator.pop(context, traveller);
  }

  // =====================================
  // ADD TRAVELLER
  // =====================================

  void _showAddTraveller() {
    final nameController = TextEditingController();

    final ageController = TextEditingController();

    final phoneController = TextEditingController();

    String gender = 'male';

    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Add Traveller',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      CustomTextField(
                        controller: nameController,
                        label: 'Full Name',
                        hint: 'Enter name',
                        prefixIcon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name is required';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      CustomTextField(
                        controller: ageController,
                        label: 'Age',
                        hint: 'Age',
                        prefixIcon: Icons.calendar_today_outlined,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          final age = int.tryParse(value ?? '');

                          if (age == null || age <= 0 || age > 120) {
                            return 'Enter valid age';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      DropdownButtonFormField<String>(
                        initialValue: gender,
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                          prefixIcon: Icon(Icons.wc_outlined),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'male', child: Text('Male')),
                          DropdownMenuItem(
                            value: 'female',
                            child: Text('Female'),
                          ),
                          DropdownMenuItem(
                            value: 'other',
                            child: Text('Other'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setModalState(() {
                              gender = value;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 15),

                      CustomTextField(
                        controller: phoneController,
                        label: 'Phone Number',
                        hint: '9876543210',
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Phone number is required';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      CustomButton(
                        text: 'Save Traveller',
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }

                          final traveller = PassengerModel(
                            name: nameController.text.trim(),
                            age: int.parse(ageController.text.trim()),
                            gender: gender,
                            phone: phoneController.text.trim(),
                          );

                          final success = await context
                              .read<ProfileProvider>()
                              .addTraveller(traveller);

                          if (!context.mounted) {
                            return;
                          }

                          if (success) {
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Traveller saved successfully'),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      nameController.dispose();
      ageController.dispose();
      phoneController.dispose();
    });
  }

  // =====================================
  // DELETE
  // =====================================

  Future<void> _deleteTraveller(PassengerModel traveller) async {
    if (traveller.id == null) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Traveller'),
          content: Text('Do you want to delete ${traveller.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    final success = await context.read<ProfileProvider>().deleteTraveller(
      traveller.id!,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Traveller deleted'
              : context.read<ProfileProvider>().errorMessage ??
                    'Unable to delete traveller',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: CustomAppBar(
        title: widget.selectionMode ? 'Select Traveller' : 'Saved Travellers',
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTraveller,
        icon: const Icon(Icons.add),
        label: const Text('Add Traveller'),
      ),

      body: provider.isTravellerLoading
          ? const LoadingWidget(message: 'Loading travellers...')
          : provider.travellers.isEmpty
          ? EmptyState(
              icon: Icons.people_outline,
              title: 'No Saved Travellers',
              message: 'Save passenger details here so you can book flights faster next time.',
              buttonText: 'Add Traveller',
              onButtonPressed: _showAddTraveller,
            )
          : RefreshIndicator(
              onRefresh: () {
                return provider.loadTravellers();
              },
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                itemCount: provider.travellers.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final traveller = provider.travellers[index];

                  return _travellerCard(traveller);
                },
              ),
            ),
    );
  }

  Widget _travellerCard(PassengerModel traveller) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          _selectTraveller(traveller);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  traveller.name.isNotEmpty
                      ? traveller.name[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      traveller.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      '${traveller.age} years â€¢ ${_capitalize(traveller.gender)}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),

                    if (traveller.phone != null &&
                        traveller.phone!.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        traveller.phone!,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              if (widget.selectionMode)
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 17,
                  color: AppColors.primary,
                )
              else
                IconButton(
                  onPressed: () {
                    _deleteTraveller(traveller);
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _capitalize(String? value) {
    if (value == null || value.isEmpty) {
      return 'Other';
    }

    return value[0].toUpperCase() + value.substring(1);
  }
}
