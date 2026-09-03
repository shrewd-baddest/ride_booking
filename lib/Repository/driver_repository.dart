import 'package:ride_booking/Databases/database.dart';
import 'package:ride_booking/Models/driver_model.dart';

class getDriver {
  final int? userId;

  getDriver({this.userId});
  final DatabaseService databaseService = DatabaseService();

  Future<Driver?> getDetails() async {
    final db = await databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'driver',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    if (maps.isNotEmpty) {
      return Driver.fromMap(maps.first);
    }
    return null;
  }
}
