import 'package:flutter/material.dart';

class BookingHeader extends StatelessWidget {
  const BookingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '▦  HOME / BOOK',
      style: TextStyle(
        color: Color(0xFF576174),
        fontSize: 9,
        letterSpacing: 1.5,
      ),
    );
  }
}
