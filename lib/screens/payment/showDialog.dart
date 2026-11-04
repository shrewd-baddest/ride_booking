import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_booking/riverpods/providers.dart';
import 'package:ride_booking/screens/payment/paymentDialog.dart';

void showPaymentDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return PaymentPhoneDialog(
        onPay: (phoneNumber) async {
          await ref
              .read(paymentProvider.notifier)
              .initiatePayment(phoneNumber);
        },
      );
    },
  );
}
