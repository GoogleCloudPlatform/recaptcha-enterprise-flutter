import 'package:recaptcha_enterprise_flutter/recaptcha_enterprise_platform_interface.dart';

import 'recaptcha_enterprise_web_js_interface.dart';

class RecaptchaEnterpriseWeb extends RecaptchaEnterprisePlatform {
  String? recaptchaKey;
  final RecaptchaEnterpriseWebJsApi? _jsApi;
  final void Function(String siteKey) _injectScript;

  RecaptchaEnterpriseWeb({RecaptchaEnterpriseWebJsApi? jsApi, void Function(String siteKey)? injectScript})
      : _jsApi = jsApi,
        _injectScript = injectScript ?? _noopInjectScript;

  static void registerWith(dynamic registrar) {
    RecaptchaEnterprisePlatform.instance = RecaptchaEnterpriseWeb();
  }

  static void resetScriptInjected() {
    // No-op on non-web platforms.
  }

  static void _noopInjectScript(String siteKey) {
    // No DOM to inject into on non-web platforms.
  }

  @override
  Future<bool> initClient(String siteKey, {double? timeout}) async {
    recaptchaKey = siteKey;
    _injectScript(siteKey);
    return true;
  }

  @override
  Future<bool> fetchClient(String siteKey) async {
    recaptchaKey = siteKey;
    _injectScript(siteKey);
    return true;
  }

  @override
  Future<String> execute(String action, {double? timeout}) async {
    if (recaptchaKey == null) {
      throw Exception("please initialize the client");
    }
    final api = _jsApi;
    if (api == null) {
      throw UnsupportedError(
        'RecaptchaEnterpriseWebJsApi is not available on this platform',
      );
    }
    return api.execute(recaptchaKey!, action, timeout: timeout);
  }
}
