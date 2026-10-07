import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ride_booking/Databases/database.dart';
import 'package:ride_booking/Models/ride_model.dart';

class RideBookingResult {
  final String message;
  final String? driverId;

  const RideBookingResult({required this.message, this.driverId});
}

class _ServerRideResult {
  final bool saved;
  final String? driverId;

  const _ServerRideResult({required this.saved, this.driverId});
}

class RideRepository {
  final DatabaseService databaseService = DatabaseService();
  static const _apiUrl = 'http://10.0.2.2:3000/api/rides';
  static const _storage = FlutterSecureStorage();

  Future<RideBookingResult> addRide(Ride ride) async {
    final results = await Future.wait<Object>([
      _saveToSqlite(ride),
      _saveToPostgres(ride),
    ], eagerError: false);

    final sqliteSaved = results[0] == true;
    final serverResult = results[1] as _ServerRideResult;

    if (sqliteSaved && serverResult.saved) {
      return RideBookingResult(
        message: 'Ride booked successfully',
        driverId: serverResult.driverId,
      );
    }
    if (sqliteSaved) {
      return const RideBookingResult(
        message: 'Ride saved locally; server sync failed',
      );
    }
    return const RideBookingResult(message: 'Ride booking failed');
  }

  Future<bool> _saveToSqlite(Ride ride) async {
    try {
      final db = await databaseService.database;
      await db.insert('ride', ride.toMap());
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<_ServerRideResult> _saveToPostgres(Ride ride) async {
    final token = await _storage.read(key: 'token');
    if (token == null || token.isEmpty) {
      return const _ServerRideResult(saved: false);
    }

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(ride.toApiMap()),
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return const _ServerRideResult(saved: false);
      }

      final payload = jsonDecode(response.body);
      final data = payload is Map<String, dynamic> ? payload['data'] : null;
      final rideData = data is Map<String, dynamic> ? data['ride'] : null;
      final assignedDriverId = rideData is Map<String, dynamic>
          ? rideData['driver_id']?.toString()
          : null;

      return _ServerRideResult(
        saved: true,
        driverId: assignedDriverId?.trim().isNotEmpty == true
            ? assignedDriverId
            : null,
      );
    } catch (_) {
      return const _ServerRideResult(saved: false);
    }
  }
}
