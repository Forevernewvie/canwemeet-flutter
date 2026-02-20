import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/ads/consent/consent_controller.dart';
import '../../core/constants/feature_texts.dart';
import '../../core/notifications/review_reminder_controller.dart';
import '../../core/persistence/preferences_store.dart';
import '../../ui_components/app_surfaces.dart';

/// Renders user settings including reminder controls and consent tools.
class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  /// Builds all settings sections and interaction handlers.
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.appPalette;
    final consent = ref.watch(consentControllerProvider);
    final prefs = ref.watch(preferencesStoreProvider);
    final reminder = ref.read(reviewReminderControllerProvider);
    final reminderTime = TimeOfDay(
      hour: prefs.reviewReminderHour,
      minute: prefs.reviewReminderMinute,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '설정 · 리마인더 & 지원',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            AppCard(
              title: 'MVP 안내',
              subtitle: '결제/구독 없이 모든 핵심 기능을 무료로 사용할 수 있어요.',
              badges: const ['무료 MVP'],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 44,
              child: FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('핵심 기능은 모두 무료로 이용할 수 있어요.')),
                  );
                },
                child: const Text('이용 안내'),
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              title: 'Appearance',
              subtitle: 'Choose how the app looks on this device.',
              badges: const ['System', 'Light', 'Dark'],
            ),
            const SizedBox(height: 8),
            SegmentedButton<AppearanceMode>(
              showSelectedIcon: false,
              segments: const <ButtonSegment<AppearanceMode>>[
                ButtonSegment<AppearanceMode>(
                  value: AppearanceMode.system,
                  label: Text('System'),
                ),
                ButtonSegment<AppearanceMode>(
                  value: AppearanceMode.light,
                  label: Text('Light'),
                ),
                ButtonSegment<AppearanceMode>(
                  value: AppearanceMode.dark,
                  label: Text('Dark'),
                ),
              ],
              selected: <AppearanceMode>{prefs.appearanceMode},
              onSelectionChanged: (selection) {
                if (selection.isEmpty) return;
                final selected = selection.first;
                ref.read(preferencesStoreProvider).setAppearanceMode(selected);
              },
            ),
            const SizedBox(height: 16),
            AppCard(
              title: FeatureTexts.reminderCardTitle,
              subtitle: FeatureTexts.reminderCardSubtitle(
                _formatTime(context, reminderTime),
              ),
              badges: const [FeatureTexts.reminderCardBadge],
            ),
            const SizedBox(height: 8),
            SwitchListTile.adaptive(
              value: prefs.reviewReminderEnabled,
              onChanged: (enabled) async {
                final result = await reminder.updateEnabled(enabled);
                if (!context.mounted) return;
                final message = switch (result) {
                  ReminderToggleResult.enabled =>
                    FeatureTexts.reminderToggleOnMessage,
                  ReminderToggleResult.disabled =>
                    FeatureTexts.reminderToggleOffMessage,
                  ReminderToggleResult.permissionDenied =>
                    FeatureTexts.reminderPermissionDeniedMessage,
                };
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(message)));
              },
              title: const Text(FeatureTexts.reminderToggleTitle),
              subtitle: const Text(FeatureTexts.reminderToggleSubtitle),
            ),
            ListTile(
              leading: const Icon(Icons.schedule_outlined),
              title: const Text(FeatureTexts.reminderTimeTitle),
              subtitle: Text(_formatTime(context, reminderTime)),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: reminderTime,
                );
                if (picked == null) return;
                await reminder.updateTime(
                  hour: picked.hour,
                  minute: picked.minute,
                );
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      FeatureTexts.reminderTimeUpdatedMessage(
                        _formatTime(context, picked),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            AppCard(
              title: '광고/개인정보(UMP)',
              subtitle:
                  '상태: ${consent.statusLabel}\n광고 요청 가능: ${consent.canRequestAds ? '예' : '아니오'}\nPrivacy Options 필요: ${consent.isPrivacyOptionsRequired ? '예' : '아니오'}',
              badges: const ['AdMob 배너만', '동의 전 광고 요청 금지'],
            ),
            const SizedBox(height: 8),
            FilledButton.tonal(
              onPressed: () async {
                final ok = await ref
                    .read(consentControllerProvider.notifier)
                    .showPrivacyOptionsForm();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(ok ? '동의 설정을 열었어요.' : '동의 설정을 열 수 없어요.'),
                  ),
                );
              },
              child: const Text('동의 설정 열기 (Privacy Options)'),
            ),
            if ((consent.lastError ?? '').isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                '동의 오류: ${consent.lastError}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: palette.accent),
              ),
            ],
            if (kDebugMode) ...[
              const SizedBox(height: 22),
              AppCard(
                title: '디버그 동의 도구',
                subtitle: '릴리즈에는 포함되지 않습니다. EEA 강제 테스트와 동의 초기화를 제공합니다.',
                badges: const ['kDebugMode only'],
              ),
              const SizedBox(height: 10),
              SwitchListTile.adaptive(
                value: consent.debugForceEea,
                onChanged: (enabled) async {
                  final ok = await ref
                      .read(consentControllerProvider.notifier)
                      .setDebugForceEea(enabled);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(ok ? 'EEA 디버그 강제 상태를 변경했어요.' : '변경 실패'),
                    ),
                  );
                },
                title: const Text('EEA 디버그 강제'),
                subtitle: const Text('동의 폼 테스트용'),
              ),
              ListTile(
                title: const Text('테스트 디바이스 해시'),
                subtitle: Text(consent.debugDeviceHash ?? '불러오는 중...'),
                trailing: IconButton(
                  icon: const Icon(Icons.copy_rounded),
                  onPressed: consent.debugDeviceHash == null
                      ? null
                      : () async {
                          await Clipboard.setData(
                            ClipboardData(text: consent.debugDeviceHash!),
                          );
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('해시를 복사했어요.')),
                          );
                        },
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () async {
                  final ok = await ref
                      .read(consentControllerProvider.notifier)
                      .resetConsent();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ok ? '동의를 초기화했어요.' : '초기화 실패')),
                  );
                },
                child: const Text('동의 리셋'),
              ),
            ],
            const SizedBox(height: 24),
            Text(
              '개인정보처리방침: https://github.com/Forevernewvie/canwemeet-flutter/blob/main/docs/PRIVACY_POLICY_KO.md\n고객지원: dlfjs351@gmail.com',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: palette.subText),
            ),
          ],
        ),
      ),
    );
  }

  /// Formats reminder time according to locale-specific conventions.
  String _formatTime(BuildContext context, TimeOfDay value) {
    return MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(value, alwaysUse24HourFormat: false);
  }
}
