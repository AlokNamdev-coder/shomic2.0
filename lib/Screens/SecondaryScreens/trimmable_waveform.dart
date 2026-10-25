import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:shomic_2/Components/SnackBar.dart';
import 'package:shomic_2/Screens/SecondaryScreens/view_waveform.dart';

import '../../Components/duration_picker_bottom_sheet.dart';

class TrimmedWaveform extends StatefulWidget {
  final Waveform? waveform;
  final Duration duration;
  final String filepath;
  final ValueChanged<double> onPixelsPerSecondChanged;
  const TrimmedWaveform({
    super.key,
    required this.waveform,
    required this.duration,
    required this.filepath,
    required this.onPixelsPerSecondChanged
  });

  @override
  State<TrimmedWaveform> createState() => _TrimmedWaveformState();
}

class _TrimmedWaveformState extends State<TrimmedWaveform>
    with SingleTickerProviderStateMixin {
  double waveformOffset = 0;
  double? start;
  double? end;
  final AudioPlayer player = AudioPlayer();
  late AnimationController controller;
  int? clipDuration = 6;
  double? pixelsPerSecond;
  double customPixelPerSecond=10;
  late double customWaveformWidth;


  Future<void> playTrimmedPart(
    AudioPlayer player,
    double startDuration,
    double endDuration,
    String filepath,
  ) async {
    try {
      await player.setFilePath(filepath);
      await player.setClip(
        start: Duration(seconds: startDuration.toInt()),
        end: Duration(seconds: endDuration.toInt()),
      );
      await player.play();
    } catch (e) {
      if (mounted) {
        customSnackBar(context, text: e.toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final path = widget.filepath;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final box_width = width * 0.3;
    final waveFormWidth = (width)/(widget.waveform!.length);

    final center = width * 0.5;
    final upperLimit = ((widget.waveform!.length) *(waveFormWidth) - center);
    final lowerLimit = center + box_width - (widget.waveform!.length * (waveFormWidth));
    final durationInSecond = (widget.duration.inSeconds);
    final secondsPerPixels =
        (durationInSecond) / ((durationInSecond * 2 * (waveFormWidth)));
    double initialDuration = center * secondsPerPixels;
    double initialEndDuration = (center + box_width) * secondsPerPixels;

    customWaveformWidth=(durationInSecond*customPixelPerSecond);
    print("the width of wavelength is:$customWaveformWidth");

    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Positioned(
                child: ClipRRect(
                  child: GestureDetector(
                    onHorizontalDragStart: (_) {
                      controller.reset();
                    },
                    onHorizontalDragEnd: (details) {
                      setState(() {
                        playTrimmedPart(player, start!, end!, path);
                        player.playerStateStream.listen((state) async {
                          if (state.processingState ==
                              ProcessingState.completed) {
                            await player.seek(
                              Duration(seconds: start!.toInt()),
                            );
                            await player.play();
                          }
                        });
                        controller.repeat();
                      });
                    },
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        waveformOffset += details.delta.dx;
                        waveformOffset = waveformOffset.clamp(
                          lowerLimit,
                          upperLimit,
                        );

                        start =
                            initialDuration -
                            ((waveformOffset) * secondsPerPixels);
                        end =
                            initialEndDuration -
                            ((waveformOffset) * secondsPerPixels);
                        start = start!.floor().toDouble();
                        end = end!.floor().toDouble();
                        print(start);

                        print(details.delta.dx);
                      });
                    },

                    child: Transform.translate(
                      offset: Offset(waveformOffset, 0),
                      child: WaveformView(waveform: widget.waveform,customWidth:customWaveformWidth ,),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: center,
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return Container(
                      width: box_width,
                      height: height * 0.065,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.deepPurpleAccent,
                          width: 2,
                        ),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: controller.value,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.2),
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                '$start'.padLeft(2),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$end",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.black,
                    builder: (context) {
                      return DurationPickerSheet(
                        selectedDuration: clipDuration!,
                        onDurationChanged: (newValue) {
                          if(clipDuration!>durationInSecond){
                            customSnackBar(context, text:"Clip Duration Can't be Greater than Actual Duration");
                            print("the clip Duration is:$clipDuration");
                            print("the Actual Duration is:$durationInSecond");

                          }else{
                            setState(() {
                              clipDuration = newValue;
                              pixelsPerSecond = ((box_width/(clipDuration!))*0.1);
                              print("the Pixels Per Second is:$pixelsPerSecond");
                              print("the Pixels Per Second in Int:${pixelsPerSecond!.toInt()}");

                            });
                            widget.onPixelsPerSecondChanged(pixelsPerSecond!);
                          }
                        },
                      );
                    },
                  );

                },
                child: Text(
                  "Select Duration",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "$clipDuration",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
