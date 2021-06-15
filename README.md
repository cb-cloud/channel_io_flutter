# channel_io_flutter
Channel Talk Flutter Plugin.

## Installation
```yaml
dependencies:
    channel_io_flutter:
        git:
            url: https://github.com/cb-cloud/channel_io_flutter.git
            ref: main
```
### iOS
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
hoge

## Usage
```dart
import 'package:channel_io_flutter/channel_io_flutter.dart';

void main() async {
    await ChannelIoFlutter.boot(pluginKey: 'pluginKey');
}
```