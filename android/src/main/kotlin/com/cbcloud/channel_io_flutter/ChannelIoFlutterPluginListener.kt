package com.cbcloud.channel_io_flutter

import com.zoyi.channel.plugin.android.open.listener.ChannelPluginListener
import com.zoyi.channel.plugin.android.open.model.PopupData
import io.flutter.plugin.common.EventChannel

class ChannelIoFlutterPluginListener : ChannelPluginListener, EventChannel.StreamHandler {

    companion object {
        const val EVENT_CHANNEL = "com.cbcloud/channel_io_flutter/unread"
    }

    // EventChannel.StreamHandler

    private var mEventSink: EventChannel.EventSink? = null

    fun sendBadge(p0: Int) {
        mEventSink?.success(p0)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        mEventSink = events
    }

    override fun onCancel(arguments: Any?) {}

    // ChannelPluginListener

    override fun onUrlClicked(p0: String?): Boolean {
        return false
    }

    override fun onProfileChanged(p0: String?, p1: Any?) {}

    override fun onBadgeChanged(p0: Int) {
        mEventSink?.success(p0)
    }

    override fun onHideMessenger() {}

    override fun onPushNotificationClicked(p0: String?): Boolean {
        return false
    }

    override fun onShowMessenger() {}

    override fun onPopupDataReceived(p0: PopupData?) {}

    override fun onChatCreated(p0: String?) {}
}
