
import 'dart:async';

import 'package:flutter/services.dart';

class ChannelIoFlutter {
  static const MethodChannel _channel =
      const MethodChannel('channel_io_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
