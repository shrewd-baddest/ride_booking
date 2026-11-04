import 'package:flutter/material.dart';
import 'package:ride_booking/constants/app_colors.dart';

class PaymentPhoneDialog extends StatefulWidget {
  final Future<void> Function(String phoneNumber) onPay;

  const PaymentPhoneDialog({super.key, required this.onPay});

  @override
  State<PaymentPhoneDialog> createState() => _PaymentPhoneDialogState();
}

class _PaymentPhoneDialogState extends State<PaymentPhoneDialog> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      String phone = _phoneController.text.trim();

      // Convert 07XXXXXXXX to 2547XXXXXXXX.
      if (phone.startsWith('0')) {
        phone = '254${phone.substring(1)}';
      }

      await widget.onPay(phone);

      

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Payment request failed. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'M-Pesa Payment',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter the phone number that should receive the M-Pesa payment prompt.',
              style: TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color:AppColors.mutedText), 
              decoration: InputDecoration(
                labelText: 'M-Pesa phone number',
                hintText: '07XXXXXXXX',
                prefixIcon: const Icon(Icons.phone_android),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a phone number';
                }

                final phone = value.trim();

                final valid = RegExp(
                  r'^(07|01)\d{8}$|^254[17]\d{8}$',
                ).hasMatch(phone);

                if (!valid) {
                  return 'Enter a valid Kenyan phone number';
                }

                return null;
              },
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),

        ElevatedButton(
          onPressed: _isLoading ? null : _submitPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Send STK Push'),
        ),
      ],
    );
  }
}
