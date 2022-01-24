package com.cbcloud.channel_io_flutter

import com.zoyi.channel.plugin.android.open.listener.ChannelPluginListener
import com.zoyi.channel.plugin.android.open.model.PopupData
import io.flutter.plugin.common.EventChannel
import java.lang.IllegalArgumentException

class ChannelIoFlutterPluginListener : ChannelPluginListener, EventChannel.StreamHandler {

    companion object {
        const val EVENT_CHANNEL = "com.cbcloud/channel_io_flutter/event"
    }

    // EventChannel.StreamHandler

    private var mUnreadEventSink: EventChannel.EventSink? = null
    private var mOnUrlClickEventSink: EventChannel.EventSink? = null

    fun sendBadge(p0: Int) {
        mUnreadEventSink?.success(p0)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        if (arguments == null) {
            throw IllegalArgumentException("EventChannel arguments must be specified.")
        }

        when (arguments) {
            "unread" -> mUnreadEventSink = events
            "onUrlClicked" -> mOnUrlClickEventSink = events
        }
    }

    override fun onCancel(arguments: Any?) {
        if (arguments == null) {
            throw IllegalArgumentException("EventChannel arguments must be specified.")
        }

        when (arguments) {
            "unread" -> mUnreadEventSink = null
            "onUrlClicked" -> mOnUrlClickEventSink = null
        }
    }

    // ChannelPluginListener

    override fun onUrlClicked(p0: String?): Boolean {
        if (p0 == null) return false

        mOnUrlClickEventSink?.success(p0)
        return true
    }

    override fun onProfileChanged(p0: String?, p1: Any?) {}

    override fun onBadgeChanged(p0: Int) {
        mUnreadEventSink?.success(p0)
    }

    override fun onHideMessenger() {}

    override fun onPushNotificationClicked(p0: String?): Boolean {
        return false
    }

    override fun onShowMessenger() {}

    override fun onPopupDataReceived(p0: PopupData?) {}

    override fun onChatCreated(p0: String?) {}
}
