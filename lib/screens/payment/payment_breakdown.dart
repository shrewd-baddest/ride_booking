import 'package:flutter/material.dart';

import 'payment_price_row.dart';

class PaymentBreakdown extends StatelessWidget {
  const PaymentBreakdown({super.key, required this.totalPrice});

  final int totalPrice;

  static const Color cardColor = Color(0xFF121927);
  static const Color yellowColor = Color(0xFFFFC928);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF202A3A)),
      ),
      child: Column(
        children: [
          const PaymentPriceRow(title: 'Base fare', amount: 'KSh xxx'),
          const SizedBox(height: 10),
          const PaymentPriceRow(title: 'Distance (4.2 km)', amount: 'KSh xxx'),
          const SizedBox(height: 10),
          const PaymentPriceRow(title: 'Time (12 min)', amount: 'KSh xxx'),
          const SizedBox(height: 10),
          const PaymentPriceRow(title: 'Booking fee', amount: 'KSh xxx'),
          const SizedBox(height: 10),
          const PaymentPriceRow(
            title: 'Promo discount',
            amount: '-KSh xxx',
            valueColor: Color(0xFF00D68F),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: Color(0xFF263144), height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'KSh $totalPrice',
                style: TextStyle(
                  color: yellowColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
