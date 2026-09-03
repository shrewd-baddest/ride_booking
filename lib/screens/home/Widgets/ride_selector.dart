import 'package:flutter/material.dart';
import 'package:ride_booking/screens/home/Widgets/ride_model.dart';

import 'ride_card.dart';

class RideSelector extends StatelessWidget {
  final List<RideModel> rides;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const RideSelector({
    super.key,
    required this.rides,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'CHOOSE RIDE',
            style: TextStyle(
              color: Color(0xFF65728B),
              fontSize: 9,
              letterSpacing: 1.4,
            ),
          ),
        ),

        const SizedBox(height: 10),

        Row(
          children: List.generate(rides.length, (index) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index == rides.length - 1 ? 0 : 8,
                ),
                child: RideCard(
                  ride: rides[index],
                  selected: index == selectedIndex,
                  onTap: () {
                    onSelected(index);
                  },
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
