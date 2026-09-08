import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ride_booking/Databases/database.dart';
import 'package:ride_booking/Models/ride_model.dart';

class RideRepository {
  final DatabaseService databaseService = DatabaseService();
  static const _apiUrl = 'http://10.0.2.2:3000/api/rides';
  static const _storage = FlutterSecureStorage();

  Future<String> addRide(Ride ride) async {
    final results = await Future.wait<Object>([
      _saveToSqlite(ride),
      _saveToPostgres(ride),
    ], eagerError: false);

    final sqliteSaved = results[0] == true;
    final postgresSaved = results[1] == true;

    if (sqliteSaved && postgresSaved) {
      return 'Ride booked successfully';
    }
    if (sqliteSaved) {
      return 'Ride saved locally; server sync failed';
    }
    return 'Ride booking failed';
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

  Future<bool> _saveToPostgres(Ride ride) async {
    final token = await _storage.read(key: 'token');
    if (token == null || token.isEmpty) return false;

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(ride.toApiMap()),
      );
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (_) {
      return false;
    }
  }
}
