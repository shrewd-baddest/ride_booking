import 'package:flutter/material.dart';
import 'package:ride_booking/routes/route_names.dart';
import 'package:ride_booking/screens/auth/login_screen.dart';
import 'package:ride_booking/screens/auth/register_screen.dart';
import 'package:ride_booking/screens/booking/cancel_ride_screen.dart';
import 'package:ride_booking/screens/booking/confirm_booking_screen.dart';
import 'package:ride_booking/screens/booking/finding_driver_screen.dart';
import 'package:ride_booking/screens/booking/location_search_screen.dart';
import 'package:ride_booking/screens/booking/ride_completed_screen.dart';
import 'package:ride_booking/screens/booking/ride_in_progress_screen.dart';
import 'package:ride_booking/screens/history/rate_ride_screen.dart';
import 'package:ride_booking/screens/history/ride_details_screen.dart';
import 'package:ride_booking/screens/history/ride_history_screen.dart';
import 'package:ride_booking/screens/home/home_screen.dart';
import 'package:ride_booking/screens/navigation/navigation_screen.dart';
import 'package:ride_booking/screens/payment/add_card_screen.dart';
import 'package:ride_booking/screens/payment/payment_failed_screen.dart';
import 'package:ride_booking/screens/payment/payment_methods_screen.dart';
import 'package:ride_booking/screens/payment/payment_screen.dart';
import 'package:ride_booking/screens/payment/payment_success_screen.dart';
import 'package:ride_booking/screens/profile/edit_profile_screen.dart';
import 'package:ride_booking/screens/profile/profile_screen.dart';
import 'package:ride_booking/screens/profile/saved_places_screen.dart';
import 'package:ride_booking/screens/profile/settings_screen.dart';
import 'package:ride_booking/screens/safety/emergency_contacts_screen.dart';
import 'package:ride_booking/screens/safety/safety_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case RouteNames.register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );

      case RouteNames.navigation:
        return MaterialPageRoute(
          builder: (_) => const NavigationScreen(),
          settings: settings,
        );

      case RouteNames.home:
        return MaterialPageRoute(
          builder: (_) => const RideBookingScreen(),
          settings: settings,
        );

      case RouteNames.history:
        return MaterialPageRoute(
          builder: (_) => const RideHistoryScreen(),
          settings: settings,
        );

      case RouteNames.payment:
        return MaterialPageRoute(
          builder: (_) => const PaymentScreen(),
          settings: settings,
        );

      case RouteNames.profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
          settings: settings,
        );

      case RouteNames.searchLocation:
        return MaterialPageRoute(
          builder: (_) => const LocationSearchScreen(),
          settings: settings,
        );

      case RouteNames.confirmBooking:
        return MaterialPageRoute(
          builder: (_) => const ConfirmBookingScreen(),
          settings: settings,
        );

      case RouteNames.findingDriver:
        return MaterialPageRoute(
          builder: (_) => const FindingDriverScreen(),
          settings: settings,
        );

      case RouteNames.rideInProgress:
        return MaterialPageRoute(
          builder: (_) => const RideInProgressScreen(),
          settings: settings,
        );

      case RouteNames.rideCompleted:
        return MaterialPageRoute(
          builder: (_) => const RideCompletedScreen(),
          settings: settings,
        );

      case RouteNames.cancelRide:
        return MaterialPageRoute(
          builder: (_) => const CancelRideScreen(),
          settings: settings,
        );

      case RouteNames.rideDetails:
        return MaterialPageRoute(
          builder: (_) => const RideDetailsScreen(),
          settings: settings,
        );

      case RouteNames.rateRide:
        return MaterialPageRoute(
          builder: (_) => const RateRideScreen(),
          settings: settings,
        );

      case RouteNames.paymentMethods:
        return MaterialPageRoute(
          builder: (_) => const PaymentMethodsScreen(),
          settings: settings,
        );

      case RouteNames.addCard:
        return MaterialPageRoute(
          builder: (_) => const AddCardScreen(),
          settings: settings,
        );

      case RouteNames.paymentSuccess:
        return MaterialPageRoute(
          builder: (_) => const PaymentSuccessScreen(),
          settings: settings,
        );

      case RouteNames.paymentFailed:
        return MaterialPageRoute(
          builder: (_) => const PaymentFailedScreen(),
          settings: settings,
        );

      case RouteNames.editProfile:
        return MaterialPageRoute(
          builder: (_) => const EditProfileScreen(),
          settings: settings,
        );

      case RouteNames.savedPlaces:
        return MaterialPageRoute(
          builder: (_) => const SavedPlacesScreen(),
          settings: settings,
        );

      case RouteNames.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
          settings: settings,
        );

      case RouteNames.safety:
        return MaterialPageRoute(
          builder: (_) => const SafetyScreen(),
          settings: settings,
        );

      case RouteNames.emergencyContacts:
        return MaterialPageRoute(
          builder: (_) => const EmergencyContactsScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
          settings: settings,
        );
    }
  }
}
