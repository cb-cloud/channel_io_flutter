#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint channel_io_flutter.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'channel_io_flutter'
  s.version          = '0.0.22'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'ChannelIOSDK','11.7.2'
  s.platform = :ios, '8.0'
  s.resource_bundles = {'channel_io_flutter_privacy' => ['PrivacyInfo.xcprivacy']}

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
