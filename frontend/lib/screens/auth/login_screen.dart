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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future<void> _login() async {
    Helpers.hideKeyboard(context);

    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.login(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      context.read<ProfileProvider>().setProfile(authProvider.user);
      Helpers.showSuccess(context, 'Login successful');

      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.main,
        (route) => false,
      );
    } else {
      Helpers.showError(context, authProvider.errorMessage ?? 'Login failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 50),

                Container(
                  width: 95,
                  height: 95,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.flight_takeoff_rounded,
                    size: 50,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Login to continue your journey',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 40),

                CustomTextField(
                  controller: emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),

                const SizedBox(height: 18),

                CustomTextField(
                  controller: passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  showPasswordToggle: true,
                  validator: Validators.password,
                ),

                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RouteNames.forgotPassword);
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ),

                const SizedBox(height: 18),

                CustomButton(
                  text: 'Login',
                  isLoading: authProvider.isLoading,
                  onPressed: _login,
                ),

                const SizedBox(height: 30),

                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RouteNames.signup);
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
