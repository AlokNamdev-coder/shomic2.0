import 'package:flutter/services.dart';

class MediaService {

  static const MethodChannel _channel =
  MethodChannel("com.shomic/media");

  Future<void> getAudioFiles() async {
    final result = await _channel.invokeMethod("getAudioFiles");

    print(result);
  }

}