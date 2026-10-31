import 'package:flutter/material.dart';

class PaymentOption extends StatelessWidget {
  const PaymentOption({
    super.key,
    required this.method,
    required this.selectedPayment,
    required this.onSelected,
  });

  final Map<String, dynamic> method;
  final String selectedPayment;
  final ValueChanged<String> onSelected;

  static const Color cardColor = Color(0xFF121927);
  static const Color yellowColor = Color(0xFFFFC928);
  static const Color mutedColor = Color(0xFF536582);

  @override
  Widget build(BuildContext context) {
    final String name = method['name'];
    final bool isSelected = selectedPayment == name;

    return GestureDetector(
      onTap: () => onSelected(name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 62,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF171B1D) : cardColor,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: isSelected ? yellowColor : const Color(0xFF202A3A),
            width: isSelected ? 1.2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: method['color'],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                method['icon'],
                color: name == 'M-Pesa'
                    ? yellowColor
                    : name == 'Cash'
                    ? const Color(0xFF5DDE83)
                    : const Color(0xFF38BDF8),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    method['description'],
                    style: const TextStyle(color: mutedColor, fontSize: 9),
                  ),
                ],
              ),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? yellowColor : const Color(0xFF263144),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: yellowColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
