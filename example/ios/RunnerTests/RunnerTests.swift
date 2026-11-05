// Copyright 2026 Google LLC
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
import XCTest

@testable import recaptcha_enterprise_flutter

class RunnerTests: XCTestCase {

  func testCreateGetClientHandlerWithNonRecaptchaErrorReturnsCastError() {
    let plugin = RecaptchaEnterprisePlugin()
    let expectation = self.expectation(description: "result called")

    let handler = plugin.createGetClientHandler { response in
      guard let error = response as? FlutterError else {
        XCTFail("Expected FlutterError, got \(String(describing: response))")
        return
      }
      XCTAssertEqual(error.code, "FL_CAST_ERROR")
      XCTAssertEqual(error.message, "Not a RecaptchaError")
      expectation.fulfill()
    }

    let nonRecaptchaError = NSError(domain: "TestDomain", code: 42, userInfo: nil)
    handler(nil, nonRecaptchaError)

    waitForExpectations(timeout: 1.0)
  }

  func testCreateGetClientHandlerWithRecaptchaErrorReturnsErrorCodeAndMessage() {
    let plugin = RecaptchaEnterprisePlugin()
    let expectation = self.expectation(description: "result called")

    let handler = plugin.createGetClientHandler { response in
      guard let error = response as? FlutterError else {
        XCTFail("Expected FlutterError, got \(String(describing: response))")
        return
      }
      XCTAssertEqual(
        error.code, String(RecaptchaErrorCode.errorInvalidSiteKey.rawValue))
      XCTAssertEqual(error.message, "Invalid site key")
      expectation.fulfill()
    }

    let recaptchaError = RecaptchaError(
      errorCode: .errorInvalidSiteKey, errorMessage: "Invalid site key")
    handler(nil, recaptchaError)

    waitForExpectations(timeout: 1.0)
  }

  func testCreateExecuteHandlerWithTokenReturnsToken() {
    let plugin = RecaptchaEnterprisePlugin()
    let expectation = self.expectation(description: "result called")

    let handler = plugin.createExecuteHandler { response in
      XCTAssertEqual(response as? String, "test-token")
      expectation.fulfill()
    }

    handler("test-token", nil)

    waitForExpectations(timeout: 1.0)
  }

  func testCreateExecuteHandlerWithNonRecaptchaErrorReturnsCastError() {
    let plugin = RecaptchaEnterprisePlugin()
    let expectation = self.expectation(description: "result called")

    let handler = plugin.createExecuteHandler { response in
      guard let error = response as? FlutterError else {
        XCTFail("Expected FlutterError, got \(String(describing: response))")
        return
      }
      XCTAssertEqual(error.code, "FL_CAST_ERROR")
      XCTAssertEqual(error.message, "Not a RecaptchaError")
      expectation.fulfill()
    }

    let nonRecaptchaError = NSError(domain: "TestDomain", code: 99, userInfo: nil)
    handler(nil, nonRecaptchaError)

    waitForExpectations(timeout: 1.0)
  }

  func testCreateExecuteHandlerWithRecaptchaErrorReturnsErrorCodeAndMessage() {
    let plugin = RecaptchaEnterprisePlugin()
    let expectation = self.expectation(description: "result called")

    let handler = plugin.createExecuteHandler { response in
      guard let error = response as? FlutterError else {
        XCTFail("Expected FlutterError, got \(String(describing: response))")
        return
      }
      XCTAssertEqual(
        error.code, String(RecaptchaErrorCode.errorInvalidAction.rawValue))
      XCTAssertEqual(error.message, "Invalid action")
      expectation.fulfill()
    }

    let recaptchaError = RecaptchaError(
      errorCode: .errorInvalidAction, errorMessage: "Invalid action")
    handler(nil, recaptchaError)

    waitForExpectations(timeout: 1.0)
  }

  func testFetchClientMissingSiteKeyReturnsInitFailedError() {
    let plugin = RecaptchaEnterprisePlugin()
    let expectation = self.expectation(description: "result called")
    let call = FlutterMethodCall(methodName: "fetchClient", arguments: [:])

    plugin.handle(call) { response in
      guard let error = response as? FlutterError else {
        XCTFail("Expected FlutterError, got \(String(describing: response))")
        return
      }
      XCTAssertEqual(error.code, "FL_INIT_FAILED")
      XCTAssertEqual(error.message, "Missing site key")
      expectation.fulfill()
    }

    waitForExpectations(timeout: 1.0)
  }

  func testInitClientMissingSiteKeyReturnsInitFailedError() {
    let plugin = RecaptchaEnterprisePlugin()
    let expectation = self.expectation(description: "result called")
    let call = FlutterMethodCall(methodName: "initClient", arguments: [:])

    plugin.handle(call) { response in
      guard let error = response as? FlutterError else {
        XCTFail("Expected FlutterError, got \(String(describing: response))")
        return
      }
      XCTAssertEqual(error.code, "FL_INIT_FAILED")
      XCTAssertEqual(error.message, "Missing site key")
      expectation.fulfill()
    }

    waitForExpectations(timeout: 1.0)
  }

  func testExecuteWithoutClientReturnsExecuteFailedError() {
    let plugin = RecaptchaEnterprisePlugin()
    let expectation = self.expectation(description: "result called")
    let call = FlutterMethodCall(
      methodName: "execute", arguments: ["action": "login"])

    plugin.handle(call) { response in
      guard let error = response as? FlutterError else {
        XCTFail("Expected FlutterError, got \(String(describing: response))")
        return
      }
      XCTAssertEqual(error.code, "FL_EXECUTE_FAILED")
      XCTAssertEqual(error.message, "Initialize client first")
      expectation.fulfill()
    }

    waitForExpectations(timeout: 1.0)
  }

  func testHandleUnknownMethodReturnsNotImplemented() {
    let plugin = RecaptchaEnterprisePlugin()
    let expectation = self.expectation(description: "result called")
    let call = FlutterMethodCall(methodName: "unknownMethod", arguments: nil)

    plugin.handle(call) { response in
      XCTAssertTrue(
        (response as AnyObject) === (FlutterMethodNotImplemented as AnyObject))
      expectation.fulfill()
    }

    waitForExpectations(timeout: 1.0)
  }
}
