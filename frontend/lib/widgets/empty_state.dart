import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import 'custom_button.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;

  final String title;

  final String message;

  final String? buttonText;

  final VoidCallback? onButtonPressed;

  const EmptyState({
    super.key,
    this.icon = Icons
        .inbox_outlined,
    required this.title,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(30),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Container(
              height: 90,
              width: 90,
              decoration:
                  const BoxDecoration(
                color:
                    AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 45,
                color:
                    AppColors.primary,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              title,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(
                fontSize: 21,
                fontWeight:
                    FontWeight.w700,
                color:
                    AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              message,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(
                fontSize: 14,
                color:
                    AppColors.textSecondary,
                height: 1.4,
              ),
            ),

            if (buttonText != null &&
                onButtonPressed !=
                    null) ...[
              const SizedBox(height: 24),

              SizedBox(
                width: 180,
                child: CustomButton(
                  text: buttonText!,
                  onPressed:
                      onButtonPressed,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

