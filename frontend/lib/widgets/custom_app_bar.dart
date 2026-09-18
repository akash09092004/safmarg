import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  final bool showBackButton;

  final List<Widget>? actions;

  final Widget? leading;

  final Color backgroundColor;

  final Color foregroundColor;

  final VoidCallback? onBack;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.leading,
    this.backgroundColor =
        AppColors.surface,
    this.foregroundColor =
        AppColors.textPrimary,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: foregroundColor,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,

      backgroundColor:
          backgroundColor,

      foregroundColor:
          foregroundColor,

      elevation: 0,

      surfaceTintColor:
          Colors.transparent,

      automaticallyImplyLeading:
          false,

      leading: leading ??
          (showBackButton
              ? IconButton(
                  icon: const Icon(
                    Icons
                        .arrow_back_ios_new,
                    size: 20,
                  ),
                  onPressed: onBack ??
                      () {
                        Navigator.maybePop(
                          context,
                        );
                      },
                )
              : null),

      actions: actions,
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(
        kToolbarHeight,
      );
}

