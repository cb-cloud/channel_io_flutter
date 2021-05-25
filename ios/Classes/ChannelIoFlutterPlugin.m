#import "ChannelIoFlutterPlugin.h"
#if __has_include(<channel_io_flutter/channel_io_flutter-Swift.h>)
#import <channel_io_flutter/channel_io_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "channel_io_flutter-Swift.h"
#endif

@implementation ChannelIoFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftChannelIoFlutterPlugin registerWithRegistrar:registrar];
}
@end
