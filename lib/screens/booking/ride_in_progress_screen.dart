import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_booking/constants/book_ride.dart';
import 'package:ride_booking/riverpods/providers.dart';
import 'package:ride_booking/screens/home/Widgets/ride_map.dart';

class RideInProgressScreen extends ConsumerWidget {
  const RideInProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driver = ref.watch(driverDetailsProvider);
    return Scaffold(
      body: driver.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (error, stackTrace) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(
              fontSize: 24,
              color: Color.fromARGB(255, 155, 88, 88),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        data: (driver) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Driver: ${driver?.name ?? "Unknown"} Approaching...',
              style: const TextStyle(
                fontSize: 24,
                color: Color.fromARGB(255, 155, 88, 88),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Driver Phone: ${driver?.phoneNumber ?? "Unknown"}',
              style: const TextStyle(
                fontSize: 24,
                color: Color.fromARGB(255, 155, 88, 88),
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...BookRideConstants.rideOptions.map(
                  (option) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Icon(
                          option['icon'],
                          size: 48,
                          color: Color.fromARGB(255, 155, 88, 88),
                        ),
                        Text(
                          option['label'] ?? '',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Color.fromARGB(255, 155, 88, 88),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            RideMap(),
          ],
        ),
      ),
    );
  }
}
