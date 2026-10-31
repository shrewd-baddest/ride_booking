class rideTable {
  static const String tableName = 'rides';

  static const createTable = '''
CREATE TABLE rides (
    id TEXT PRIMARY KEY,
    driver_id TEXT NOT NULL,
    user_id TEXT NOT NULL,
    from_location TEXT NOT NULL,
    to_location TEXT NOT NULL,
    distance REAL NOT NULL,
    duration INTEGER NOT NULL,
    status TEXT NOT NULL DEFAULT 'requested'
      CHECK (status IN ('requested', 'accepted', 'in_progress', 'completed', 'cancelled')),
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    fare REAL NOT NULL DEFAULT 0 CHECK (fare >= 0),
    category TEXT NOT NULL DEFAULT 'Economy',
    payment_method TEXT NOT NULL DEFAULT 'M-Pesa',
    CHECK (distance >= 0),
    CHECK (duration >= 0),
    FOREIGN KEY (driver_id) REFERENCES drivers(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
''';

  static const userIndex =
      'CREATE INDEX rides_user_id_created_at_idx ON rides (user_id, created_at)';
  static const driverIndex =
      'CREATE INDEX rides_driver_id_created_at_idx ON rides (driver_id, created_at)';
}
