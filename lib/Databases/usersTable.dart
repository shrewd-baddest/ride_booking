class usersTable {
  static const String tableName = 'users';

  static const createTable = '''
CREATE TABLE users (
  Id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
    created_at TEXT NOT NULL
);
''';
}
