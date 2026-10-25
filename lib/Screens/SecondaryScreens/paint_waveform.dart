import 'package:flutter/material.dart';
import 'package:just_waveform/just_waveform.dart';

class WaveformPainter extends CustomPainter {
  final Waveform? waveform;

  WaveformPainter(this.waveform);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromRGBO(255, 255, 255, 0.2)
      ..strokeWidth = 5
      ..strokeCap=StrokeCap.round;


    final centerY = size.height / 2;


    final waveformLength = waveform!.length;
    print('the length of wavefrom is :$waveformLength');

    if (waveformLength == 0) {
      return;
    }

    // Find the largest amplitude in the whole waveform.
    int largestAmplitude = 0;

    for (int i = 0; i < waveformLength; i++) {
      final max = waveform!.getPixelMax(i).abs();
      final min = waveform!.getPixelMin(i).abs();

      final amplitude = max > min ? max : min;

      if (amplitude > largestAmplitude) {
        largestAmplitude = amplitude;
      }
    }

    if (largestAmplitude == 0) {
      return;
    }

    final barWidth = size.width / waveformLength;
    print("barwidth:$barWidth");
    print("Screen Width on Paint Screen:${size.width}");

    for (int i = 0; i < waveformLength; i++) {

      final maxValue = waveform!.getPixelMax(i);

      final minValue = waveform!.getPixelMin(i);

      // Normalize the values between -1 and +1.

      final normalizedMax =
          maxValue / largestAmplitude;

      final normalizedMin =
          minValue / largestAmplitude;

      final x = i * barWidth;

      final top =
          centerY - (normalizedMax * centerY);

      final bottom =
          centerY - (normalizedMin * centerY);

      canvas.drawLine(
        Offset(x, top),
        Offset(x, bottom),
        paint,
      );


    }
  }

  @override
  bool shouldRepaint(
      covariant WaveformPainter oldDelegate,
      ) {
    return oldDelegate.waveform != waveform;
  }
}