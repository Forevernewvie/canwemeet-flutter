import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const _channel = MethodChannel('com.ourmatchwell/ump');

class UmpConsentResult {
  const UmpConsentResult({
    required this.canRequestAds,
    required this.isPrivacyOptionsRequired,
    required this.consentStatus,
    required this.error,
  });

  final bool canRequestAds;
  final bool isPrivacyOptionsRequired;
  final int? consentStatus;
  final String? error;

  factory UmpConsentResult.fromMap(Map<dynamic, dynamic> map) {
    return UmpConsentResult(
      canRequestAds: map['canRequestAds'] == true,
      isPrivacyOptionsRequired: map['isPrivacyOptionsRequired'] == true,
      consentStatus: map['consentStatus'] is int
          ? map['consentStatus'] as int
          : null,
      error: map['error'] is String ? map['error'] as String : null,
    );
  }
}

class UmpDebugState {
  const UmpDebugState({required this.forceEea, required this.deviceHash});

  final bool forceEea;
  final String? deviceHash;

  factory UmpDebugState.fromMap(Map<dynamic, dynamic> map) {
    return UmpDebugState(
      forceEea: map['forceEea'] == true,
      deviceHash: map['deviceHash'] is String
          ? map['deviceHash'] as String
          : null,
    );
  }
}

class UmpConsentChannel {
  const UmpConsentChannel._();

  static Future<UmpConsentResult> gatherConsent() async {
    if (!Platform.isAndroid) {
      return const UmpConsentResult(
        canRequestAds: true,
        isPrivacyOptionsRequired: false,
        consentStatus: null,
        error: null,
      );
    }

    try {
      final raw = await _channel.invokeMethod<dynamic>('gatherConsent');
      if (raw is Map) return UmpConsentResult.fromMap(raw);
      return const UmpConsentResult(
        canRequestAds: false,
        isPrivacyOptionsRequired: false,
        consentStatus: null,
        error: 'Unexpected response type from native UMP channel.',
      );
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('[ads] UMP gatherConsent PlatformException: ${e.message}');
      }
      return UmpConsentResult(
        canRequestAds: false,
        isPrivacyOptionsRequired: false,
        consentStatus: null,
        error: e.message,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ads] UMP gatherConsent error: $e');
      }
      return UmpConsentResult(
        canRequestAds: false,
        isPrivacyOptionsRequired: false,
        consentStatus: null,
        error: e.toString(),
      );
    }
  }

  static Future<bool> showPrivacyOptionsForm() async {
    if (!Platform.isAndroid) return false;

    try {
      final ok = await _channel.invokeMethod<dynamic>('showPrivacyOptionsForm');
      return ok == true;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint(
          '[ads] UMP showPrivacyOptionsForm PlatformException: ${e.message}',
        );
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ads] UMP showPrivacyOptionsForm error: $e');
      }
      return false;
    }
  }

  static Future<UmpDebugState> getDebugState() async {
    if (!Platform.isAndroid) {
      return const UmpDebugState(forceEea: false, deviceHash: null);
    }

    try {
      final raw = await _channel.invokeMethod<dynamic>('getDebugState');
      if (raw is Map) return UmpDebugState.fromMap(raw);
      return const UmpDebugState(forceEea: false, deviceHash: null);
    } catch (_) {
      return const UmpDebugState(forceEea: false, deviceHash: null);
    }
  }

  static Future<bool> setDebugForceEea(bool enabled) async {
    if (!Platform.isAndroid) return false;

    try {
      final ok = await _channel.invokeMethod<dynamic>(
        'setDebugForceEea',
        <String, dynamic>{'enabled': enabled},
      );
      return ok == true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> resetConsent() async {
    if (!Platform.isAndroid) return false;

    try {
      final ok = await _channel.invokeMethod<dynamic>('resetConsent');
      return ok == true;
    } catch (_) {
      return false;
    }
  }
}
