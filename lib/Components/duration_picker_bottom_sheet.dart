import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DurationPickerSheet extends StatefulWidget {
  final int selectedDuration;
  final ValueChanged<int> onDurationChanged;

  const DurationPickerSheet({
    super.key,
    required this.selectedDuration,
    required this.onDurationChanged,
  });

  @override
  State<DurationPickerSheet> createState() =>
      _DurationPickerSheetState();
}

class _DurationPickerSheetState extends State<DurationPickerSheet> {
  final List<int> durations = [
    5, 6, 7, 8, 9, 10,
    11, 12, 13, 14, 15,
    16, 17, 18, 19, 20,
    21, 22, 23, 24, 25,
    26, 27, 28, 29, 30,
    31, 32, 33, 34, 35,
    36, 37, 38, 39, 40,
    41, 42, 43, 44, 45,
    46, 47, 48, 49, 50,
    51, 52, 53, 54, 55,
    56, 57, 58, 59, 60,
  ];

  late int selectedDuration;

  @override
  void initState() {
    super.initState();

    selectedDuration = widget.selectedDuration;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 10),

          Text(
            "Choose Clip Duration",
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          Expanded(
            child: ListWheelScrollView.useDelegate(
              itemExtent: 50,
              physics: const FixedExtentScrollPhysics(),

              onSelectedItemChanged: (index) {
                setState(() {
                  selectedDuration = durations[index];
                });

                widget.onDurationChanged(selectedDuration);
              },

              childDelegate: ListWheelChildBuilderDelegate(
                childCount: durations.length,

                builder: (context, index) {
                  final duration = durations[index];

                  final isSelected =
                      duration == selectedDuration;

                  return Center(
                    child: Text(
                      "$duration s",
                      style: TextStyle(
                        fontSize: isSelected ? 24 : 17,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}