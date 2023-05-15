# reCAPTCHA Enterprise Flutter Module

NOTE: This plugin is considered a Public Preview at this stage and the public
API is subject to change.

Please note that issues filed in this repository are not an official Google
support channel and are answered on a best effort basis. For official support,
please visit: https://cloud.google.com/support-hub.

If you have an issue with the Flutter plugin please post issues in this
repository. If you are having issues with the underlying SDK, please post issues
in
[https://github.com/GoogleCloudPlatform/recaptcha-enterprise-mobile-sdk](https://github.com/GoogleCloudPlatform/recaptcha-enterprise-mobile-sdk).

For general documentation on reCAPTCHA Enterprise for mobile applications, see
[Android](https://cloud.google.com/recaptcha-enterprise/docs/instrument-android-apps)
and
[iOS](https://cloud.google.com/recaptcha-enterprise/docs/instrument-ios-apps).

initClient:

```
    try {
      await RecaptchaEnterprise.initClient(siteKey);
    } catch (err) {
      print('Caught exception on init: $err');
    }
```

Execute:

```
    try {
      await RecaptchaEnterprise.execute("LOGIN");
    } catch (err) {
      print('Caught exception on execute: $err');
    }
```

## Sample App

Copy example/assets/configs/dev.json.example to example/assets/configs/dev.json
and add your sitekeys to the file.

Change ios bundle id in example/ios/Runner.xcodeproj/project.pbxproj from
google.FlutterTestApp in three places to your own bundle id.

Change the Android bundle id in example/android/app/build.gradle from
google.FlutterTestApp to your own.

Start an emulator, e.g. `open -a Simulator` or
`~/Library/Android/sdk/emulator/emulator -avd Pixel_4_API_32`

### Run app:

```
cd example && flutter run
```

### Run unit tests:

```
flutter test
```

### Running Integration Tests

```
cd example && flutter test integration_test/app_test.dart
```

## Upgrade SDK version

### Common

Update the CHANGELOG.md

Bump version of plugin in pubspec.yaml. The version of the plugin will roughly
follow the version of the underlying SDK. In the cases where the latest Android
and iOS versions are different, the plugin will include the latest version of
the SDK up to the version of the plugin. This means the plugin may pull in a new
version of the SDK without changing the plugin version, but the plugin API
itself will not change without a change in the plugin version.

For instance if the plugin version is 18.1.2 and the latest Android SDK is
18.1.1, then build.gradle will have an inclusive range: `[18.1.1,18.1.2]`

Check package analysis:

```
flutter pub publish --dry-run
```

### iOS

Change version in ios/recaptcha_enterprise.podspec

Update ios example app

```
cd example/ios && pod update
```

### Android

Upgrade version in android/build.gradle

### Final step

```
flutter pub publish
```
