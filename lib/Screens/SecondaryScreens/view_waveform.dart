import 'package:flutter/material.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:shomic_2/Screens/SecondaryScreens/paint_waveform.dart';

class WaveformView extends StatelessWidget {
  final Waveform? waveform;
  final double? customWidth;

  const WaveformView({
    super.key,
    required this.waveform,
    required this.customWidth
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 60,
      width: customWidth,
      child: Center(
        child: CustomPaint(
          painter: WaveformPainter(waveform),
          size: Size(
            customWidth!,
            30,
          ),
        ),
      ),
    );
  }
}