import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class AirlineCard extends StatelessWidget {
  final String name;

  final String? imagePath;

  final VoidCallback? onTap;

  const AirlineCard({
    super.key,
    required this.name,
    this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius:
          BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: 110,
        padding:
            const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(alpha: .05),
              blurRadius: 15,
              offset:
                  const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 55,
              child: imagePath != null
                  ? Image.asset(
                      imagePath!,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (_, _, _) {
                        return const Icon(
                          Icons.flight,
                          size: 42,
                          color:
                              AppColors
                                  .primary,
                        );
                      },
                    )
                  : const Icon(
                      Icons.flight,
                      size: 42,
                      color:
                          AppColors.primary,
                    ),
            ),

            const SizedBox(height: 10),

            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              style:
                  const TextStyle(
                fontSize: 13,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

