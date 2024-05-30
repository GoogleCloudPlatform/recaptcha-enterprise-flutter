#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint recaptcha_enterprise.podspec` to validate before publishing.
#

Pod::Spec.new do |s|
  s.name             = 'recaptcha_enterprise_flutter'
  s.version          = '18.5.1'
  s.summary          = 'reCAPTCHA Enterprise Flutter plugin'
  s.description      = <<-DESC
  reCAPTCHA Enterprise Flutter plugin
                       DESC
  s.homepage         = 'https://cloud.google.com/recaptcha-enterprise/'
  s.license          = { :file => '../LICENSE' }
  s.author           = 'Google, Inc.'
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'RecaptchaEnterprise', '=18.5.1'
  s.platform = :ios, '12.0'
  s.static_framework = true
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end