/*
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.flutter.recaptcha

import android.app.Application
import androidx.annotation.NonNull
import com.google.android.recaptcha.Recaptcha
import com.google.android.recaptcha.RecaptchaAction
import com.google.android.recaptcha.RecaptchaClient
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

/** RecaptchaEnterprisePlugin */
class RecaptchaEnterprisePlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel: MethodChannel
  private lateinit var recaptchaClient: RecaptchaClient
  private lateinit var application: Application

  override fun onAttachedToEngine(
    @NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
  ) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "recaptcha_enterprise")
    channel.setMethodCallHandler(this)
  }

  fun mapAction(actionStr: String): RecaptchaAction {
    return when {
      actionStr.equals("login", ignoreCase = true) -> RecaptchaAction.LOGIN
      actionStr.equals("signup", ignoreCase = true) -> RecaptchaAction.SIGNUP
      else -> RecaptchaAction.custom(actionStr)
    }
  }

  private fun initClient(@NonNull call: MethodCall, @NonNull result: Result) {
    if (application == null) {
      result.error("FL_INIT_FAILED", "No application registered", null)
      return
    }
    val siteKey = call.argument<String>("siteKey")
    val timeout = call.argument<Long>("timeout")

    if (siteKey != null) {
      GlobalScope.launch {
        let {
            if (timeout != null) Recaptcha.getClient(application, siteKey, timeout)
            else Recaptcha.getClient(application, siteKey)
          }
          .onSuccess { client ->
            recaptchaClient = client
            result.success(true)
          }
          .onFailure { exception -> result.error("FL_INIT_FAILED", exception.toString(), null) }
      }
    }
  }

  private fun execute(@NonNull call: MethodCall, @NonNull result: Result) {
    if (!this::recaptchaClient.isInitialized || recaptchaClient == null) {
      result.error("FL_EXECUTE_FAILED", "Initialize client first", null)
      return
    }

    val actionStr = call.argument<String>("action")
    if (actionStr == null) {
      result.error("FL_EXECUTE_FAILED", "Missing action", null)
      return
    }

    val action = mapAction(actionStr)
    val timeout = call.argument<Long>("timeout")
    GlobalScope.launch {
      recaptchaClient
        .let { if (timeout != null) it.execute(action, timeout) else it.execute(action) }
        .onSuccess { token -> result.success(token) }
        .onFailure { exception -> result.error("FL_EXECUTE_FAILED", exception.toString(), null) }
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "initClient" -> initClient(call, result)
      "execute" -> execute(call, result)
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    val activity = binding.activity
    application = activity.application
  }

  override fun onDetachedFromActivity() {}

  override fun onDetachedFromActivityForConfigChanges() {}

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}
}
