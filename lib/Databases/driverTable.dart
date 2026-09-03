class driverTable {
  static const String tableName = 'driver';

  static const createTable = '''
CREATE TABLE driver (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    user_id INTEGER,
    is_available INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL
);
''';
}
