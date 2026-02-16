import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  @override
  ConsentState build() {
    Future<void>.microtask(refreshDebugState);
    return const ConsentState.initial();
  }

  Future<void> gatherConsent({bool force = false}) async {
    if (!force && state.isReady) return;

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
  }

  Future<bool> showPrivacyOptionsForm() async {
    final ok = await UmpConsentChannel.showPrivacyOptionsForm();
    await gatherConsent(force: true);
    return ok;
  }

  Future<void> refreshDebugState() async {
    final debug = await UmpConsentChannel.getDebugState();
    state = state.copyWith(
      debugForceEea: debug.forceEea,
      debugDeviceHash: debug.deviceHash,
      lastError: state.lastError,
    );
  }

  Future<bool> setDebugForceEea(bool enabled) async {
    final ok = await UmpConsentChannel.setDebugForceEea(enabled);
    await gatherConsent(force: true);
    return ok;
  }

  Future<bool> resetConsent() async {
    final ok = await UmpConsentChannel.resetConsent();
    await gatherConsent(force: true);
    return ok;
  }
}
