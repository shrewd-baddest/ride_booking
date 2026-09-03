// import 'dart:ffi';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ride_booking/Models/driver_model.dart';
import 'package:ride_booking/Repository/ride_repository.dart';
import 'package:ride_booking/riverpods/authNotifier.dart';

import 'notifier.dart';

final selectProvider = StateProvider<int>((ref) => 0);
final locationProvider = StateProvider<String>((ref) => '');
final destinationProvider = StateProvider<String>((ref) => '');
final gpsProvider = AsyncNotifierProvider<GpsNotifier, Position>(
  GpsNotifier.new,
);
final rideProvider = StateProvider<String>((ref) => '');
final rideRepositoryProvider = Provider<RideRepository>(
  (ref) => RideRepository(),
);
final rideBookingProvider = AsyncNotifierProvider<RideBookingNotifier, String>(
  RideBookingNotifier.new,
);
final userIdProvider = StateProvider<int>((ref) => 0);
final driverDetailsProvider =
    AsyncNotifierProvider<DriverDetailsNotifier, Driver?>(
      DriverDetailsNotifier.new,
    );
final loginProvider = AsyncNotifierProvider<LoginNotifier, String?>(
  LoginNotifier.new,
);

final registerProvider = loginProvider;
