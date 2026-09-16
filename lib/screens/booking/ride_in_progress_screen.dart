import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_booking/constants/app_colors.dart';
import 'package:ride_booking/constants/book_ride.dart';
import 'package:ride_booking/riverpods/providers.dart';
import 'package:ride_booking/screens/booking/ride_completed_screen.dart';
import 'package:ride_booking/screens/booking/statuspills.dart';
import 'package:ride_booking/screens/home/Widgets/ride_map.dart';

class RideInProgressScreen extends ConsumerWidget {
  const RideInProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driverAsync = ref.watch(driverDetailsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF0B1017),
                border: Border.all(color: const Color(0xFF26313F)),
                borderRadius: BorderRadius.circular(38),
              ),
              child: driverAsync.when(
                loading: () => const SizedBox(
                  height: 300,
                  child: Center(child: CircularProgressIndicator()),
                ),

                error: (error, stackTrace) => Padding(
                  padding: const EdgeInsets.all(30),
                  child: Center(
                    child: Text(
                      'Error: $error',
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ),

                data: (driver) {
                  // Replace these with your actual model fields
                  final vehicleRegistration =
                      driver?.vehicleRegistration ?? 'Unknown';

                  final vehicleColor = driver?.vehicleColor ?? 'Unknown';

                  final vehicleModel = driver?.vehicleModel ?? 'Unknown';

                  // This should come from your ride provider
                  final rideStatus = ref.watch(rideStatusProvider);

                  // This should come from your ETA/location logic
                  final etaMinutes = ref.watch(etaProvider);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 18,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // -----------------------------
                        // TOP NOTCH
                        // -----------------------------
                        Container(
                          width: 72,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Color(0xFF080C12),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                        ),

                        const SizedBox(height: 38),
                        StatusPill(status: rideStatus),

                        const SizedBox(height: 14),

                        // -----------------------------
                        // ETA
                        // --_etaText---------------------------
                        Text(
                          _etaText(rideStatus, etaMinutes),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 5),

                        // -----------------------------
                        // VEHICLE DETAILS
                        // -----------------------------
                        Text(
                          '$vehicleRegistration - '
                          '$vehicleColor $vehicleModel',
                          style: const TextStyle(
                            color: Color(0xFF66758A),
                            fontSize: 11,
                          ),
                        ),

                        const SizedBox(height: 22),

                        // -----------------------------
                        // PROGRESS
                        // -----------------------------
                        RideProgressTracker(status: rideStatus),

                        const SizedBox(height: 12),
                        RideMap(),

                        // You can add driver information here
                        // if you want it to appear below
                        //
                        // Text(driverName),
                        // Text(driverPhone),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _etaText(RideStatus status, int? etaMinutes) {
    switch (status) {
      case RideStatus.booked:
        return 'Waiting for driver';

      case RideStatus.enRoute:
        if (etaMinutes == null) {
          return 'Driver is on the way';
        }

        return 'Arriving in $etaMinutes min';

      case RideStatus.arrived:
        return 'Driver has arrived';

      case RideStatus.done:
        return 'Ride completed';
    }
  }
}
