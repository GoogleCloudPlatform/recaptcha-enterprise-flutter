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

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'api_type.dart';
import 'recaptcha_enterprise_method_channel.dart';

abstract class RecaptchaEnterprisePlatform extends PlatformInterface {
  /// Constructs a RecaptchaEnterprisePlatform.
  RecaptchaEnterprisePlatform() : super(token: _token);

  static final Object _token = Object();

  static RecaptchaEnterprisePlatform _instance =
      MethodChannelRecaptchaEnterprise();

  /// The default instance of [RecaptchaEnterprisePlatform] to use.
  ///
  /// Defaults to [MethodChannelRecaptchaEnterprise].
  static RecaptchaEnterprisePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [RecaptchaEnterprisePlatform] when
  /// they register themselves.
  static set instance(RecaptchaEnterprisePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> initClient(String siteKey, InitApiType apiType, {double? timeout}) {
    throw UnimplementedError('initClient() has not been implemented.');
  }

  Future<String> execute(String action, {double? timeout}) {
    throw UnimplementedError('execute() has not been implemented.');
  }
}
