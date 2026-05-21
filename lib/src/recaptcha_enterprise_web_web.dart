import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_enterprise_platform_interface.dart';

import 'recaptcha_enterprise_web_js_api.dart';
import 'recaptcha_enterprise_web_js_interface.dart';

class RecaptchaEnterpriseWeb extends RecaptchaEnterprisePlatform {
  String? recaptchaKey;
  final RecaptchaEnterpriseWebJsApi _jsApi;

  RecaptchaEnterpriseWeb({RecaptchaEnterpriseWebJsApi? jsApi})
      : _jsApi = jsApi ?? RecaptchaEnterpriseWebJsApiImpl();

  static void registerWith(Registrar registrar) {
    RecaptchaEnterprisePlatform.instance = RecaptchaEnterpriseWeb();
  }

  @override
  Future<bool> initClient(String siteKey, {double? timeout}) async {
    recaptchaKey = siteKey;
    return true;
  }

  @override
  Future<bool> fetchClient(String siteKey) async {
    recaptchaKey = siteKey;
    return true;
  }

  @override
  Future<String> execute(String action, {double? timeout}) async {
    if (recaptchaKey == null) {
      throw Exception("please initialize the client");
    }
    return _jsApi.execute(recaptchaKey!, action, timeout: timeout);
  }
}
