class Ride {
  final int id;
  final String? driverName;
  final double fare;
  final String userId;
  final String fromLocation;
  final String toLocation;
  final double distance;
  final int duration;
  final DateTime createdAt;
  final double? pickupLatitude;
  final double? pickupLongitude;
  final String? date;
  final String? time;
  final String? category;
  final String paymentMethod;
  final String status;
  final int rating;

  Ride({
    required this.id,
    this.driverName,
    required this.fare,
    required this.userId,
    required this.fromLocation,
    required this.toLocation,
    required this.distance,
    required this.duration,
    required this.createdAt,
    this.pickupLatitude,
    this.pickupLongitude,
    this.date,
    this.time,
    this.category,
    this.paymentMethod = 'Unknown',
    this.status = 'Completed',
    this.rating = 5,
  });

  String get driver => driverName ?? 'Unassigned';
  String get pickup => fromLocation;
  String get destination => toLocation;

  /// Create a Ride from a Map (typically from database or JSON)
  factory Ride.fromMap(Map<String, dynamic> map) {
    return Ride(
      id:
          int.tryParse(map['id']?.toString() ?? '') ??
          int.tryParse(map['Id']?.toString() ?? '') ??
          0,
      driverName: map['driver_id']?.toString(),
      userId: map['user_id']?.toString() ?? '',
      fare: (map['price'] is num) ? (map['price'] as num).toDouble() : 0,
      fromLocation: map['from_location']?.toString() ?? '',
      toLocation: map['to_location']?.toString() ?? '',
      distance: (map['distance'] is num)
          ? (map['distance'] as num).toDouble()
          : double.tryParse(map['distance']?.toString() ?? '') ?? 0,
      duration: map['duration'] is int
          ? map['duration'] as int
          : int.tryParse(map['duration']?.toString() ?? '') ?? 0,
      createdAt:
          DateTime.tryParse(map['created_at']?.toString() ?? '') ??
          DateTime.now(),
      paymentMethod: map['payment_method']?.toString() ?? 'Unknown',
      status: map['status']?.toString() ?? 'Completed',
      rating: map['rating'] is int
          ? map['rating'] as int
          : int.tryParse(map['rating']?.toString() ?? '') ?? 5,
    );
  }

  /// Convert Ride to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id.toString(),
      'driver_id': driverName,
      'user_id': userId,
      'from_location': fromLocation,
      'to_location': toLocation,
      'distance': distance,
      'duration': duration,
      'status': status.toLowerCase().replaceAll(' ', '_'),
      'created_at': createdAt.toIso8601String(),
      'fare': fare,
      'category': category ?? 'Economy',
      'payment_method': paymentMethod,
    };
  }

  Map<String, dynamic> toApiMap() {
    return {
      if (driverName != null) 'driver_id': driverName,
      'from_location': fromLocation,
      'to_location': toLocation,
      'distance': distance,
      'duration': duration,
      'created_at': createdAt.toIso8601String(),
      if (pickupLatitude != null) 'pickup_latitude': pickupLatitude,
      if (pickupLongitude != null) 'pickup_longitude': pickupLongitude,
    };
  }
}
