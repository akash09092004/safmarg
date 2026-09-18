import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/seat_model.dart';

class SeatWidget extends StatelessWidget {
  final SeatModel seat;

  final VoidCallback? onTap;

  final double size;

  const SeatWidget({
    super.key,
    required this.seat,
    this.onTap,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        _backgroundColor();

    final borderColor =
        _borderColor();

    final textColor =
        _textColor();

    return GestureDetector(
      onTap:
          seat.isAvailable ? onTap : null,
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 180),

        width: size,
        height: size,

        alignment: Alignment.center,

        decoration: BoxDecoration(
          color: backgroundColor,

          borderRadius:
              BorderRadius.circular(9),

          border: Border.all(
            color: borderColor,
            width:
                seat.isSelected ? 2 : 1,
          ),
        ),

        child: Text(
          seat.seatNumber,
          style: TextStyle(
            color: textColor,
            fontSize: 11,
            fontWeight:
                FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Color _backgroundColor() {
    if (!seat.isAvailable) {
      return AppColors.bookedSeat;
    }

    if (seat.isSelected) {
      return AppColors.selectedSeat;
    }

    switch (seat.seatClass) {
      case 'business':
        return const Color(
          0xfffff3db,
        );

      case 'premium_economy':
        return const Color(
          0xfff3ecff,
        );

      default:
        return Colors.white;
    }
  }

  Color _borderColor() {
    if (!seat.isAvailable) {
      return AppColors.bookedSeat;
    }

    if (seat.isSelected) {
      return AppColors.primary;
    }

    switch (seat.seatClass) {
      case 'business':
        return AppColors.warning;

      case 'premium_economy':
        return const Color(
          0xff8b5cf6,
        );

      default:
        return AppColors.primary;
    }
  }

  Color _textColor() {
    if (!seat.isAvailable) {
      return Colors.white;
    }

    if (seat.isSelected) {
      return Colors.white;
    }

    return AppColors.textPrimary;
  }
}

