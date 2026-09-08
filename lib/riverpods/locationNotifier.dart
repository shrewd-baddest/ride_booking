import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ride_booking/riverpods/providers.dart';

class LocationNameNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    final position = await ref.watch(gpsProvider.future);

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
