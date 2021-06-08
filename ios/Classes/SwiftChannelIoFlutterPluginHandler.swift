//
//  SwiftChannelIoFlutterPluginHandler.swift
//  channel_io_flutter
//
//  Created by h.ando on 2021/06/04.
//

import Flutter
import UIKit
import ChannelIO

public class SwiftChannelIoFlutterPluginHandler: NSObject, ChannelPluginDelegate {
    
    public override init() {
        super.init()
        ChannelIO.delegate = self
    }
    
    var eventSink: FlutterEventSink?
    
    public func onUrlClicked(url: URL) -> Bool {
        return false
    }
    
    public func onProfileChanged(key: String, value: Any?) {}
    
    public func onBadgeChanged(count: Int) {
        eventSink?(count)
    }
    
    public func onHideMessenger() {}
    
    public func onShowMessenger() {}
    
    public func onPopupDataReceived(event: PopupData) {}
    
    public func onChatCreated(chatId: String) {}
}

extension SwiftChannelIoFlutterPluginHandler: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
