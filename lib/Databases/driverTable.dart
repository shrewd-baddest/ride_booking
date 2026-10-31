class driverTable {
  static const String tableName = 'drivers';

  static const createTable = '''
CREATE TABLE drivers (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    phone_number TEXT NOT NULL UNIQUE,
    email TEXT,
    license_number TEXT NOT NULL UNIQUE,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    rating REAL NOT NULL DEFAULT 5.0
      CHECK (rating >= 0 AND rating <= 5),
    current_latitude REAL,
    current_longitude REAL,
    location_updated_at TEXT
);
''';
}
