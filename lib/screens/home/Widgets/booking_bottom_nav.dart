import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_booking/riverpods/providers.dart';

class BookingBottomNav extends ConsumerWidget {
  const BookingBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectProvider);

    return SizedBox(
      height: 54,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home,
            label: 'Home',
            selected: selectedIndex == 0,
            onTap: () {
              ref.read(selectProvider.notifier).state = 0;
            },
          ),

          _NavItem(
            icon: Icons.history,
            label: 'History',
            selected: selectedIndex == 1,
            onTap: () {
              ref.read(selectProvider.notifier).state = 1;
            },
          ),

          _NavItem(
            icon: Icons.payment,
            label: 'Payment',
            selected: selectedIndex == 2,
            onTap: () {
              ref.read(selectProvider.notifier).state = 2;
            },
          ),

          _NavItem(
            icon: Icons.person,
            label: 'Profile',
            selected: selectedIndex == 3,
            onTap: () {
              ref.read(selectProvider.notifier).state = 3;
            },
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFFFFD000) : const Color(0xFF647087);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: color),

          const SizedBox(height: 3),

          Text(label, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }
}
