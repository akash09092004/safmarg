import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/profile_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/loading_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  bool initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!initialized) {
      final user = context.read<ProfileProvider>().user;

      if (user != null) {
        nameController.text = user.name;

        emailController.text = user.email;

        phoneController.text = user.phone ?? '';
      }

      initialized = true;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();

    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<ProfileProvider>();

    final success = await provider.updateProfile(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      context.read<AuthProvider>().setUser(provider.user);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Profile update nahi hui.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    if (provider.isLoading && provider.user == null) {
      return const Scaffold(body: LoadingWidget(message: 'Loading profile...'));
    }

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: const CustomAppBar(title: 'Edit Profile'),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),

              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  nameController.text.isNotEmpty
                      ? nameController.text[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              CustomTextField(
                controller: nameController,
                label: 'Full Name',
                hint: 'Enter your name',
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }

                  if (value.trim().length < 2) {
                    return 'Enter valid name';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: emailController,
                label: 'Email',
                hint: 'Your email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                readOnly: true,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: phoneController,
                label: 'Phone Number',
                hint: 'Enter phone number',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null &&
                      value.trim().isNotEmpty &&
                      value.trim().length < 10) {
                    return 'Enter valid phone number';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              CustomButton(
                text: 'Save Changes',
                icon: Icons.save_outlined,
                isLoading: provider.isLoading,
                onPressed: provider.isLoading ? null : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
