import 'package:flutter/material.dart';
import 'package:ride_booking/constants/app_colors.dart';
import 'package:ride_booking/constants/book_ride.dart';

class StatusPill extends StatelessWidget {
  final RideStatus status;

  const StatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final text = switch (status) {
      RideStatus.booked => 'Ride Booked',
      RideStatus.enRoute => 'Driver Approaching',
      RideStatus.arrived => 'Driver Arrived',
      RideStatus.done => 'Ride Completed',
    };

    final iconColor = switch (status) {
      RideStatus.booked => Colors.orange,
      RideStatus.enRoute => AppColors.success,
      RideStatus.arrived => Colors.blue,
      RideStatus.done => AppColors.success,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2A20),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: iconColor, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
          ),

          const SizedBox(width: 7),

          Text(
            text,
            style: TextStyle(
              color: iconColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
