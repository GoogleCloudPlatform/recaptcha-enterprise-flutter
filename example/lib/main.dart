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

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_enterprise.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_action.dart';
import 'dart:io' show Platform;
import 'package:recaptcha_flutter_example/app_config.dart';

void main({String? env}) async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = await AppConfig.forEnvironment(env);

  runApp(MyApp(config: config));
}

class MyApp extends StatefulWidget {
  final AppConfig config;

  const MyApp({required this.config, super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _clientState = "NOT INITIALIZED";
  String _token = "NO TOKEN";

  final _recaptchaEnterprisePlugin = RecaptchaEnterprise();

  void initClient() async {
    String siteKey = Platform.isAndroid
        ? widget.config.androidSiteKey
        : widget.config.iosSiteKey;

    var result = false;
    var errorMessage = "failure";

    try {
      result = await RecaptchaEnterprise.initClient(siteKey, timeout: 10000);
    } on PlatformException catch (err) {
      print('Caught platform exception on init: $err');
      errorMessage = 'Code: ${err.code} Message ${err.message}';
    } catch (err) {
      print('Caught exception on init: $err');
      errorMessage = err.toString();
    }

    setState(() {
      _clientState = result ? "ok" : errorMessage;
    });
  }

  void execute({custom = false}) async {
    String result;

    try {
      result = custom
          ? await RecaptchaEnterprise.execute(RecaptchaAction.LOGIN())
          : await RecaptchaEnterprise.execute(RecaptchaAction.custom('foo'),
              timeout: 10000);
    } on PlatformException catch (err) {
      print('Caught platform exception on execute: $err');
      result = 'Code: ${err.code} Message ${err.message}';
    } catch (err) {
      print('Caught exception on execute: $err');
      result = err.toString();
    }

    setState(() {
      _token = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('reCAPTCHA Example'),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Text('reCAPTCHA Client:\n '),
            Text(_clientState, key: Key('clientState')),
          ]),
        ]),
        Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text('reCAPTCHA Token:\n '),
          SizedBox(
            width: 300,
            child: Text(_token,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 12,
                key: Key('token')),
          ),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          TextButton(
            onPressed: () {
              initClient();
            },
            key: Key('initButton'),
            child: Container(
              color: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: const Text(
                'Init',
                style: TextStyle(color: Colors.white, fontSize: 13.0),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              execute();
            },
            key: Key('executeButton'),
            child: Container(
              color: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: const Text(
                'Execute',
                style: TextStyle(color: Colors.white, fontSize: 13.0),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              execute(custom: true);
            },
            key: Key('executeButtonCustom'),
            child: Container(
              color: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: const Text(
                'ExecuteCustom',
                style: TextStyle(color: Colors.white, fontSize: 13.0),
              ),
            ),
          ),
        ]),
      ]),
    ));
  }
}
