import 'package:flutter_test/flutter_test.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_enterprise_platform_interface.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_enterprise_web.dart';
import 'package:recaptcha_enterprise_flutter/src/recaptcha_enterprise_web_js_interface.dart';

class MockJsApi implements RecaptchaEnterpriseWebJsApi {
  String? capturedKey;
  String? capturedAction;
  double? capturedTimeout;

  @override
  Future<String> execute(String recaptchaKey, String action, {double? timeout}) async {
    capturedKey = recaptchaKey;
    capturedAction = action;
    capturedTimeout = timeout;
    return 'mock-token';
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RecaptchaEnterpriseWeb', () {
    setUp(() {
      RecaptchaEnterpriseWeb.resetScriptInjected();
    });

    test('default instance is RecaptchaEnterpriseWeb', () {
      RecaptchaEnterpriseWeb.registerWith(null as dynamic);
      expect(RecaptchaEnterprisePlatform.instance, isA<RecaptchaEnterpriseWeb>());
    });

    test('initClient stores key and returns true', () async {
      final plugin = RecaptchaEnterpriseWeb();
      final result = await plugin.initClient('test-key');
      expect(result, isTrue);
      expect(plugin.recaptchaKey, equals('test-key'));
    });

    test('fetchClient stores key and returns true', () async {
      final plugin = RecaptchaEnterpriseWeb();
      final result = await plugin.fetchClient('test-key');
      expect(result, isTrue);
      expect(plugin.recaptchaKey, equals('test-key'));
    });

    test('initClient calls injectScript with correct site key', () async {
      String? injectedKey;
      final plugin = RecaptchaEnterpriseWeb(
        injectScript: (key) {
          injectedKey = key;
        },
      );
      final result = await plugin.initClient('test-key');
      expect(result, isTrue);
      expect(injectedKey, equals('test-key'));
    });

    test('fetchClient calls injectScript with correct site key', () async {
      String? injectedKey;
      final plugin = RecaptchaEnterpriseWeb(
        injectScript: (key) {
          injectedKey = key;
        },
      );
      final result = await plugin.fetchClient('test-key');
      expect(result, isTrue);
      expect(injectedKey, equals('test-key'));
    });

    test('execute throws when key is null', () async {
      final plugin = RecaptchaEnterpriseWeb();
      expect(
        () => plugin.execute('my-action'),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('please initialize the client'),
        )),
      );
    });

    test('execute calls JS facade with correct args', () async {
      final mockJsApi = MockJsApi();
      final plugin = RecaptchaEnterpriseWeb(jsApi: mockJsApi);

      plugin.recaptchaKey = 'my-key';
      final result = await plugin.execute('my-action', timeout: 3000);

      expect(result, equals('mock-token'));
      expect(mockJsApi.capturedKey, equals('my-key'));
      expect(mockJsApi.capturedAction, equals('my-action'));
      expect(mockJsApi.capturedTimeout, equals(3000));
    });
  });
}
