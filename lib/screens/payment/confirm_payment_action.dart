import 'package:flutter/material.dart';

void confirmPayment(BuildContext context, String selectedPayment) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Proceeding with $selectedPayment payment...'),
      backgroundColor: const Color(0xFF202A3A),
    ),
  );

  // TODO: Integrate your actual payment processing logic here.
  // M-Pesa: Initiate STK Push.
  // Visa: Navigate to card payment.
  // Cash: Confirm cash payment.
}
