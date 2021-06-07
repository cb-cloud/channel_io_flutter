package com.cbcloud.channel_io_flutter

import android.util.Log
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import com.zoyi.channel.plugin.android.ChannelIO

class PushInterceptService : FirebaseMessagingService() {
    override fun onNewToken(p0: String) {
        super.onNewToken(p0)

        ChannelIO.initPushToken(p0)
    }

    override fun onMessageReceived(p0: RemoteMessage) {
        super.onMessageReceived(p0)

        val message = p0.data
        if (ChannelIO.isChannelPushNotification(message)) {
            Log.d(TAG, "Channel Talk message received")
            ChannelIO.receivePushNotification(application, message)
        } else {
            Log.d(TAG, "Push message received, not for Channel Talk")
        }
    }

    companion object {
        private const val TAG = "PushInterceptService"
    }
}