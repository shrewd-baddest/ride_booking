import 'package:flutter/material.dart';
import 'package:ride_booking/constants/app_colors.dart';
import 'package:ride_booking/constants/book_ride.dart';

class RideProgressTracker extends StatelessWidget {
  final RideStatus status;

  const RideProgressTracker({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final currentStep = _stepFromStatus(status);

    return Column(
      children: [
        Row(
          children: [
            _step(0, currentStep, Icons.check),
            _line(0, currentStep),

            _step(1, currentStep, Icons.directions_car),
            _line(1, currentStep),

            _step(2, currentStep, Icons.location_on),
            _line(2, currentStep),

            _step(3, currentStep, Icons.check),
          ],
        ),

        const SizedBox(height: 6),

        const Row(
          children: [
            Expanded(child: _Label('Booked')),
            Expanded(child: _Label('En\nRoute')),
            Expanded(child: _Label('Arrived')),
            Expanded(child: _Label('Done')),
          ],
        ),
      ],
    );
  }

  int _stepFromStatus(RideStatus status) {
    switch (status) {
      case RideStatus.booked:
        return 0;

      case RideStatus.enRoute:
        return 1;

      case RideStatus.arrived:
        return 2;

      case RideStatus.done:
        return 3;
    }
  }

  Widget _step(int step, int currentStep, IconData icon) {
    final isCompleted = step < currentStep;
    final isCurrent = step == currentStep;

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.success
            : isCurrent
            ? Colors.yellow
            : const Color(0xFF17202D),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 15,
        color: isCompleted || isCurrent
            ? Colors.black
            : const Color(0xFF354153),
      ),
    );
  }

  Widget _line(int step, int currentStep) {
    return Expanded(
      child: Container(
        height: 2,
        color: step < currentStep ? AppColors.success : const Color(0xFF202A38),
      ),
    );
  }
}

class RideCompletedScreen extends StatelessWidget {
  const RideCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Ride completed')));
  }
}

class _Label extends StatelessWidget {
  final String text;

  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Color(0xFF66758A), fontSize: 10),
    );
  }
}
