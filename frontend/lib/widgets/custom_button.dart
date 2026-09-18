import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  final bool isLoading;

  final Color? backgroundColor;
  final Color? foregroundColor;

  final double? width;
  final double height;

  final IconData? icon;

  final bool outlined;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height = AppSizes.buttonHeight,
    this.icon,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 20,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          );

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: outlined
          ? OutlinedButton(
              onPressed:
                  isLoading ? null : onPressed,
              style:
                  OutlinedButton.styleFrom(
                foregroundColor:
                    foregroundColor ??
                        AppColors.primary,
                side: BorderSide(
                  color:
                      backgroundColor ??
                          AppColors.primary,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    AppSizes.radiusMD,
                  ),
                ),
              ),
              child: child,
            )
          : ElevatedButton(
              onPressed:
                  isLoading ? null : onPressed,
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    backgroundColor ??
                        AppColors.primary,
                foregroundColor:
                    foregroundColor ??
                        Colors.white,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    AppSizes.radiusMD,
                  ),
                ),
              ),
              child: child,
            ),
    );
  }
}

