// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'recaptcha_enterprise_platform_interface.dart';

// An implementation of [RecaptchaEnterprisePlatform] that uses method channels.
class MethodChannelRecaptchaEnterprise extends RecaptchaEnterprisePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('recaptcha_enterprise');

  @override
  Future<bool> initClient(String siteKey, {double? timeout}) async {
    Map<String, dynamic> opts = {'siteKey': siteKey};

    if (timeout != null) {
      opts['timeout'] = timeout;
    }

    return await methodChannel.invokeMethod('initClient', opts);
  }

  @override
  Future<String> execute(String action, {double? timeout}) async {
    Map<String, dynamic> opts = {
      'action': action,
    };

    if (timeout != null) {
      opts['timeout'] = timeout;
    }

    return await methodChannel.invokeMethod('execute', opts);
  }

  @override
  Future<bool> fetchClient(String siteKey) async {
    Map<String, dynamic> opts = {'siteKey': siteKey};
    return await methodChannel.invokeMethod('fetchClient', opts);
  }
}
