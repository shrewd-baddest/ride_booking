class Payment {
  final int id;
  final int rideId;
  final double baseFare;
  final double distanceFare;
  final double timeFare;
  final double totalFare;
  final String paymentMethod;
  final String paymentStatus;
  final DateTime createdAt;

  Payment({
    required this.id,
    required this.rideId,
    required this.baseFare,
    required this.distanceFare,
    required this.timeFare,
    required this.totalFare,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.createdAt,
  });

  /// Create a Payment from a Map (typically from database or JSON)
  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['Id'] as int,
      rideId: map['ride_id'] as int,
      baseFare: (map['base_fare'] as num).toDouble(),
      distanceFare: (map['distance_fare'] as num).toDouble(),
      timeFare: (map['time_fare'] as num).toDouble(),
      totalFare: (map['total_fare'] as num).toDouble(),
      paymentMethod: map['payment_method'] as String,
      paymentStatus: map['payment_status'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// Convert Payment to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'ride_id': rideId,
      'base_fare': baseFare,
      'distance_fare': distanceFare,
      'time_fare': timeFare,
      'total_fare': totalFare,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Create a copy of Payment with optional field replacements
  Payment copyWith({
    int? id,
    int? rideId,
    double? baseFare,
    double? distanceFare,
    double? timeFare,
    double? totalFare,
    String? paymentMethod,
    String? paymentStatus,
    DateTime? createdAt,
  }) {
    return Payment(
      id: id ?? this.id,
      rideId: rideId ?? this.rideId,
      baseFare: baseFare ?? this.baseFare,
      distanceFare: distanceFare ?? this.distanceFare,
      timeFare: timeFare ?? this.timeFare,
      totalFare: totalFare ?? this.totalFare,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Check if payment is completed
  bool get isCompleted => paymentStatus.toLowerCase() == 'completed';

  /// Get fare breakdown summary
  String get fareSummary =>
      'Base: \$$baseFare, Distance: \$$distanceFare, Time: \$$timeFare = \$$totalFare';

  @override
  String toString() =>
      'Payment(id: $id, rideId: $rideId, baseFare: $baseFare, distanceFare: $distanceFare, timeFare: $timeFare, totalFare: $totalFare, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, createdAt: $createdAt)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Payment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          rideId == other.rideId &&
          baseFare == other.baseFare &&
          distanceFare == other.distanceFare &&
          timeFare == other.timeFare &&
          totalFare == other.totalFare &&
          paymentMethod == other.paymentMethod &&
          paymentStatus == other.paymentStatus &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      rideId.hashCode ^
      baseFare.hashCode ^
      distanceFare.hashCode ^
      timeFare.hashCode ^
      totalFare.hashCode ^
      paymentMethod.hashCode ^
      paymentStatus.hashCode ^
      createdAt.hashCode;
}
