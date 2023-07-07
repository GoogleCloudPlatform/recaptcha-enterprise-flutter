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

import 'package:flutter_test/flutter_test.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_enterprise.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_enterprise_platform_interface.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_enterprise_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_action.dart';

class MockRecaptchaEnterprisePlatform
    with MockPlatformInterfaceMixin
    implements RecaptchaEnterprisePlatform {
  @override
  Future<bool> initClient(String siteKey, {double? timeout}) =>
      Future.value(true);

  @override
  Future<String> execute(String action, {double? timeout}) =>
      Future.value('token');
}

void main() {
  final initialPlatform = RecaptchaEnterprisePlatform.instance;

  test('$MethodChannelRecaptchaEnterprise is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelRecaptchaEnterprise>());
  });

  test('initClient', () async {
    var fakePlatform = MockRecaptchaEnterprisePlatform();
    RecaptchaEnterprisePlatform.instance = fakePlatform;

    expect(await RecaptchaEnterprise.initClient('SITE_KEY'), true);
  });

  test('initClientWithTimeout', () async {
    var fakePlatform = MockRecaptchaEnterprisePlatform();
    RecaptchaEnterprisePlatform.instance = fakePlatform;

    expect(
        await RecaptchaEnterprise.initClient('SITE_KEY', timeout: 5000), true);
  });

  test('execute', () async {
    var fakePlatform = MockRecaptchaEnterprisePlatform();
    RecaptchaEnterprisePlatform.instance = fakePlatform;

    expect(await RecaptchaEnterprise.execute(RecaptchaAction.LOGIN()), 'token');
  });

  test('executeWithTimeout', () async {
    var fakePlatform = MockRecaptchaEnterprisePlatform();
    RecaptchaEnterprisePlatform.instance = fakePlatform;

    expect(
        await RecaptchaEnterprise.execute(RecaptchaAction.LOGIN(),
            timeout: 5000),
        'token');
  });
}
