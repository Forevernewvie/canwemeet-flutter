package com.ourmatchwell.ourmatchwell_flutter

import android.provider.Settings
import android.content.pm.ApplicationInfo
import com.google.android.ump.ConsentDebugSettings
import com.google.android.ump.ConsentInformation
import com.google.android.ump.ConsentRequestParameters
import com.google.android.ump.UserMessagingPlatform
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.security.MessageDigest

class MainActivity : FlutterActivity() {
    private val channelName = "com.ourmatchwell/ump"
    private var debugForceEea: Boolean = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "gatherConsent" -> gatherConsent(result)
                    "showPrivacyOptionsForm" -> showPrivacyOptionsForm(result)
                    "setDebugForceEea" -> setDebugForceEea(call, result)
                    "resetConsent" -> resetConsent(result)
                    "getDebugState" -> getDebugState(result)
                    else -> result.notImplemented()
                }
            }
    }

    private fun gatherConsent(result: MethodChannel.Result) {
        val activity = this
        val consentInfo = UserMessagingPlatform.getConsentInformation(activity)
        val params = buildConsentRequestParameters(activity)

        activity.runOnUiThread {
            consentInfo.requestConsentInfoUpdate(
                activity,
                params,
                {
                    UserMessagingPlatform.loadAndShowConsentFormIfRequired(activity) { formError ->
                        val statusRequired =
                            consentInfo.privacyOptionsRequirementStatus ==
                                ConsentInformation.PrivacyOptionsRequirementStatus.REQUIRED

                        val payload =
                            hashMapOf<String, Any?>(
                                "canRequestAds" to consentInfo.canRequestAds(),
                                "isPrivacyOptionsRequired" to statusRequired,
                                "consentStatus" to consentInfo.consentStatus,
                                "error" to formError?.message,
                            )
                        result.success(payload)
                    }
                },
                { requestError ->
                    val payload =
                        hashMapOf<String, Any?>(
                            "canRequestAds" to consentInfo.canRequestAds(),
                            "isPrivacyOptionsRequired" to false,
                            "consentStatus" to consentInfo.consentStatus,
                            "error" to requestError.message,
                        )
                    result.success(payload)
                },
            )
        }
    }

    private fun showPrivacyOptionsForm(result: MethodChannel.Result) {
        val activity = this
        activity.runOnUiThread {
            UserMessagingPlatform.showPrivacyOptionsForm(activity) { formError ->
                result.success(formError == null)
            }
        }
    }

    private fun setDebugForceEea(call: MethodCall, result: MethodChannel.Result) {
        if (!isDebugBuild()) {
            result.success(false)
            return
        }

        val enabled = call.argument<Boolean>("enabled") == true
        debugForceEea = enabled
        result.success(true)
    }

    private fun resetConsent(result: MethodChannel.Result) {
        if (!isDebugBuild()) {
            result.success(false)
            return
        }

        UserMessagingPlatform.getConsentInformation(this).reset()
        result.success(true)
    }

    private fun getDebugState(result: MethodChannel.Result) {
        result.success(
            hashMapOf(
                "forceEea" to debugForceEea,
                "deviceHash" to debugDeviceHash(),
            ),
        )
    }

    private fun buildConsentRequestParameters(activity: FlutterActivity): ConsentRequestParameters {
        if (!isDebugBuild() || !debugForceEea) {
            return ConsentRequestParameters.Builder().build()
        }

        val debugSettings =
            ConsentDebugSettings
                .Builder(activity)
                .setDebugGeography(ConsentDebugSettings.DebugGeography.DEBUG_GEOGRAPHY_EEA)
                .build()

        return ConsentRequestParameters
            .Builder()
            .setConsentDebugSettings(debugSettings)
            .build()
    }

    private fun debugDeviceHash(): String {
        val androidId =
            Settings.Secure.getString(contentResolver, Settings.Secure.ANDROID_ID) ?: return ""
        val digest = MessageDigest.getInstance("SHA-256").digest(androidId.toByteArray())
        return digest.joinToString(separator = "") { byte -> "%02x".format(byte) }
    }

    private fun isDebugBuild(): Boolean {
        return (applicationInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE) != 0
    }
}
