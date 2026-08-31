import 'dart:async';
import 'dart:js_interop';

import 'recaptcha_enterprise_web_js_interface.dart';

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

class RecaptchaEnterpriseWebJsApiImpl implements RecaptchaEnterpriseWebJsApi {
  @override
  Future<String> execute(String recaptchaKey, String action, {double? timeout}) {
    final completer = Completer<String>();

    _ready(() {
      final promise = _execute(recaptchaKey, ExecuteOptions(action: action));
      promise.toDart
          .then((value) => completer.complete(value.toString()))
          .catchError(completer.completeError);
    }.toJS);

    return completer.future;
  }
}
