import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ride_booking/Models/driver_model.dart';
import 'package:ride_booking/Models/ride_model.dart';
import 'package:ride_booking/Repository/driver_repository.dart';
import 'package:ride_booking/Repository/ride_repository.dart';
import 'package:ride_booking/riverpods/providers.dart';

class GpsNotifier extends AsyncNotifier<Position> {
  StreamSubscription<Position>? _positionSubscription;

  @override
  Future<Position> build() async {
    ref.onDispose(() => _positionSubscription?.cancel());

    if (!await Geolocator.isLocationServiceEnabled()) {
      throw StateError('Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw StateError('Location permission was not granted.');
    }

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    final initialPosition = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (position) => state = AsyncData(position),
          onError: (Object error, StackTrace stackTrace) {
            state = AsyncError(error, stackTrace);
          },
        );

    return initialPosition;
  }
}

class RideBookingNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async => 'Idle';

  Future<void> bookRide(Ride ride) async {
    state = const AsyncLoading();

    try {
      final repository = RideRepository();
      final message = await repository.addRide(ride);
      state = AsyncData(message);
    } catch (error, stackTrace) {
      state = AsyncError('Ride booking failed', stackTrace);
    }
  }
}

class DriverDetailsNotifier extends AsyncNotifier<Driver?> {
  @override
  Future<Driver?> build() async {
    final userId = ref.read(userIdProvider);
    if (userId == 0) {
      throw StateError('User ID is not available.');
    }

    final repository = getDriver(userId: userId);
    return await repository.getDetails();
  }
}

class LocationNameNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    // Wait for the GPS provider to obtain the current position
    final position = await ref.watch(gpsProvider.future);

    // Convert coordinates into a human-readable address
    final geocoding = Geocoding();
    final placemarks = await geocoding.placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isEmpty) {
      return 'Unknown location';
    }

    final place = placemarks.first;

    return [
      place.street,
      place.subLocality,
      place.locality,
      place.country,
    ].whereType<String>().where((value) => value.isNotEmpty).join(', ');
  }
}
