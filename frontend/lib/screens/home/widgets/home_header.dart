import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onProfileTap;

  const HomeHeader({super.key, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 245,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: Color(0xFF0866E5)),
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Image.asset(
                'assets/images/flight_hero_v2.png',
                fit: BoxFit.contain,
                alignment: Alignment.topCenter,
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xA6003D93),
                    Color(0x220067D8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const Positioned(
              left: 22,
              top: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Safemarg',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      height: 1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Fly Smart, Travel Safe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 20,
              top: 20,
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F2FF),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.16),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: IconButton(
                    tooltip: 'Profile',
                    onPressed: onProfileTap,
                    icon: const Icon(
                      Icons.person_rounded,
                      color: Color(0xFF0866E5),
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
