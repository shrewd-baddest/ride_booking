class Driver {
  final int id;
  final String name;
  final String phoneNumber;
  final String email;
  final String licenseNumber;
  final int? userId;
  final bool isAvailable;
  final DateTime createdAt;

  Driver({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.licenseNumber,
    this.userId,
    this.isAvailable = false,
    required this.createdAt,
  });

  /// Create a Driver from a Map (typically from database or JSON)
  factory Driver.fromMap(Map<String, dynamic> map) {
    return Driver(
      id: map['Id'] as int,
      name: map['name'] as String,
      phoneNumber: map['phone_number'] as String? ?? '',
      email: map['email'] as String? ?? '',
      licenseNumber: map['license_number'] as String? ?? '',
      userId: map['user_id'] as int?,
      isAvailable: (map['is_available'] as int? ?? 0) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// Convert Driver to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'name': name,
      'user_id': userId,
      'is_available': isAvailable ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Create a copy of Driver with optional field replacements
  Driver copyWith({
    int? id,
    String? name,
    String? phoneNumber,
    String? email,
    String? licenseNumber,
    int? userId,
    bool? isAvailable,
    DateTime? createdAt,
  }) {
    return Driver(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      userId: userId ?? this.userId,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'Driver(id: $id, name: $name, phoneNumber: $phoneNumber, email: $email, licenseNumber: $licenseNumber, createdAt: $createdAt)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Driver &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          phoneNumber == other.phoneNumber &&
          email == other.email &&
          licenseNumber == other.licenseNumber &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      phoneNumber.hashCode ^
      email.hashCode ^
      licenseNumber.hashCode ^
      createdAt.hashCode;
}
