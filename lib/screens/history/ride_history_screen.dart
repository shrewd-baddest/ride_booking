import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_booking/Models/ride_model.dart';
import 'package:ride_booking/riverpods/providers.dart';
import 'package:ride_booking/screens/history/rate_ride_screen.dart';

// Import the file that declares historyProvider.
// Replace this path with your actual provider file.
// import 'package:ride_booking/providers/history_provider.dart';

class RideHistoryScreen extends ConsumerStatefulWidget {
  const RideHistoryScreen({super.key});

  @override
  ConsumerState<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends ConsumerState<RideHistoryScreen> {
  String selectedMonth = 'This Month';

  final List<String> months = ['This Month', 'Last Month', 'All Time'];

  List<Ride> filterRides(List<Ride> rides) {
    final now = DateTime.now();

    return rides.where((ride) {
      final date = ride.createdAt;

      switch (selectedMonth) {
        case 'This Month':
          return date.year == now.year && date.month == now.month;

        case 'Last Month':
          final lastMonth = DateTime(now.year, now.month - 1);
          return date.year == lastMonth.year && date.month == lastMonth.month;

        case 'All Time':
          return true;

        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0E13),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),

            const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 13,
                    color: Color(0xFF687080),
                  ),
                  SizedBox(width: 5),
                  Text(
                    'RIDE HISTORY',
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 2,
                      color: Color(0xFF687080),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 27),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Your Rides',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  MonthFilter(
                    selectedMonth: selectedMonth,
                    months: months,
                    onChanged: (month) {
                      setState(() {
                        selectedMonth = month;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: historyAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFFC928)),
                ),

                error: (error, stackTrace) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.redAccent,
                          size: 36,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Error fetching ride history:\n$error',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            ref.invalidate(historyProvider);
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),

                data: (rides) {
                  final allRides = rides ?? <Ride>[];
                  final filteredRides = filterRides(allRides);

                  if (filteredRides.isEmpty) {
                    return const Center(
                      child: Text(
                        'No ride history found.',
                        style: TextStyle(color: Color(0xFF687080)),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredRides.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return RideCard(ride: filteredRides[index]);
                    },
                  );
                },
              ),
            ),

            historyAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (rides) {
                final allRides = rides ?? <Ride>[];
                final filteredRides = filterRides(allRides);

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 8,
                  ),
                  child: Text(
                    'Showing ${filteredRides.length} of '
                    '${allRides.length} rides',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF536582),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------
// 4. REUSABLE MONTH FILTER
// --------------------------------------------------

class MonthFilter extends StatelessWidget {
  final String selectedMonth;
  final List<String> months;
  final ValueChanged<String> onChanged;

  const MonthFilter({
    super.key,
    required this.selectedMonth,
    required this.months,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: const Color(0xFF10151F),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF594817)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedMonth,
          dropdownColor: const Color(0xFF151B28),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFFFFC928),
            size: 14,
          ),
          style: const TextStyle(fontSize: 10, color: Color(0xFFFFC928)),
          items: months.map((month) {
            return DropdownMenuItem<String>(value: month, child: Text(month));
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ),
    );
  }
}

// --------------------------------------------------
// 6. REUSABLE LOCATION ROW
// --------------------------------------------------

class LocationRow extends StatelessWidget {
  final Color color;
  final String location;

  const LocationRow({super.key, required this.color, required this.location});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),

        const SizedBox(width: 9),

        Expanded(
          child: Text(
            location,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: Color(0xFFD6DCE8)),
          ),
        ),
      ],
    );
  }
}

// --------------------------------------------------
// 7. REUSABLE PAYMENT DETAILS
// --------------------------------------------------

class PaymentDetails extends StatelessWidget {
  final String paymentMethod;
  final String status;

  const PaymentDetails({
    super.key,
    required this.paymentMethod,
    required this.status,
  });

  IconData get paymentIcon {
    switch (paymentMethod.toLowerCase()) {
      case 'm-pesa':
        return Icons.account_balance_wallet_rounded;
      case 'card':
        return Icons.credit_card_rounded;
      case 'cash':
        return Icons.money_rounded;
      default:
        return Icons.payment_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(paymentIcon, size: 11, color: const Color(0xFF55DCA4)),

        const SizedBox(width: 5),

        Flexible(
          child: Text(
            '$paymentMethod · $status',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 9, color: Color(0xFF50617F)),
          ),
        ),
      ],
    );
  }
}

// --------------------------------------------------
// 8. REUSABLE STAR RATING
// --------------------------------------------------

class RideRating extends StatelessWidget {
  final int rating;

  const RideRating({super.key, this.rating = 5});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
          size: 12,
          color: const Color(0xFFFFD21F),
        );
      }),
    );
  }
}
