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

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_enterprise_method_channel.dart';

void main() {
  var platform = MethodChannelRecaptchaEnterprise();
  const channel = MethodChannel('recaptcha_enterprise');
  dynamic args;
  dynamic apiCalled;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    apiCalled = 'none';

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      args = methodCall.arguments;
      apiCalled = methodCall.method;

      switch (methodCall.method) {
        case 'initClient':
          return true;
        case 'fetchClient':
          return true;
        case 'execute':
          return 'token';
      }

      throw Exception('Not a valid method');
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('initClient', () async {
    var initResult = await platform.initClient(
        'FAKE_SITEKEY');
    expect(initResult, true);
    expect(args["siteKey"], "FAKE_SITEKEY");
    expect(args["timeout"], null);
    expect(apiCalled, 'initClient');
  });

  test('initClientTimeout', () async {
    var initResult = await platform.initClient(
        'FAKE_SITEKEY', timeout: 5000);
    expect(initResult, true);
    expect(args["siteKey"], "FAKE_SITEKEY");
    expect(args["timeout"], 5000);
    expect(apiCalled, 'initClient');

  });

  test('fetchClient', () async {
    var fetchClientResult = await platform.fetchClient('FAKE_SITEKEY');
    expect(fetchClientResult, true);
    expect(args["siteKey"], "FAKE_SITEKEY");
    expect(apiCalled, 'fetchClient');
  });

  test('execute', () async {
    expect(await platform.execute('ACTION'), 'token');
  });

  test('executeTimeout', () async {
    expect(await platform.execute('ACTION', timeout: 5000), 'token');
  });
}
