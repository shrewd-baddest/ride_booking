import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_booking/Models/input_validators.dart';
import 'package:ride_booking/riverpods/providers.dart';
import 'package:ride_booking/widgets/textField.dart';

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

    return CustomTextField(
      title: 'Pickup location',
      hintText: 'Current location',
      controller: _controller,
      prefixIcon: const Icon(Icons.my_location),
      validator: InputValidators.required,
      onChanged: (value) {
        ref.read(locationNameProvider.notifier).state = value;
      },
    );
  }
}
