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

import 'recaptcha_enterprise_platform_interface.dart';
import 'recaptcha_action.dart';

/// A client that enables Flutter Apps to trigger reCAPTCHA Enterprise.
class RecaptchaClient {

  /// Executes reCAPTCHA Enterprise on a user [action].
  /// It is suggested the usage of 10 seconds for the [timeout]. The minimum
  /// value is 5 seconds.
  static Future<String> execute(RecaptchaAction action, {double? timeout}) {
    return RecaptchaEnterprisePlatform.instance
        .execute(action.action, timeout: timeout);
  }
}