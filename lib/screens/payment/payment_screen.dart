import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_booking/riverpods/providers.dart';
import 'confirm_payment_action.dart';
import 'payment_breakdown.dart';
import 'payment_header.dart';
import 'payment_option.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  String selectedPayment = 'M-Pesa';

  // Colors
  static const Color backgroundColor = Color(0xFF0D1117);
  static const Color yellowColor = Color(0xFFFFC928);

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'name': 'M-Pesa',
      'description': '+254 712 *** 456',
      'icon': Icons.apps,
      'color': Color(0xFF28452F),
    },
    {
      'name': 'Visa Card',
      'description': '**** **** 4821',
      'icon': Icons.credit_card,
      'color': Color(0xFF20334D),
    },
    {
      'name': 'Cash',
      'description': 'Pay driver directly',
      'icon': Icons.payments,
      'color': Color(0xFF34432C),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final totalPrice = ref.watch(priceProvider);

    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: Column(
          children: [
            // Main content
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  PaymentHeader(onBackPressed: () => Navigator.pop(context)),

                  const SizedBox(height: 22),

                  // Payment breakdown
                  PaymentBreakdown(totalPrice: totalPrice),

                  const SizedBox(height: 16),

                  // Payment method heading
                  const Text(
                    'PAYMENT METHOD',
                    style: TextStyle(
                      color: Color(0xFF536582),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Payment options
                  ...paymentMethods.map((method) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: PaymentOption(
                        method: method,
                        selectedPayment: selectedPayment,
                        onSelected: (name) {
                          setState(() {
                            selectedPayment = name;
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: 10),

            // Bottom payment button
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () => confirmPayment(context, selectedPayment),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellowColor,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Pay KSh $totalPrice via $selectedPayment',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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
