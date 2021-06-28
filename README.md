# channel_io_flutter
Channel Talk Flutter Plugin.（Unofficial）

## Installation
Add channel_io_flutter Plugin to pubspec.yaml.
```yaml
dependencies:
    channel_io_flutter:
        git:
            url: https://github.com/cb-cloud/channel_io_flutter.git
            ref: main
```
### iOS
Add pod installation to ios/Podfile.
```pod
target 'Runner' do
  use_frameworks!
  use_modular_headers!
  # Add line
  pod 'ChannelIOSDK', podspec: 'https://mobile-static.channel.io/ios/latest/xcframework.podspec'
  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end
```

### Android
1. Implement firebase_messaging and make sure it works: https://pub.dev/packages/firebase_messaging#android-integration
2. Add the Firebase server key to Channel Talk: https://developers.channel.io/docs/android-push-notification
3. Add the following to your AndroidManifest.xml file.
```xml
<service
    android:name="com.cbcloud.channel_io_flutter.PushInterceptService"
    android:enabled="true"
    android:exported="true">
    <intent-filter>
      <action android:name="com.google.firebase.MESSAGING_EVENT" />
    </intent-filter>
</service>
```
4. If you wish to customise the icon of notification, add an image with an identical file name to the following path: https://developers.channel.io/docs/android-push-notification#step-4-register-your-fcm-icon
`/res/drawable/ch_push_icon.png`

## Usage
```dart
import 'package:channel_io_flutter/channel_io_flutter.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ChannelIoFlutter.boot(pluginKey: 'pluginKey');
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FloatingActionButton(
          onPressed: () async {
            await ChannelIoFlutter.showMessenger();
          },
        ),
      ),
    );
  }
}
```