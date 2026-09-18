import 'package:flutter/material.dart';

class TripTypeTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const TripTypeTabs({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final titles = [
      "One Way",
      "Round Trip",
      "Multi City",
    ];

    return Row(
      children: List.generate(
        titles.length,
        (index) {
          final selected =
              selectedIndex == index;

          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () => onChanged(index),
                child: AnimatedContainer(
                duration:
                    const Duration(milliseconds: 200),
                height: 52,
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  right:
                      index != titles.length - 1
                          ? 8
                          : 0,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xff0866e5)
                      : const Color(0xfff5f7fb),
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: Text(
                  titles[index],
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : const Color(0xff4f5668),
                    fontSize: 15,
                    fontWeight: selected
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
