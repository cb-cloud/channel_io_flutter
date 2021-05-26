import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ChannelIoFlutter {
  static const MethodChannel _channel =
      const MethodChannel('com.cbcloud/channel_io_flutter');
  static const EventChannel _unreadChannel =
      const EventChannel('com.cbcloud/channel_io_flutter/unread');

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

  static Future<bool> initPushToken({
    @required String deviceToken,
  }) {
    return _channel.invokeMethod('initPushToken', {
      'deviceToken': deviceToken,
    });
  }

  static Future<bool> isChannelPushNotification({
    @required Map<String, dynamic> content,
  }) {
    return _channel.invokeMethod('isChannelPushNotification', {
      'content': content,
    });
  }

  static Future<bool> receivePushNotification({
    @required Map<String, dynamic> content,
  }) {
    return _channel.invokeMethod('receivePushNotification', {
      'content': content,
    });
  }

  static Future<bool> hasStoredPushNotification() {
    return _channel.invokeMethod('hasStoredPushNotification');
  }

  static Future<bool> openStoredPushNotification() {
    return _channel.invokeMethod('openStoredPushNotification');
  }

  static Stream<dynamic> getUnreadStream() {
    return _unreadChannel.receiveBroadcastStream();
  }
}
