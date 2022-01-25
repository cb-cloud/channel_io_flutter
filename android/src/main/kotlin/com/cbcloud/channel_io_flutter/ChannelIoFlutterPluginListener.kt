package com.cbcloud.channel_io_flutter

import com.zoyi.channel.plugin.android.open.listener.ChannelPluginListener
import com.zoyi.channel.plugin.android.open.model.PopupData
import io.flutter.plugin.common.EventChannel
import java.lang.IllegalArgumentException

class ChannelIoFlutterPluginListener : ChannelPluginListener {

    companion object {
        const val UNREAD_EVENT_CHANNEL = "com.cbcloud/channel_io_flutter/unread"
        const val ON_URL_CLICKED_EVENT_CHANNEL = "com.cbcloud/channel_io_flutter/on_url_clicked"
    }

    val unreadEventHandler: ChannelIoStreamHandler = ChannelIoStreamHandler()
    val onUrlClickEventHandler: ChannelIoStreamHandler = ChannelIoStreamHandler()

    fun sendBadge(p0: Int) {
        unreadEventHandler.mEventSink?.success(p0)
    }

    // ChannelPluginListener

    override fun onUrlClicked(p0: String?): Boolean {
        if (p0 == null) return false

        onUrlClickEventHandler.mEventSink?.success(p0)
        return true
    }

    override fun onProfileChanged(p0: String?, p1: Any?) {}

    override fun onBadgeChanged(p0: Int) {
        unreadEventHandler.mEventSink?.success(p0)
    }

    override fun onHideMessenger() {}

    override fun onPushNotificationClicked(p0: String?): Boolean {
        return false
    }

    override fun onShowMessenger() {}

    override fun onPopupDataReceived(p0: PopupData?) {}

    override fun onChatCreated(p0: String?) {}
}

class ChannelIoStreamHandler : EventChannel.StreamHandler {

    var mEventSink: EventChannel.EventSink? = null
        private set

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        mEventSink = events
    }

    override fun onCancel(arguments: Any?) {
        mEventSink = null
    }
}