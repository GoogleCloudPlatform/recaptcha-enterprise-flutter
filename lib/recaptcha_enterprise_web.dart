import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_enterprise_platform_interface.dart';

import 'dart:async';
import 'dart:js_interop';

@JS('grecaptcha.enterprise.ready')
external void _ready(JSFunction callback);

@JS('grecaptcha.enterprise.execute')
external JSPromise _execute(String recaptchaKey, ExecuteOptions options);

@JS()
@anonymous
@staticInterop
class ExecuteOptions {
  external factory ExecuteOptions({String action});
}

class RecaptchaEnterpriseWeb extends RecaptchaEnterprisePlatform {
  String? recaptchaKey;

  RecaptchaEnterpriseWeb();

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
    Map<String, dynamic> opts = {
      'action': action,
    };

    if (timeout != null) {
      opts['timeout'] = timeout;
    }

    final completer = Completer<String>();

    if (recaptchaKey == null) {
      throw Exception("please initialize the client");
    }

    _ready(() {
      final promise = _execute(recaptchaKey!, ExecuteOptions(action: action));
      promise.toDart
          .then((value) => completer.complete(value.toString()))
          .catchError(completer.completeError);
    }.toJS);

    return completer.future;
  }
}
