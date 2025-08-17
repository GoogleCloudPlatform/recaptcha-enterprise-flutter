/*
Copyright 2022 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import 'dart:convert';

import 'package:flutter/services.dart';

class AppConfig {
  final String androidSiteKey;
  final String iosSiteKey;
  final String webSiteKey;

  const AppConfig({
    required this.androidSiteKey,
    required this.iosSiteKey,
    required this.webSiteKey,
  });

  static Future<AppConfig> forEnvironment(String? env) async {
    env = env ?? 'dev';

    final contents = await rootBundle.loadString(
      'assets/config/$env.json',
    );

    final json = jsonDecode(contents);
    return AppConfig(
      androidSiteKey: json['androidSiteKey'],
      iosSiteKey: json['iosSiteKey'],
      webSiteKey: json['webSiteKey'],
    );
  }
}
