package com.cbcloud.channel_io_flutter

import android.app.Activity
import android.app.Application
import android.content.Context
import androidx.annotation.NonNull
import com.zoyi.channel.plugin.android.ChannelIO
import com.zoyi.channel.plugin.android.open.config.BootConfig
import com.zoyi.channel.plugin.android.open.enumerate.BootStatus
import com.zoyi.channel.plugin.android.open.model.Profile
import com.zoyi.channel.plugin.android.open.option.Language
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.*
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** ChannelIoFlutterPlugin */
class ChannelIoFlutterPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private lateinit var activity: Activity
  private val channelIoFlutterPluginListener = ChannelIoFlutterPluginListener()

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.cbcloud/channel_io_flutter")
    channel.setMethodCallHandler(this)

    val unreadEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, ChannelIoFlutterPluginListener.EVENT_CHANNEL)
    unreadEventChannel.setStreamHandler(channelIoFlutterPluginListener)

    context = flutterPluginBinding.applicationContext

    try {
      ChannelIO.initialize(context as Application?)
    } catch (e: Exception) {
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
        "boot" -> {
          boot(call, result)
        }
        "shutdown" -> {
          shutdown(result)
        }
        "showMessenger" -> {
          showMessenger(result)
        }
        "isBooted" -> {
          isBooted(result)
        }
        "setDebugMode" -> {
          setDebugMode(call, result)
        }
        "initPushToken" -> {
          initPushToken(call, result)
        }
        "isChannelPushNotification" -> {
          isChannelPushNotification(call, result)
        }
        "receivePushNotification" -> {
          receivePushNotification(call, result)
        }
        "storePushNotification" -> {
          result.error("UNAVAILABLE", "There is no API in Android", null)
        }
        "hasStoredPushNotification" -> {
          hasStoredPushNotification(result)
        }
        "openStoredPushNotification" -> {
          openStoredPushNotification(result)
        }
        else -> {
          result.notImplemented()
        }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivity() {}

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {}

  private fun boot(call: MethodCall, result: Result) {
    val pluginKey = call.argument<String>("pluginKey")
    if (pluginKey == null || pluginKey.isEmpty()) {
      result.error("UNAVAILABLE", "Missing argument(pluginKey)", null)
      return
    }

    val profile = Profile.create()
    call.argument<String>("email")?.let {
      profile.setEmail(it)
    }
    call.argument<String>("name")?.let {
      profile.setName(it)
    }
    call.argument<String>("mobileNumber")?.let {
      profile.setMobileNumber(it)
    }

    val bootConfig = BootConfig.create(pluginKey)
            .setProfile(profile)
    call.argument<String>("memberId")?.let {
      bootConfig.memberId = it
    }
    call.argument<Boolean>("trackDefaultEvent")?.let {
      bootConfig.setTrackDefaultEvent(it)
    }
    call.argument<Boolean>("hidePopup")?.let {
      bootConfig.setHidePopup(it)
    }
    call.argument<String>("language")?.let {
      bootConfig.setLanguage(getLanguage(it))
    }
    call.argument<String>("memberHash")?.let {
      bootConfig.setMemberHash(it)
    }

    ChannelIO.boot(bootConfig) { bootStatus, user ->
      if (bootStatus == BootStatus.SUCCESS && user != null) {
        if (ChannelIO.hasStoredPushNotification(activity)) {
          ChannelIO.openStoredPushNotification(activity)
        }
        ChannelIO.setListener(channelIoFlutterPluginListener)
        channelIoFlutterPluginListener.sendBadge(user.alert)
        result.success(true)
      } else {
        result.error("ERROR", "Execution failed(boot)", null)
      }
    }
  }

  private fun shutdown(result: Result) {
    ChannelIO.shutdown()
    result.success(true)
  }

  private fun showMessenger(result: Result) {
    if (!ChannelIO.isBooted()) {
      result.error("UNAVAILABLE", "Channel Talk is not booted", null)
    }
    ChannelIO.showMessenger(activity)
    result.success(true)
  }

  private fun isBooted(result: Result) {
    result.success(ChannelIO.isBooted())
  }

  private fun setDebugMode(call: MethodCall, result: Result) {
    val flag = call.argument<Boolean>("flag")
    flag ?: run {
      result.error("UNAVAILABLE", "Missing argument(flag)", null)
      return
    }

    ChannelIO.setDebugMode(flag)
    result.success(true)
  }

  private fun getLanguage(lang: String): Language? {
    return when (lang) {
      "english" -> Language.ENGLISH
      "korean" -> Language.KOREAN
      "japanese" -> Language.JAPANESE
      else -> Language.KOREAN
    }
  }

  private fun initPushToken(call: MethodCall, result: Result) {
    val deviceToken = call.argument<String>("deviceToken")
    if (deviceToken == null || deviceToken.isEmpty()) {
      result.error("UNAVAILABLE", "Missing argument(deviceToken)", null)
      return
    }
    try {
      ChannelIO.initPushToken(deviceToken)
    } catch (e: java.lang.Exception) {
    }
    result.success(true)
  }

  private fun isChannelPushNotification(call: MethodCall, result: Result) {
    val content = call.argument<Map<String, String>>("content")
    if (content == null || content.isEmpty()) {
      result.error("UNAVAILABLE", "Missing argument(content)", null)
      return
    }
    val res = ChannelIO.isChannelPushNotification(content)
    result.success(res)
  }

  private fun receivePushNotification(call: MethodCall, result: Result) {
    val content = call.argument<Map<String, String>>("content")
    if (content == null || content.isEmpty()) {
      result.error("UNAVAILABLE", "Missing argument(content)", null)
      return
    }
    ChannelIO.receivePushNotification(context, content)
    result.success(true)
  }

  private fun hasStoredPushNotification(result: Result) {
    val res = ChannelIO.hasStoredPushNotification(activity)
    result.success(res)
  }

  private fun openStoredPushNotification(result: Result) {
    ChannelIO.openStoredPushNotification(activity)
    result.success(true)
  }
}
