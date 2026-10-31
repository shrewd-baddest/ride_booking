import 'package:flutter/material.dart';

class PaymentHeader extends StatelessWidget {
  const PaymentHeader({super.key, required this.onBackPressed});

  final VoidCallback onBackPressed;

  static const Color yellowColor = Color(0xFFFFC928);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onBackPressed,
          child: const Icon(Icons.arrow_back, color: yellowColor, size: 18),
        ),
        const SizedBox(width: 12),
        const Text(
          'Confirm Payment',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
