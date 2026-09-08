import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_booking/Models/ride_model.dart';
import 'package:ride_booking/riverpods/providers.dart';
import 'package:ride_booking/routes/route_names.dart';
import 'package:ride_booking/screens/home/Widgets/book_ride_button.dart';
import 'package:ride_booking/screens/home/Widgets/booking_bottom_nav.dart';
import 'package:ride_booking/screens/home/Widgets/booking_header.dart';
import 'package:ride_booking/screens/home/Widgets/destination_field.dart';
import 'package:ride_booking/screens/home/Widgets/location_field.dart';
import 'package:ride_booking/screens/home/Widgets/ride_map.dart';
import 'package:ride_booking/screens/home/Widgets/ride_model.dart';
import 'package:ride_booking/screens/home/Widgets/ride_selector.dart';

class RideBookingScreen extends ConsumerStatefulWidget {
  const RideBookingScreen({super.key});

  @override
  ConsumerState<RideBookingScreen> createState() => _RideBookingScreenState();
}

class _RideBookingScreenState extends ConsumerState<RideBookingScreen> {
  int selectedRide = 0;

  final List<RideModel> rides = const [
    RideModel(icon: '🚕', name: 'Economy', price: 'KSh 320', time: '3 min'),
    RideModel(icon: '🚙', name: 'Comfort', price: 'KSh 520', time: '5 min'),
    RideModel(icon: '🚐', name: 'XL', price: 'KSh 740', time: '8 min'),
  ];

  @override
  Widget build(BuildContext context) {
    final currentRide = rides[selectedRide];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 25),

            const BookingHeader(),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const RideMap(),

                      const SizedBox(height: 14),

                      const LocationField(),

                      const SizedBox(height: 8),

                      const DestinationField(),

                      const SizedBox(height: 15),

                      RideSelector(
                        rides: rides,
                        selectedIndex: selectedRide,
                        onSelected: (index) {
                          setState(() {
                            selectedRide = index;
                          });
                          ref.read(rideProvider.notifier).state =
                              rides[index].name;
                        },
                      ),

                      const SizedBox(height: 15),

                      BookRideButton(
                        ride: currentRide,
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.maybeOf(context);
                          final ride = Ride(
                            id: 0,
                            driverId: null,
                            userId: ref.read(userIdProvider),
                            fromLocation:
                                ref.read(locationNameProvider).trim().isNotEmpty
                                ? ref.read(locationNameProvider)
                                : 'Westlands, Nairobi',
                            toLocation:
                                ref.read(destinationProvider).trim().isNotEmpty
                                ? ref.read(destinationProvider)
                                : 'Nairobi CBD',
                            distance: 12.5,
                            duration: 18,
                            createdAt: DateTime.now(),
                          );

                          await ref
                              .read(rideBookingProvider.notifier)
                              .bookRide(ride);

                          final state = ref.read(rideBookingProvider);
                          final message =
                              state.value ??
                              state.error?.toString() ??
                              'Ride booking failed';

                          if (mounted && messenger != null) {
                            messenger.showSnackBar(
                              SnackBar(content: Text(message)),
                            );
                          }
                          if (!context.mounted) return;

                          Navigator.pushNamed(
                            context,
                            RouteNames.rideInProgress,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BookingBottomNav(),
    );
  }
}
