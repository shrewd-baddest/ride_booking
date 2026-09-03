import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ride_booking/riverpods/providers.dart';

class RideMap extends ConsumerWidget {
  const RideMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gpsState = ref.watch(gpsProvider);

    return Container(
      height: 210,

      decoration: BoxDecoration(
        color: const Color(0xFF101927),
        borderRadius: BorderRadius.circular(17),
      ),

      clipBehavior: Clip.hardEdge,

      child: Stack(
        children: [
          CustomPaint(
            size: const Size(double.infinity, 210),
            painter: MapGridPainter(),
          ),

          // Roads
          Positioned(
            top: 108,
            left: 0,
            right: 0,
            child: Container(height: 5, color: const Color(0xFF294B76)),
          ),

          Positioned(
            top: 151,
            left: 0,
            right: 0,
            child: Container(height: 5, color: const Color(0xFF294B76)),
          ),

          Positioned(
            left: 80,
            top: 0,
            bottom: 0,
            child: Container(width: 5, color: const Color(0xFF294B76)),
          ),

          Positioned(
            left: 148,
            top: 0,
            bottom: 0,
            child: Container(width: 5, color: const Color(0xFF294B76)),
          ),

          // LIVE
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF09120F),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: const Color(0xFF1D754A)),
              ),
              child: const Text(
                '• LIVE',
                style: TextStyle(
                  color: Color(0xFF40E47F),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Nairobi
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF121923),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '🌐 Nairobi',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),

          // Route
          CustomPaint(
            size: const Size(double.infinity, 210),
            painter: RoutePainter(),
          ),

          gpsState.when(
            loading: () => const Positioned(
              left: 88,
              top: 101,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (_, _) => const Positioned(
              left: 88,
              top: 101,
              child: Icon(Icons.location_disabled, color: Colors.white70),
            ),
            data: (position) => Positioned(
              left: _mapX(position.longitude),
              top: _mapY(position.latitude),
              child: const Text('🚕', style: TextStyle(fontSize: 17)),
            ),
          ),

          // Pickup marker
          Positioned(
            left: 105,
            top: 116,
            child: _Marker(color: const Color(0xFFF23662)),
          ),

          // Destination marker
          Positioned(
            left: 159,
            top: 36,
            child: _Marker(color: const Color(0xFFF04466), size: 22),
          ),

          Positioned(
            left: 10,
            bottom: 10,
            child: gpsState.when(
              loading: () => const _MapStatus(text: 'Locating...'),
              error: (error, _) => _MapStatus(text: error.toString()),
              data: (position) => _MapStatus(
                text:
                    '${_distanceToDestination(position).toStringAsFixed(1)} km away',
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _destinationLatitude = -1.2864;
  static const _destinationLongitude = 36.8172;

  double _distanceToDestination(Position position) {
    return Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          _destinationLatitude,
          _destinationLongitude,
        ) /
        1000;
  }

  double _mapX(double longitude) =>
      ((longitude - 36.75) / 0.14 * 280 + 70).clamp(12.0, 315.0);

  double _mapY(double latitude) =>
      ((-1.22 - latitude) / 0.14 * 160 + 24).clamp(24.0, 170.0);
}

class _MapStatus extends StatelessWidget {
  final String text;

  const _MapStatus({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xDD09120F),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
    );
  }
}

class _Marker extends StatelessWidget {
  final Color color;
  final double size;

  const _Marker({required this.color, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF243247)
      ..strokeWidth = .7;

    for (double x = 3; x < size.width; x += 28) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 8; y < size.height; y += 27) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF1CF00)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(112, 151)
      ..lineTo(165, 50);

    const dashLength = 7.0;
    const gapLength = 5.0;

    for (final metric in path.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        final end = distance + dashLength;

        canvas.drawPath(
          metric.extractPath(
            distance,
            end > metric.length ? metric.length : end,
          ),
          paint,
        );

        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
