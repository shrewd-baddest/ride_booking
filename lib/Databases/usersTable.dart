class usersTable {
  static const String tableName = 'users';

  static const createTable = '''
CREATE TABLE users (
    id TEXT PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT,
    phone_number TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    is_verified INTEGER NOT NULL DEFAULT 1 CHECK (is_verified IN (0, 1)),
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
);
''';
}
