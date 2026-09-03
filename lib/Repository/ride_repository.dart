import 'package:ride_booking/Databases/database.dart';
import 'package:ride_booking/Models/ride_model.dart';

class RideRepository {
  final DatabaseService databaseService = DatabaseService();

  Future<String> addRide(Ride ride) async {
    try {
      final db = await databaseService.database;
      await db.insert('ride', ride.toMap());
      return 'Ride booked successfully';
    } catch (e) {
      return 'Ride booking failed';
    }
  }
}
