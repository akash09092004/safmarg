import 'package:flutter/material.dart';

import '../../app/route_names.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../core/network/api_client.dart';
import '../../core/utils/helpers.dart';
import '../../core/utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({
    super.key,
    required this.email,
  });

  @override
  State<OtpScreen> createState() =>
      _OtpScreenState();
}

class _OtpScreenState
    extends State<OtpScreen> {
  final formKey =
      GlobalKey<FormState>();

  final otpController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final confirmPasswordController =
      TextEditingController();

  bool loading = false;
  bool resendLoading = false;

  @override
  void dispose() {
    otpController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  Future<void> verifyOtp() async {
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
      '${ApiConstants.baseUrl}/auth/verify-otp',
      body: {
        'email': widget.email,
        'otp':
            otpController.text.trim(),
        'newPassword':
            passwordController.text,
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
      'Password changed successfully',
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.login,
      (route) => false,
    );
  }

  Future<void> resendOtp() async {
    setState(() {
      resendLoading = true;
    });

    final response =
        await ApiClient.instance.post(
      '${ApiConstants.baseUrl}/auth/forgot-password',
      body: {
        'email': widget.email,
      },
    );

    if (!mounted) {
      return;
    }

    setState(() {
      resendLoading = false;
    });

    if (response.success) {
      Helpers.showSuccess(
        context,
        'OTP sent again',
      );
    } else {
      Helpers.showError(
        context,
        response.message,
      );
    }
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
                height: 20,
              ),

              Container(
                height: 100,
                width: 100,
                decoration:
                    const BoxDecoration(
                  color:
                      AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons
                      .verified_user_outlined,
                  size: 50,
                  color:
                      AppColors.primary,
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              const Text(
                'Verify OTP',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              Text(
                'OTP sent to\n${widget.email}',
                textAlign:
                    TextAlign.center,
                style: const TextStyle(
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
                    otpController,
                label: 'OTP',
                hint:
                    'Enter OTP',
                prefixIcon:
                    Icons.password_outlined,
                keyboardType:
                    TextInputType.number,
                validator:
                    Validators.otp,
              ),

              const SizedBox(
                height: 18,
              ),

              CustomTextField(
                controller:
                    passwordController,
                label: 'New Password',
                hint:
                    'Enter new password',
                prefixIcon:
                    Icons.lock_outline,
                obscureText: true,
                showPasswordToggle: true,
                validator:
                    Validators.password,
              ),

              const SizedBox(
                height: 18,
              ),

              CustomTextField(
                controller:
                    confirmPasswordController,
                label:
                    'Confirm New Password',
                hint:
                    'Enter password again',
                prefixIcon:
                    Icons.lock_outline,
                obscureText: true,
                showPasswordToggle: true,
                validator: (value) {
                  return Validators
                      .confirmPassword(
                    value,
                    passwordController.text,
                  );
                },
              ),

              const SizedBox(
                height: 25,
              ),

              CustomButton(
                text:
                    'Verify & Reset Password',
                isLoading: loading,
                onPressed: verifyOtp,
              ),

              const SizedBox(
                height: 15,
              ),

              TextButton(
                onPressed:
                    resendLoading
                        ? null
                        : resendOtp,
                child: resendLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Didn't receive OTP? Resend",
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
