import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../support/app_logger.dart';
import 'ump_consent_channel.dart';

@immutable
class ConsentState {
  const ConsentState({
    required this.isReady,
    required this.canRequestAds,
    required this.isPrivacyOptionsRequired,
    required this.consentStatus,
    required this.lastError,
    required this.debugForceEea,
    required this.debugDeviceHash,
  });

  const ConsentState.initial()
    : isReady = false,
      canRequestAds = false,
      isPrivacyOptionsRequired = false,
      consentStatus = null,
      lastError = null,
      debugForceEea = false,
      debugDeviceHash = null;

  final bool isReady;
  final bool canRequestAds;
  final bool isPrivacyOptionsRequired;
  final int? consentStatus;
  final String? lastError;
  final bool debugForceEea;
  final String? debugDeviceHash;

  String get statusLabel {
    return switch (consentStatus) {
      1 => 'Required',
      2 => 'Not required',
      3 => 'Obtained',
      _ => 'Unknown',
    };
  }

  ConsentState copyWith({
    bool? isReady,
    bool? canRequestAds,
    bool? isPrivacyOptionsRequired,
    int? consentStatus,
    String? lastError,
    bool? debugForceEea,
    String? debugDeviceHash,
  }) {
    return ConsentState(
      isReady: isReady ?? this.isReady,
      canRequestAds: canRequestAds ?? this.canRequestAds,
      isPrivacyOptionsRequired:
          isPrivacyOptionsRequired ?? this.isPrivacyOptionsRequired,
      consentStatus: consentStatus ?? this.consentStatus,
      lastError: lastError,
      debugForceEea: debugForceEea ?? this.debugForceEea,
      debugDeviceHash: debugDeviceHash ?? this.debugDeviceHash,
    );
  }
}

final consentControllerProvider =
    NotifierProvider<ConsentController, ConsentState>(ConsentController.new);

class ConsentController extends Notifier<ConsentState> {
  AppLogger get _logger => ref.read(appLoggerProvider);

  @override
  ConsentState build() {
    Future<void>.microtask(refreshDebugState);
    return const ConsentState.initial();
  }

  Future<void> gatherConsent({bool force = false}) async {
    if (!force && state.isReady) return;

    try {
      final res = await UmpConsentChannel.gatherConsent();
      final debug = await UmpConsentChannel.getDebugState();

      state = state.copyWith(
        isReady: true,
        canRequestAds: res.canRequestAds,
        isPrivacyOptionsRequired: res.isPrivacyOptionsRequired,
        consentStatus: res.consentStatus,
        lastError: res.error,
        debugForceEea: debug.forceEea,
        debugDeviceHash: debug.deviceHash,
      );
    } catch (error, stackTrace) {
      _logger.error(
        AppLogCategory.consent,
        'Failed to gather UMP consent state.',
        error: error,
        stackTrace: stackTrace,
      );
      state = state.copyWith(
        isReady: true,
        canRequestAds: false,
        lastError: error.toString(),
      );
    }
  }

  Future<bool> showPrivacyOptionsForm() async {
    try {
      final ok = await UmpConsentChannel.showPrivacyOptionsForm();
      await gatherConsent(force: true);
      return ok;
    } catch (error, stackTrace) {
      _logger.error(
        AppLogCategory.consent,
        'Failed to open Privacy Options form.',
        error: error,
        stackTrace: stackTrace,
      );
      state = state.copyWith(lastError: error.toString());
      return false;
    }
  }

  Future<void> refreshDebugState() async {
    try {
      final debug = await UmpConsentChannel.getDebugState();
      state = state.copyWith(
        debugForceEea: debug.forceEea,
        debugDeviceHash: debug.deviceHash,
        lastError: state.lastError,
      );
    } catch (error, stackTrace) {
      _logger.error(
        AppLogCategory.consent,
        'Failed to read UMP debug state.',
        error: error,
        stackTrace: stackTrace,
      );
      state = state.copyWith(lastError: error.toString());
    }
  }

  Future<bool> setDebugForceEea(bool enabled) async {
    try {
      final ok = await UmpConsentChannel.setDebugForceEea(enabled);
      await gatherConsent(force: true);
      return ok;
    } catch (error, stackTrace) {
      _logger.error(
        AppLogCategory.consent,
        'Failed to update UMP debug geography flag.',
        error: error,
        stackTrace: stackTrace,
      );
      state = state.copyWith(lastError: error.toString());
      return false;
    }
  }

  Future<bool> resetConsent() async {
    try {
      final ok = await UmpConsentChannel.resetConsent();
      await gatherConsent(force: true);
      return ok;
    } catch (error, stackTrace) {
      _logger.error(
        AppLogCategory.consent,
        'Failed to reset UMP consent state.',
        error: error,
        stackTrace: stackTrace,
      );
      state = state.copyWith(lastError: error.toString());
      return false;
    }
  }
}
