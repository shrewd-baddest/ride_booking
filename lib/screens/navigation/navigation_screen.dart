import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_booking/riverpods/providers.dart';
import 'package:ride_booking/screens/history/ride_history_screen.dart';
import 'package:ride_booking/screens/home/Widgets/booking_bottom_nav.dart';
import 'package:ride_booking/screens/home/home_screen.dart';
import 'package:ride_booking/screens/payment/payment_screen.dart';
import 'package:ride_booking/screens/profile/profile_screen.dart';

class NavigationScreen extends ConsumerWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: IndexedStack(
        index: ref.watch(selectProvider),
        children: const [
          RideBookingScreen(),
          RideHistoryScreen(),
          PaymentScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: const BookingBottomNav(),
    );
  }
}
