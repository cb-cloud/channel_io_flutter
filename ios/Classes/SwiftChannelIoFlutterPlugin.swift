import Flutter
import UIKit
import ChannelIO

public class SwiftChannelIoFlutterPlugin: NSObject, FlutterPlugin {
    
    public static let channelIoFlutterPluginHandler = SwiftChannelIoFlutterPluginHandler()

    public func application(_ application: UIApplication,
                              didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        ChannelIO.initPushToken(deviceToken: deviceToken)
    }

    enum CallMethod: String {
        case boot
        case shutdown
        case showMessenger
        case isBooted
        case setDebugMode
        case isChannelPushNotification
        case receivePushNotification
        case storePushNotification
        case hasStoredPushNotification
        case openStoredPushNotification
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "com.cbcloud/channel_io_flutter", binaryMessenger: registrar.messenger())
        let plugin = SwiftChannelIoFlutterPlugin()
        registrar.addMethodCallDelegate(plugin, channel: methodChannel)
        registrar.addApplicationDelegate(plugin)
        
        let unreadEventChannel = FlutterEventChannel(name: "com.cbcloud/channel_io_flutter/unread", binaryMessenger: registrar.messenger())
        unreadEventChannel.setStreamHandler(channelIoFlutterPluginHandler)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch CallMethod(rawValue: call.method).unsafelyUnwrapped {
        case .boot:
            boot(call, result)
        case .shutdown:
            shutdown(call, result)
        case .showMessenger:
            showMessenger(call, result)
        case .isBooted:
            isBooted(call, result)
        case .setDebugMode:
            setDebugMode(call, result)
        case .isChannelPushNotification:
            isChannelPushNotification(call, result)
        case .receivePushNotification:
            receivePushNotification(call, result)
        case .storePushNotification:
            storePushNotification(call, result)
        case .hasStoredPushNotification:
            hasStoredPushNotification(call, result)
        case .openStoredPushNotification:
            openStoredPushNotification(call, result)
        }
    }
    
    private func boot(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let argMaps = call.arguments as? Dictionary<String, Any>,
              let pluginKey = argMaps["pluginKey"] as? String else {
            result(FlutterError(code: call.method, message: "Missing argument", details: nil))
            return
        }
        
        let profile = Profile()
        if let email = argMaps["email"] as? String {
            profile.set(email: email)
        }
        if let name = argMaps["name"] as? String {
            profile.set(name: name)
        }
        if let mobileNumber = argMaps["mobileNumber"] as? String {
            profile.set(mobileNumber: mobileNumber)
        }
                
        let memberId = argMaps["memberId"] as? String
        let memberHash = argMaps["memberHash"] as? String
        let trackDefaultEvent = argMaps["trackDefaultEvent"] as? Bool
        let hidePopup = argMaps["hidePopup"] as? Bool
        
        let language = argMaps["language"] as? String
        var enumLanguage: LanguageOption = LanguageOption.korean
        switch language {
        case "english":
            enumLanguage = LanguageOption.english
        case "korean":
            enumLanguage = LanguageOption.korean
        case "japanese":
            enumLanguage = LanguageOption.japanese
        default:
            enumLanguage = LanguageOption.device
        }
        
        let bootConfig = BootConfig.init(
            pluginKey: pluginKey,
            memberId: memberId,
            memberHash: memberHash,
            profile: profile,
            hidePopup: hidePopup ?? false,
            trackDefaultEvent: trackDefaultEvent ?? false,
            language: enumLanguage
        )
        
        ChannelIO.boot(with: bootConfig) { (completion, user) in
            if completion == .success, let _ = user {
                ChannelIO.delegate = SwiftChannelIoFlutterPlugin.channelIoFlutterPluginHandler
                result(true)
            } else {
                result(false)
            }
        }
    }
    
    private func shutdown(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        ChannelIO.shutdown()
        result(true)
    }
    
    private func showMessenger(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        ChannelIO.showMessenger()
        result(true)
    }
    
    private func isBooted(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        result(ChannelIO.isBooted)
    }
    
    private func setDebugMode(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let argMaps = call.arguments as? Dictionary<String, Any>,
              let flag = argMaps["flag"] as? Bool else {
            result(FlutterError(code: call.method, message: "Missing argument", details: nil))
            return
        }
        
        ChannelIO.setDebugMode(with: flag)
        result(true)
    }
    
    private func isChannelPushNotification(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let argMaps = call.arguments as? Dictionary<String, Any>,
              let content = argMaps["content"] as? [AnyHashable : Any] else {
            result(FlutterError(code: call.method, message: "Missing argument", details: nil))
            return
        }
        
        result(ChannelIO.isChannelPushNotification(content))
    }
    
    private func receivePushNotification(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let argMaps = call.arguments as? Dictionary<String, Any>,
              let content = argMaps["content"] as? [AnyHashable : Any] else {
            result(FlutterError(code: call.method, message: "Missing argument", details: nil))
            return
        }
        
        ChannelIO.receivePushNotification(content)
        result(true)
    }
    
    private func storePushNotification(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let argMaps = call.arguments as? Dictionary<String, Any>,
              let content = argMaps["content"] as? [AnyHashable : Any] else {
            result(FlutterError(code: call.method, message: "Missing argument", details: nil))
            return
        }
        
        ChannelIO.storePushNotification(content)
        result(true)
    }
    
    private func hasStoredPushNotification(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        result(ChannelIO.hasStoredPushNotification())
    }
    
    private func openStoredPushNotification(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        ChannelIO.openStoredPushNotification()
        result(true)
    }
}
