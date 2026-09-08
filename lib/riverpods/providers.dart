// import 'dart:ffi';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ride_booking/Models/driver_model.dart';
import 'package:ride_booking/Models/login_model.dart';
import 'package:ride_booking/Repository/ride_repository.dart';
import 'package:ride_booking/riverpods/authNotifier.dart';

import 'notifier.dart';

final selectProvider = StateProvider<int>((ref) => 0);
final locationProvider = AsyncNotifierProvider<LocationNameNotifier, String>(
  LocationNameNotifier.new,
);
final locationNameProvider = StateProvider<String>(
  (ref) => ref.watch(locationProvider).value ?? '',
);
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
final userIdProvider = StateProvider<String>((ref) => '');
final driverDetailsProvider =
    AsyncNotifierProvider<DriverDetailsNotifier, Driver?>(
      DriverDetailsNotifier.new,
    );
final loginProvider = AsyncNotifierProvider<AuthNotifier, LoginResponse?>(
  AuthNotifier.new,
);

final registerProvider = AsyncNotifierProvider<AuthNotifier, LoginResponse?>(
  AuthNotifier.new,
);
