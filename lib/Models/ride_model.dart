class Ride {
  final int id;
  final String? driverId;
  final String userId;
  final String fromLocation;
  final String toLocation;
  final double distance;
  final int duration;
  final DateTime createdAt;

  Ride({
    required this.id,
    required this.driverId,
    required this.userId,
    required this.fromLocation,
    required this.toLocation,
    required this.distance,
    required this.duration,
    required this.createdAt,
  });

  /// Create a Ride from a Map (typically from database or JSON)
  factory Ride.fromMap(Map<String, dynamic> map) {
    return Ride(
      id: map['Id'] as int,
      driverId: map['driver_id'] as String?,
      userId: map['user_id'] as String,
      fromLocation: map['from_location'] as String,
      toLocation: map['to_location'] as String,
      distance: (map['distance'] as num).toDouble(),
      duration: map['duration'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// Convert Ride to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'driver_id': driverId,
      'user_id': userId,
      'from_location': fromLocation,
      'to_location': toLocation,
      'distance': distance,
      'duration': duration,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toApiMap() {
    return {
      if (driverId != null) 'driver_id': driverId,
      'from_location': fromLocation,
      'to_location': toLocation,
      'distance': distance,
      'duration': duration,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Create a copy of Ride with optional field replacements
  Ride copyWith({
    int? id,
    String? driverId,
    String? userId,
    String? fromLocation,
    String? toLocation,
    double? distance,
    int? duration,
    DateTime? createdAt,
  }) {
    return Ride(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      userId: userId ?? this.userId,
      fromLocation: fromLocation ?? this.fromLocation,
      toLocation: toLocation ?? this.toLocation,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'Ride(id: $id, driverId: $driverId, userId: $userId, fromLocation: $fromLocation, toLocation: $toLocation, distance: $distance, duration: $duration, createdAt: $createdAt)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ride &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          driverId == other.driverId &&
          userId == other.userId &&
          fromLocation == other.fromLocation &&
          toLocation == other.toLocation &&
          distance == other.distance &&
          duration == other.duration &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      driverId.hashCode ^
      userId.hashCode ^
      fromLocation.hashCode ^
      toLocation.hashCode ^
      distance.hashCode ^
      duration.hashCode ^
      createdAt.hashCode;
}
