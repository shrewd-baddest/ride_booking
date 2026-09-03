import 'package:path/path.dart';
import 'package:ride_booking/Databases/driverTable.dart';
import 'package:ride_booking/Databases/rideTable.dart';
import 'package:ride_booking/Databases/usersTable.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'rideBooking.db'),
      version: 2,
      onCreate: _createTables,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute(driverTable.createTable);
    await db.execute(rideTable.createTable);
    await db.execute(usersTable.createTable);
  }

  Future<void> _upgradeDatabase(
    Database db,
    int oldVersion,
    int version,
  ) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS users');
      await db.execute('DROP TABLE IF EXISTS payment');
      await db.execute('DROP TABLE IF EXISTS driver');
      await db.execute('DROP TABLE IF EXISTS ride');
      await _createTables(db, version);
    }
  }
}
