//
//  SwiftChannelIoFlutterPluginHandler.swift
//  channel_io_flutter
//
//  Created by h.ando on 2021/06/04.
//

import Flutter
import UIKit
import ChannelIOFront

public class SwiftChannelIoFlutterPluginHandler: NSObject, ChannelPluginDelegate {
    
    public let unreadStreamHandler: ChannelIoStreamHandler = ChannelIoStreamHandler()
    public let onUrlClickedStreamHandler: ChannelIoStreamHandler = ChannelIoStreamHandler()
    
    public func sendBadge(count: Int) {
        unreadStreamHandler.add(count)
    }

    public func onUrlClicked(url: URL) -> Bool {
        onUrlClickedStreamHandler.add(url.absoluteString)
        return onUrlClickedStreamHandler.isListened()
    }
    
    public func onFollowChanged(key: String, value: Any?) {}
    
    public func onBadgeChanged(count: Int) {
        unreadStreamHandler.add(count)
    }
    
    public func onHideMessenger() {}
    
    public func onShowMessenger() {}
    
    public func onPopupDataReceived(event: PopupData) {}
    
    public func onChatCreated(chatId: String) {}
}

public class ChannelIoStreamHandler: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    
    public func add(_ argument: Any) {
        eventSink?(argument)
    }
    
    public func isListened() -> Bool {
        return eventSink != nil
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
