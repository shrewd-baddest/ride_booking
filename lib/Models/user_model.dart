import 'package:geolocator/geolocator.dart';

class User {
  final int? id;
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String? password;
  final Position? location;
  final DateTime? createdAt;

  User({
    this.id,
    required this.fullName,
    required this.phoneNumber,
    this.email,
    this.password,
    this.location,
    this.createdAt,
  });

  String get name => fullName;

  /// Create a User from a Map (typically from database or JSON)
  factory User.fromMap(Map<String, dynamic> map) {
    final positionMap = map['position'] as Map<String, dynamic>? ?? {};

    final longitude = (positionMap['longitude'] as num?)?.toDouble() ?? 0.0;
    final latitude = (positionMap['latitude'] as num?)?.toDouble() ?? 0.0;
    final timestamp = positionMap['timestamp'] != null
        ? DateTime.parse(positionMap['timestamp'] as String)
        : DateTime.now();
    final accuracy = (positionMap['accuracy'] as num?)?.toDouble() ?? 0.0;
    final altitude = (positionMap['altitude'] as num?)?.toDouble() ?? 0.0;
    final altitudeAccuracy =
        (positionMap['altitude_accuracy'] as num?)?.toDouble() ?? 0.0;
    final heading = (positionMap['heading'] as num?)?.toDouble() ?? 0.0;
    final headingAccuracy =
        (positionMap['heading_accuracy'] as num?)?.toDouble() ?? 0.0;
    final speed = (positionMap['speed'] as num?)?.toDouble() ?? 0.0;
    final speedAccuracy =
        (positionMap['speed_accuracy'] as num?)?.toDouble() ?? 0.0;
    return User(
      id: (map['id'] ?? map['Id']) as int?,
      fullName: (map['full_name'] ?? map['name']) as String,
      phoneNumber: map['phone_number'] as String,
      email: map['email'] as String?,
      password: map['password'] as String?,
      location: Position(
        longitude: longitude,
        latitude: latitude,
        timestamp: timestamp,
        accuracy: accuracy,
        altitude: altitude,
        altitudeAccuracy: altitudeAccuracy,
        heading: heading,
        headingAccuracy: headingAccuracy,
        speed: speed,
        speedAccuracy: speedAccuracy,
      ),
      createdAt: map['created_at'] == null
          ? null
          : DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      if (password != null) 'password': password,
    };
  }

  Map<String, dynamic> toMap() {
    final currentLocation = location;
    final creationTime = createdAt;

    return {
      'Id': id,
      'name': fullName,
      'phone_number': phoneNumber,
      'email': email,
      if (currentLocation != null)
        'position': {
          'longitude': currentLocation.longitude,
          'latitude': currentLocation.latitude,
          'timestamp': currentLocation.timestamp.toIso8601String(),
          'accuracy': currentLocation.accuracy,
          'altitude': currentLocation.altitude,
          'altitude_accuracy': currentLocation.altitudeAccuracy,
          'heading': currentLocation.heading,
          'heading_accuracy': currentLocation.headingAccuracy,
          'speed': currentLocation.speed,
          'speed_accuracy': currentLocation.speedAccuracy,
        },
      if (creationTime != null) 'created_at': creationTime.toIso8601String(),
    };
  }

  /// Create a copy of User with optional field replacements
  User copyWith({
    int? id,
    String? fullName,
    String? phoneNumber,
    String? email,
    String? password,
    Position? location,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      email: email ?? this.email,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'User(id: $id, fullName: $fullName, phoneNumber: $phoneNumber, email: $email, createdAt: $createdAt)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          fullName == other.fullName &&
          phoneNumber == other.phoneNumber &&
          email == other.email &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      fullName.hashCode ^
      phoneNumber.hashCode ^
      email.hashCode ^
      createdAt.hashCode;
}
