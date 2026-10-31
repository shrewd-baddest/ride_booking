import 'package:flutter/material.dart';

class PaymentPriceRow extends StatelessWidget {
  const PaymentPriceRow({
    super.key,
    required this.title,
    required this.amount,
    this.valueColor = Colors.white,
  });

  final String title;
  final String amount;
  final Color valueColor;

  static const Color mutedColor = Color(0xFF536582);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: mutedColor, fontSize: 11)),
        Text(
          amount,
          style: TextStyle(
            color: valueColor,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
