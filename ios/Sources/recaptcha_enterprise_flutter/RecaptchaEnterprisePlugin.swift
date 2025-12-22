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

import Flutter
import RecaptchaEnterprise
import UIKit

public class RecaptchaEnterprisePlugin: NSObject, FlutterPlugin {
  var recaptchaClient: RecaptchaClient?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "recaptcha_enterprise", binaryMessenger: registrar.messenger())
    let instance = SwiftRecaptchaEnterprisePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  private func mapAction(_ actionStr: String) -> RecaptchaAction {
    if actionStr == "login" {
      return RecaptchaAction.login
    } else if actionStr == "signup" {
      return RecaptchaAction.signup
    } else {
      return RecaptchaAction(customAction: actionStr)
    }
  }

  private func createGetClientHandler(_ result: @escaping FlutterResult) -> (
    RecaptchaClient?, Error?
  ) -> Void {
    let getClientClosure: (RecaptchaClient?, Error?) -> Void = {
      recaptchaClient, error in
      if let recaptchaClient = recaptchaClient {
        self.recaptchaClient = recaptchaClient
        result(true)
      } else if let error = error {
        guard let error = error as? RecaptchaError else {
          FlutterError.init(
            code: "FL_CAST_ERROR", message: "Not a RecaptchaError", details: nil
          )
          return
        }
        result(
          FlutterError.init(
            code: String(error.code), message: error.errorMessage, details: nil)
        )
      }
    }
    return getClientClosure
  }

  private func fetchClient(
    _ call: FlutterMethodCall, result: @escaping FlutterResult
  ) {
    guard let args = call.arguments as? [String: Any],
      let siteKey = args["siteKey"] as? String
    else {
      result(
        FlutterError.init(
          code: "FL_INIT_FAILED", message: "Missing site key", details: nil))
      return
    }

    Recaptcha.fetchClient(
      withSiteKey: siteKey, completion: createGetClientHandler(result))
  }

  private func initClient(
    _ call: FlutterMethodCall, result: @escaping FlutterResult
  ) {
    guard let args = call.arguments as? [String: Any],
      let siteKey = args["siteKey"] as? String
    else {
      result(
        FlutterError.init(
          code: "FL_INIT_FAILED", message: "Missing site key", details: nil))
      return
    }

    let getClientClosure = createGetClientHandler(result)

    if let timeout = args["timeout"] as? Double {
      Recaptcha.getClient(
        withSiteKey: siteKey, withTimeout: timeout, completion: getClientClosure
      )
    } else {
      Recaptcha.getClient(withSiteKey: siteKey, completion: getClientClosure)
    }
  }

  private func execute(
    _ call: FlutterMethodCall, result: @escaping FlutterResult
  ) {
    guard let client = recaptchaClient else {
      result(
        FlutterError.init(
          code: "FL_EXECUTE_FAILED", message: "Initialize client first",
          details: nil))
      return
    }

    guard let args = call.arguments as? [String: Any],
      let actionStr = args["action"] as? String
    else {
      result(
        FlutterError.init(
          code: "FL_EXECUTE_FAILED", message: "Missing action", details: nil))
      return
    }

    let action = mapAction(actionStr)

    let executeClosure: (String?, Error?) -> Void = { token, error -> Void in
      if let token = token {
        result(token)
      } else if let error = error {
        guard let error = error as? RecaptchaError else {
          FlutterError.init(
            code: "FL_CAST_ERROR", message: "Not a RecaptchaError", details: nil
          )
          return
        }
        result(
          FlutterError.init(
            code: String(error.code), message: error.errorMessage, details: nil)
        )
      }
    }

    if let timeout = args["timeout"] as? Double {
      client.execute(
        withAction: action, withTimeout: timeout, completion: executeClosure)
    } else {
      client.execute(withAction: action, completion: executeClosure)
    }

  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult)
  {
    switch call.method {
    case "initClient":
      initClient(call, result: result)
    case "fetchClient":
      fetchClient(call, result: result)
    case "execute":
      execute(call, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
