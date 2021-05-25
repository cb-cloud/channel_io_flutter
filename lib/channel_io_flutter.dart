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
    if (memberHash != null) {
      bootConfig['memberHash'] = memberHash;
    }
    if (memberId != null) {
      bootConfig['memberId'] = memberId;
    }
    if (name != null) {
      bootConfig['name'] = name;
    }
    if (avatarUrl != null) {
      bootConfig['avatarUrl'] = avatarUrl;
    }
    if (email != null) {
      bootConfig['email'] = email;
    }
    if (mobileNumber != null) {
      bootConfig['mobileNumber'] = mobileNumber;
    }
    if (language != null) {
      bootConfig['language'] = language;
    }
    if (unsubscribed != null) {
      bootConfig['unsubscribed'] = unsubscribed;
    }
    if (trackDefaultEvent != null) {
      bootConfig['trackDefaultEvent'] = trackDefaultEvent;
    }
    if (hidePopup != null) {
      bootConfig['hidePopup'] = hidePopup;
    }

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
