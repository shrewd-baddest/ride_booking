class paymentTable {
  static const String tableName = 'payments';

  static const createTable = '''
CREATE TABLE payments (
    id TEXT PRIMARY KEY,
    ride_id TEXT NOT NULL UNIQUE,
    total_fare REAL NOT NULL CHECK (total_fare >= 0),
    payment_method TEXT NOT NULL,
    payment_status TEXT NOT NULL DEFAULT 'pending'
      CHECK (payment_status IN ('pending', 'completed', 'failed', 'refunded')),
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (ride_id) REFERENCES rides(id)
);
''';

  static const statusIndex =
      'CREATE INDEX payments_status_idx ON payments (payment_status)';
}
