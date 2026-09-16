import 'package:flutter/material.dart';
import 'package:ride_booking/Models/driver_model.dart';

class FindingDriverScreen extends StatelessWidget {
  const FindingDriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Finding your driver...')));
  }
}

class DriverCard extends StatelessWidget {
  final Driver driver;

  const DriverCard({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Driver avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF374151),
            child: const Text('👨‍🦱', style: TextStyle(fontSize: 24)),
          ),

          const SizedBox(width: 12),

          // Driver information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  driver.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                // Rating
                Row(
                  children: [
                    Row(
                      children: List.generate(
                        5,
                        (index) => const Icon(
                          Icons.star,
                          color: Color(0xFFFFD600),
                          size: 14,
                        ),
                      ),
                    ),

                    const SizedBox(width: 5),

                    Text(
                      '5.0',
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ],
                ),

                const SizedBox(height: 3),

                // Vehicle
                Text(
                  '${driver.vehicleModel} · ${driver.vehicleRegistration}',
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
