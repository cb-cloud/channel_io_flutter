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
    
    private var unreadStreamSink: FlutterEventSink?
    private var onUrlClickedStreamSink: FlutterEventSink?
    
    public func sendBadge(count: Int) {
        unreadStreamSink?(count)
    }

    public func onUrlClicked(url: URL) -> Bool {
        onUrlClickedStreamSink?(url.absoluteString)
        return true
    }
    
    public func onProfileChanged(key: String, value: Any?) {}
    
    public func onBadgeChanged(count: Int) {
        unreadStreamSink?(count)
    }
    
    public func onHideMessenger() {}
    
    public func onShowMessenger() {}
    
    public func onPopupDataReceived(event: PopupData) {}
    
    public func onChatCreated(chatId: String) {}
}

extension SwiftChannelIoFlutterPluginHandler: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        guard let channel = arguments as? String else {
            return FlutterError(code: "NOT_IMPLEMENTED", message: "EventChannel arguments must be specified.", details: nil)
        }
        
        switch(channel) {
        case "unread":
            unreadStreamSink = events
            return nil
        case "onUrlClicked":
            onUrlClickedStreamSink = events
            return nil
        default:
            return nil
        }
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        guard let channel = arguments as? String else {
            return FlutterError(code: "NOT_IMPLEMENTED", message: "EventChannel arguments must be specified.", details: nil)
        }
        
        switch(channel) {
        case "unread":
            unreadStreamSink = nil
            return nil
        case "onUrlClicked":
            onUrlClickedStreamSink = nil
            return nil
        default:
            return nil
        }
    }
}
