import 'dart:async';

import 'package:flutter/services.dart';

class ChannelIoFlutter {
  static const MethodChannel _channel =
      const MethodChannel('com.cbcloud/channel_io_flutter');
  static const EventChannel _eventChannel =
      const EventChannel('com.cbcloud/channel_io_flutter/event');

  static Stream<Uri?>? _onUrlClicked;
  static Stream<dynamic>? _unreadStream;

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Stream<Uri?> get onUrlClicked => _onUrlClicked ??= _eventChannel
      .receiveBroadcastStream('onUrlClicked')
      .map((event) => Uri.tryParse(event));

  static Future<bool> boot({
    required String pluginKey,
    String? memberId,
    String? memberHash,
    String? name,
    String? avatarUrl,
    String? email,
    String? mobileNumber,
    String? language,
    Map<String, dynamic>? customAttributes,
    bool? unsubscribed,
    bool? trackDefaultEvent,
    bool? hidePopup,
  }) async {
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
    bootConfig['customAttributes'] = customAttributes;
    bootConfig['unsubscribed'] = unsubscribed;
    bootConfig['trackDefaultEvent'] = trackDefaultEvent;
    bootConfig['hidePopup'] = hidePopup;

    bootConfig.removeWhere((_, value) => value == null);

    return await _channel.invokeMethod('boot', bootConfig);
  }

  static Future<bool> shutdown() async {
    return await _channel.invokeMethod('shutdown');
  }

  static Future<bool> showMessenger() async {
    return await _channel.invokeMethod('showMessenger');
  }

  static Future<bool> isBooted() async {
    return await _channel.invokeMethod('isBooted');
  }

  static Future<bool> setDebugMode({required bool flag}) async {
    return await _channel.invokeMethod('setDebugMode', {
      'flag': flag,
    });
  }

  static Future<bool> initPushToken({required String deviceToken}) async {
    return await _channel.invokeMethod('initPushToken', {
      'deviceToken': deviceToken,
    });
  }

  static Future<bool> isChannelPushNotification({
    required Map<String, dynamic> content,
  }) async {
    return await _channel.invokeMethod('isChannelPushNotification', {
      'content': content,
    });
  }

  static Future<bool> receivePushNotification({
    required Map<String, dynamic> content,
  }) async {
    return await _channel.invokeMethod('receivePushNotification', {
      'content': content,
    });
  }

  static Future<bool> hasStoredPushNotification() async {
    return await _channel.invokeMethod('hasStoredPushNotification');
  }

  static Future<bool> openStoredPushNotification() async {
    return await _channel.invokeMethod('openStoredPushNotification');
  }

  static Future<bool> addTags({
    required List<String> tags,
  }) async {
    return await _channel.invokeMethod('addTags', {
      'tags': tags,
    });
  }

  static Stream<dynamic> getUnreadStream() {
    return _unreadStream ??= _eventChannel.receiveBroadcastStream('unread');
  }
}
