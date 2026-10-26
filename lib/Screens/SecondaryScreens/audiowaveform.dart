import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shomic_2/Screens/SecondaryScreens/trimmable_waveform.dart';
import 'package:shomic_2/Screens/SecondaryScreens/view_waveform.dart';

class audioWaveform extends StatefulWidget {
  final String filepath;
  final double initialPixelsPerSecond;

  audioWaveform({
    super.key,
    required this.filepath,
    required this.initialPixelsPerSecond,
  });

  @override
  State<audioWaveform> createState() => _audioWaveformState();
}

class _audioWaveformState extends State<audioWaveform> {
  final player = AudioPlayer();
  Duration? duration = Duration.zero;
  Duration? position = Duration.zero;
  Waveform? waveform;
  double extractionProgress = 0.0;

  bool isExtracting = false;
  late double pixelsPerSecond;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pixelsPerSecond=widget.initialPixelsPerSecond;
    initialized();
  }



  Future<void> initialized() async {
    try {
      await player.setFilePath(widget.filepath);
      setState(() {
        duration = player.duration;
      });
      player.positionStream.listen((newPosition) async {
        if (!mounted) return;
        setState(() {
          position = newPosition;
        });
      });

      player.playerStateStream.listen((state) async {
        if (state.processingState == ProcessingState.completed) {
          await player.seek(Duration.zero);
          await player.play();
        }
      });

      await extractWaveform();
    } catch (e) {
      print("Some Error Occurred While Initializing");
    }
  }

  Future<void> extractWaveform() async {
    try {
      setState(() {
        isExtracting = true;
        extractionProgress = 0;
      });

      final directory = await getTemporaryDirectory();

      final waveFile = File('${directory.path}/shomic_waveform.wave',);

      final progressStream = JustWaveform.extract(
        audioInFile: File(widget.filepath),
        waveOutFile: waveFile,
        zoom: WaveformZoom.pixelsPerSecond(1),
      );

      progressStream.listen(
        (progress) {
          if (!mounted) return;

          setState(() {
            extractionProgress = progress.progress;

            if (progress.waveform != null) {
              waveform = progress.waveform;
              isExtracting = false;
            }
          });
        },
        onError: (error) {
          debugPrint('Waveform extraction error: $error');

          if (!mounted) return;

          setState(() {
            isExtracting = false;
          });
        },
      );
    } catch (e) {
      debugPrint('Waveform extraction failed: $e');

      if (!mounted) return;

      setState(() {
        isExtracting = false;
      });
    }
  }

  Future<void> toggleButton() async {
    if (player.playing) {
      await player.pause();
    } else {
      await player.play();
    }
  }

  String formatDuration(Duration? value) {
    final minutes = value!.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    player.dispose();

    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: toggleButton,
              child: Icon(
                player.playing
                    ? Icons.stop_circle_outlined
                    : Icons.play_circle_fill_rounded,
                color: Colors.white,
              ),
            ),
            Text(
              formatDuration(position),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              formatDuration(duration),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            waveform != null
                ? TrimmedWaveform(
                    waveform: waveform,
                    duration: duration!,
                    filepath: widget.filepath,
                    onPixelsPerSecondChanged: (newValue){

                      setState(() {
                        pixelsPerSecond=newValue;
                      });
                      extractWaveform();
                    },
                  )
                : CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
