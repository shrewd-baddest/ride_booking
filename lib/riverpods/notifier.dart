import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:ride_booking/Models/driver_model.dart';
import 'package:ride_booking/Models/ride_model.dart';
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
      ref.read(driverIdProvider.notifier).state = '';
      final result = await repository.addRide(ride);
      final driverId = result.driverId;
      if (driverId != null) {
        ref.read(driverIdProvider.notifier).state = driverId;
      }
      state = AsyncData(result.message);
    } catch (error, stackTrace) {
      state = AsyncError('Ride booking failed', stackTrace);
    }
  }
}

class DriverDetailsNotifier extends AsyncNotifier<Driver?> {
  static const String _apiUrl = 'http://10.0.2.2:3000/api/drivers';

  @override
  Future<Driver?> build() async {
    final driverId = ref.watch(driverIdProvider).trim();
    if (driverId.isEmpty) {
      return null;
    }

    final response = await http.get(
      Uri.parse('$_apiUrl/${Uri.encodeComponent(driverId)}'),
    );

    if (response.statusCode != 200) {
      throw StateError('Failed to load driver details: ${response.statusCode}');
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    final driverMap = payload['data']?['driver'] as Map<String, dynamic>?;
    if (driverMap == null) {
      return null;
    }

    return Driver(
      id: int.tryParse(driverMap['id']?.toString() ?? '') ?? 0,
      name: driverMap['name']?.toString() ?? '',
      phoneNumber: driverMap['phone_number']?.toString() ?? '',
      email: driverMap['email']?.toString() ?? '',
      licenseNumber: driverMap['license_number']?.toString() ?? '',
      vehicleRegistration: '',
      vehicleColor: '',
      vehicleModel: '',
      userId: null,
      isAvailable: false,
      createdAt:
          DateTime.tryParse(driverMap['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
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
