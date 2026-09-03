import 'package:flutter/material.dart';
import 'package:ride_booking/screens/home/Widgets/ride_model.dart';

class BookRideButton extends StatelessWidget {
  final RideModel ride;
  final VoidCallback onPressed;

  const BookRideButton({
    super.key,
    required this.ride,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: onPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF2BC00),
          foregroundColor: const Color(0xFF080B10),
          elevation: 0,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🚕', style: TextStyle(fontSize: 14)),

            const SizedBox(width: 9),

            Text(
              'Book ${ride.name} • ${ride.price}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
