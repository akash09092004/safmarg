import 'package:flutter/material.dart';

import '../../app/route_names.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../core/network/api_client.dart';
import '../../core/utils/helpers.dart';
import '../../core/utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class ForgotPasswordScreen
    extends StatefulWidget {
  const ForgotPasswordScreen({
    super.key,
  });

  @override
  State<ForgotPasswordScreen>
      createState() =>
          _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final formKey =
      GlobalKey<FormState>();

  final emailController =
      TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  Future<void> sendOtp() async {
    Helpers.hideKeyboard(context);

    if (formKey.currentState?.validate() !=
        true) {
      return;
    }

    setState(() {
      loading = true;
    });

    final response =
        await ApiClient.instance.post(
      '${ApiConstants.baseUrl}/auth/forgot-password',
      body: {
        'email':
            emailController.text.trim(),
      },
    );

    if (!mounted) {
      return;
    }

    setState(() {
      loading = false;
    });

    if (!response.success) {
      Helpers.showError(
        context,
        response.message,
      );

      return;
    }

    Helpers.showSuccess(
      context,
      response.message,
    );

    Navigator.pushNamed(
      context,
      RouteNames.otp,
      arguments:
          emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),

              Container(
                width: 100,
                height: 100,
                decoration:
                    const BoxDecoration(
                  color:
                      AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons
                      .lock_reset_outlined,
                  size: 50,
                  color:
                      AppColors.primary,
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              const Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              const Text(
                'Enter your registered email. We will send an OTP to reset your password.',
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  color:
                      AppColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const SizedBox(
                height: 35,
              ),

              CustomTextField(
                controller:
                    emailController,
                label:
                    'Registered Email',
                hint:
                    'Enter your email',
                prefixIcon:
                    Icons.email_outlined,
                keyboardType:
                    TextInputType
                        .emailAddress,
                validator:
                    Validators.email,
              ),

              const SizedBox(
                height: 25,
              ),

              CustomButton(
                text: 'Send OTP',
                isLoading: loading,
                onPressed: sendOtp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
