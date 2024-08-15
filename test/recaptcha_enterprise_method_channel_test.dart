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
import 'package:recaptcha_enterprise_flutter/api_type.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_enterprise_method_channel.dart';

void main() {
  var platform = MethodChannelRecaptchaEnterprise();
  const channel = MethodChannel('recaptcha_enterprise');
  dynamic args;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'initClient':
          args = methodCall.arguments;
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
        'FAKE_SITEKEY', InitApiType.getClient);
    expect(initResult, true);
    expect(args["apiType"], "getClient");
    expect(args["siteKey"], "FAKE_SITEKEY");
    expect(args["timeout"], null);
  });

  test('initClientTimeout', () async {
    var initResult = await platform.initClient(
        'FAKE_SITEKEY', InitApiType.getClient, timeout: 5000);
    expect(initResult, true);
    expect(args["apiType"], "getClient");
    expect(args["siteKey"], "FAKE_SITEKEY");
    expect(args["timeout"], 5000);
  });

  test('initClient_withFetchClientAPI', () async {
    var initResult = await platform.initClient(
        'FAKE_SITEKEY', InitApiType.fetchClient);
    expect(initResult, true);
    expect(args["apiType"], "fetchClient");
    expect(args["siteKey"], "FAKE_SITEKEY");
    expect(args["timeout"], null);
  });

  test('execute', () async {
    expect(await platform.execute('ACTION'), 'token');
  });

  test('executeTimeout', () async {
    expect(await platform.execute('ACTION', timeout: 5000), 'token');
  });
}
