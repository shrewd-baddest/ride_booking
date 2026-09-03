import 'package:flutter/material.dart';
import 'package:ride_booking/screens/home/Widgets/ride_model.dart';

class RideCard extends StatelessWidget {
  final RideModel ride;
  final bool selected;
  final VoidCallback onTap;

  const RideCard({
    super.key,
    required this.ride,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),

        height: 101,

        decoration: BoxDecoration(
          color: selected ? const Color(0xFF111925) : const Color(0xFF101722),

          borderRadius: BorderRadius.circular(14),

          border: Border.all(
            color: selected ? const Color(0xFFF1CF00) : const Color(0xFF1E2A3B),

            width: selected ? 1.2 : 1,
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(ride.icon, style: const TextStyle(fontSize: 20)),

            const SizedBox(height: 3),

            Text(
              ride.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              ride.price,
              style: TextStyle(
                color: selected
                    ? const Color(0xFFF1CF00)
                    : const Color(0xFF8791A3),
                fontSize: 9,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              ride.time,
              style: const TextStyle(color: Color(0xFF52E39A), fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}
