import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_booking/Models/input_validators.dart';
import 'package:ride_booking/riverpods/providers.dart';
import 'package:ride_booking/widgets/textField.dart';

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
    return CustomTextField(
      title: 'Destination',
      hintText: 'Where to?',
      controller: _controller,
      prefixIcon: const Icon(Icons.search),
      validator: InputValidators.required,
      onChanged: (value) {
        ref.read(destinationProvider.notifier).state = value;
      },
    );
  }
}
