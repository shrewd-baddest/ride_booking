class rideTable {
  static const String tableName = 'ride';

  static const createTable = '''
CREATE TABLE ride (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    driver_id TEXT,
    user_id TEXT NOT NULL,
    from_location TEXT NOT NULL,
    to_location TEXT NOT NULL,
    distance REAL NOT NULL,
    duration INTEGER NOT NULL,
    created_at TEXT NOT NULL
);
''';
}
