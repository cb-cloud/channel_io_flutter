import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ChannelIoFlutter {
  static const MethodChannel _channel =
      const MethodChannel('com.cbcloud/channel_io_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> boot({
    @required String pluginKey,
    String memberId,
    String memberHash,
    String name,
    String avatarUrl,
    String email,
    String mobileNumber,
    String language,
    bool unsubscribed,
    bool trackDefaultEvent,
    bool hidePopup,
  }) {
    Map<String, dynamic> bootConfig = {
      'pluginKey': pluginKey,
    };
    bootConfig['memberHash'] = memberHash;
    bootConfig['memberId'] = memberId;
    bootConfig['name'] = name;
    bootConfig['avatarUrl'] = avatarUrl;
    bootConfig['email'] = email;
    bootConfig['mobileNumber'] = mobileNumber;
    bootConfig['language'] = language;
    bootConfig['unsubscribed'] = unsubscribed;
    bootConfig['trackDefaultEvent'] = trackDefaultEvent;
    bootConfig['hidePopup'] = hidePopup;

    bootConfig.removeWhere((_, value) => value == null);

    return _channel.invokeMethod('boot', bootConfig);
  }

  static Future<bool> shutdown() {
    return _channel.invokeMethod('shutdown');
  }

  static Future<bool> showMessenger() {
    return _channel.invokeMethod('showMessenger');
  }

  static Future<bool> isBooted() {
    return _channel.invokeMethod('isBooted');
  }

  static Future<bool> setDebugMode({
    @required bool flag,
  }) {
    return _channel.invokeMethod('setDebugMode', {
      'flag': flag,
    });
  }
}
