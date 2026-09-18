import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import 'text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      // =========================
      // COLORS
      // =========================

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.surface,
        error: AppColors.error,
      ),

      scaffoldBackgroundColor:
          AppColors.background,

      // =========================
      // TEXT
      // =========================

      textTheme:
          AppTextTheme.lightTextTheme,

      // =========================
      // APP BAR
      // =========================

      appBarTheme: const AppBarTheme(
        backgroundColor:
            AppColors.surface,
        foregroundColor:
            AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor:
            Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color:
              AppColors.textPrimary,
        ),
        iconTheme: IconThemeData(
          color:
              AppColors.textPrimary,
        ),
      ),

      // =========================
      // ELEVATED BUTTON
      // =========================

      elevatedButtonTheme:
          ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              AppColors.primary,
          foregroundColor:
              Colors.white,

          elevation: 0,

          minimumSize: const Size(
            double.infinity,
            AppSizes.buttonHeight,
          ),

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              AppSizes.radiusMD,
            ),
          ),

          textStyle:
              const TextStyle(
            fontSize:
                AppSizes.fontLG,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ),

      // =========================
      // OUTLINED BUTTON
      // =========================

      outlinedButtonTheme:
          OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor:
              AppColors.primary,

          minimumSize: const Size(
            0,
            AppSizes.buttonHeight,
          ),

          side: const BorderSide(
            color: AppColors.border,
          ),

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              AppSizes.radiusMD,
            ),
          ),

          textStyle:
              const TextStyle(
            fontSize:
                AppSizes.fontMD,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ),

      // =========================
      // TEXT BUTTON
      // =========================

      textButtonTheme:
          TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor:
              AppColors.primary,
          textStyle:
              const TextStyle(
            fontSize:
                AppSizes.fontMD,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ),

      // =========================
      // INPUT FIELD
      // =========================

      inputDecorationTheme:
          InputDecorationTheme(
        filled: true,
        fillColor:
            AppColors.surface,

        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        hintStyle:
            const TextStyle(
          color:
              AppColors.textLight,
          fontSize:
              AppSizes.fontMD,
        ),

        labelStyle:
            const TextStyle(
          color:
              AppColors.textSecondary,
          fontSize:
              AppSizes.fontMD,
        ),

        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            AppSizes.radiusMD,
          ),
          borderSide:
              const BorderSide(
            color: AppColors.border,
          ),
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            AppSizes.radiusMD,
          ),
          borderSide:
              const BorderSide(
            color: AppColors.border,
          ),
        ),

        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            AppSizes.radiusMD,
          ),
          borderSide:
              const BorderSide(
            color:
                AppColors.primary,
            width: 1.5,
          ),
        ),

        errorBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            AppSizes.radiusMD,
          ),
          borderSide:
              const BorderSide(
            color:
                AppColors.error,
          ),
        ),

        focusedErrorBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            AppSizes.radiusMD,
          ),
          borderSide:
              const BorderSide(
            color:
                AppColors.error,
            width: 1.5,
          ),
        ),
      ),

      // =========================
      // CARD
      // =========================

      cardTheme: CardThemeData(
        color:
            AppColors.cardBackground,

        elevation: 0,

        surfaceTintColor:
            Colors.transparent,

        margin: EdgeInsets.zero,

        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
            AppSizes.cardRadius,
          ),
        ),
      ),

      // =========================
      // DIVIDER
      // =========================

      dividerTheme:
          const DividerThemeData(
        color:
            AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // =========================
      // ICON
      // =========================

      iconTheme:
          const IconThemeData(
        color:
            AppColors.textPrimary,
        size:
            AppSizes.iconMD,
      ),

      // =========================
      // BOTTOM NAVIGATION
      // =========================

      bottomNavigationBarTheme:
          const BottomNavigationBarThemeData(
        backgroundColor:
            AppColors.surface,

        selectedItemColor:
            AppColors.primary,

        unselectedItemColor:
            AppColors.textSecondary,

        selectedLabelStyle:
            TextStyle(
          fontSize: 12,
          fontWeight:
              FontWeight.w600,
        ),

        unselectedLabelStyle:
            TextStyle(
          fontSize: 12,
          fontWeight:
              FontWeight.w500,
        ),

        type:
            BottomNavigationBarType.fixed,

        elevation: 0,
      ),

      // =========================
      // NAVIGATION BAR
      // Material 3
      // =========================

      navigationBarTheme:
          NavigationBarThemeData(
        backgroundColor:
            AppColors.surface,

        elevation: 0,

        height:
            AppSizes.bottomNavHeight,

        indicatorColor:
            AppColors.primaryLight,

        iconTheme:
            WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(
              WidgetState.selected,
            )) {
              return const IconThemeData(
                color:
                    AppColors.primary,
              );
            }

            return const IconThemeData(
              color:
                  AppColors.textSecondary,
            );
          },
        ),

        labelTextStyle:
            WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(
              WidgetState.selected,
            )) {
              return const TextStyle(
                color:
                    AppColors.primary,
                fontSize: 12,
                fontWeight:
                    FontWeight.w600,
              );
            }

            return const TextStyle(
              color:
                  AppColors.textSecondary,
              fontSize: 12,
              fontWeight:
                  FontWeight.w500,
            );
          },
        ),
      ),

      // =========================
      // PROGRESS INDICATOR
      // =========================

      progressIndicatorTheme:
          const ProgressIndicatorThemeData(
        color:
            AppColors.primary,
      ),

      // =========================
      // CHECKBOX
      // =========================

      checkboxTheme:
          CheckboxThemeData(
        fillColor:
            WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(
              WidgetState.selected,
            )) {
              return AppColors.primary;
            }

            return Colors.transparent;
          },
        ),

        side:
            const BorderSide(
          color:
              AppColors.border,
        ),

        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(4),
        ),
      ),

      // =========================
      // RADIO
      // =========================

      radioTheme:
          RadioThemeData(
        fillColor:
            WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(
              WidgetState.selected,
            )) {
              return AppColors.primary;
            }

            return AppColors.textLight;
          },
        ),
      ),

      // =========================
      // SWITCH
      // =========================

      switchTheme:
          SwitchThemeData(
        thumbColor:
            WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(
              WidgetState.selected,
            )) {
              return Colors.white;
            }

            return Colors.white;
          },
        ),

        trackColor:
            WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(
              WidgetState.selected,
            )) {
              return AppColors.primary;
            }

            return AppColors.bookedSeat;
          },
        ),
      ),

      // =========================
      // SNACKBAR
      // =========================

      snackBarTheme:
          SnackBarThemeData(
        backgroundColor:
            const Color(0xFF1F2937),

        contentTextStyle:
            const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),

        behavior:
            SnackBarBehavior.floating,

        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
            AppSizes.radiusMD,
          ),
        ),
      ),

      // =========================
      // DIALOG
      // =========================

      dialogTheme:
          DialogThemeData(
        backgroundColor:
            AppColors.surface,

        surfaceTintColor:
            Colors.transparent,

        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
            AppSizes.radiusXL,
          ),
        ),
      ),

      // =========================
      // BOTTOM SHEET
      // =========================

      bottomSheetTheme:
          const BottomSheetThemeData(
        backgroundColor:
            AppColors.surface,

        surfaceTintColor:
            Colors.transparent,

        showDragHandle: true,
      ),

      // =========================
      // DATE PICKER
      // =========================

      datePickerTheme:
          DatePickerThemeData(
        backgroundColor:
            AppColors.surface,

        surfaceTintColor:
            Colors.transparent,

        headerBackgroundColor:
            AppColors.primary,

        headerForegroundColor:
            Colors.white,

        todayForegroundColor:
            const WidgetStatePropertyAll(
          AppColors.primary,
        ),

        todayBorder:
            const BorderSide(
          color:
              AppColors.primary,
        ),

        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
            AppSizes.radiusXL,
          ),
        ),
      ),
    );
  }
}

