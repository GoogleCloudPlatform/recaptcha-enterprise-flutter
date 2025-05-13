
# reCAPTCHA Enterprise Flutter Module

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

## Integrating reCAPTCHA Enterprise with your Flutter Application

This guide outlines the steps to integrate reCAPTCHA Enterprise into your
Flutter application for enhanced security.

### 1. Environment Setup

1.  **Add the reCAPTCHA Enterprise Flutter library:**

    Execute the following command in your Flutter project's root directory:

    ```bash
    flutter pub add recaptcha_enterprise_flutter
    ```

    **Note:** This library supports only iOS and Android platforms.

### 2. Client Initialization

1.  **Obtain Site Keys:**

    Acquire your reCAPTCHA Enterprise site keys for both Android and iOS
    platforms from the Google Cloud Console.

2.  **Instantiate the `RecaptchaClient`:**

    Initialize the client using the appropriate site key based on the platform.
    It's crucial to initialize the client as early as possible within your
    application's lifecycle to minimize latency.

    ```dart
    import 'package:flutter/material.dart';
    import 'package:recaptcha_enterprise_flutter/recaptcha_enterprise_flutter.dart';
    import 'dart:io' show Platform;

    void main() async {
      WidgetsFlutterBinding.ensureInitialized();

      final siteKey = Platform.isAndroid
          ? "<ANDROID_SITE_KEY>"
          : "<IOS_SITE_KEY>";

      RecaptchaClient client = await Recaptcha.fetchClient(siteKey);

      runApp(MyApp(client: client));
    }

    class MyApp extends StatelessWidget {
      final RecaptchaClient client;

      const MyApp({super.key, required this.client});

      // ... other code ...
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          home: MyHomePage(title: 'reCAPTCHA Demo', client: client),
        );
      }
    }
    ```

    **Important:**

    *   Replace `<ANDROID_SITE_KEY>` and `<IOS_SITE_KEY>` with your actual
        reCAPTCHA Enterprise site keys.
    *   The example above demonstrates platform-specific site key selection. You
        can adopt alternative strategies, such as using asset files, to manage
        your site keys.
    *   Initialization of the SDK can take several seconds to complete. To
        mitigate this latency, initialize the client as early as possible,

### 3. Executing reCAPTCHA Actions

1.  **Invoke the `execute` method:**

    For each action within your application that requires reCAPTCHA protection
    (e.g., login, registration), call the `execute` method of the
    `RecaptchaClient`, passing a `RecaptchaAction` instance.

    ```dart
    class MyHomePage extends StatefulWidget {
      const MyHomePage({super.key, required this.title, required this.client});

      final String title;
      final RecaptchaClient client;

      Future<bool> _login() async {
        try {
          String token = await client.execute(RecaptchaAction.LOGIN());
          // Send the token to your server for assessment.
          return await handleToken(token); // handleToken is a function that sends the token to your backend.
        } catch (err) {
          // Handle reCAPTCHA execution errors.
          print('reCAPTCHA execution error: $err');
          return false;
        }
      }

      // ... other code ...

      @override
      State<MyHomePage> createState() => _MyHomePageState();
    }

    class _MyHomePageState extends State<MyHomePage> {
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // ... other UI elements ...
                ElevatedButton(
                  onPressed: () async {
                    bool loginSuccess = await widget._login();
                    if(loginSuccess){
                      // handle successful login
                    } else {
                      // handle failed login
                    }
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        );
      }

    }
    Future<bool> handleToken(String token) async{
      // sends token to your backend.
      // this is a placeholder function, and needs to be implemented.
      return true;
    }
    ```

    *   Replace `handleToken(token)` with your server-side logic for assessing
        the reCAPTCHA token.

### 4. Error Handling

1.  **Implement Robust Error Handling:**

    Your application must gracefully handle potential errors during reCAPTCHA
    service communication. Implement appropriate error handling mechanisms to
    manage scenarios where the API encounters issues.

2.  **Refer to Official Documentation:**

    Consult the official Google Cloud reCAPTCHA Enterprise documentation for
    detailed information on error codes and best practices:

    *   [Android](https://cloud.google.com/recaptcha-enterprise/docs/instrument-android-apps)
    *   [iOS](https://cloud.google.com/recaptcha-enterprise/docs/instrument-ios-apps)

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

```bash
cd example && flutter run
```

### Run unit tests:

```bash
flutter test
```

### Running Integration Tests

```bash
cd example && flutter test integration_test/app_test.dart
```
