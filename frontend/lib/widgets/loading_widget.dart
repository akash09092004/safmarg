import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;

  final double size;

  const LoadingWidget({
    super.key,
    this.message,
    this.size = 38,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: size,
            width: size,
            child:
                const CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.primary,
            ),
          ),

          if (message != null) ...[
            const SizedBox(height: 16),

            Text(
              message!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color:
                    AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

