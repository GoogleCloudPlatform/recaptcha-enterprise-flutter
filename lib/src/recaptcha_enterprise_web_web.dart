import 'dart:html';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_enterprise_platform_interface.dart';

import 'recaptcha_enterprise_web_js_api.dart';
import 'recaptcha_enterprise_web_js_interface.dart';

class RecaptchaEnterpriseWeb extends RecaptchaEnterprisePlatform {
  String? recaptchaKey;
  final RecaptchaEnterpriseWebJsApi _jsApi;
  final void Function(String siteKey) _injectScript;
  static bool _scriptInjected = false;

  RecaptchaEnterpriseWeb({RecaptchaEnterpriseWebJsApi? jsApi, void Function(String siteKey)? injectScript})
      : _jsApi = jsApi ?? RecaptchaEnterpriseWebJsApiImpl(),
        _injectScript = injectScript ?? _defaultInjectScript;

  static void registerWith(Registrar registrar) {
    RecaptchaEnterprisePlatform.instance = RecaptchaEnterpriseWeb();
  }

  static void resetScriptInjected() {
    _scriptInjected = false;
  }

  static void _defaultInjectScript(String siteKey) {
    if (_scriptInjected) return;
    _scriptInjected = true;
    final script = ScriptElement()
      ..src = 'https://www.google.com/recaptcha/enterprise.js?render=$siteKey'
      ..async = true
      ..defer = true;
    document.head!.append(script);
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
    return _jsApi.execute(recaptchaKey!, action, timeout: timeout);
  }
}
