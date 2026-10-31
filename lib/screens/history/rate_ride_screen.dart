import 'package:flutter/material.dart';
import 'package:ride_booking/Models/ride_model.dart';
import 'package:ride_booking/screens/history/ride_history_screen.dart';

class RideCard extends StatelessWidget {
  final Ride ride;

  const RideCard({super.key, required this.ride});

  static const Color cardColor = Color(0xFF111725);
  static const Color mutedColor = Color(0xFF50617F);
  static const Color yellowColor = Color(0xFFFFD21F);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 12, 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF202939), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date, time and fare
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${ride.date}, ${ride.time}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '${ride.category} · ${ride.driver}',
                      style: const TextStyle(fontSize: 9, color: mutedColor),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Text(
                'KSh ${ride.fare}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: yellowColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 11),

          // Pickup location
          LocationRow(color: const Color(0xFF43D98B), location: ride.pickup),

          const SizedBox(height: 8),

          // Destination location
          LocationRow(
            color: const Color(0xFFFF747B),
            location: ride.destination,
          ),

          const SizedBox(height: 10),

          // Divider
          Container(height: 1, color: const Color(0xFF202939)),

          const SizedBox(height: 9),

          // Payment information and rating
          Row(
            children: [
              PaymentDetails(
                paymentMethod: ride.paymentMethod,
                status: ride.status,
              ),

              const Spacer(),

              RideRating(rating: ride.rating),
            ],
          ),
        ],
      ),
    );
  }
}
