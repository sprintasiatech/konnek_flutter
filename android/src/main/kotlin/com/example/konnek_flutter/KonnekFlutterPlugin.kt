package com.example.konnek_flutter

import com.example.konnek_flutter.network.EnvironmentConfig
import com.example.konnek_flutter.network.Flavor
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** KonnekFlutterPlugin */
class KonnekFlutterPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity

    companion object {
        var clientId = ""
        var access = ""
    }

    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "konnek_flutter")
        channel.setMethodCallHandler(this)
    }


    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else if (call.method == "initialize") {
            initialize(call, result)
        } else if (call.method == "getConfig") {
            KonnekService().getConfig(
                call,
                onSuccess = { value: String ->
                    result.success(value)
                },
                onFailed = { errorMessage: String ->
                    result.error(
                        errorMessage.toString(),
                        errorMessage.toString(),
                        null,
                    )
                },
            )
        } else if (call.method == "getConversation") {
//            result.notImplemented()
            KonnekService().getConversation(
                call,
                onSuccess = { value: String ->
                    result.success(value)
                },
                onFailed = { errorMessage: String ->
                    result.error(
                        errorMessage.toString(),
                        errorMessage.toString(),
                        null,
                    )
                },
            )
        } else if (call.method == "sendChat") {
//            result.notImplemented()
            KonnekService().sendChat(
                call,
                onSuccess = { value: String ->
                    result.success(value)
                },
                onFailed = { errorMessage: String ->
                    result.error(
                        errorMessage.toString(),
                        errorMessage.toString(),
                        null,
                    )
                },
            )
        } else if (call.method == "uploadMedia") {
//            result.notImplemented()
            KonnekService().uploadMedia(
                call,
                onSuccess = { value: String ->
                    result.success(value)
                },
                onFailed = { errorMessage: String ->
                    result.error(
                        errorMessage.toString(),
                        errorMessage.toString(),
                        null,
                    )
                },
            )
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun initialize(call: MethodCall, result: Result) {
        try {
            val map = call.arguments as Map<*, *>

            val flavor = map["flavor"] as String?
            when (flavor) {
                "development" -> {
                    EnvironmentConfig.flavor = Flavor.DEVELOPMENT
                }

                "staging" -> {
                    EnvironmentConfig.flavor = Flavor.STAGING
                }

                "production" -> {
                    EnvironmentConfig.flavor = Flavor.PRODUCTION
                }

                else -> {
                    EnvironmentConfig.flavor = Flavor.STAGING
                }
            }
            result.success("success initialize $flavor")
        } catch (e: Exception) {
            result.error(
                "failed12",
                "failed12",
                null,
            )
        }
    }
}
