import 'package:path/path.dart';
import 'package:ride_booking/Databases/driverTable.dart';
import 'package:ride_booking/Databases/rideTable.dart';
import 'package:ride_booking/Databases/usersTable.dart';
import 'package:ride_booking/Databases/paymentTable.dart';
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
      version: 4,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _createTables,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute(usersTable.createTable);
    await db.execute(driverTable.createTable);
    await db.execute(rideTable.createTable);
    await db.execute(paymentTable.createTable);
    await db.execute(paymentTable.statusIndex);
    await db.execute(rideTable.userIndex);
    await db.execute(rideTable.driverIndex);
  }

  Future<void> _upgradeDatabase(
    Database db,
    int oldVersion,
    int version,
  ) async {
    if (oldVersion < 4) {
      await db.transaction((transaction) async {
        await transaction.execute('DROP TABLE IF EXISTS payments');
        await transaction.execute('DROP TABLE IF EXISTS payment');
        await transaction.execute('DROP TABLE IF EXISTS rides');
        await transaction.execute('DROP TABLE IF EXISTS ride');
        await transaction.execute('DROP TABLE IF EXISTS drivers');
        await transaction.execute('DROP TABLE IF EXISTS driver');
        await transaction.execute('DROP TABLE IF EXISTS users');
      });
      await _createTables(db, version);
    }
  }
}
