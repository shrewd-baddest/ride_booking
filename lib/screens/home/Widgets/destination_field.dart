import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_booking/riverpods/providers.dart';

class DestinationField extends ConsumerStatefulWidget {
  const DestinationField({super.key});

  @override
  ConsumerState<DestinationField> createState() => _DestinationFieldState();
}

class _DestinationFieldState extends ConsumerState<DestinationField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF111825),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8C500), width: 1.2),
      ),
      child: Row(
        children: [
          const Text('🔍', style: TextStyle(fontSize: 12)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (value) {
                ref.read(destinationProvider.notifier).state = value;
              },
              decoration: const InputDecoration(
                hintText: 'Where to?',
                hintStyle: TextStyle(color: Color(0xFFDDE1E8), fontSize: 12),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
