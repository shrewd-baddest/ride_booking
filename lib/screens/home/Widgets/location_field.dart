import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_booking/riverpods/providers.dart';

class LocationField extends ConsumerStatefulWidget {
  const LocationField({super.key});

  @override
  ConsumerState<LocationField> createState() => _LocationFieldState();
}

class _LocationFieldState extends ConsumerState<LocationField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(locationNameProvider));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String>(locationNameProvider, (previous, next) {
      if (_controller.text == next) {
        return;
      }

      _controller.value = _controller.value.copyWith(
        text: next,
        selection: TextSelection.collapsed(offset: next.length),
        composing: TextRange.empty,
      );
    });

    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF111825),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1A2638)),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Color(0xFF43D985),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (value) {
                ref.read(locationNameProvider.notifier).state = value;
              },
              style: const TextStyle(fontSize: 12, color: Color(0xFFE7EAF0)),
              decoration: const InputDecoration(
                hintText: 'Current location',
                hintStyle: TextStyle(fontSize: 12, color: Color(0xFFDDE1E8)),
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
