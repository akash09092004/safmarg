import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/route_names.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/helpers.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  bool acceptTerms = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  Future<void> _signup() async {
    Helpers.hideKeyboard(context);

    if (_formKey.currentState?.validate() != true) {
      return;
    }

    if (!acceptTerms) {
      Helpers.showError(context, 'Please accept Terms & Conditions');

      return;
    }

    final provider = context.read<AuthProvider>();

    final success = await provider.register(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      password: passwordController.text,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      context.read<ProfileProvider>().setProfile(provider.user);
      Helpers.showSuccess(context, 'Account created successfully');

      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.main,
        (route) => false,
      );
    } else {
      Helpers.showError(context, provider.errorMessage ?? 'Signup failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 35),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Join SafMarg',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
                ),

                const SizedBox(height: 7),

                const Text(
                  'Create your account and start booking flights',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),

                const SizedBox(height: 30),

                CustomTextField(
                  controller: nameController,
                  label: 'Full Name',
                  hint: 'Enter full name',
                  prefixIcon: Icons.person_outline,
                  validator: Validators.name,
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller: emailController,
                  label: 'Email',
                  hint: 'Enter email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller: phoneController,
                  label: 'Phone Number',
                  hint: '9876543210',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller: passwordController,
                  label: 'Password',
                  hint: 'Create password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  showPasswordToggle: true,
                  validator: Validators.password,
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller: confirmPasswordController,
                  label: 'Confirm Password',
                  hint: 'Enter password again',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  showPasswordToggle: true,
                  validator: (value) {
                    return Validators.confirmPassword(
                      value,
                      passwordController.text,
                    );
                  },
                ),

                const SizedBox(height: 15),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          acceptTerms = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Wrap(
                          children: [
                            const Text('I agree to the '),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, RouteNames.terms);
                              },
                              child: const Text(
                                'Terms & Conditions',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Text(' and '),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  RouteNames.privacyPolicy,
                                );
                              },
                              child: const Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                CustomButton(
                  text: 'Create Account',
                  isLoading: provider.isLoading,
                  onPressed: _signup,
                ),

                const SizedBox(height: 22),

                Column(
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
