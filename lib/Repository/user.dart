import 'package:ride_booking/Databases/database.dart';
import 'package:ride_booking/Models/user_model.dart';

class userRepository {
  final DatabaseService databaseService = DatabaseService();

  Future<void> addUser(User user) async {
    final db = await databaseService.database;
    await db.insert('users', {
      'Id': user.id,
      'name': user.fullName,
      'created_at': (user.createdAt ?? DateTime.now()).toIso8601String(),
    });
  }

  Future<List<User>> getUsers() async {
    final db = await databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<void> updateUser(User user) async {
    final db = await databaseService.database;
    await db.update(
      'users',
      {
        'name': user.fullName,
        'created_at': (user.createdAt ?? DateTime.now()).toIso8601String(),
      },
      where: 'Id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(int id) async {
    final db = await databaseService.database;
    await db.delete('users', where: 'Id = ?', whereArgs: [id]);
  }
}
